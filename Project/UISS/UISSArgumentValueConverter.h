//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UISSArgument;

@protocol UISSArgumentValueConverter <NSObject>

- (BOOL)canConvertValueForArgument:(UISSArgument *)argument;

- (NSString *)generateCodeForValue:(id)value;

- (id)convertValue:(id)value;

@end
