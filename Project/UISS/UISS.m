//
//  UISS.m
//  UISS
//
//  Created by Robert Wijas on 10/7/11.
//  Copyright (c) 2011 57things. All rights reserved.
//

#import "UISS.h"

#import <objc/runtime.h>

#import "UISSStatusViewController.h"
#import "UISSPropertySetter.h"
#import "UISSAppearancePrivate.h"
#import "UISSConsoleViewController.h"
#import "UISSError.h"
#import "UISSCodeGenerator.h"
#import "UISSStatusWindow.h"

NSString *const UISSWillApplyStyleNotification = @"UISSWillApplyStyleNotification";
NSString *const UISSDidApplyStyleNotification = @"UISSDidApplyStyleNotification";

NSString *const UISSWillRefreshViewsNotification = @"UISSWillRefreshViewsNotification";
NSString *const UISSDidRefreshViewsNotification = @"UISSDidRefreshViewsNotification";

@interface UISS () <UISSStatusWindowControllerDelegate>

@property (nonatomic, strong) UISSStatusViewController *statusWindowController;
@property (nonatomic, strong) UISSStatusWindow *statusWindow;

@property (nonatomic, strong) NSTimer *autoReloadTimer;
@property (nonatomic, assign) dispatch_queue_t queue; // all style parsing is done on the queue

@property (nonatomic, strong) UISSCodeGenerator *codeGenerator;

@property (nonatomic, strong) NSMutableArray *configuredAppearanceProxies;

@end

@implementation UISS

@synthesize config=_config;
@synthesize style=_style;

@synthesize statusWindowController=_statusWindowController;
@synthesize statusWindow=_statusWindow;

@synthesize autoReloadTimer=_autoReloadTimer;
@synthesize queue=_queue;

@synthesize codeGenerator=_codeGenerator;

@synthesize configuredAppearanceProxies=_configuredAppearanceProxies;

#pragma mark - Contructors

- (id)init
{
    self = [super init];
    if (self) {
        self.config = [UISSConfig sharedConfig];
        self.style = [[UISSStyle alloc] init];
        
        self.queue = dispatch_queue_create("com.robertwijas.uiss.queue", DISPATCH_QUEUE_SERIAL);
        
        self.codeGenerator = [[UISSCodeGenerator alloc] init];
        
#ifdef UISS_DEBUG
        self.configuredAppearanceProxies = [NSMutableArray array];
#endif
    }
    
    return self;
}

+ (UISS *)configureWithJSONFilePath:(NSString *)filePath;
{
    UISS *uiss = [[UISS alloc] init];
    uiss.style.url = [NSURL fileURLWithPath:filePath];
    [uiss load];
    return uiss;
}

+ (UISS *)configureWithDefaultJSONFile;
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"uiss" ofType:@"json"];
    return [self configureWithJSONFilePath:filePath];
}

- (void)configureAppearanceWithPropertySetters:(NSArray *)propertySetters errors:(NSMutableArray *)errors;
{
    [[NSNotificationCenter defaultCenter] postNotificationName:UISSWillApplyStyleNotification object:self];

    [self resetAppearanceForPropertySetters:propertySetters];
    
    NSMutableArray *invocations = [NSMutableArray array];
    
    for (UISSPropertySetter *propertySetter in propertySetters) {
        NSInvocation *invocation = propertySetter.invocation;
        if (invocation) {
            [invocations addObject:invocation];
        } else {
            [errors addObject:[UISSError errorWithCode:UISSPropertySetterCreateInvocationError 
                                              userInfo:[NSDictionary dictionaryWithObject:propertySetter forKey:UISSPopertySetterErrorKey]]];
        }
    }
    
    for (NSInvocation *invocation in invocations) {
        if ([self.configuredAppearanceProxies containsObject:invocation.target] == NO) {
            [self.configuredAppearanceProxies addObject:invocation.target];
        }
        
        [invocation invoke];
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:UISSDidApplyStyleNotification object:self];
}

- (void)reload;
{
    NSLog(@"UISS -- reloading...");
    
    dispatch_async(self.queue, ^{
        // if new data downloaded
        if ([self.style downloadData]) {
            UIUserInterfaceIdiom userInterfaceIdiom = [UIDevice currentDevice].userInterfaceIdiom;
            
            [self.style parseDictionaryForUserInterfaceIdiom:userInterfaceIdiom withConfig:self.config];
            NSArray *propertySetters = [self.style propertySettersForUserInterfaceIdiom:userInterfaceIdiom];
            
            if (propertySetters) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self configureAppearanceWithPropertySetters:propertySetters errors:self.style.errors];
                    [self refreshViews];
                });
            }
        }
    });
}

- (void)load;
{
    __block NSArray *propertySetters = nil;
    
    dispatch_sync(self.queue, ^{
        UIUserInterfaceIdiom userInterfaceIdiom = [UIDevice currentDevice].userInterfaceIdiom;
        if ([self.style parseDictionaryForUserInterfaceIdiom:userInterfaceIdiom withConfig:self.config]) {
            propertySetters = [self.style propertySettersForUserInterfaceIdiom:userInterfaceIdiom];
        }
    });
    
    if (propertySetters) {
        [self configureAppearanceWithPropertySetters:propertySetters errors:self.style.errors];
    }
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

- (void)resetAppearanceForPropertySetters:(NSArray *)propertySetters;
{
#ifdef UISS_DEBUG
    NSLog(@"UISS -- reseting appearance");
    
    for (id appearanceProxy in self.configuredAppearanceProxies) {
        [[appearanceProxy _appearanceInvocations] removeAllObjects];
    }
    
    [self.configuredAppearanceProxies removeAllObjects];
#endif
}

#pragma mark - Code Generation

- (void)generateCodeForUserInterfaceIdiom:(UIUserInterfaceIdiom)userInterfaceIdiom 
                              codeHandler:(void (^)(NSString *code, NSArray *errors))codeHandler;
{
    NSAssert(codeHandler, @"code handler required");
    
    dispatch_async(self.queue, ^{
        [self.style parseDictionaryForUserInterfaceIdiom:userInterfaceIdiom withConfig:self.config];
        NSArray *propertySetters = [self.style propertySettersForUserInterfaceIdiom:userInterfaceIdiom];
        NSMutableArray *errors = [NSMutableArray array];
        
        NSString *code = [self.codeGenerator generateCodeForPropertySetters:propertySetters errors:errors];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            codeHandler(code, errors);
        });
    });
}

#pragma mark - Auto Refresh

- (void)enableAutoReloadWithTimeInterval:(NSTimeInterval)timeInterval;
{
    [self disableAutoReload];
    
    self.autoReloadTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval 
                                                             target:self
                                                           selector:@selector(reload)
                                                           userInfo:nil
                                                            repeats:YES];
}

- (void)disableAutoReload;
{
    [self.autoReloadTimer invalidate];
    self.autoReloadTimer = nil;
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
        [self reload];
    }
}


#pragma mark - Status Window

- (BOOL)statusWindowEnabled;
{
    return self.statusWindow != nil;
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
            
            self.statusWindow = [[UISSStatusWindow alloc] init];
            
            UISSStatusViewController *statusWindowController = [[UISSStatusViewController alloc] init];
            statusWindowController.delegate = self;
            
            self.statusWindow.rootViewController = statusWindowController;
            
            self.statusWindow.hidden = NO;
        }
    } else {
        self.statusWindow = nil;
    }
}


#pragma mark - Console

- (void)statusWindowControllerDidSelect:(UISSStatusViewController *)statusWindowController;
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
