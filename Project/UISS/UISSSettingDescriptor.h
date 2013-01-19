//
// Copyright 2013 Taptera Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UISSSettingDescriptor : NSObject

@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *info;

@property(nonatomic, copy) id (^valueProvider)();
@property(nonatomic, copy) void (^valueChangeHandler)(id);

@end