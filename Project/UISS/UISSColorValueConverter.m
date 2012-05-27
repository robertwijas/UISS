//
//  UISSColorValueConverter.m
//  UISS
//
//  Created by Robert Wijas on 5/8/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import "UISSColorValueConverter.h"
#import "UISSImageValueConverter.h"

@interface UISSColorValueConverter ()

@property (nonatomic, strong) UISSImageValueConverter *imageValueConverter;

@end

@implementation UISSColorValueConverter

@synthesize imageValueConverter;

- (id)init
{
    self = [super init];
    if (self) {
        self.imageValueConverter = [[UISSImageValueConverter alloc] init];
    }
    return self;
}

- (BOOL)canConvertPropertyWithName:(NSString *)name value:(id)value argumentType:(NSString *)argumentType;
{
    return [argumentType hasPrefix:@"@"] && [[name lowercaseString] hasSuffix:@"color"];
}

- (UIColor *)colorFromHexString:(NSString *)colorString;
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
    }
    
    return nil;
}

- (UIColor *)colorFromSelectorString:(NSString *)selectorString;
{
    if (![selectorString hasSuffix:@"Color"]) {
        selectorString = [selectorString stringByAppendingString:@"Color"];
    }
    
    SEL colorSelector = NSSelectorFromString(selectorString);
    
    if ([UIColor respondsToSelector:colorSelector]) {
        return [UIColor performSelector:colorSelector];
    }
    
    return nil;
}

- (UIColor *)colorFromPatterImageString:(NSString *)patternImageString;
{
    // UIColor with pattern
    UIImage *patternImage = [self.imageValueConverter convertPropertyValue:patternImageString];
    if (patternImage) {
        return [UIColor colorWithPatternImage:patternImage];
    }

    return nil;
}

- (UIColor *)colorFromString:(NSString *)colorString;
{
    UIColor *color = [self colorFromHexString:colorString];
    
    if (color == nil) {
        color = [self colorFromSelectorString:colorString];
    }
    
    if (color == nil) {
        color = [self colorFromPatterImageString:colorString];
    }
    
    return color;
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
