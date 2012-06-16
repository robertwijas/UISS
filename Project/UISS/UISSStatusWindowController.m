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

@synthesize delegate=_delegate;
@synthesize statusWindow=_statusWindow;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init
{
    self = [super init];
    if (self) {
        [self registerForNotifications];
        
        self.statusWindow = [[UISSStatusWindow alloc] init];
        self.statusWindow.hidden = NO;
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self 
                                                                                               action:@selector(tapGestureRecognizerHandler:)];
        [self.statusWindow addGestureRecognizer:tapGestureRecognizer];
    }
    return self;
}

- (void)tapGestureRecognizerHandler:(UIGestureRecognizer *)gestureRecognizer;
{
    if (gestureRecognizer.state == UIGestureRecognizerStateRecognized) {
        if ([self.delegate respondsToSelector:@selector(statusWindowControllerDidSelect:)]) {
            [self.delegate statusWindowControllerDidSelect:self];
        }
    }
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
