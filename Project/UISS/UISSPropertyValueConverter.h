//
//  UISSValueConverter.h
//  UISS
//
//  Created by Robert Wijas on 5/8/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UISSPropertyValueConverter <NSObject>

- (BOOL)canConvertPropertyWithName:(NSString *)name value:(id)value argumentType:(NSString *)argumentType;
- (id)convertPropertyValue:(id)value;
- (NSString *)generateCodeForPropertyValue:(id)value;

@end
