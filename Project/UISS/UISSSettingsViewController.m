//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import "UISSSettingsViewController.h"
#import "UISSSettingDescriptor.h"


@interface UISSSettingsViewController () <UIAlertViewDelegate>

@property(nonatomic, strong) NSArray *settingDescriptors;
@property(nonatomic, strong) UISS *uiss;

@end

@implementation UISSSettingsViewController

- (id)initWithUISS:(UISS *)uiss {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.uiss = uiss;

        self.title = @"Settings";
        self.tabBarItem.image = [UIImage imageNamed:@"UISSResources.bundle/settings"];

        [self setupSettingDescriptors];
    }

    return self;
}

- (void)setupSettingDescriptors {
    UISS *uiss = self.uiss;

    UISSSettingDescriptor *urlSettingDescriptor = [[UISSSettingDescriptor alloc] init];
    urlSettingDescriptor.name = @"URL";
    urlSettingDescriptor.title = @"UISS Style URL";
    urlSettingDescriptor.info = @"You can provide an URL to your UISS JSON file.";
    urlSettingDescriptor.valueProvider = ^{
        return uiss.style.url.absoluteString;
    };
    urlSettingDescriptor.valueChangeHandler = ^(id value) {
        NSLog(@"changing value to: %@", value);
    };

    self.settingDescriptors = @[urlSettingDescriptor];
}

#pragma mark - View

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.backgroundView = nil;
}

#pragma mark - TableView Data Source & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.settingDescriptors.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    UISSSettingDescriptor *settingDescriptor = self.settingDescriptors[(NSUInteger) section];
    return settingDescriptor.title;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    UISSSettingDescriptor *settingDescriptor = self.settingDescriptors[(NSUInteger) section];
    return settingDescriptor.info;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    UISSSettingDescriptor *settingDescriptor = self.settingDescriptors[(NSUInteger) indexPath.section];
    cell.textLabel.text = settingDescriptor.name;
    cell.detailTextLabel.text = settingDescriptor.valueProvider();
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const reuseIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:reuseIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UISSSettingDescriptor *settingDescriptor = self.settingDescriptors[(NSUInteger) indexPath.section];

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Change Setting"
                                                        message:settingDescriptor.title
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Change", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    alertView.delegate = self;

    [alertView textFieldAtIndex:0].text = settingDescriptor.valueProvider();

    [alertView show];
}

#pragma mark - AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        UISSSettingDescriptor *settingDescriptor = self.settingDescriptors[(NSUInteger) self.tableView.indexPathForSelectedRow.section];
        settingDescriptor.valueChangeHandler([alertView textFieldAtIndex:0].text);
    }

    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}

@end