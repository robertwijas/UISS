//
//  UISSPointValueConverter.m
//  UISS
//
//  Created by Robert Wijas on 5/9/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import "UISSPointValueConverter.h"

@implementation UISSPointValueConverter

- (BOOL)canConvertPropertyWithName:(NSString *)name value:(id)value argumentType:(NSString *)argumentType;
{
    return [argumentType isEqualToString:[NSString stringWithCString:@encode(CGPoint) encoding:NSUTF8StringEncoding]];
}

- (id)convertPropertyValue:(id)value;
{
    if ([value isKindOfClass:[NSArray class]]) {
        CGFloat x = 0, y = 0;
        NSArray *array = (NSArray *)value;
        
        if (array.count > 0) {
            x = [[array objectAtIndex:0] floatValue];
        }
        
        if (array.count > 1) {
            y = [[array objectAtIndex:1] floatValue];
        } else {
            y = x;
        }
        
        return [NSValue valueWithCGPoint:CGPointMake(x, y)];
    } else if ([value isKindOfClass:[NSNumber class]]) {
        return [NSValue valueWithCGPoint:CGPointMake([value floatValue], [value floatValue])];
    }
    
    return nil;
}

@end
