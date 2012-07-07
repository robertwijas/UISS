//
//  UIView+UISS.m
//  UISS
//
//  Created by Robert Wijas on 6/21/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import "UIView+UISS.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (UISS)

- (void)setDebugBorderColor:(UIColor *)color UI_APPEARANCE_SELECTOR;
{
    if (color) {
        self.layer.borderColor = color.CGColor;
        self.layer.borderWidth = 1;
    } else {
        self.layer.borderWidth = 0;
    }
}

- (void)setBackgroundUISSColor:(UIColor *)backgroundColor;
{
    [self setBackgroundColor:backgroundColor];
}

@end
