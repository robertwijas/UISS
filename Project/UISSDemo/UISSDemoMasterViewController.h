//
//  UISSDemoMasterViewController.h
//  UISSDemo
//
//  Created by Robert Wijas on 10/7/11.
//  Copyright (c) 2011 57things. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UISSDemoDetailViewController;

@interface UISSDemoMasterViewController : UITableViewController

@property (strong, nonatomic) UISSDemoDetailViewController *detailViewController;

@end
