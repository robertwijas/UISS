//
//  UISSRectValueConverter.m
//  UISS
//
//  Created by Robert Wijas on 5/9/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import "UISSRectValueConverter.h"

@implementation UISSRectValueConverter

- (BOOL)canConvertPropertyWithName:(NSString *)name value:(id)value argumentType:(NSString *)argumentType;
{
    return [argumentType isEqualToString:[NSString stringWithCString:@encode(CGRect) encoding:NSUTF8StringEncoding]];
}

- (id)convertPropertyValue:(id)value;
{
    if ([value isKindOfClass:[NSArray class]] && [value count] == 4) {
        NSArray *array = (NSArray *)value;
        return [NSValue valueWithCGRect:CGRectMake([[array objectAtIndex:0] floatValue],
                                                   [[array objectAtIndex:1] floatValue],
                                                   [[array objectAtIndex:2] floatValue],
                                                   [[array objectAtIndex:3] floatValue])];
    }
    
    return nil;
}

@end
