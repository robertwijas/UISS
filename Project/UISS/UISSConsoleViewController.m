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
#import "UISSSettingsViewController.h"

@interface UISSConsoleViewController ()

@property(nonatomic, strong) UISS *uiss;

@end

@implementation UISSConsoleViewController

@synthesize uiss = _uiss;

- (id)initWithUISS:(UISS *)uiss; {
    self = [super init];
    if (self) {
        self.uiss = uiss;

        // Errors
        UISSErrorsViewController *errorsViewController = [[UISSErrorsViewController alloc] init];
        errorsViewController.tabBarItem.image = [UIImage imageNamed:@"UISSResources.bundle/errors"];
        errorsViewController.navigationItem.leftBarButtonItem = self.closeBarButtonItem;
        if (self.uiss.style.errors.count) {
            errorsViewController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", self.uiss.style.errors.count];
        }
        errorsViewController.errors = self.uiss.style.errors;

        UINavigationController *errorsNavigationController = [[UINavigationController alloc] initWithRootViewController:errorsViewController];

        // Config
        UISSSettingsViewController *configViewController = [[UISSSettingsViewController alloc] initWithUISS:self.uiss];
        configViewController.navigationItem.leftBarButtonItem = self.closeBarButtonItem;
        configViewController.tabBarItem.image = [UIImage imageNamed:@"UISSResources.bundle/settings"];
        UINavigationController *configNavigationController = [[UINavigationController alloc] initWithRootViewController:configViewController];


        // Code
        UISSGeneratedCodeViewController *generatedCodeViewController = [[UISSGeneratedCodeViewController alloc] initWithUISS:self.uiss];
        generatedCodeViewController.tabBarItem.image = [UIImage imageNamed:@"UISSResources.bundle/code"];
        generatedCodeViewController.navigationItem.leftBarButtonItem = self.closeBarButtonItem;
        UINavigationController *generatedCodeNavigationController = [[UINavigationController alloc] initWithRootViewController:generatedCodeViewController];

        self.viewControllers = [NSArray arrayWithObjects:errorsNavigationController, configNavigationController,
                                                         generatedCodeNavigationController, nil];

        if (self.uiss.style.errors.count) {
            self.selectedViewController = errorsViewController;
        }
    }
    return self;
}

- (UIBarButtonItem *)closeBarButtonItem {
    return [[UIBarButtonItem alloc] initWithTitle:@"Close"
                                            style:UIBarButtonItemStyleBordered
                                           target:self
                                           action:@selector(close)];
}

- (void)close {
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation; {
    return YES;
}

@end
