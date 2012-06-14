//
//  UISSFloatValueConverter.h
//  UISS
//
//  Created by Robert Wijas on 5/9/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UISSArgumentValueConverter.h"

#define UISS_FLOAT_VALUE_CONVERTER_DEFAULT_PRECISION 1

@interface UISSFloatValueConverter : NSObject <UISSArgumentValueConverter>

@property (nonatomic) NSUInteger precision;

- (NSString *)generateCodeForFloatValue:(CGFloat)floatValue;

@end
