//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UISSConfig : NSObject

@property (nonatomic, strong) NSArray *propertyValueConverters;
@property (nonatomic, strong) NSArray *axisParameterValueConverters;
@property (nonatomic, strong) NSArray *preprocessors;

+ (UISSConfig *)sharedConfig;

@end
