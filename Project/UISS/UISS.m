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

NSString *const UISSWillDownloadStyleNotification = @"UISSWillDownloadStyleNotification";
NSString *const UISSDidDownloadStyleNotification = @"UISSDidDownloadStyleNotification";

NSString *const UISSWillParseStyleNotification = @"UISSWillParseStyleNotification";
NSString *const UISSDidParseStyleNotification = @"UISSDidParseStyleNotification";

NSString *const UISSWillApplyStyleNotification = @"UISSWillApplyStyleNotification";
NSString *const UISSDidApplyStyleNotification = @"UISSDidApplyStyleNotification";

NSString *const UISSWillRefreshViewsNotification = @"UISSWillRefreshViewsNotification";
NSString *const UISSDidRefreshViewsNotification = @"UISSDidRefreshViewsNotification";

@interface UISS ()

@property (strong) NSData *data;
@property (nonatomic, strong) UISSStatusWindowController *statusWindowController;

@end

@implementation UISS

@synthesize config=_config;

@synthesize url=_url;
@synthesize refreshInterval=_refreshInterval;

@synthesize data=_data;
@synthesize statusWindowController=_statusWindowController;

- (id)init
{
    self = [super init];
    if (self) {
        self.config = [UISSConfig sharedConfig];
        self.statusWindowController = [[UISSStatusWindowController alloc] init];
    }
    return self;
}

- (void)dispatchOnMainQueueIfNecessary:(dispatch_block_t)block;
{
    if (dispatch_get_main_queue() == dispatch_get_current_queue()) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

- (void)postOnMainQueueNotificationName:(NSString *)notificationName;
{
    [self dispatchOnMainQueueIfNecessary:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:self];
    }];
}

- (void)downloadStyleDataFromUrl:(NSURL *)url queue:(dispatch_queue_t)queue completion:(void (^)(BOOL updated))completion;
{
    [self postOnMainQueueNotificationName:UISSWillDownloadStyleNotification];
    
    void (^downloadBlock)(void) = ^{
        NSData *data = [NSData dataWithContentsOfURL:url options:0 error:nil]; // TODO: error
        
        [self postOnMainQueueNotificationName:UISSDidDownloadStyleNotification];
        
        if (data && [data isEqualToData:self.data] == NO) {
            self.data = data;
            [self dispatchOnMainQueueIfNecessary:^{
                completion(YES);
            }];
        } else {
            [self dispatchOnMainQueueIfNecessary:^{
                completion(NO);
            }];
        }
    };
    
    if (queue) {
        dispatch_async(queue, downloadBlock);
    } else {
        downloadBlock();
    }
}

- (void)parseStyleData:(NSData *)data queue:(dispatch_queue_t)queue completion:(void (^)(NSDictionary *dictionary))completion;
{
    [self postOnMainQueueNotificationName:UISSWillParseStyleNotification];
    
    void (^block)() = ^{
        NSError *error;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                   options:NSJSONReadingMutableContainers
                                                                     error:&error];
        
        [self postOnMainQueueNotificationName:UISSDidParseStyleNotification];
        
        if (error) {
            NSLog(@"UISS -- cannot parse JSON file, error: %@", error);
        }
        
        [self dispatchOnMainQueueIfNecessary:^{
            completion(dictionary);
        }];
    };
    
    if (queue) {
        dispatch_async(queue, block);
    } else {
        block();
    }
}

- (void)parseStyleDictionary:(NSDictionary *)dictionary queue:(dispatch_queue_t)queue completion:(void (^)(NSArray *propertySetters))completion;
{
    [self postOnMainQueueNotificationName:UISSWillParseStyleNotification];
    
    void (^block)() = ^{
        UISSParser *parser = [[UISSParser alloc] init];
        parser.config = self.config;
        
        NSArray *propertySetters = [parser parseDictionary:dictionary];
        
        [self postOnMainQueueNotificationName:UISSDidParseStyleNotification];
        
        [self dispatchOnMainQueueIfNecessary:^{
            completion(propertySetters); 
        }];
    };
    
    if (queue) {
        dispatch_async(queue, block);
    } else {
        block();
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

- (void)reloadUsingQueue:(dispatch_queue_t)queue completion:(void (^)(BOOL reloaded))completion;
{
    NSLog(@"UISS -- reloading...");
    
    [self downloadStyleDataFromUrl:self.url queue:queue completion:^(BOOL updated) {
        if (updated) {
            [self parseStyleData:self.data queue:queue completion:^(NSDictionary *dictionary) {
                [self parseStyleDictionary:dictionary queue:queue completion:^(NSArray *propertySetters) {
                    for (UISSPropertySetter *propertySetter in propertySetters) {
                        [propertySetter.invocation invoke];
                    }
                    completion(YES);
                }];
            }];
        } else {
            completion(NO);
        }
    }];
}

- (void)reload;
{
    [self reloadUsingQueue:nil completion:^(BOOL reloaded) {
        [self scheduleRefresh];
    }];
}

- (void)reloadAsync;
{
    [self reloadUsingQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) 
                completion:^(BOOL reloaded){
                    if (reloaded) {
                        [self refreshViews];
                    }
                    
                    [self scheduleRefresh];
                }];
}

+ (void)configureWithJSONFilePath:(NSString *)filePath;
{
    UISS *uiss = [[UISS alloc] init];
    uiss.url = [NSURL fileURLWithPath:filePath];
    [uiss reload];
}

+ (void)configureWithDefaultJSONFile;
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"uiss" ofType:@"json"];
    [self configureWithJSONFilePath:filePath];
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

- (void)reloadGestureRecognizerHandler:(UILongPressGestureRecognizer *)gestureRecognizer;
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self reloadAsync];
    }
}

@end
