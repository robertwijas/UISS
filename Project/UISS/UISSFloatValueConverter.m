//
//  UISSFloatValueConverter.m
//  UISS
//
//  Created by Robert Wijas on 5/9/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import "UISSFloatValueConverter.h"

@implementation UISSFloatValueConverter

- (BOOL)canConvertPropertyWithName:(NSString *)name value:(id)value argumentType:(NSString *)argumentType;
{
    return [argumentType isEqualToString:[NSString stringWithCString:@encode(CGFloat) encoding:NSUTF8StringEncoding]];
}

- (id)convertPropertyValue:(id)value;
{
    if ([value isKindOfClass:[NSNumber class]]) {
        CGFloat floatValue = [value floatValue];
        return [NSValue value:&floatValue withObjCType:@encode(CGFloat)];
    }
    
    return nil;
}

@end
