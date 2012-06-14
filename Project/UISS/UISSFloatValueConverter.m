//
//  UISSFloatValueConverter.m
//  UISS
//
//  Created by Robert Wijas on 5/9/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import "UISSFloatValueConverter.h"
#import "UISSArgument.h"

@implementation UISSFloatValueConverter

- (BOOL)canConvertPropertyWithName:(NSString *)name value:(id)value argumentType:(NSString *)argumentType;
{
    return [argumentType isEqualToString:[NSString stringWithCString:@encode(CGFloat) encoding:NSUTF8StringEncoding]];
}

- (id)convertValue:(id)value;
{
    if ([value isKindOfClass:[NSNumber class]]) {
        CGFloat floatValue = [value floatValue];
        return [NSValue value:&floatValue withObjCType:@encode(CGFloat)];
    }
    
    return nil;
}

- (NSString *)generateCodeForValue:(id)value
{
    return nil;
}

- (BOOL)canConvertValueForArgument:(UISSArgument *)argument
{
    return [self canConvertPropertyWithName:argument.name value:argument.value argumentType:argument.type];
}

@end
