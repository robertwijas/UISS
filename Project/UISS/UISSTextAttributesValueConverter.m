//
//  UISSTextAttributesValueConverter.m
//  UISS
//
//  Created by Robert Wijas on 5/9/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import "UISSTextAttributesValueConverter.h"
#import "UISSFontValueConverter.h"
#import "UISSColorValueConverter.h"
#import "UISSOffsetValueConverter.h"

@interface UISSTextAttributesValueConverter ()

@property (nonatomic, strong) UISSFontValueConverter *fontConverter;
@property (nonatomic, strong) UISSColorValueConverter *colorConverter;
@property (nonatomic, strong) UISSOffsetValueConverter *offsetConverter;

@end

@implementation UISSTextAttributesValueConverter

@synthesize fontConverter;
@synthesize colorConverter;
@synthesize offsetConverter;

- (id)init
{
    self = [super init];
    if (self) {
        self.fontConverter = [[UISSFontValueConverter alloc] init];
        self.colorConverter = [[UISSColorValueConverter alloc] init];
        self.offsetConverter = [[UISSOffsetValueConverter alloc] init];
    }
    return self;
}

- (BOOL)canConvertPropertyWithName:(NSString *)name value:(id)value argumentType:(NSString *)argumentType;
{
    return [argumentType hasPrefix:@"@"] && [name hasSuffix:@"TextAttributes"] && [value isKindOfClass:[NSDictionary class]];
}

- (void)convertProperty:(NSString *)propertyName fromDictionary:(NSDictionary *)dictionary
           toDictionary:(NSMutableDictionary *)converterDictionary withKey:(NSString *)key 
         usingConverter:(id<UISSPropertyValueConverter>)converter;
{
    id value = [dictionary objectForKey:propertyName];
    if (value) {
        id conveterd = [converter convertPropertyValue:value];
        if (conveterd) {
            [converterDictionary setObject:conveterd forKey:key];
        }
    }
}

- (id)convertPropertyValue:(id)value;
{
    if ([value isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        NSDictionary *dictionary = (NSDictionary *)value;
        
        [self convertProperty:@"font" fromDictionary:dictionary toDictionary:attributes withKey:UITextAttributeFont 
               usingConverter:self.fontConverter];

        [self convertProperty:@"textColor" fromDictionary:dictionary toDictionary:attributes withKey:UITextAttributeTextColor 
               usingConverter:self.colorConverter];

        [self convertProperty:@"textShadowColor" fromDictionary:dictionary toDictionary:attributes withKey:UITextAttributeTextShadowColor 
               usingConverter:self.colorConverter];

        [self convertProperty:@"textShadowOffset" fromDictionary:dictionary toDictionary:attributes withKey:UITextAttributeTextShadowOffset 
               usingConverter:self.offsetConverter];
        
        if (attributes.count) {
            return attributes;
        }
    }
    
    return nil;
}

@end
