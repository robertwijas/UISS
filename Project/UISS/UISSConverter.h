//
//  UISSConverter.h
//  UISS
//
//  Created by Robert Wijas on 6/10/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UISSConfig;
@protocol UISSPropertyValueConverter;
@protocol UISSAxisParameterValueConverter;

@interface UISSConverter : NSObject

@property (nonatomic, strong) UISSConfig *config;

- (id<UISSPropertyValueConverter>)findConverterForProperty:(NSString *)property value:(id)value
                                              argumentType:(NSString *)argumentType;
- (id<UISSAxisParameterValueConverter>)findConverterForAxisParameter:(NSString *)axisParameter value:(id)value
                                                        argumentType:(NSString *)argumentType;

@end
