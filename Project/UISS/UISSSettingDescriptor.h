//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, UISSSettingDescriptorEditorType) {
    UISSSettingDescriptorEditorTypeText = 0,
    UISSSettingDescriptorEditorTypeSwitch
};

@interface UISSSettingDescriptor : NSObject

@property(nonatomic, strong) NSString *label;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *info;

@property(nonatomic) UISSSettingDescriptorEditorType editorType;
@property(nonatomic) UIKeyboardType keyboardType;

@property(nonatomic, copy) id (^valueProvider)();
@property(nonatomic, copy) void (^valueChangeHandler)(id);

@property(nonatomic, readonly) NSString *stringValue;

@end