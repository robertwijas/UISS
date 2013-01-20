//
//  UISS.h
//  UISS
//
//  Created by Robert Wijas on 10/7/11.
//  Copyright (c) 2011 57things. All rights reserved.
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

- (void)load;

- (void)reload;

- (void)registerReloadGestureRecognizerInView:(UIView *)view;

// codeHandler is called on main thread
- (void)generateCodeForUserInterfaceIdiom:(UIUserInterfaceIdiom)userInterfaceIdiom
                              codeHandler:(void (^)(NSString *code, NSArray *errors))codeHandler;

#pragma mark - Factory Methods

+ (UISS *)configureWithJSONFilePath:(NSString *)filePath;

+ (UISS *)configureWithDefaultJSONFile;

+ (UISS *)configureWithURL:(NSURL *)url;

@end
