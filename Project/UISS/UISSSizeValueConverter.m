//
//  UISSSizeValueConverter.m
//  UISS
//
//  Created by Robert Wijas on 5/9/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import "UISSSizeValueConverter.h"

@implementation UISSSizeValueConverter

- (BOOL)canConvertPropertyWithName:(NSString *)name value:(id)value argumentType:(NSString *)argumentType;
{
    return [argumentType isEqualToString:[NSString stringWithCString:@encode(CGSize) encoding:NSUTF8StringEncoding]];
}

- (id)convertPropertyValue:(id)value;
{
    if ([value isKindOfClass:[NSArray class]]) {
        CGFloat width = 0, height = 0;
        NSArray *array = (NSArray *)value;
        
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

@end
