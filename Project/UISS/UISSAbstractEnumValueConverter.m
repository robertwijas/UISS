//
//  UISSAbstractEnumValueConverter.m
//  UISS
//
//  Created by Robert Wijas on 5/16/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import "UISSAbstractEnumValueConverter.h"

@interface UISSAbstractEnumValueConverter ()

@property (nonatomic, strong) NSDictionary *conversionDictionary;

@end

@implementation UISSAbstractEnumValueConverter

@synthesize conversionDictionary=_conversionDictionary;

- (BOOL)canConvertAxisParameterWithName:(NSString *)name value:(id)value argumentType:(NSString *)argumentType;
{
    if (![argumentType isEqualToString:self.argumentType]) return NO;
    if (![value isKindOfClass:[NSString class]]) return NO;
    if (![[name lowercaseString] hasSuffix:[self.propertyNameSuffix lowercaseString]]) return NO;
    
    return YES;
}

- (NSNumber *)convertAxisParameter:(id)value;
{
    if ([value isKindOfClass:[NSString class]]) {
        return [self.conversionDictionary objectForKey:value];
    }
    
    return nil;
}

- (NSString *)argumentType;
{
    return [NSString stringWithCString:@encode(NSInteger) encoding:NSUTF8StringEncoding];
}

@end
