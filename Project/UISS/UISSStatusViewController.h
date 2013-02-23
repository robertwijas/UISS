//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UISSStatusWindowControllerDelegate;

@interface UISSStatusViewController : UIViewController

@property (nonatomic, weak) id<UISSStatusWindowControllerDelegate> delegate;

@end

@protocol UISSStatusWindowControllerDelegate <NSObject>

@optional
- (void)statusWindowControllerDidSelect:(UISSStatusViewController *)statusWindowController;

@end

