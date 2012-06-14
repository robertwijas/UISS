//
//  UISSAbstractEnumValueConverter.m
//  UISS
//
//  Created by Robert Wijas on 5/16/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import "UISSAbstractEnumValueConverter.h"
#import "UISSArgument.h"

@interface UISSAbstractEnumValueConverter ()

@property (nonatomic, strong) NSDictionary *stringToValueDictionary;
@property (nonatomic, strong) NSDictionary *stringToCodeDictionary;

@end

@implementation UISSAbstractEnumValueConverter

@synthesize stringToValueDictionary = _stringToValueDictionary;
@synthesize stringToCodeDictionary = _stringToCodeDictionary;


- (BOOL)canConvertAxisParameterWithName:(NSString *)name value:(id)value argumentType:(NSString *)argumentType;
{
    if (![argumentType isEqualToString:self.argumentType]) return NO;
    if (![value isKindOfClass:[NSString class]]) return NO;
    if (![[name lowercaseString] hasSuffix:[self.propertyNameSuffix lowercaseString]]) return NO;
    
    return YES;
}

- (NSString *)propertyNameSuffix
{
    return nil;
}

- (NSString *)argumentType;
{
    return [NSString stringWithCString:@encode(NSInteger) encoding:NSUTF8StringEncoding];
}

- (BOOL)canConvertValueForArgument:(UISSArgument *)argument
{
    return [self canConvertAxisParameterWithName:argument.name value:argument.value argumentType:argument.type];
}

- (NSString *)generateCodeForValue:(id)value;
{
    return [self.stringToCodeDictionary objectForKey:value];
}

- (id)convertValue:(id)value
{
    return [self.stringToValueDictionary objectForKey:value];
}

@end
