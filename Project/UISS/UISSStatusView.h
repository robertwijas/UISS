//
//  UISSStatusView.h
//  UISS
//
//  Created by Robert Wijas on 6/25/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISSStatusView : UIView

- (void)setTitle:(NSString *)title status:(NSString *)status activity:(BOOL)activity error:(BOOL)error;

@end
