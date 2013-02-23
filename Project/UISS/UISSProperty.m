//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
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
