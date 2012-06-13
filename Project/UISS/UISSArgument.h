//
//  UISSArgument.h
//  UISS
//
//  Created by Robert Wijas on 6/2/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UISSConfig.h"
#import "UISSArgumentValueConverter.h"

@class UISSPropertySetter;

@interface UISSArgument : NSObject {
    @protected
    NSString *_name;
}

@property (nonatomic, weak) UISSPropertySetter *propertySetter;

@property (nonatomic, strong) UISSConfig *config;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) id value;

@property (nonatomic, readonly) id convertedValue;
@property (nonatomic, readonly) NSString *generatedCode;

@end

@interface UISSArgument (Subclass)

@property (nonatomic, readonly) NSString *type;
@property (nonatomic, readonly) NSArray *availableConverters;

@end