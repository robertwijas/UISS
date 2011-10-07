//
//  UISSDemoDetailViewController.h
//  UISSDemo
//
//  Created by Robert Wijas on 10/7/11.
//  Copyright (c) 2011 57things. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISSDemoDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
