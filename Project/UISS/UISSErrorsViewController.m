//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import "UISSErrorsViewController.h"

@interface UISSErrorsViewController ()

@end

@implementation UISSErrorsViewController

#pragma mark - Table view data source

- (id)init {
    self = [super init];
    if (self) {
        self.title = @"Errors";
        self.tabBarItem.image = [UIImage imageNamed:@"UISSResources.bundle/errors"];
    }
    return self;
}

- (void)viewDidLoad; {
    [super viewDidLoad];

    self.tableView.rowHeight = 100;
}

- (void)setErrors:(NSArray *)errors {
    _errors = errors;

    [self update];
}

- (void)update {
    if (self.errors.count) {
        self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", self.errors.count];
    } else {
        self.tabBarItem.badgeValue = nil;
    }

    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.errors.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation; {
    return YES;
}

@end
