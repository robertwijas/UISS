//
//  UISS.m
//  UISS
//
//  Created by Robert Wijas on 10/7/11.
//  Copyright (c) 2011 57things. All rights reserved.
//

#import "UISS.h"

#import <objc/runtime.h>

#import "UISSStatusWindowController.h"
#import "UISSPropertySetter.h"
#import "UISSAppearancePrivate.h"
#import "UISSConsoleViewController.h"
#import "UISSError.h"

NSString *const UISSWillApplyStyleNotification = @"UISSWillApplyStyleNotification";
NSString *const UISSDidApplyStyleNotification = @"UISSDidApplyStyleNotification";

NSString *const UISSWillRefreshViewsNotification = @"UISSWillRefreshViewsNotification";
NSString *const UISSDidRefreshViewsNotification = @"UISSDidRefreshViewsNotification";

@interface UISS () <UISSStatusWindowControllerDelegate>

@property (nonatomic, strong) UISSStatusWindowController *statusWindowController;

@end

@implementation UISS

@synthesize config=_config;
@synthesize refreshInterval=_refreshInterval;

@synthesize style=_style;

@synthesize statusWindowController=_statusWindowController;

- (id)init
{
    self = [super init];
    if (self) {
        self.config = [UISSConfig sharedConfig];
        self.style = [[UISSStyle alloc] init];
    }
    
    return self;
}

- (BOOL)statusWindowEnabled;
{
    return self.statusWindowController != nil;
}

- (void)setStatusWindowEnabled:(BOOL)statusWindowEnabled;
{
    if (statusWindowEnabled) {
        if (self.statusWindowController == nil) {
            // configure Console
            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"uiss_console" ofType:@"json" inDirectory:@"UISSResources.bundle"];
            if (filePath) {
                [UISS configureWithJSONFilePath:filePath];
            }
            
            self.statusWindowController = [[UISSStatusWindowController alloc] init];
            self.statusWindowController.delegate = self;
        }
    } else {
        self.statusWindowController = nil;
    }
}

- (void)scheduleRefresh;
{
    if (self.refreshInterval) {
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, self.refreshInterval * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self reloadAsync];
        });
    }
}

- (void)resetAppearance;
{
    NSLog(@"UISS -- reseting appearance");
    
    NSMutableSet *done = [NSMutableSet set];
    NSArray *propertySetters = [self.style propertySettersForUserInterfaceIdiom:[UIDevice currentDevice].userInterfaceIdiom];
    
    for (UISSPropertySetter *propertySetter in propertySetters) {
        if ([done containsObject:propertySetter.target] == NO) {
            [[propertySetter.target _appearanceInvocations] removeAllObjects];
            [done addObject:propertySetter.target];
        }
    }
}

- (void)configureAppearanceWithPropertySetters:(NSArray *)propertySetters;
{
    [[NSNotificationCenter defaultCenter] postNotificationName:UISSWillApplyStyleNotification object:self];

    [self resetAppearance];
    
    NSMutableArray *invocations = [NSMutableArray array];
    
    for (UISSPropertySetter *propertySetter in propertySetters) {
        NSInvocation *invocation = propertySetter.invocation;
        if (invocation) {
            [invocations addObject:invocation];
        } else {
            // TODO: error
        }
    }
    
    for (NSInvocation *invocation in invocations) {
        [invocation invoke];
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:UISSDidApplyStyleNotification object:self];
}

- (void)reloadUsingQueue:(dispatch_queue_t)queue completion:(void (^)(BOOL reloaded, NSArray *errors))completion;
{
    NSLog(@"UISS -- reloading...");
    
    if ([self.style downloadData]) {
        if ([self.style parseDictionaryForUserInterfaceIdiom:[UIDevice currentDevice].userInterfaceIdiom withConfig:self.config]) {
            NSArray *propertySetters = [self.style propertySettersForUserInterfaceIdiom:[UIDevice currentDevice].userInterfaceIdiom];
            [self configureAppearanceWithPropertySetters:propertySetters];
            completion(YES, self.style.errors);
        } else {
            completion(NO, self.style.errors);
        }
    } else {
        completion(NO, self.style.errors);
    }    
}

- (void)reload;
{
    [self reloadUsingQueue:nil completion:^(BOOL reloaded, NSArray *errors) {
        self.style.errors = errors;
        
        [self scheduleRefresh];
    }];
}

- (void)reloadAsync;
{
    [self reloadUsingQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) 
                completion:^(BOOL reloaded, NSArray *errors){
                    self.style.errors = errors;
                    
                    if (reloaded) {
                        [self refreshViews];
                    }
                    
                    [self scheduleRefresh];
                }];
}

- (void)generateCodeFromPropertySetters:(NSArray *)propertySetters 
                            codeHandler:(void (^)(NSString *code, NSArray *errors))codeHandler;
{
    NSAssert(codeHandler, @"code handler required");
    
    NSMutableString *code = [NSMutableString string];
    NSMutableArray *errors = [NSMutableArray array];
    
    for (UISSPropertySetter *propertySetter in propertySetters) {
        NSString *generatedCode = propertySetter.generatedCode;
        if (generatedCode) {
            [code appendFormat:@"%@\n", generatedCode];
        } else {
            [errors addObject:[UISSError errorWithCode:UISSPropertySetterGenerateCodeError 
                                              userInfo:[NSDictionary dictionaryWithObject:propertySetter forKey:UISSPopertySetterErrorKey]]];
        }
    }
    
    codeHandler(code, errors);
}

- (void)generateCodeForUserInterfaceIdiom:(UIUserInterfaceIdiom)userInterfaceIdiom 
                              codeHandler:(void (^)(NSString *code, NSArray *errors))codeHandler;
{
    if ([self.style parseDictionaryForUserInterfaceIdiom:userInterfaceIdiom withConfig:self.config]) {
        [self generateCodeFromPropertySetters:[self.style propertySettersForUserInterfaceIdiom:userInterfaceIdiom]
                                  codeHandler:codeHandler];
    } else {
        codeHandler(nil, self.style.errors);
    }
}

+ (UISS *)configureWithJSONFilePath:(NSString *)filePath;
{
    UISS *uiss = [[UISS alloc] init];
    uiss.style.url = [NSURL fileURLWithPath:filePath];
    [uiss reload];
    return uiss;
}

+ (UISS *)configureWithDefaultJSONFile;
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"uiss" ofType:@"json"];
    return [self configureWithJSONFilePath:filePath];
}

- (void)refreshViews;
{
    [[NSNotificationCenter defaultCenter] postNotificationName:UISSWillRefreshViewsNotification object:self];
    
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        for (UIView *view in window.subviews) {
            [view removeFromSuperview];
            [window addSubview:view];
        }
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:UISSDidRefreshViewsNotification object:self];
}

#pragma mark - Reload Gesture Recognizer Support

- (UIGestureRecognizer *)defaultGestureRecognizer;
{
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] init];
    recognizer.numberOfTouchesRequired = 1;
    recognizer.minimumPressDuration = 1;
    
    return recognizer;
}

- (void)registerReloadGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer inView:(UIView *)view;
{
    if (gestureRecognizer == nil) {
        gestureRecognizer = [self defaultGestureRecognizer];
    }
    
    [gestureRecognizer addTarget:self action:@selector(reloadGestureRecognizerHandler:)];
    [view addGestureRecognizer:gestureRecognizer];
}

- (void)registerReloadGestureRecognizerInView:(UIView *)view;
{
    [self registerReloadGestureRecognizer:nil inView:view];
}

- (void)reloadGestureRecognizerHandler:(UILongPressGestureRecognizer *)gestureRecognizer;
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self reloadAsync];
    }
}

#pragma mark - Console

- (void)statusWindowControllerDidSelect:(UISSStatusWindowController *)statusWindowController;
{
    [self presentConsoleViewController];
}

- (void)presentConsoleViewController;
{
    UISSConsoleViewController *consoleViewController = [[UISSConsoleViewController alloc] initWithUISS:self];
    consoleViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    UIViewController *presentingViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    if (presentingViewController.presentedViewController) {
        if ([presentingViewController.presentedViewController isKindOfClass:[UISSConsoleViewController class]]) {
            [presentingViewController dismissViewControllerAnimated:YES completion:nil];
        } else {
            [presentingViewController dismissViewControllerAnimated:YES completion:^{
                [presentingViewController presentViewController:consoleViewController animated:YES completion:nil];
            }];
        }
    } else {
        [presentingViewController presentViewController:consoleViewController animated:YES completion:nil];
    }
}

@end
