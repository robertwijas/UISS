//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import "UISSStatusView.h"

@interface UISSStatusView ()

@property(nonatomic, strong, readwrite) UILabel *titleLabel;
@property(nonatomic, strong, readwrite) UILabel *statusLabel;
@property(nonatomic, strong, readwrite) UIActivityIndicatorView *activityIndicator;

@property(nonatomic, assign) BOOL error;

@end

@implementation UISSStatusView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [[UILabel alloc] initWithFrame:
                                                   CGRectInset(CGRectMake(0, 0, roundf(self.bounds.size.width * 0.5), self.bounds.size.height), 5, 0)];

        self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin;
        self.titleLabel.textAlignment = NSTextAlignmentLeft;

        self.statusLabel = [[UILabel alloc] initWithFrame:
                                                    CGRectInset(CGRectMake(roundf(self.bounds.size.width * 0.5), 0, roundf(self.bounds.size.width * 0.5), self.bounds.size.height), 5, 0)];

        self.statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin;
        self.statusLabel.textAlignment = NSTextAlignmentRight;

        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        self.activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        self.activityIndicator.center = CGPointMake(roundf(self.bounds.size.width * 0.5), roundf(self.bounds.size.height * 0.5));
        self.activityIndicator.transform = CGAffineTransformMakeScale(0.75, 0.75);

        [self addSubview:self.titleLabel];
        [self addSubview:self.statusLabel];
        [self addSubview:self.activityIndicator];
    }

    return self;
}

- (void)stopAnimatingActivityIndicator {
    [self.activityIndicator stopAnimating];
}

- (void)setTitle:(NSString *)title status:(NSString *)status activity:(BOOL)activity error:(BOOL)error; {
    self.titleLabel.text = title;
    self.statusLabel.text = status;

    // stop animation with delay to prevent flickering
    if (activity) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopAnimatingActivityIndicator)
                                                   object:nil];
        [self.activityIndicator startAnimating];
    } else {
        [self performSelector:@selector(stopAnimatingActivityIndicator) withObject:nil afterDelay:0.5];
    }

    self.error = error;

    [self updateStyle];
}

- (void)updateStyle; {
    // this prevents from changing status window style by UIAppearance proxies
    self.backgroundColor = self.error ? [UIColor redColor] : [UIColor colorWithWhite:0.2 alpha:1];

    self.statusLabel.font = [UIFont boldSystemFontOfSize:12];
    self.statusLabel.textColor = [UIColor whiteColor];
    self.statusLabel.backgroundColor = self.backgroundColor;

    self.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.backgroundColor = self.backgroundColor;
}

- (void)layoutSubviews; {
    [super layoutSubviews];
    [self updateStyle];
}

@end
