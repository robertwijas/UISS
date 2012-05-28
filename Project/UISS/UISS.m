//
//  UISS.m
//  UISS
//
//  Created by Robert Wijas on 10/7/11.
//  Copyright (c) 2011 57things. All rights reserved.
//

#import "UISS.h"

#import "UISSParser.h"

@interface UISS ()

@end

@implementation UISS

@synthesize url=_url;

- (void)reloadUsingQueue:(dispatch_queue_t)queue completion:(void (^)())completion;
{
    NSLog(@"UISS -- configuring with url: %@", self.url);
    
    void (^block)(void) = ^{
        NSData *data = [NSData dataWithContentsOfURL:self.url];
        
        if (data) {
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                       options:0 
                                                                         error:NULL];
            
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
            
            if (completion) {
                if (dispatch_get_current_queue() == dispatch_get_main_queue()) {
                    completion();
                } else{
                    dispatch_async(dispatch_get_main_queue(), completion);
                }
            }
            
            NSLog(@"UISS -- configured");
        } else {
            NSLog(@"UISS -- cannot load file from url: %@", self.url);
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
    recognizer.numberOfTouchesRequired = 3;
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
        }];
    }
}

@end
