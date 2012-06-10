//
//  UISSPropertySetter.m
//  UISS
//
//  Created by Robert Wijas on 6/2/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import <objc/runtime.h>
#import "UISSPropertySetter.h"
#import "NSString+UISS.h"

@implementation UISSPropertySetter

@synthesize appearanceClass;
@synthesize containment;
@synthesize property;
@synthesize axisParameters;

- (id <UIAppearance>)target {
    return nil;
}

- (NSString *)selectorRegexp
{
    NSMutableString *regexp = [NSMutableString stringWithFormat:@"^set%@:", [self.property.name firstLetterCapitalizedString]];

    for (NSUInteger i = 0; i < self.axisParameters.count; i++) {
        if (i == 0) {
            [regexp appendString:@"for"];
        }
        [regexp appendString:@"\\w+:"];
    }

    [regexp appendString:@"$"];

    return regexp;
}

- (SEL)selector
{
    return [self findSelectorMatchingRegexp:[self selectorRegexp] class:self.appearanceClass currentBestSelector:NULL];
}

- (SEL)findSelectorMatchingRegexp:(NSString *)regexp class:(Class<UIAppearance>)class currentBestSelector:(SEL)currentBestSelector;
{
    unsigned int count = 0;
    Method *methods = class_copyMethodList(class, &count);

    for (int i = 0; i < count; i++) {
        SEL selector = method_getName(methods[i]);
        NSString *selectorString = NSStringFromSelector(selector);

        if ([selectorString rangeOfString:regexp options:NSRegularExpressionSearch].location != NSNotFound) {
            // this favours selector with shorter name
            // the purpose of this is to pick forState: instead of forStates:

            if (currentBestSelector == NULL || NSStringFromSelector(currentBestSelector).length > selectorString.length) {
                // found new shorter selector
                currentBestSelector = selector;
            }
        }
    }
    free(methods);

    Class superclass = class_getSuperclass(class);
    if ([superclass conformsToProtocol:@protocol(UIAppearance)]) {
        return [self findSelectorMatchingRegexp:regexp class:superclass currentBestSelector:currentBestSelector];
    } else {
        return currentBestSelector;
    }
}

@end
