//
//  UISSConverter.m
//  UISS
//
//  Created by Robert Wijas on 6/10/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import "UISSConverter.h"

#import "UISSColorValueConverter.h"
#import "UISSAxisParameterValueConverter.h"
#import "UISSConfig.h"

@implementation UISSConverter

@synthesize config = _config;

- (id)init
{
    self = [super init];
    if (self) {
        self.config = [UISSConfig sharedConfig];
    }
    
    return self;
}

- (id<UISSPropertyValueConverter>)findConverterForProperty:(NSString *)property value:(id)value
                                              argumentType:(NSString *)argumentType;
{
    for (id<UISSPropertyValueConverter> converter in self.config.propertyValueConverters) {
        if ([converter canConvertPropertyWithName:property value:value argumentType:argumentType]) {
            return converter;
        }
    }

    return nil;
}

- (id<UISSAxisParameterValueConverter>)findConverterForAxisParameter:(NSString *)axisParameter value:(id)value
                                                        argumentType:(NSString *)argumentType;
{
    for (id<UISSAxisParameterValueConverter> converter in self.config.axisParameterValueConverters) {
        if ([converter canConvertAxisParameterWithName:axisParameter value:value argumentType:argumentType]) {
            return converter;
        }
    }

    return nil;
}

@end
