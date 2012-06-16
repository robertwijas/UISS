//
//  UISSConsoleViewController.m
//  UISS
//
//  Created by Robert Wijas on 6/6/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import "UISSConsoleViewController.h"
#import "UISSGeneratedCodeViewController.h"
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
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:generatedCodeViewController];
        self.viewControllers = [NSArray arrayWithObject:navigationController];
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
{
    return YES;
}

- (void)viewDidLayoutSubviews;
{
    [super viewDidLayoutSubviews];
    
    self.tabBar.tintColor = [UIColor darkGrayColor];
}

@end
