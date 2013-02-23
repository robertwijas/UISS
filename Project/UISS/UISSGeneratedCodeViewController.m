//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import "UISSGeneratedCodeViewController.h"
#import "UISSErrorsViewController.h"

@interface UISSGeneratedCodeViewController ()

@property (nonatomic, strong) UISS *uiss;
@property (nonatomic, readonly) UITextView *textView;

@property (nonatomic, strong) NSArray *errors;

@end

@implementation UISSGeneratedCodeViewController

- (id)initWithUISS:(UISS *)uiss;
{
    self = [super init];
    if (self) {
        self.uiss = uiss;

        self.title = @"Code";
        self.tabBarItem.image = [UIImage imageNamed:@"UISSResources.bundle/code"];
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
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Phone",
                                                                                                               @"Pad",
                                                                                                               nil]];
    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    [segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentedControl;
}

- (void)presentErrors;
{
    UISSErrorsViewController *errorsViewController = [[UISSErrorsViewController alloc] init];
    errorsViewController.errors = self.errors;
    [self.navigationController pushViewController:errorsViewController animated:YES];
}

- (void)updateErrorsButton;
{
    if (self.errors.count) {
        NSString *buttonTitle = [NSString stringWithFormat:@"Errors (%d)", self.errors.count];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:buttonTitle
                                                                                  style:UIBarButtonItemStyleBordered 
                                                                                 target:self 
                                                                                 action:@selector(presentErrors)];
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)setErrors:(NSArray *)errors;
{
    if (_errors != errors) {
        _errors = errors;
        
        [self updateErrorsButton];
    }
}

- (void)segmentedControlValueChanged:(UISegmentedControl *)segmentedControl;
{
    UIUserInterfaceIdiom userInterfaceIdiom = segmentedControl.selectedSegmentIndex == 0 ? UIUserInterfaceIdiomPhone : UIUserInterfaceIdiomPad;
    segmentedControl.enabled = NO;
    
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    UIBarButtonItem *activityBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicatorView];
    
    self.navigationItem.rightBarButtonItem = activityBarButtonItem;
    
    [activityIndicatorView startAnimating];
    
    [self.uiss generateCodeForUserInterfaceIdiom:userInterfaceIdiom codeHandler:^(NSString *code, NSArray *errors) {
        // remove activity indicator
        self.navigationItem.rightBarButtonItem = nil;
        
        self.errors = errors;
        self.textView.text = code;
        
        segmentedControl.enabled = YES;
    }];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
{
    return YES;
}

@end
