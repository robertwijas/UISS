//
//  UISSDemoAppDelegate.m
//  UISSDemo
//
//  Created by Robert Wijas on 10/21/11.
//  Copyright (c) 2011 57things. All rights reserved.
//

#import "UISSDemoAppDelegate.h"
#import "UISS.h"

@interface UISSDemoAppDelegate ()

@property(nonatomic, strong) UISS *uiss;

@end

@implementation UISSDemoAppDelegate

@synthesize window = _window;
@synthesize uiss = _uiss;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // skip the rest if running tests
    if ([[[NSProcessInfo processInfo] environment] objectForKey:@"TEST"]) {
        return YES;
    }

    self.uiss = [[UISS alloc] init];
    self.uiss.style.url = [NSURL URLWithString:@"http://uiss.10.0.1.7.xip.io/uiss_demo.json"];
    self.uiss.statusWindowEnabled = YES;
    [self.uiss registerReloadGestureRecognizerInView:self.window];

    [self.uiss load];
    [self.uiss enableAutoReloadWithTimeInterval:0.1];


    // Local style
    //[UISS configureWithDefaultJSONFile];

    return YES;
}

@end
