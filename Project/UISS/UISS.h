//
//  UISS.h
//  UISS
//
//  Created by Robert Wijas on 10/7/11.
//  Copyright (c) 2011 57things. All rights reserved.
//

@interface UISS : NSObject

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, assign) NSTimeInterval refreshInterval;

- (void)reload;
- (void)registerReloadGestureRecognizerInView:(UIView *)view;

+ (void)configureWithJSONFilePath:(NSString *)filePath;
+ (void)configureWithDefaultJSONFile;

@end
