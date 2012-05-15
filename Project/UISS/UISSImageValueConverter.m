//
//  UISSImageValueConverter.m
//  UISS
//
//  Created by Robert Wijas on 5/8/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import "UISSImageValueConverter.h"

@implementation UISSImageValueConverter

- (BOOL)canConvertPropertyWithName:(NSString *)name value:(id)value argumentType:(NSString *)argumentType;
{
    return [argumentType hasPrefix:@"@"] && [name hasSuffix:@"Image"];
}

- (id)convertPropertyValue:(id)value;
{
    if ([value isKindOfClass:[NSString class]]) {
        NSString *imageURL = [[NSBundle bundleForClass:[self class]].resourcePath stringByAppendingPathComponent:value];
        return [UIImage imageWithContentsOfFile:imageURL];
    }
    
    return nil;
}

@end
