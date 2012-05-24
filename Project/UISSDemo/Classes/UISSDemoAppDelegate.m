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

@interface UISSDemoAppDelegate ()

@property (nonatomic, strong) UISS *uiss;

@end

@implementation UISSDemoAppDelegate

@synthesize window = _window;
@synthesize uiss=_uiss;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.uiss = [[UISS alloc] init];
    self.uiss.url = [NSURL URLWithString:@"https://dl.dropbox.com/s/5jv1isaom3i8hsr/uiss.json?dl=1"];
    [self.uiss reload];

    UILongPressGestureRecognizer *reloadGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(reloadGestureRecognizerHandler:)];
    reloadGestureRecognizer.numberOfTouchesRequired = 1;
    reloadGestureRecognizer.minimumPressDuration = 3;
    
    [self.window addGestureRecognizer:reloadGestureRecognizer];
    
    //[UISS configureWithDefaultJSONFile];
    
    return YES;
}

- (void)refresh:(UIView *)view;
{
    [view.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        [self refresh:subview];
    }];
    [view setNeedsLayout];
    [view setNeedsDisplay];
}

- (void)reloadGestureRecognizerHandler:(UILongPressGestureRecognizer *)gestureRecognizer;
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"UISS" 
                                                            message:@"Realoading..." 
                                                           delegate:nil
                                                  cancelButtonTitle:nil 
                                                  otherButtonTitles:nil];
        [alertView show];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.uiss reload];
            [self refresh:self.window];
            
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
        });
    }
}

@end
