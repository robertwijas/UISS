//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import "UISSAxisParameter.h"
#import "UISSPropertySetter.h"

@implementation UISSAxisParameter

- (NSString *)name;
{
    if (_name == nil) {
        if (self.propertySetter) {
            NSUInteger index = [self.propertySetter.axisParameters indexOfObject:self];
            if (index != NSNotFound) {
                index += 1;
                
                NSArray *selectorParts = self.propertySetter.selectorParts;
                if (selectorParts.count > index) {
                    NSString *name = [selectorParts objectAtIndex:index];
                    _name = name;
                }
            }
        }
    }
    
    return _name;
}

- (NSString *)type;
{
    NSMethodSignature *methodSignature = self.propertySetter.methodSignature;
    if (methodSignature) {
        NSUInteger index = [self.propertySetter.axisParameters indexOfObject:self];
        if (index != NSNotFound) {
            index += 1 + 2; // property + self and cmd
            if (index < methodSignature.numberOfArguments) {
                return [NSString stringWithUTF8String:[methodSignature getArgumentTypeAtIndex:index]];
            }
        }
    }
    
    return nil;
}

- (NSArray *)availableConverters;
{
    return self.config.axisParameterValueConverters;
}

@end
