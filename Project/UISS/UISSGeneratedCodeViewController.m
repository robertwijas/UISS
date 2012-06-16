//
//  UISSGeneratedCodeViewController.m
//  UISS
//
//  Created by Robert Wijas on 6/16/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import "UISSGeneratedCodeViewController.h"

@interface UISSGeneratedCodeViewController ()

@property (nonatomic, strong) UISS *uiss;
@property (nonatomic, readonly) UITextView *textView;

@end

@implementation UISSGeneratedCodeViewController

@synthesize uiss=_uiss;

- (id)initWithUISS:(UISS *)uiss;
{
    self = [super init];
    if (self) {
        self.uiss = uiss;
    }
    return self;
}

- (UITextView *)textView;
{
    return (UITextView *)self.view;
}

- (void)loadView;
{
    UITextView *textView = [[UITextView alloc] init];
    textView.editable = NO;
    
    self.view = textView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Code";
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Phone", @"Pad", nil]];
    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    [segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentedControl;
}

- (void)segmentedControlValueChanged:(UISegmentedControl *)segmentedControl;
{
    UIUserInterfaceIdiom userInterfaceIdiom = segmentedControl.selectedSegmentIndex == 0 ? UIUserInterfaceIdiomPhone : UIUserInterfaceIdiomPad;
    [self.uiss generateCodeForUserInterfaceIdiom:userInterfaceIdiom codeHandler:^(NSString *code, NSArray *errors) {
        self.textView.text = code;
    }];
}

@end
