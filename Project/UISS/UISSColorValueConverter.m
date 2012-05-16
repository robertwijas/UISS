//
//  UISSColorValueConverter.m
//  UISS
//
//  Created by Robert Wijas on 5/8/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import "UISSColorValueConverter.h"

@implementation UISSColorValueConverter

- (BOOL)canConvertPropertyWithName:(NSString *)name value:(id)value argumentType:(NSString *)argumentType;
{
    return [argumentType hasPrefix:@"@"] && [name hasSuffix:@"Color"];
}

- (UIColor *)colorFromString:(NSString *)colorString;
{
    if ([colorString hasPrefix:@"#"]) {
        NSScanner *scanner = [NSScanner scannerWithString:[colorString substringFromIndex:1]];
        
        unsigned long long hexValue;
        if ([scanner scanHexLongLong:&hexValue]) {
            CGFloat red   = ((hexValue & 0xFF0000) >> 16) / 255.0f;
            CGFloat green = ((hexValue & 0x00FF00) >>  8) / 255.0f;
            CGFloat blue  =  (hexValue & 0x0000FF) / 255.0f;
            
            return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
        }
    } else {
        if (![colorString hasSuffix:@"Color"]) {
            colorString = [colorString stringByAppendingString:@"Color"];
        }
        
        SEL colorSelector = NSSelectorFromString(colorString);
        
        if ([UIColor respondsToSelector:colorSelector]) {
            return [UIColor performSelector:colorSelector];
        }
    }

    return nil;
}

- (id)convertPropertyValue:(id)value;
{
    if ([value isKindOfClass:[NSArray class]]) {
        NSArray *array = (NSArray *)value;
        CGFloat red, green, blue, alpha = 1;
        
        if (array.count > 0) {
            if ([[array objectAtIndex:0] isKindOfClass:[NSString class]]) {
                UIColor *color = [self colorFromString:[array objectAtIndex:0]];
                
                if (array.count > 1) {
                    alpha = [[array objectAtIndex:1] floatValue];
                    color = [color colorWithAlphaComponent:alpha];
                }
                
                return color;
            } else {
                red = [[array objectAtIndex:0] intValue] / 255.0f;
                
                if (array.count > 1) {
                    green = [[array objectAtIndex:1] intValue] / 255.0f;
                    
                    if (array.count > 2) {
                        blue = [[array objectAtIndex:2] intValue] / 255.0f;
                        
                        if (array.count > 3) {
                            alpha = [[array objectAtIndex:3] floatValue];
                        }
                    }
                }
            }
        }
        
        return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    } else if ([value isKindOfClass:[NSString class]]) {
        return [self colorFromString:value];
    }
    
    return nil;
}

@end
