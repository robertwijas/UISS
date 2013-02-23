//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import "UISSConfig.h"
#import "UISSStyle.h"

extern NSString *const UISSWillApplyStyleNotification;
extern NSString *const UISSDidApplyStyleNotification;

extern NSString *const UISSWillRefreshViewsNotification;
extern NSString *const UISSDidRefreshViewsNotification;

@interface UISS : NSObject

@property(nonatomic, strong) UISSConfig *config;
@property(nonatomic, assign) BOOL statusWindowEnabled;

@property(nonatomic) NSTimeInterval autoReloadTimeInterval;
@property(nonatomic) BOOL autoReloadEnabled;

@property(nonatomic, strong) UISSStyle *style;

- (void)loadStyleSynchronously;

- (void)reloadStyleAsynchronously;

// code handler is called on main thread
- (void)generateCodeForUserInterfaceIdiom:(UIUserInterfaceIdiom)userInterfaceIdiom
                              codeHandler:(void (^)(NSString *code, NSArray *errors))codeHandler;

- (void)presentConsoleViewController;

#pragma mark - Factory Methods

+ (UISS *)configureWithJSONFilePath:(NSString *)filePath;

+ (UISS *)configureWithDefaultJSONFile;

+ (UISS *)configureWithURL:(NSURL *)url;

@end
