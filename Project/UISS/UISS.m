//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import "UISS.h"

#import "UISSStatusViewController.h"
#import "UISSPropertySetter.h"
#import "UISSConsoleViewController.h"
#import "UISSError.h"
#import "UISSCodeGenerator.h"
#import "UISSStatusWindow.h"

#if UISS_DEBUG

#import "UISSAppearancePrivate.h"

#endif

NSString *const UISSWillApplyStyleNotification = @"UISSWillApplyStyleNotification";
NSString *const UISSDidApplyStyleNotification = @"UISSDidApplyStyleNotification";

NSString *const UISSWillRefreshViewsNotification = @"UISSWillRefreshViewsNotification";
NSString *const UISSDidRefreshViewsNotification = @"UISSDidRefreshViewsNotification";

@interface UISS () <UISSStatusWindowControllerDelegate>

@property(nonatomic, strong) UISSStatusViewController *statusWindowController;
@property(nonatomic, strong) UISSStatusWindow *statusWindow;

@property(nonatomic, strong) NSTimer *autoReloadTimer;

@property(nonatomic, strong) UISSCodeGenerator *codeGenerator;

@property(nonatomic, strong) NSMutableArray *configuredAppearanceProxies;

// all style parsing is done on the queue
#if OS_OBJECT_USE_OBJC
@property(nonatomic, strong) dispatch_queue_t queue;
#else
@property(nonatomic, unsafe_unretained) dispatch_queue_t queue;
#endif

@end

@implementation UISS

#pragma mark - Constructors

- (id)init {
    self = [super init];
    if (self) {
        self.config = [UISSConfig sharedConfig];
        self.style = [[UISSStyle alloc] init];

        self.queue = dispatch_queue_create("com.robertwijas.uiss.queue", DISPATCH_QUEUE_SERIAL);

        self.codeGenerator = [[UISSCodeGenerator alloc] init];

#if UISS_DEBUG
        [self logDebugMessageOnce];
        self.configuredAppearanceProxies = [NSMutableArray array];
#endif
    }

    return self;
}

- (void)dealloc {
#if !(OS_OBJECT_USE_OBJC)
    dispatch_release(self.queue);
#endif
}

- (void)logDebugMessageOnce {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"UISS is running in DEBUG mode");
    });
}

#pragma mark - Factory Methods

+ (UISS *)configureWithJSONFilePath:(NSString *)filePath {
    UISS *uiss = [[UISS alloc] init];
    uiss.style.url = [NSURL fileURLWithPath:filePath];
    [uiss loadStyleSynchronously];
    return uiss;
}

+ (UISS *)configureWithDefaultJSONFile {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"uiss" ofType:@"json"];
    return [self configureWithJSONFilePath:filePath];
}

+ (UISS *)configureWithURL:(NSURL *)url {
    UISS *uiss = [[UISS alloc] init];

    uiss.style.url = url;
    uiss.statusWindowEnabled = YES;

    [uiss loadStyleSynchronously];

    uiss.autoReloadTimeInterval = 5;
    uiss.autoReloadEnabled = YES;

    return uiss;
}

#pragma mark - Reloading Style

- (void)configureAppearanceWithPropertySetters:(NSArray *)propertySetters errors:(NSMutableArray *)errors {
    [[NSNotificationCenter defaultCenter] postNotificationName:UISSWillApplyStyleNotification object:self];

#if UISS_DEBUG
    [self resetAppearanceForPropertySetters:propertySetters];
#endif

    NSMutableArray *invocations = [NSMutableArray array];

    for (UISSPropertySetter *propertySetter in propertySetters) {
        NSInvocation *invocation = propertySetter.invocation;
        if (invocation) {
            [invocations addObject:invocation];
        } else {
            [errors addObject:[UISSError errorWithCode:UISSPropertySetterCreateInvocationError
                                              userInfo:[NSDictionary dictionaryWithObject:propertySetter
                                                                                   forKey:UISSPropertySetterErrorKey]]];
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

- (void)reloadStyleAsynchronously {
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

- (void)loadStyleSynchronously {
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

- (void)refreshViews {
    [[NSNotificationCenter defaultCenter] postNotificationName:UISSWillRefreshViewsNotification object:self];

    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        for (UIView *view in window.subviews) {
            [view removeFromSuperview];
            [window addSubview:view];
        }
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:UISSDidRefreshViewsNotification object:self];
}

#if UISS_DEBUG

- (void)resetAppearanceForPropertySetters:(NSArray *)propertySetters {
    UISS_LOG(@"resetting appearance");

    for (id appearanceProxy in self.configuredAppearanceProxies) {
        [[appearanceProxy _appearanceInvocations] removeAllObjects];
    }

    [self.configuredAppearanceProxies removeAllObjects];
}

#endif

#pragma mark - Code Generation

- (void)generateCodeForUserInterfaceIdiom:(UIUserInterfaceIdiom)userInterfaceIdiom
                              codeHandler:(void (^)(NSString *code, NSArray *errors))codeHandler {
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

#pragma mark - Auto Reload

- (void)updateAutoReloadTimer {
    if (self.autoReloadEnabled && self.autoReloadTimeInterval) {
        self.autoReloadTimer = [NSTimer scheduledTimerWithTimeInterval:self.autoReloadTimeInterval
                                                                target:self
                                                              selector:@selector(reloadStyleAsynchronously)
                                                              userInfo:nil repeats:YES];
    } else {
        self.autoReloadTimer = nil;
    }
}

- (void)setAutoReloadTimer:(NSTimer *)autoReloadTimer {
    [_autoReloadTimer invalidate];
    _autoReloadTimer = autoReloadTimer;
}

- (void)setAutoReloadTimeInterval:(NSTimeInterval)autoReloadTimeInterval {
    _autoReloadTimeInterval = autoReloadTimeInterval;
    [self updateAutoReloadTimer];
}

- (void)setAutoReloadEnabled:(BOOL)autoReloadEnabled {
    _autoReloadEnabled = autoReloadEnabled;
    [self updateAutoReloadTimer];
}

#pragma mark - Status Window

- (BOOL)statusWindowEnabled {
    return self.statusWindow != nil;
}

- (void)setStatusWindowEnabled:(BOOL)statusWindowEnabled {
    if (statusWindowEnabled) {
        if (self.statusWindowController == nil) {
            // configure Console
            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"uiss_console" ofType:@"json"
                                                            inDirectory:@"UISSResources.bundle"];
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

- (void)statusWindowControllerDidSelect:(UISSStatusViewController *)statusWindowController {
    [self presentConsoleViewController];
}

- (void)presentConsoleViewController {
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
