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
        errorsViewController.navigationItem.leftBarButtonItem = [self createCloseBarButton];
        if (self.uiss.style.errors.count) {
            errorsViewController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",
                                                                                    self.uiss.style.errors.count];
        }
        errorsViewController.errors = self.uiss.style.errors;

        UINavigationController *errorsNavigationController = [[UINavigationController alloc] initWithRootViewController:errorsViewController];

        // Config
        UISSSettingsViewController *settingsViewController = [[UISSSettingsViewController alloc] initWithUISS:self.uiss];
        settingsViewController.navigationItem.leftBarButtonItem = [self createCloseBarButton];
        UINavigationController *configNavigationController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];


        // Code
        UISSGeneratedCodeViewController *generatedCodeViewController = [[UISSGeneratedCodeViewController alloc] initWithUISS:self.uiss];
        generatedCodeViewController.navigationItem.leftBarButtonItem = [self createCloseBarButton];
        UINavigationController *generatedCodeNavigationController = [[UINavigationController alloc] initWithRootViewController:generatedCodeViewController];

        self.viewControllers = [NSArray arrayWithObjects:errorsNavigationController, configNavigationController,
                                                         generatedCodeNavigationController, nil];

        if (self.uiss.style.errors.count) {
            self.selectedViewController = errorsNavigationController;
        } else {
            self.selectedViewController = configNavigationController;
        }
    }
    return self;
}

- (UIBarButtonItem *)createCloseBarButton {
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
