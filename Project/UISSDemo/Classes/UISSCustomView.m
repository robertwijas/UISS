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

@end

@implementation UISSCustomView

@synthesize backgroundView=_backgroundView;

- (void)setBackgroundImage:(UIImage *)image;
{
    self.backgroundView.image = image;
}

- (UIImageView *)backgroundView;
{
    if (_backgroundView == nil) {
        UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
        backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        [self addSubview:backgroundView];
        self.backgroundView = backgroundView;
    }
    
    return _backgroundView;
}

@end
