//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import "UISSStatusWindow.h"

@interface UISSStatusWindow ()

@end

@implementation UISSStatusWindow

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init
{
    self = [super initWithFrame:[UIApplication sharedApplication].statusBarFrame];
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
    if (self) {
        self.windowLevel = UIWindowLevelStatusBar + 1;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeStatusBarFrame:) 
                                                     name:UIApplicationDidChangeStatusBarOrientationNotification 
                                                   object:nil];
    }
    return self;
}

- (void)didChangeStatusBarFrame:(NSNotification *)notification;
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateLayout];
    });
}

- (void)updateLayout;
{
    self.frame = [self frameForOrientation:[UIApplication sharedApplication].statusBarOrientation];
    self.rootViewController.view.frame = self.bounds;
}

- (CGRect)frameForOrientation:(UIInterfaceOrientation)orientation;
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat height = 20;
    
    switch (orientation) {
        case UIInterfaceOrientationLandscapeLeft:
            return CGRectMake(0, 0, height, screenSize.height);
        case UIInterfaceOrientationLandscapeRight:
            return CGRectMake(screenSize.width - height, 0, height, screenSize.height);
        case UIInterfaceOrientationPortraitUpsideDown:
            return CGRectMake(0, screenSize.height - height, screenSize.width, height);
        case UIInterfaceOrientationPortrait:
        default:
            return CGRectMake(0, 0, screenSize.width, height);
    }
}

- (void)layoutSubviews;
{
    [super layoutSubviews];
    
    [self updateLayout];
}

@end
