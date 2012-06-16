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

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong, readwrite) UILabel *titleLabel;
@property (nonatomic, strong, readwrite) UILabel *statusLabel;
@property (nonatomic, strong, readwrite) UIActivityIndicatorView *activityIndicator;

@end

@implementation UISSStatusWindow

@synthesize containerView=_containerView;
@synthesize titleLabel=_titleLabel;
@synthesize statusLabel=_statusLabel;
@synthesize activityIndicator=_activityIndicator;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init
{
    self = [super initWithFrame:[UIApplication sharedApplication].statusBarFrame];
    if (self) {
        self.windowLevel = UIWindowLevelStatusBar + 1;
        
        self.containerView = [[UIView alloc] initWithFrame:self.bounds];
        self.containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:
                           CGRectInset(CGRectMake(0, 0, roundf(self.bounds.size.width*0.5), self.bounds.size.height), 5, 0)];
        
        self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleRightMargin;
        self.titleLabel.text = @"UISS";
        self.titleLabel.textAlignment = UITextAlignmentLeft;

        self.statusLabel = [[UILabel alloc] initWithFrame:
                           CGRectInset(CGRectMake(roundf(self.bounds.size.width*0.5), 0, roundf(self.bounds.size.width*0.5), self.bounds.size.height), 5, 0)];
        
        self.statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin;
        self.statusLabel.textAlignment = UITextAlignmentRight;
        
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        self.activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        self.activityIndicator.center = CGPointMake(roundf(self.bounds.size.width*0.5), roundf(self.bounds.size.height*0.5));
        self.activityIndicator.transform = CGAffineTransformMakeScale(0.75, 0.75);

        [self.containerView addSubview:self.titleLabel];
        [self.containerView addSubview:self.statusLabel];
        [self.containerView addSubview:self.activityIndicator];
        [self addSubview:self.containerView];
        
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
    self.transform = [self transformForOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

- (void)updateStyle;
{
    // this prevents from changing status window style by UIAppearance proxies

    self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1];
    self.containerView.backgroundColor = self.backgroundColor;

    self.statusLabel.font = [UIFont boldSystemFontOfSize:12];
    self.statusLabel.textColor = [UIColor whiteColor];
    self.statusLabel.backgroundColor = self.backgroundColor;
    
    self.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.backgroundColor = self.backgroundColor;
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
    [self updateStyle];
}

@end
