//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import "UISSConsoleViewController.h"
#import "UISSGeneratedCodeViewController.h"
#import "UISSErrorsViewController.h"
#import "UISSSettingsViewController.h"

@interface UISSConsoleViewController ()

@property(nonatomic, strong) UISS *uiss;
@property(nonatomic, strong) UISSErrorsViewController *errorsViewController;

@end

@implementation UISSConsoleViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (id)initWithUISS:(UISS *)uiss; {
    self = [super init];
    if (self) {
        self.uiss = uiss;

        // Errors
        self.errorsViewController = [[UISSErrorsViewController alloc] init];
        self.errorsViewController.navigationItem.leftBarButtonItem = [self createCloseBarButton];
        [self updateErrors];

        UINavigationController *errorsNavigationController = [[UINavigationController alloc] initWithRootViewController:self.errorsViewController];

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

        [self registerForNotifications];
    }
    return self;
}

- (void)registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateErrors)
                                                 name:UISSStyleDidParseDataNotification
                                               object:self.uiss.style];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateErrors)
                                                 name:UISSStyleDidParseDictionaryNotification
                                               object:self.uiss.style];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateErrors)
                                                 name:UISSDidApplyStyleNotification
                                               object:self.uiss];
}

- (void)updateErrors {
    self.errorsViewController.errors = self.uiss.style.errors;
}

- (UIBarButtonItem *)createCloseBarButton {
    return [[UIBarButtonItem alloc] initWithTitle:@"Close"
                                            style:UIBarButtonItemStyleBordered
                                           target:self
                                           action:@selector(close)];
}

- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation; {
    return YES;
}

@end
