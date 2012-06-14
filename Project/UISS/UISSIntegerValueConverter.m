//
//  UISSIntegerValueConverter.m
//  UISS
//
//  Created by Robert Wijas on 5/9/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import "UISSIntegerValueConverter.h"
#import "UISSArgument.h"

@implementation UISSIntegerValueConverter

- (BOOL)canConvertPropertyWithName:(NSString *)name value:(id)value argumentType:(NSString *)argumentType;
{
    return [argumentType isEqualToString:[NSString stringWithCString:@encode(NSInteger) encoding:NSUTF8StringEncoding]];
}

- (BOOL)canConvertAxisParameterWithName:(NSString *)name value:(id)value argumentType:(NSString *)argumentType;
{
    return [self canConvertPropertyWithName:name value:value argumentType:argumentType];
}

- (NSString *)generateCodeForValue:(id)value
{
    return nil;
}

- (BOOL)canConvertValueForArgument:(UISSArgument *)argument
{
    return [self canConvertPropertyWithName:argument.name value:argument.value argumentType:argument.type];
}

- (id)convertValue:(id)value
{
    if ([value isKindOfClass:[NSNumber class]]) {
        NSInteger integerValue = [value integerValue];
        return [NSValue value:&integerValue withObjCType:@encode(NSInteger)];
    }
    
    return nil;
}

@end
