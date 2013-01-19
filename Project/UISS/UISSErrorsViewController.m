//
//  UISSErrorsViewController.m
//  UISS
//
//  Created by Robert Wijas on 6/18/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import "UISSErrorsViewController.h"

@interface UISSErrorsViewController ()

@end

@implementation UISSErrorsViewController

@synthesize errors=_errors;

#pragma mark - Table view data source

- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"Errors";
    }
    return self;
}

- (void)viewDidLoad;
{
    [super viewDidLoad];
    
    self.tableView.rowHeight = 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.errors.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ErrorCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSError *error = [self.errors objectAtIndex:(NSUInteger) indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = error.localizedDescription;
    
    return cell;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
{
    return YES;
}

@end
