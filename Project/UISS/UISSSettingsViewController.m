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

    UISSSettingDescriptor *styleUrl = [[UISSSettingDescriptor alloc] init];
    styleUrl.label = @"URL";
    styleUrl.title = @"Style URL";
    styleUrl.info = @"You can provide an URL to your UISS JSON file.";
    styleUrl.keyboardType = UIKeyboardTypeURL;
    styleUrl.valueProvider = ^{
        return uiss.style.url.absoluteString;
    };
    styleUrl.valueChangeHandler = ^(id value) {
        uiss.style.url = [NSURL URLWithString:value];
    };

    UISSSettingDescriptor *autoReloadEnabled = [[UISSSettingDescriptor alloc] init];
    autoReloadEnabled.title = @"Auto Reload";
    autoReloadEnabled.label = @"Enabled";
    autoReloadEnabled.editorType = UISSSettingDescriptorEditorTypeSwitch;
    autoReloadEnabled.valueProvider = ^{
        return [NSNumber numberWithBool:uiss.autoReloadEnabled];
    };
    autoReloadEnabled.valueChangeHandler = ^(id value) {
        uiss.autoReloadEnabled = [value boolValue];
    };

    UISSSettingDescriptor *autoReloadInterval = [[UISSSettingDescriptor alloc] init];
    autoReloadInterval.title = @"Auto Reload Interval";
    autoReloadInterval.label = @"In Seconds";
    autoReloadInterval.keyboardType = UIKeyboardTypeDecimalPad;
    autoReloadInterval.valueProvider = ^{
        return [NSNumber numberWithDouble:uiss.autoReloadTimeInterval];
    };
    autoReloadInterval.valueChangeHandler = ^(id value) {
        uiss.autoReloadTimeInterval = [value doubleValue];
    };

    UISSSettingDescriptor *statusWindowEnabled = [[UISSSettingDescriptor alloc] init];
    statusWindowEnabled.title = @"Status Window";
    statusWindowEnabled.label = @"Visible";
    statusWindowEnabled.editorType = UISSSettingDescriptorEditorTypeSwitch;
    statusWindowEnabled.valueProvider = ^{
        return [NSNumber numberWithBool:uiss.statusWindowEnabled];
    };
    statusWindowEnabled.valueChangeHandler = ^(id value) {
        uiss.statusWindowEnabled = [value boolValue];
    };

    self.settingDescriptors = @[styleUrl, autoReloadEnabled, autoReloadInterval, statusWindowEnabled];
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

    cell.textLabel.text = settingDescriptor.label;

    if (settingDescriptor.editorType == UISSSettingDescriptorEditorTypeText) {
        cell.detailTextLabel.text = settingDescriptor.stringValue;
        cell.accessoryView = nil;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    } else if (settingDescriptor.editorType == UISSSettingDescriptorEditorTypeSwitch) {
        UISwitch *switchAccessoryView = [[UISwitch alloc] init];
        switchAccessoryView.on = [settingDescriptor.valueProvider() boolValue];
        switchAccessoryView.tag = indexPath.section;

        [switchAccessoryView addTarget:self action:@selector(switchAccessoryViewValueChanged:)
                      forControlEvents:UIControlEventValueChanged];

        cell.accessoryView = switchAccessoryView;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const reuseIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:reuseIdentifier];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UISSSettingDescriptor *settingDescriptor = self.settingDescriptors[(NSUInteger) indexPath.section];

    if (settingDescriptor.editorType == UISSSettingDescriptorEditorTypeText) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Change Setting"
                                                            message:settingDescriptor.title
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Change", nil];
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        alertView.delegate = self;

        UITextField *textField = [alertView textFieldAtIndex:0];
        textField.text = settingDescriptor.stringValue;
        textField.keyboardType = settingDescriptor.keyboardType;

        [alertView show];
    }
}

#pragma mark - AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSIndexPath *indexPathForSelectedRow = self.tableView.indexPathForSelectedRow;

    if (buttonIndex != alertView.cancelButtonIndex) {
        UISSSettingDescriptor *settingDescriptor = self.settingDescriptors[(NSUInteger) indexPathForSelectedRow.section];
        settingDescriptor.valueChangeHandler([alertView textFieldAtIndex:0].text);
        [self.tableView reloadRowsAtIndexPaths:@[indexPathForSelectedRow]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
    }

    [self.tableView deselectRowAtIndexPath:indexPathForSelectedRow animated:YES];
}

- (void)switchAccessoryViewValueChanged:(UISwitch *)switchAccessoryView {
    UISSSettingDescriptor *settingDescriptor = self.settingDescriptors[(NSUInteger) switchAccessoryView.tag];
    settingDescriptor.valueChangeHandler(@(switchAccessoryView.on));
}

@end