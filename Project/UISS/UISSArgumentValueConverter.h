//
//  UISSArgumentValueConverter.h
//  UISS
//
//  Created by Robert Wijas on 6/13/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UISSArgument;

@protocol UISSArgumentValueConverter <NSObject>

- (BOOL)canConvertValueForArgument:(UISSArgument *)argument;
- (NSString *)generateCodeForArgument:(UISSArgument *)argument;
- (id)convertValueForArgument:(UISSArgument *)argument;

@end
