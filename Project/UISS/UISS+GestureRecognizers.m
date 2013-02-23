//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import "UISS+GestureRecognizers.h"


@implementation UISS (GestureRecognizers)

#pragma mark - Reload Gesture Recognizer Support

- (UIGestureRecognizer *)defaultGestureRecognizer {
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] init];
    recognizer.numberOfTouchesRequired = 1;
    recognizer.minimumPressDuration = 1;

    return recognizer;
}

- (void)registerReloadGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer inView:(UIView *)view {
    if (gestureRecognizer == nil) {
        gestureRecognizer = [self defaultGestureRecognizer];
    }

    [gestureRecognizer addTarget:self action:@selector(reloadGestureRecognizerHandler:)];
    [view addGestureRecognizer:gestureRecognizer];
}

- (void)registerReloadGestureRecognizerInView:(UIView *)view; {
    [self registerReloadGestureRecognizer:nil inView:view];
}

- (void)reloadGestureRecognizerHandler:(UILongPressGestureRecognizer *)gestureRecognizer; {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self reloadStyleAsynchronously];
    }
}

@end