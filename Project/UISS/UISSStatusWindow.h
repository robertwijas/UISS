//
//  UISSStatusWindow.h
//  UISS
//
//  Created by Robert Wijas on 6/6/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UISSStatusView.h"

@interface UISSStatusWindow : UIWindow

@property (nonatomic, strong, readonly) UISSStatusView *statusView;

@end
