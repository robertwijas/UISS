//
//  UISSFontValueConverter.m
//  UISS
//
//  Created by Robert Wijas on 5/8/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import "UISSFontValueConverter.h"

@implementation UISSFontValueConverter

- (BOOL)canConvertPropertyWithName:(NSString *)name value:(id)value argumentType:(NSString *)argumentType;
{
    return [argumentType hasPrefix:@"@"] && [name hasSuffix:@"Font"];
}

- (id)convertPropertyValue:(id)value;
{
    if ([value isKindOfClass:[NSArray class]]) {
        NSArray *array = (NSArray *)value;
        
        if (array.count == 2) {
            NSString *name = [array objectAtIndex:0];
            CGFloat size = [[array objectAtIndex:1] floatValue];
            
            if ([name isEqualToString:@"system"]) {
                return [UIFont systemFontOfSize:size];
            } else if ([name isEqualToString:@"bold"]) {
                return [UIFont boldSystemFontOfSize:size];
            } else if ([name isEqualToString:@"italic"]) {
                return [UIFont italicSystemFontOfSize:size];
            } else {
                return [UIFont fontWithName:name size:size];
            }
        }
    } else if ([value isKindOfClass:[NSNumber class]]) {
        return [UIFont systemFontOfSize:[value floatValue]];
    }
    
    return nil;
}

@end
