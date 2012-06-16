//
//  UISSDemoAppDelegate.m
//  UISSDemo
//
//  Created by Robert Wijas on 10/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "UISSDemoAppDelegate.h"
#import "UISS.h"

#import "UISSDemoSecondViewController.h"
#import "UISSStatusWindow.h"

@interface UISSDemoAppDelegate ()

@property (nonatomic, strong) UISS *uiss;
@property (nonatomic, strong) UISSStatusWindow *statusWindow;

@end

@implementation UISSDemoAppDelegate

@synthesize window = _window;
@synthesize uiss = _uiss;
@synthesize statusWindow = _statusWindow;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // skip the rest if running tests
    if ([[[NSProcessInfo processInfo] environment] objectForKey:@"TEST"]) {
        return YES;
    }

    self.uiss = [[UISS alloc] init];
    self.uiss.statusWindowEnabled = YES;
    self.uiss.url = [NSURL URLWithString:@"https://dl.dropbox.com/s/39ulxi0b7bojx1k/uiss%20demo.json?dl=1"];
    self.uiss.refreshInterval = 5;
    
    [self.uiss registerReloadGestureRecognizerInView:self.window];
    [self.uiss reload];
    
    //[UISS configureWithDefaultJSONFile];
    
    return YES;
}

@end
