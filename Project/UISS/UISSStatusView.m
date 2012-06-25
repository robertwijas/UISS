//
//  UISSStatusView.m
//  UISS
//
//  Created by Robert Wijas on 6/25/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import "UISSStatusView.h"

@interface UISSStatusView ()

@property (nonatomic, strong, readwrite) UILabel *titleLabel;
@property (nonatomic, strong, readwrite) UILabel *statusLabel;
@property (nonatomic, strong, readwrite) UIActivityIndicatorView *activityIndicator;

@property (nonatomic, assign) BOOL error;

@end

@implementation UISSStatusView

@synthesize titleLabel=_titleLabel;
@synthesize statusLabel=_statusLabel;
@synthesize activityIndicator=_activityIndicator;

@synthesize error=_error;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [[UILabel alloc] initWithFrame:
                           CGRectInset(CGRectMake(0, 0, roundf(self.bounds.size.width*0.5), self.bounds.size.height), 5, 0)];
        
        self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleRightMargin;
        self.titleLabel.textAlignment = UITextAlignmentLeft;
        
        self.statusLabel = [[UILabel alloc] initWithFrame:
                            CGRectInset(CGRectMake(roundf(self.bounds.size.width*0.5), 0, roundf(self.bounds.size.width*0.5), self.bounds.size.height), 5, 0)];
        
        self.statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin;
        self.statusLabel.textAlignment = UITextAlignmentRight;
        
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        self.activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        self.activityIndicator.center = CGPointMake(roundf(self.bounds.size.width*0.5), roundf(self.bounds.size.height*0.5));
        self.activityIndicator.transform = CGAffineTransformMakeScale(0.75, 0.75);
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.statusLabel];
        [self addSubview:self.activityIndicator];
    }
    
    return self;
}

- (void)setTitle:(NSString *)title status:(NSString *)status activity:(BOOL)activity error:(BOOL)error;
{
    self.titleLabel.text = title;
    self.statusLabel.text = status;
    
    if (activity) {
        [self.activityIndicator startAnimating];
    } else {
        [self.activityIndicator stopAnimating];
    }
    
    self.error = error;
    
    [self updateStyle];
}

- (void)updateStyle;
{
    // this prevents from changing status window style by UIAppearance proxies
    self.backgroundColor = self.error ? [UIColor redColor] : [UIColor colorWithWhite:0.2 alpha:1];
    
    self.statusLabel.font = [UIFont boldSystemFontOfSize:12];
    self.statusLabel.textColor = [UIColor whiteColor];
    self.statusLabel.backgroundColor = self.backgroundColor;
    
    self.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.backgroundColor = self.backgroundColor;
}

- (void)layoutSubviews;
{
    [super layoutSubviews];
    [self updateStyle];
}

@end
