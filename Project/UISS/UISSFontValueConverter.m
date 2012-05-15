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
    return NO;    
}

- (id)convertPropertyValue:(id)value;
{
    return nil;
}

@end
