//
//  UISSEdgeInsetsValueConverter.m
//  UISS
//
//  Created by Robert Wijas on 5/9/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import "UISSEdgeInsetsValueConverter.h"
#import "UISSArgument.h"

@implementation UISSEdgeInsetsValueConverter

- (BOOL)canConvertPropertyWithName:(NSString *)name value:(id)value argumentType:(NSString *)argumentType;
{
    return [argumentType isEqualToString:[NSString stringWithCString:@encode(UIEdgeInsets) encoding:NSUTF8StringEncoding]];
}

- (id)convertPropertyValue:(id)value;
{
    if ([value isKindOfClass:[NSArray class]] && [value count] == 4) {
        NSArray *array = (NSArray *)value;
        return [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake([[array objectAtIndex:0] floatValue],
                                                               [[array objectAtIndex:1] floatValue],
                                                               [[array objectAtIndex:2] floatValue],
                                                               [[array objectAtIndex:3] floatValue])];
    }
    
    return nil;
}


- (NSString *)generateCodeForPropertyValue:(id)value
{
    id converted = [self convertPropertyValue:value];

    if (converted) {
        UIEdgeInsets edgeInsets = [converted UIEdgeInsetsValue];

        return [NSString stringWithFormat:@"UIEdgeInsetsMake(%.1f, %.1f, %.1f, %.1f)",
                        edgeInsets.top, edgeInsets.left, edgeInsets.bottom, edgeInsets.right];
    } else {
        return @"UIEdgeInsetsZero";
    }
}

- (BOOL)canConvertValueForArgument:(UISSArgument *)argument
{
    return [self canConvertPropertyWithName:argument.name value:argument.value argumentType:argument.type];
}

- (NSString *)generateCodeForArgument:(UISSArgument *)argument
{
    return [self generateCodeForPropertyValue:argument.value];
}

- (id)convertValueForArgument:(UISSArgument *)argument
{
    return [self convertPropertyValue:argument.value];
}

@end
