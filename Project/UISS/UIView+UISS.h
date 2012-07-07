//
//  UIView+UISS.h
//  UISS
//
//  Created by Robert Wijas on 6/21/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (UISS)

- (void)setBackgroundUISSColor:(UIColor *)backgroundColor UI_APPEARANCE_SELECTOR;
- (void)setDebugBorderColor:(UIColor *)color UI_APPEARANCE_SELECTOR;

@end
