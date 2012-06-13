//
//  UISSSizeValueConverter.m
//  UISS
//
//  Created by Robert Wijas on 5/9/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import "UISSSizeValueConverter.h"
#import "UISSArgument.h"

@implementation UISSSizeValueConverter

- (BOOL)canConvertPropertyWithName:(NSString *)name value:(id)value argumentType:(NSString *)argumentType;
{
    return [argumentType isEqualToString:[NSString stringWithCString:@encode(CGSize) encoding:NSUTF8StringEncoding]];
}

- (id)convertPropertyValue:(id)value;
{
    if ([value isKindOfClass:[NSArray class]]) {
        CGFloat width = 0, height = 0;
        NSArray *array = (NSArray *) value;

        if (array.count > 0) {
            width = [[array objectAtIndex:0] floatValue];
        }

        if (array.count > 1) {
            height = [[array objectAtIndex:1] floatValue];
        } else {
            height = width;
        }

        return [NSValue valueWithCGSize:CGSizeMake(width, height)];
    } else if ([value isKindOfClass:[NSNumber class]]) {
        return [NSValue valueWithCGSize:CGSizeMake([value floatValue], [value floatValue])];
    }

    return nil;
}

- (NSString *)generateCodeForPropertyValue:(id)value
{
    id converted = [self convertPropertyValue:value];

    if (converted) {
        CGSize size = [converted CGSizeValue];

        return [NSString stringWithFormat:@"CGSizeMake(%.1f, %.1f)",
                                          size.width, size.height];
    } else {
        return @"CGSizeZero";
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
