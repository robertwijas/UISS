//
//  UISS.h
//  UISS
//
//  Created by Robert Wijas on 10/7/11.
//  Copyright (c) 2011 57things. All rights reserved.
//

extern NSString *const UISSWillDownloadStyleNotification;
extern NSString *const UISSDidDownloadStyleNotification;

extern NSString *const UISSWillParseStyleNotification;
extern NSString *const UISSDidParseStyleNotification;

extern NSString *const UISSWillApplyStyleNotification;
extern NSString *const UISSDidApplyStyleNotification;

extern NSString *const UISSWillRefreshViewsNotification;
extern NSString *const UISSDidRefreshViewsNotification;

@interface UISS : NSObject

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, assign) NSTimeInterval refreshInterval;

- (void)reload;
- (void)registerReloadGestureRecognizerInView:(UIView *)view;

+ (void)configureWithJSONFilePath:(NSString *)filePath;
+ (void)configureWithDefaultJSONFile;

@end
