//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import "UISSDemoAppDelegate.h"
#import "UISS.h"

@interface UISSDemoAppDelegate ()

@property(nonatomic, strong) UISS *uiss;

@end

@implementation UISSDemoAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // skip the rest if running tests
    if ([[[NSProcessInfo processInfo] environment] objectForKey:@"TEST"]) {
        return YES;
    }

    // Remote Style
    self.uiss = [UISS configureWithURL:[NSURL URLWithString:@"http://uiss.10.0.1.7.xip.io/uiss_demo.json"]];

    // Local Style
    self.uiss = [UISS configureWithDefaultJSONFile];

    return YES;
}

@end
