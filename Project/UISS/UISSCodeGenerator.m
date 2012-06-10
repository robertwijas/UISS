//
//  UISSCodeGenerator.m
//  UISS
//
//  Created by Robert Wijas on 6/7/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import "UISSCodeGenerator.h"
#import "UISSPropertySetter.h"
#import "NSString+UISS.h"
#import "UISSConverter.h"
#import "UISSPropertyValueConverter.h"

@implementation UISSCodeGenerator

@synthesize converter = _converter;

- (id)init
{
    self = [super init];
    if (self) {
        self.converter = [[UISSConverter alloc] init];
    }
    return self;
}

- (NSString *)generateCodeForPropertySetter:(UISSPropertySetter *)setter
{
    id <UISSPropertyValueConverter> propertyValueConverter = [self.converter findConverterForProperty:setter.property.name
                                                                                                value:setter.property.value
                                                                                         argumentType:@"@"];

    return [NSString stringWithFormat:@"[[%@ appearance] set%@:%@];",
                                      NSStringFromClass(setter.appearanceClass),
                                      [setter.property.name firstLetterCapitalizedString],
                                      [propertyValueConverter generateCodeForPropertyValue:setter.property.value]];
}

@end
