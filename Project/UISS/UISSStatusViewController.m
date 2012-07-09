//
//  UISSStatusViewController.m
//  UISS
//
//  Created by Robert Wijas on 6/6/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import "UISSStatusViewController.h"
#import "UISSStatusWindow.h"
#import "UISS.h"
#import "UISSStyle.h"

@interface UISSStatusViewController ()

@property (nonatomic, readonly) UISSStatusView *statusView;
@property (nonatomic, strong) NSDictionary *statusDictionary;

@end

@implementation UISSStatusViewController

@synthesize delegate=_delegate;

@synthesize statusDictionary;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init
{
    self = [super init];
    if (self) {
        
        self.statusDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"Parsing Style Data", UISSStyleWillParseDataNotification,
                                 @"Style Data Parsed", UISSStyleDidParseDataNotification,
                                 @"Parsing Style Dictionary", UISSStyleWillParseDictionaryNotification,
                                 @"Style Dictionary Parsed", UISSStyleDidParseDictionaryNotification,
                                 @"Applying Style", UISSWillApplyStyleNotification,
                                 @"Style Applied", UISSDidApplyStyleNotification,
                                 @"Refreshing Views", UISSWillRefreshViewsNotification,
                                 @"Views Refreshed", UISSDidRefreshViewsNotification,
                                 nil];
        
        [self registerForNotifications];
    }
    return self;
}

- (void)loadView;
{
    self.view = [[UISSStatusView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
}

- (void)viewDidLoad;
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self 
                                                                                           action:@selector(tapGestureRecognizerHandler:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)tapGestureRecognizerHandler:(UIGestureRecognizer *)gestureRecognizer;
{
    if (gestureRecognizer.state == UIGestureRecognizerStateRecognized) {
        if ([self.delegate respondsToSelector:@selector(statusWindowControllerDidSelect:)]) {
            [self.delegate statusWindowControllerDidSelect:self];
        }
    }
}

- (UISSStatusView *)statusView;
{
    return (UISSStatusView *)self.view;
}

- (void)registerForNotifications;
{
    
    // UISSStyle
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(updateStatusViewForNotification:) 
                                                 name:UISSStyleWillDownloadNotification 
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(updateStatusViewForNotification:) 
                                                 name:UISSStyleDidDownloadNotification 
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(updateStatusViewForNotification:) 
                                                 name:UISSStyleWillParseDataNotification 
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(updateStatusViewForNotification:) 
                                                 name:UISSStyleDidParseDataNotification 
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(updateStatusViewForNotification:) 
                                                 name:UISSStyleWillParseDictionaryNotification 
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(updateStatusViewForNotification:) 
                                                 name:UISSStyleDidParseDictionaryNotification 
                                               object:nil];
    
    // UISS
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(updateStatusViewForNotification:) 
                                                 name:UISSWillApplyStyleNotification 
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(updateStatusViewForNotification:) 
                                                 name:UISSDidApplyStyleNotification 
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(updateStatusViewForNotification:) 
                                                 name:UISSWillRefreshViewsNotification 
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(updateStatusViewForNotification:) 
                                                 name:UISSDidRefreshViewsNotification 
                                               object:nil];
}

- (NSString *)titleForNotification:(NSNotification *)notification;
{
    return @"UISS";
}

- (NSString *)statusForNotification:(NSNotification *)notification;
{
    return [self.statusDictionary objectForKey:notification.name];
}

- (BOOL)activityForNotfication:(NSNotification *)notification;
{
    return [notification.name rangeOfString:@"Will"].location != NSNotFound;
}

- (BOOL)errorForNotification:(NSNotification *)notification;
{
    if ([notification.object isKindOfClass:[UISSStyle class]]) {
        UISSStyle *style = notification.object;
        return style.errors.count > 0;
    } else  if ([notification.object isKindOfClass:[UISS class]]) {
        UISS *uiss = notification.object;
        return uiss.style.errors.count > 0;
    }
    
    return NO;
}

- (void)updateStatusViewForNotification:(NSNotification *)notification;
{
    void (^block)(void) = ^{
        [self.statusView setTitle:[self titleForNotification:notification]
                           status:[self statusForNotification:notification]
                         activity:[self activityForNotfication:notification]
                            error:[self errorForNotification:notification]];
    };
    
    // notification may not arrive on main thread
    if (dispatch_get_current_queue() != dispatch_get_main_queue()) {
        dispatch_async(dispatch_get_main_queue(), block);
    } else {
        block();
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
{
    return YES;
}

@end
