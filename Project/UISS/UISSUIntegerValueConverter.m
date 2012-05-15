//
//  UISSUIntegerValueConverter.m
//  UISS
//
//  Created by Robert Wijas on 5/15/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import "UISSUIntegerValueConverter.h"

@implementation UISSUIntegerValueConverter

- (BOOL)canConvertPropertyWithName:(NSString *)name value:(id)value argumentType:(NSString *)argumentType;
{
    return [argumentType isEqualToString:[NSString stringWithCString:@encode(NSUInteger) encoding:NSUTF8StringEncoding]];
}

- (id)convertPropertyValue:(id)value;
{
    if ([value isKindOfClass:[NSNumber class]]) {
        NSUInteger unsignedIntegerValue = [value unsignedIntegerValue];
        return [NSValue value:&unsignedIntegerValue withObjCType:@encode(NSUInteger)];
    }
    
    return nil;
}

- (BOOL)canConvertAxisParameterWithName:(NSString *)name value:(id)value argumentType:(NSString *)argumentType;
{
    return [self canConvertPropertyWithName:name value:value argumentType:argumentType];
}

- (NSNumber *)convertAxisParameter:(id)value;
{
    if ([value isKindOfClass:[NSNumber class]]) {
        return value;
    } else {
        return nil;
    }
}

@end
