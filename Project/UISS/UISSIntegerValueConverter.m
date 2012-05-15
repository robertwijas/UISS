//
//  UISSIntegerValueConverter.m
//  UISS
//
//  Created by Robert Wijas on 5/9/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import "UISSIntegerValueConverter.h"

@implementation UISSIntegerValueConverter

- (BOOL)canConvertPropertyWithName:(NSString *)name value:(id)value argumentType:(NSString *)argumentType;
{
    return [argumentType isEqualToString:[NSString stringWithCString:@encode(NSInteger) encoding:NSUTF8StringEncoding]];
}

- (id)convertPropertyValue:(id)value;
{
    if ([value isKindOfClass:[NSNumber class]]) {
        NSInteger integerValue = [value integerValue];
        return [NSValue value:&integerValue withObjCType:@encode(NSInteger)];
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
