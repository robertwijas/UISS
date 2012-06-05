//
//  UISS.m
//  UISS
//
//  Created by Robert Wijas on 10/7/11.
//  Copyright (c) 2011 57things. All rights reserved.
//

#import "UISS.h"

#import <QuartzCore/QuartzCore.h>
#import "UISSParser.h"
#import <objc/runtime.h>

@interface UISS ()

@property (atomic, strong) NSData *data;

@end

@implementation UISS

@synthesize data=_data;
@synthesize url=_url;
@synthesize refreshInterval=_refreshInterval;

- (void)debugUIAppearance;
{
    unsigned int count = 0;
    Method *methods = class_copyMethodList(NSClassFromString(@"_UIAppearance"), &count);
    
    for (int i = 0; i < count; i++) {
        SEL selector = method_getName(methods[i]);
        NSLog(@"%@", NSStringFromSelector(selector));
    }
}

- (void)reloadUsingQueue:(dispatch_queue_t)queue completion:(void (^)())completion;
{
    NSLog(@"UISS -- configuring with url: %@", self.url);
    
    void (^block)(void) = ^{
        NSData *data = [NSData dataWithContentsOfURL:self.url];
        
        if (data && [data isEqualToData:self.data] == NO) {
            NSError *error;
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                       options:NSJSONReadingMutableContainers
                                                                         error:&error];
            
            if (error) {
                NSLog(@"UISS -- cannot parse JSON file, error: %@", error);
            } else {
                UISSParser *parser = [[UISSParser alloc] init];
                
                [parser parseDictionary:dictionary handler:^(NSInvocation *invocation) {
                    NSLog(@"UISS -- invocation: %@ %@", invocation.target, NSStringFromSelector(invocation.selector));
                    
                    if (dispatch_get_current_queue() == dispatch_get_main_queue()) {
                        [invocation invoke];
                    } else {
                        [invocation retainArguments];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [invocation invoke];
                        });
                    }
                }];
            }
            
            if (completion) {
                if (dispatch_get_current_queue() == dispatch_get_main_queue()) {
                    completion();
                } else{
                    dispatch_async(dispatch_get_main_queue(), completion);
                }
            }
            
            // store data for comparison
            self.data = data;
            
            NSLog(@"UISS -- configured");
        } else {
            NSLog(@"UISS -- cannot load file from url: %@", self.url);
        }
        
        if (self.refreshInterval) {
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, self.refreshInterval * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self reloadUsingQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) completion:^{
                    [self reloadViews];
                }];
            });
        }
    };
    
    if (queue) {
        dispatch_async(queue, block);    
    } else {
        block();
    }
}

- (void)reload;
{
    [self debugUIAppearance];
    [self reloadUsingQueue:nil completion:nil];
}

+ (void)configureWithJSONFilePath:(NSString *)filePath;
{
    UISS *uiss = [[UISS alloc] init];
    uiss.url = [NSURL fileURLWithPath:filePath];
    [uiss reload];
}

+ (void)configureWithDefaultJSONFile;
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"uiss" ofType:@"json"];
    [self configureWithJSONFilePath:filePath];
}

#pragma mark - Reload Gesture Recognizer Support

- (UIGestureRecognizer *)defaultGestureRecognizer;
{
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] init];
    recognizer.numberOfTouchesRequired = 1;
    recognizer.minimumPressDuration = 1;
    
    return recognizer;
}

- (void)registerReloadGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer inView:(UIView *)view;
{
    if (gestureRecognizer == nil) {
        gestureRecognizer = [self defaultGestureRecognizer];
    }
    
    [gestureRecognizer addTarget:self action:@selector(reloadGestureRecognizerHandler:)];
    [view addGestureRecognizer:gestureRecognizer];
}

- (void)registerReloadGestureRecognizerInView:(UIView *)view;
{
    [self registerReloadGestureRecognizer:nil inView:view];
}

- (void)reloadView:(UIView *)view;
{
    for (UIView *subview in view.subviews) {
        [self reloadView:subview];
    }
    
    UIView *superview = view.superview;
    if (superview) {
        [view removeFromSuperview];
        [superview addSubview:view];
    }
}

- (void)reloadViews;
{
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        for (UIView *view in window.subviews) {
            [view removeFromSuperview];
            [window addSubview:view];
        }
        //[self reloadView:window];
    }
}

- (void)reloadGestureRecognizerHandler:(UILongPressGestureRecognizer *)gestureRecognizer;
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"UISS" 
                                                            message:@"Realoading..." 
                                                           delegate:nil
                                                  cancelButtonTitle:@"Close" 
                                                  otherButtonTitles:nil];
        [alertView show];
        
        [self reloadUsingQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) completion:^{
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
            [self reloadViews];
        }];
    }
}

@end
