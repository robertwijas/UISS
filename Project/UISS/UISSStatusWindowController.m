//
//  UISSStatusWindowController.m
//  UISS
//
//  Created by Robert Wijas on 6/6/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import "UISSStatusWindowController.h"
#import "UISSStatusWindow.h"
#import "UISS.h"

@interface UISSStatusWindowController ()

@property (nonatomic, strong) UISSStatusWindow *statusWindow;

@end

@implementation UISSStatusWindowController

@synthesize statusWindow=_statusWindow;

- (id)init
{
    self = [super init];
    if (self) {
        [self registerForNotifications];
        
        self.statusWindow = [[UISSStatusWindow alloc] init];
        [self.statusWindow makeKeyAndVisible];
        [self.statusWindow resignKeyWindow];
    }
    return self;
}

- (void)registerForNotifications;
{
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(willDownloadStyle:) 
                                                 name:UISSWillDownloadStyleNotification 
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(didDownloadStyle:) 
                                                 name:UISSDidDownloadStyleNotification 
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(willParseStyle:) 
                                                 name:UISSWillParseStyleNotification 
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(didParseStyle:) 
                                                 name:UISSDidParseStyleNotification 
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(willApplyStyle:) 
                                                 name:UISSWillApplyStyleNotification 
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(didApplyStyle:) 
                                                 name:UISSDidApplyStyleNotification 
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(willRefreshViews:) 
                                                 name:UISSWillRefreshViewsNotification 
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(didRefreshViews:) 
                                                 name:UISSDidRefreshViewsNotification 
                                               object:nil];
}

- (void)willDownloadStyle:(NSNotification *)notification;
{
    [self.statusWindow.activityIndicator startAnimating];
    self.statusWindow.statusLabel.text = @"";
}

- (void)didDownloadStyle:(NSNotification *)notification;
{
    [self.statusWindow.activityIndicator stopAnimating];
    self.statusWindow.statusLabel.text = @"";
}

- (void)willParseStyle:(NSNotification *)notification;
{
    [self.statusWindow.activityIndicator startAnimating];
    self.statusWindow.statusLabel.text = @"Parsing Style";    
}

- (void)didParseStyle:(NSNotification *)notification;
{
    [self.statusWindow.activityIndicator stopAnimating];
    self.statusWindow.statusLabel.text = @"Style Parsed";
}

- (void)willApplyStyle:(NSNotification *)notification;
{
    [self.statusWindow.activityIndicator startAnimating];
    self.statusWindow.statusLabel.text = @"Applying Style";
}

- (void)didApplyStyle:(NSNotification *)notification;
{
    [self.statusWindow.activityIndicator stopAnimating];
    self.statusWindow.statusLabel.text = @"Style Applied";
}

- (void)willRefreshViews:(NSNotification *)notification;
{
    [self.statusWindow.activityIndicator startAnimating];
    self.statusWindow.statusLabel.text = @"Refreshing Views";
}

- (void)didRefreshViews:(NSNotification *)notification;
{
    [self.statusWindow.activityIndicator stopAnimating];
    self.statusWindow.statusLabel.text = @"Views Refreshed";
}

@end
