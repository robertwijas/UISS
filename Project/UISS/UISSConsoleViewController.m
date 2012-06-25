//
//  UISSConsoleViewController.m
//  UISS
//
//  Created by Robert Wijas on 6/6/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import "UISSConsoleViewController.h"
#import "UISSGeneratedCodeViewController.h"
#import "UISSErrorsViewController.h"
#import "UISS.h"

@interface UISSConsoleViewController ()

@property (nonatomic, strong) UISS *uiss;

@end

@implementation UISSConsoleViewController

@synthesize uiss=_uiss;

- (id)initWithUISS:(UISS *)uiss;
{
    self = [super init];
    if (self) {
        self.uiss = uiss;
        
        UISSGeneratedCodeViewController *generatedCodeViewController = [[UISSGeneratedCodeViewController alloc] initWithUISS:self.uiss];
        generatedCodeViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:generatedCodeViewController.title 
                                                                               image:[UIImage imageNamed:@"UISSResources.bundle/code"] 
                                                                                 tag:0];
        UINavigationController *generatedCodeNavigationController = [[UINavigationController alloc] initWithRootViewController:generatedCodeViewController];
        
        
        UISSErrorsViewController *errorsViewController = [[UISSErrorsViewController alloc] init];
        UITabBarItem *errorsTabBarItem =[[UITabBarItem alloc] initWithTitle:errorsViewController.title 
                                                                        image:[UIImage imageNamed:@"UISSResources.bundle/errors"] 
                                                                          tag:0];
        if (self.uiss.style.errors.count) {
            errorsTabBarItem.badgeValue = [NSString stringWithFormat:@"%d", self.uiss.style.errors.count];
        }
        errorsViewController.tabBarItem = errorsTabBarItem;
        errorsViewController.errors = self.uiss.style.errors;
        
        self.viewControllers = [NSArray arrayWithObjects:generatedCodeNavigationController, errorsViewController, nil];
        
        if (self.uiss.style.errors.count) {
            self.selectedViewController = errorsViewController;
        }
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
{
    return YES;
}

@end
