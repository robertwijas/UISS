//
//  UISS.m
//  UISS
//
//  Created by Robert Wijas on 10/7/11.
//  Copyright (c) 2011 57things. All rights reserved.
//

#import "UISS.h"

#import <objc/runtime.h>

#import "UISSParser.h"
#import "UISSStatusWindowController.h"
#import "UISSPropertySetter.h"
#import "UISSAppearancePrivate.h"
#import "UISSConsoleViewController.h"
#import "UISSError.h"

NSString *const UISSWillDownloadStyleNotification = @"UISSWillDownloadStyleNotification";
NSString *const UISSDidDownloadStyleNotification = @"UISSDidDownloadStyleNotification";

NSString *const UISSWillParseStyleNotification = @"UISSWillParseStyleNotification";
NSString *const UISSDidParseStyleNotification = @"UISSDidParseStyleNotification";

NSString *const UISSWillApplyStyleNotification = @"UISSWillApplyStyleNotification";
NSString *const UISSDidApplyStyleNotification = @"UISSDidApplyStyleNotification";

NSString *const UISSWillRefreshViewsNotification = @"UISSWillRefreshViewsNotification";
NSString *const UISSDidRefreshViewsNotification = @"UISSDidRefreshViewsNotification";

@interface UISS () <UISSStatusWindowControllerDelegate>

// last successfully parsed data
@property (strong) NSData *data;
@property (nonatomic, strong) NSArray *propertySetters;

@property (nonatomic, strong) UISSStatusWindowController *statusWindowController;

@end

@implementation UISS

@synthesize config=_config;

@synthesize url=_url;
@synthesize refreshInterval=_refreshInterval;

@synthesize data=_data;
@synthesize propertySetters=_propertySetters;

@synthesize statusWindowController=_statusWindowController;

- (id)init
{
    self = [super init];
    if (self) {
        self.config = [UISSConfig sharedConfig];
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
            [UISS configureWithJSONFilePath:filePath];
            
            self.statusWindowController = [[UISSStatusWindowController alloc] init];
            self.statusWindowController.delegate = self;
        }
    } else {
        self.statusWindowController = nil;
    }
}

- (void)downloadStyleDataFromUrl:(NSURL *)url queue:(dispatch_queue_t)queue completion:(void (^)(BOOL updated, NSArray *errors))completion;
{
    [self executeOnQueue:queue block:^{
        [self postOnMainQueueNotificationName:UISSWillDownloadStyleNotification];
        
        NSError *error;
        NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
        
        if (error) {
            completion(NO, [NSArray arrayWithObject:error]);
        } else {
            [self postOnMainQueueNotificationName:UISSDidDownloadStyleNotification];
            
            if (data && [data isEqualToData:self.data] == NO) {
                self.data = data;
                [self dispatchSyncOnMainQueueIfNecessary:^{
                    completion(YES, nil);
                }];
            } else {
                [self dispatchSyncOnMainQueueIfNecessary:^{
                    completion(NO, nil);
                }];
            }
        }
    }];
}

- (void)parseStyleData:(NSData *)data queue:(dispatch_queue_t)queue completion:(void (^)(NSDictionary *dictionary))completion;
{
    [self executeOnQueue:queue block:^{
        [self postOnMainQueueNotificationName:UISSWillParseStyleNotification];
        
        NSError *error;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                   options:NSJSONReadingMutableContainers
                                                                     error:&error];
        
        if (error) {
            NSLog(@"UISS -- cannot parse JSON file, error: %@", error);
        }
        
        [self postOnMainQueueNotificationName:UISSDidParseStyleNotification];
        
        [self dispatchSyncOnMainQueueIfNecessary:^{
            completion(dictionary);
        }];
    }];
}

- (void)parseStyleDictionary:(NSDictionary *)dictionary userInterfaceIdiom:(UIUserInterfaceIdiom)userInterfaceIdiom
                       queue:(dispatch_queue_t)queue completion:(void (^)(NSArray *propertySetters))completion;
{
    [self executeOnQueue:queue block:^{
        [self postOnMainQueueNotificationName:UISSWillParseStyleNotification];
        
        UISSParser *parser = [[UISSParser alloc] init];
        parser.userInterfaceIdiom = userInterfaceIdiom;
        parser.config = self.config;
        
        NSArray *propertySetters = [parser parseDictionary:dictionary];
        
        [self postOnMainQueueNotificationName:UISSDidParseStyleNotification];
        
        [self dispatchSyncOnMainQueueIfNecessary:^{
            completion(propertySetters); 
        }];
    }];
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
    for (UISSPropertySetter *propertySetter in self.propertySetters) {
        if ([done containsObject:propertySetter.target] == NO) {
            [[propertySetter.target _appearanceInvocations] removeAllObjects];
            [done addObject:propertySetter.target];
        }
    }
}

- (void)configureAppearanceWithPropertySetters:(NSArray *)propertySetters;
{
    [self resetAppearance];
    
    self.propertySetters = propertySetters;
    
    NSLog(@"UISS -- creating invocations");
    
    NSMutableArray *invocations = [NSMutableArray array];
    for (UISSPropertySetter *propertySetter in self.propertySetters) {
        NSInvocation *invocation = propertySetter.invocation;
        if (invocation) {
            [invocations addObject:invocation];
        } else {
            // TODO: error
        }
    }
    
    NSLog(@"UISS -- number of invocations: %d", invocations.count);
    for (NSInvocation *invocation in invocations) {
        [invocation invoke];
    }
    
    NSLog(@"UISS -- done");
}

- (void)reloadUsingQueue:(dispatch_queue_t)queue completion:(void (^)(BOOL reloaded, NSArray *errors))completion;
{
    NSLog(@"UISS -- reloading...");
    
    [self downloadStyleDataFromUrl:self.url queue:queue completion:^(BOOL updated, NSArray *errors) {
        if (updated) {
            [self parseStyleData:self.data queue:queue completion:^(NSDictionary *dictionary) {
                [self parseStyleDictionary:dictionary 
                        userInterfaceIdiom:[UIDevice currentDevice].userInterfaceIdiom 
                                     queue:queue
                                completion:^(NSArray *propertySetters) {
                                    [self configureAppearanceWithPropertySetters:propertySetters];
                                    completion(YES, errors);
                                }];
            }];
        } else {
            completion(NO, errors);
        }
    }];
}

- (void)reload;
{
    [self reloadUsingQueue:nil completion:^(BOOL reloaded, NSArray *errors) {
        [self scheduleRefresh];
    }];
}

- (void)reloadAsync;
{
    [self reloadUsingQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) 
                completion:^(BOOL reloaded, NSArray *errors){
                    if (errors.count) {
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
            [errors addObject:[UISSError errorWithCode:UISSPropertySetterGenerateCodeError]];
        }
    }
    
    codeHandler(code, errors);
}

- (void)generateCodeForUserInterfaceIdiom:(UIUserInterfaceIdiom)userInterfaceIdiom 
                              codeHandler:(void (^)(NSString *code, NSArray *errors))codeHandler;
{
    [self parseStyleData:self.data queue:nil completion:^(NSDictionary *dictionary) {
        [self parseStyleDictionary:dictionary 
                userInterfaceIdiom:userInterfaceIdiom
                             queue:nil
                        completion:^(NSArray *propertySetters) {
                            [self generateCodeFromPropertySetters:propertySetters codeHandler:codeHandler];
                        }];
    }];
}

+ (UISS *)configureWithJSONFilePath:(NSString *)filePath;
{
    UISS *uiss = [[UISS alloc] init];
    uiss.url = [NSURL fileURLWithPath:filePath];
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
    [self postOnMainQueueNotificationName:UISSWillRefreshViewsNotification];
    
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        for (UIView *view in window.subviews) {
            [view removeFromSuperview];
            [window addSubview:view];
        }
    }
    
    [self postOnMainQueueNotificationName:UISSDidRefreshViewsNotification];
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

#pragma mark - Helper Methods

- (void)dispatchSyncOnMainQueueIfNecessary:(dispatch_block_t)block;
{
    if (dispatch_get_main_queue() == dispatch_get_current_queue()) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

- (void)postOnMainQueueNotificationName:(NSString *)notificationName;
{
    [self dispatchSyncOnMainQueueIfNecessary:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:self];
    }];
}

- (void)executeOnQueue:(dispatch_queue_t)queue block:(void (^)())block;
{
    if (queue) {
        dispatch_async(queue, block);
    } else {
        block();
    }
}


@end
