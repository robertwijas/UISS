//
//  UISSProperty.m
//  UISS
//
//  Created by Robert Wijas on 6/2/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import "UISSProperty.h"
#import "UISSPropertySetter.h"

@implementation UISSProperty

- (NSString *)type;
{
    NSMethodSignature *methodSignature = self.propertySetter.methodSignature;
    if (methodSignature) {
        NSUInteger index = 2;
        if (index < methodSignature.numberOfArguments) {
            return [NSString stringWithUTF8String:[methodSignature getArgumentTypeAtIndex:index]];
        }
    }

    return nil;
}

- (NSArray *)availableConverters;
{
    return self.config.propertyValueConverters;
}

@end
