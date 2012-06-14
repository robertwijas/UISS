//
//  UISSUIntegerValueConverter.m
//  UISS
//
//  Created by Robert Wijas on 5/15/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import "UISSUIntegerValueConverter.h"
#import "UISSArgument.h"

@implementation UISSUIntegerValueConverter

- (BOOL)canConvertPropertyWithName:(NSString *)name value:(id)value argumentType:(NSString *)argumentType;
{
    return [argumentType isEqualToString:[NSString stringWithCString:@encode(NSUInteger) encoding:NSUTF8StringEncoding]];
}

- (BOOL)canConvertAxisParameterWithName:(NSString *)name value:(id)value argumentType:(NSString *)argumentType;
{
    return [self canConvertPropertyWithName:name value:value argumentType:argumentType];
}

- (NSNumber *)convertValue:(id)value;
{
    if ([value isKindOfClass:[NSNumber class]]) {
        return value;
    } else {
        return nil;
    }
}

- (NSString *)generateCodeForValue:(id)value
{
    return nil;
}

- (BOOL)canConvertValueForArgument:(UISSArgument *)argument
{
    return [self canConvertPropertyWithName:argument.name value:argument.value argumentType:argument.type];
}

@end
