//
//  UISSCustomView.m
//  UISS
//
//  Created by Robert Wijas on 5/7/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import "UISSCustomView.h"

@interface UISSCustomView ()

@property (nonatomic, weak) UIImageView *backgroundView;
@property (nonatomic) CGFloat backgroundMargin;

@end

@implementation UISSCustomView

- (void)setBackgroundImage:(UIImage *)image;
{
    NSLog(@"DEMO: setBackgroundImage");
    
    self.backgroundView.image = image;
}

- (void)setBackgroundMargin:(CGFloat)backgroundMargin;
{
    _backgroundMargin = backgroundMargin;
    [self setNeedsLayout];
}

- (UIImageView *)backgroundView;
{
    if (_backgroundView == nil) {
        UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
        backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        [self insertSubview:backgroundView atIndex:0];
        self.backgroundView = backgroundView;
    }
    
    return _backgroundView;
}

- (void)layoutSubviews;
{
    NSLog(@"DEMO: layoutSubviews");

    [super layoutSubviews];
    
    UIEdgeInsets backgroundEdgeInsets = UIEdgeInsetsMake(self.backgroundMargin, self.backgroundMargin, self.backgroundMargin, self.backgroundMargin);
    self.backgroundView.frame = UIEdgeInsetsInsetRect(self.bounds, backgroundEdgeInsets);
}

@end
