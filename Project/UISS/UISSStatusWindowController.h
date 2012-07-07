//
//  UISSStatusWindowController.h
//  UISS
//
//  Created by Robert Wijas on 6/6/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UISSStatusWindowControllerDelegate;

@interface UISSStatusWindowController : UIViewController

@property (nonatomic, weak) id<UISSStatusWindowControllerDelegate> delegate;

@end

@protocol UISSStatusWindowControllerDelegate <NSObject>

@optional
- (void)statusWindowControllerDidSelect:(UISSStatusWindowController *)statusWindowController;

@end

