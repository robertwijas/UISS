//
//  UISSStatusWindow.m
//  UISS
//
//  Created by Robert Wijas on 6/6/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import "UISSStatusWindow.h"
#import "UISSConsoleViewController.h"

@interface UISSStatusWindow ()

@property (nonatomic, strong, readwrite) UISSStatusView *statusView;

@end

@implementation UISSStatusWindow

@synthesize statusView=_statusView;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init
{
    self = [super initWithFrame:[UIApplication sharedApplication].statusBarFrame];
    if (self) {
        self.windowLevel = UIWindowLevelStatusBar + 1;
        
        self.statusView = [[UISSStatusView alloc] initWithFrame:self.bounds];
        self.statusView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        [self addSubview:self.statusView];
        
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
    self.transform = [self transformForOrientation:[UIApplication sharedApplication].statusBarOrientation];
    self.frame = [self frameForOrientation:[UIApplication sharedApplication].statusBarOrientation];
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

- (CGAffineTransform)transformForOrientation:(UIInterfaceOrientation)orientation;
{
    switch (orientation) {
        case UIInterfaceOrientationLandscapeLeft:
            return CGAffineTransformMakeRotation((CGFloat) -M_PI_2);
        case UIInterfaceOrientationLandscapeRight:
            return CGAffineTransformMakeRotation((CGFloat) M_PI_2);
        case UIInterfaceOrientationPortraitUpsideDown:
            return CGAffineTransformMakeRotation((CGFloat) M_PI);
        case UIInterfaceOrientationPortrait:
        default:
            return CGAffineTransformMakeRotation(0);
    }
}

- (void)layoutSubviews;
{
    [super layoutSubviews];
    
    [self updateLayout];
}

@end
