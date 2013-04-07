//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import "UISSStatusViewController.h"
#import "UISSStatusWindow.h"
#import "UISS.h"

@interface UISSStatusViewController ()

@property(nonatomic, readonly) UISSStatusView *statusView;
@property(nonatomic, strong) NSDictionary *statusDictionary;

@end

@implementation UISSStatusViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init {
    self = [super init];
    if (self) {

        self.statusDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                      @"Parsing Style Data", UISSStyleWillParseDataNotification,
                                                      @"Style Data Parsed", UISSStyleDidParseDataNotification,
                                                      @"Parsing Style Dictionary",
                                                      UISSStyleWillParseDictionaryNotification,
                                                      @"Style Dictionary Parsed",
                                                      UISSStyleDidParseDictionaryNotification,
                                                      @"Applying Style", UISSWillApplyStyleNotification,
                                                      @"Style Applied", UISSDidApplyStyleNotification,
                                                      @"Refreshing Views", UISSWillRefreshViewsNotification,
                                                      @"Views Refreshed", UISSDidRefreshViewsNotification,
                                                      nil];

        [self registerForNotifications];
    }
    return self;
}

- (void)loadView; {
    self.view = [[UISSStatusView alloc] initWithFrame:[UIScreen mainScreen].bounds];
}

- (void)viewDidLoad; {
    [super viewDidLoad];

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(tapGestureRecognizerHandler:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)tapGestureRecognizerHandler:(UIGestureRecognizer *)gestureRecognizer; {
    if (gestureRecognizer.state == UIGestureRecognizerStateRecognized) {
        if ([self.delegate respondsToSelector:@selector(statusWindowControllerDidSelect:)]) {
            [self.delegate statusWindowControllerDidSelect:self];
        }
    }
}

- (UISSStatusView *)statusView; {
    return (UISSStatusView *) self.view;
}

- (void)registerForNotifications; {

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

- (NSString *)titleForNotification:(NSNotification *)notification; {
    return @"UISS";
}

- (NSString *)statusForNotification:(NSNotification *)notification; {
    return [self.statusDictionary objectForKey:notification.name];
}

- (BOOL)activityForNotification:(NSNotification *)notification; {
    return [notification.name rangeOfString:@"Will"].location != NSNotFound;
}

- (BOOL)errorForNotification:(NSNotification *)notification; {
    if ([notification.object isKindOfClass:[UISSStyle class]]) {
        UISSStyle *style = notification.object;
        return style.errors.count > 0;
    } else if ([notification.object isKindOfClass:[UISS class]]) {
        UISS *uiss = notification.object;
        return uiss.style.errors.count > 0;
    }

    return NO;
}

- (void)updateStatusViewForNotification:(NSNotification *)notification; {
    [self.statusView setTitle:[self titleForNotification:notification]
                       status:[self statusForNotification:notification]
                     activity:[self activityForNotification:notification]
                        error:[self errorForNotification:notification]];
}

#pragma mark - Interface Orientation

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration; {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    self.view.window.hidden = YES; // Bad animation workaround
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation; {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    self.view.window.hidden = NO; // Bad animation workaround
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation; {
    return YES;
}

@end
