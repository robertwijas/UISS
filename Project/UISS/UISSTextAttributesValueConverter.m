//
//  UISSTextAttributesValueConverter.m
//  UISS
//
//  Created by Robert Wijas on 5/9/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import "UISSTextAttributesValueConverter.h"

@implementation UISSTextAttributesValueConverter

- (BOOL)canConvertPropertyWithName:(NSString *)name value:(id)value argumentType:(NSString *)argumentType;
{
    return [argumentType hasPrefix:@"@"] && [name hasSuffix:@"TextAttributes"] && [value isKindOfClass:[NSDictionary class]];
}

- (id)convertPropertyValue:(id)value;
{
    NSMutableDictionary *textAttributes = [NSMutableDictionary dictionary];
    
    id fontDescription = [value objectForKey:@"font"];
    UIFont *font = [UIFont systemFontOfSize:[fontDescription floatValue]];
    [textAttributes setObject:font forKey:UITextAttributeFont];
    
    return textAttributes;
}

@end
