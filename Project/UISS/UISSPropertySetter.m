//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import <objc/runtime.h>
#import "UISSPropertySetter.h"
#import "NSString+UISS.h"

@interface UISSPropertySetter ()

@property(nonatomic, strong, readwrite) NSMethodSignature *methodSignature;
@property(nonatomic, assign, readwrite) SEL selector;

@end

@implementation UISSPropertySetter

- (NSString *)selectorPrefix {
    return [NSString stringWithFormat:@"set%@:", [self.property.name uppercaseFirstCharacterString]];
}

- (NSString *)selectorRegexp {
    NSMutableString *regexp = [NSMutableString stringWithFormat:@"^%@", self.selectorPrefix];

    for (NSUInteger i = 0; i < self.axisParameters.count; i++) {
        if (i == 0) {
            [regexp appendString:@"for"];
        }
        [regexp appendString:@"\\w+:"];
    }

    [regexp appendString:@"$"];

    return regexp;
}

- (SEL)selector {
    if (_selector == NULL) {
        _selector = [self findSelectorMatchingRegexp:[self selectorRegexp] class:self.appearanceClass
                                 currentBestSelector:NULL];
    }

    return _selector;
}

- (NSArray *)selectorParts {
    SEL selector = self.selector;
    if (selector) {
        NSArray *selectorParts = [NSStringFromSelector(self.selector) componentsSeparatedByString:@":"];
        // remove last empty part
        selectorParts = [selectorParts subarrayWithRange:NSMakeRange(0, selectorParts.count - 1)];

        return selectorParts;
    }

    return nil;
}

- (NSMethodSignature *)methodSignature {
    if (_methodSignature == nil) {
        SEL selector = self.selector;
        if (selector) {
            _methodSignature = [self.appearanceClass instanceMethodSignatureForSelector:selector];
        }
    }

    return _methodSignature;
}

- (SEL)findSelectorMatchingRegexp:(NSString *)regexp class:(Class <UIAppearance>)class currentBestSelector:(SEL)currentBestSelector {
    unsigned int count = 0;
    Method *methods = class_copyMethodList(class, &count);

    NSString *selectorPrefix = self.selectorPrefix;

    for (int i = 0; i < count; i++) {
        SEL selector = method_getName(methods[i]);
        NSString *selectorString = NSStringFromSelector(selector);

        if ([selectorString hasPrefix:selectorPrefix]) { // reducing the use of regular expression for performance reasons
            if ([selectorString rangeOfString:regexp options:NSRegularExpressionSearch].location != NSNotFound) {
                // this favours selector with shorter label
                // the purpose of this is to pick forState: instead of forStates:

                if (currentBestSelector == NULL || NSStringFromSelector(currentBestSelector).length > selectorString.length) {
                    // found new shorter selector
                    currentBestSelector = selector;
                }
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

#pragma mark - Setters

- (void)resetCalculatedProperties {
    self.selector = NULL;
    self.methodSignature = nil;
}

- (void)setAppearanceClass:(Class <UIAppearance>)appearanceClass {
    if (_appearanceClass != appearanceClass) {
        _appearanceClass = appearanceClass;

        [self resetCalculatedProperties];
    }
}

- (void)setProperty:(UISSProperty *)property {
    if (_property != property) {
        _property = property;

        _property.propertySetter = self;

        [self resetCalculatedProperties];
    }
}

- (void)setAxisParameters:(NSArray *)axisParameters {
    if (_axisParameters != axisParameters) {
        _axisParameters = axisParameters;

        for (UISSAxisParameter *axisParameter in _axisParameters) {
            axisParameter.propertySetter = self;
        }

        [self resetCalculatedProperties];
    }
}

#pragma mark - Code generation

- (NSString *)appearanceCode {
    if (self.containment.count) {
        NSMutableString *containmentCode = [NSMutableString string];

        for (Class <UIAppearanceContainer> appearanceContainer in self.containment.reverseObjectEnumerator) {
            [containmentCode appendFormat:@"[%@ class], ", NSStringFromClass(appearanceContainer)];
        }
        [containmentCode appendString:@"nil"];

        return [NSString stringWithFormat:@"[%@ appearanceWhenContainedIn:%@]",
                                          NSStringFromClass(self.appearanceClass), containmentCode];
    } else {
        return [NSString stringWithFormat:@"[%@ appearance]", NSStringFromClass(self.appearanceClass)];
    }
}

- (NSString *)generatedCode {
    NSArray *selectorParts = self.selectorParts;
    if (selectorParts) {
        NSMutableString *selectorString = [NSMutableString string];

        for (NSUInteger idx = 0; idx < selectorParts.count; idx++) {
            NSString *selectorPart = [selectorParts objectAtIndex:idx];

            if (idx) {
                [selectorString appendString:@" "];
            }

            [selectorString appendString:selectorPart];
            [selectorString appendString:@":"];

            NSString *argumentValueCode = nil;

            if (idx == 0) {
                argumentValueCode = self.property.generatedCode;
            } else {
                argumentValueCode = [[self.axisParameters objectAtIndex:idx - 1] generatedCode];
            }

            if (argumentValueCode) {
                [selectorString appendString:argumentValueCode];
            } else {
                return nil;
            }
        }

        return [NSString stringWithFormat:@"[%@ %@];", [self appearanceCode], selectorString];
    } else {
        return nil;
    }
}

#pragma mark - Invocations

- (NSInvocation *)invocation {
    if (self.methodSignature == nil) return nil;

    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:self.methodSignature];
    invocation.selector = self.selector;
    invocation.target = self.target;

    [invocation retainArguments];

    id converted = [self.property convertedValue];
    if ([converted isKindOfClass:[NSValue class]]) {
        NSUInteger size;
        NSGetSizeAndAlignment([converted objCType], &size, NULL);
        char argumentValue[size];

        [converted getValue:argumentValue];
        [invocation setArgument:argumentValue atIndex:2];
    } else {
        [invocation setArgument:&converted atIndex:2];
    }

    [self.axisParameters enumerateObjectsUsingBlock:^(UISSAxisParameter *axisParameter, NSUInteger index, BOOL *stop) {
        NSInteger argumentIndex = index + 3;
        NSNumber *number = [axisParameter convertedValue];

        if ([axisParameter.type isEqualToString:[NSString stringWithCString:@encode(NSUInteger)
                                                                   encoding:NSUTF8StringEncoding]]) {
            NSUInteger unsignedInteger = [number unsignedIntegerValue];
            [invocation setArgument:&unsignedInteger atIndex:argumentIndex];
        } else {
            NSInteger integer = [number integerValue];
            [invocation setArgument:&integer atIndex:argumentIndex];
        }
    }];

    return invocation;
}

- (id)target {
    // This may be the ugliest method I have ever written
    // but I do not know how to call this method having NSArray of arguments

    switch (self.containment.count) {
        case 0:
            return [self.appearanceClass appearance];
        case 1:
            return [self.appearanceClass appearanceWhenContainedIn:
                                                 [self.containment objectAtIndex:0],
                                         nil];
        case 2:
            return [self.appearanceClass appearanceWhenContainedIn:
                                                 [self.containment objectAtIndex:1],
                                                 [self.containment objectAtIndex:0],
                                         nil];
        case 3:
            return [self.appearanceClass appearanceWhenContainedIn:
                                                 [self.containment objectAtIndex:2],
                                                 [self.containment objectAtIndex:1],
                                                 [self.containment objectAtIndex:0],
                                         nil];
        case 4:
            return [self.appearanceClass appearanceWhenContainedIn:
                                                 [self.containment objectAtIndex:3],
                                                 [self.containment objectAtIndex:2],
                                                 [self.containment objectAtIndex:1],
                                                 [self.containment objectAtIndex:0],
                                         nil];
        case 5:
            return [self.appearanceClass appearanceWhenContainedIn:
                                                 [self.containment objectAtIndex:4],
                                                 [self.containment objectAtIndex:3],
                                                 [self.containment objectAtIndex:2],
                                                 [self.containment objectAtIndex:1],
                                                 [self.containment objectAtIndex:0],
                                         nil];
        case 6:
            return [self.appearanceClass appearanceWhenContainedIn:
                                                 [self.containment objectAtIndex:5],
                                                 [self.containment objectAtIndex:4],
                                                 [self.containment objectAtIndex:3],
                                                 [self.containment objectAtIndex:2],
                                                 [self.containment objectAtIndex:1],
                                                 [self.containment objectAtIndex:0],
                                         nil];
        default:
            return nil;
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"[%@ - appearanceClass: %@, property.name: %@, property.value: %@]",
                                      NSStringFromClass(self.class),
                                      NSStringFromClass(self.appearanceClass),
                                      self.property.name,
                                      self.property.value];
}

@end
