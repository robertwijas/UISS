//
//  UISSRectValueConverter.m
//  UISS
//
//  Created by Robert Wijas on 5/9/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import "UISSRectValueConverter.h"
#import "UISSArgument.h"

@implementation UISSRectValueConverter

- (BOOL)canConvertPropertyWithName:(NSString *)name value:(id)value argumentType:(NSString *)argumentType;
{
    return [argumentType isEqualToString:[NSString stringWithCString:@encode(CGRect) encoding:NSUTF8StringEncoding]];
}

- (id)convertValue:(id)value;
{
    if ([value isKindOfClass:[NSArray class]] && [value count] == 4) {
        NSArray *array = (NSArray *) value;
        return [NSValue valueWithCGRect:CGRectMake(
                [[array objectAtIndex:0] floatValue],
                [[array objectAtIndex:1] floatValue],
                [[array objectAtIndex:2] floatValue],
                [[array objectAtIndex:3] floatValue]
        )];
    }

    return nil;
}

- (NSString *)generateCodeForValue:(id)value
{
    id converted = [self convertValue:value];

    if (converted) {
        CGRect rect = [converted CGRectValue];

        return [NSString stringWithFormat:@"CGRectMake(%.1f, %.1f, %.1f, %.1f)",
                                          rect.origin.x, rect.origin.y, rect.size.width, rect.size.height];
    } else {
        return @"CGRectZero";
    }
}

- (BOOL)canConvertValueForArgument:(UISSArgument *)argument
{
    return [self canConvertPropertyWithName:argument.name value:argument.value argumentType:argument.type];
}

@end
