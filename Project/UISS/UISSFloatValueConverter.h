//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UISSArgumentValueConverter.h"

#define UISS_FLOAT_VALUE_CONVERTER_DEFAULT_PRECISION 1

@interface UISSFloatValueConverter : NSObject <UISSArgumentValueConverter>

@property (nonatomic) NSUInteger precision;

- (NSString *)generateCodeForFloatValue:(CGFloat)floatValue;

@end
