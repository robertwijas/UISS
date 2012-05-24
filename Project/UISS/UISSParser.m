//
//  UISSParser.m
//  UISS
//
//  Created by Robert Wijas on 5/9/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import "UISSParser.h"

#import <objc/runtime.h>

#import "UISSParserContext.h"
#import "NSInvocation+UISS.h"

#import "UISSColorValueConverter.h"
#import "UISSImageValueConverter.h"
#import "UISSFontValueConverter.h"
#import "UISSTextAttributesValueConverter.h"

#import "UISSSizeValueConverter.h"
#import "UISSPointValueConverter.h"
#import "UISSEdgeInsetsValueConverter.h"
#import "UISSRectValueConverter.h"
#import "UISSOffsetValueConverter.h"

#import "UISSIntegerValueConverter.h"
#import "UISSUIntegerValueConverter.h"
#import "UISSFloatValueConverter.h"

#import "UISSBarMetricsValueConverter.h"
#import "UISSControlStateValueConveter.h"
#import "UISSSegmentedControlSegmentValueConverter.h"
#import "UISSToolbarPositionConverter.h"
#import "UISSSearchBarIconValueConverter.h"

@implementation UISSParser

@synthesize variablesPreprocessor=_variablesPreprocessor;

@synthesize propertyValueConverters=_propertyValueConverters;
@synthesize axisParameterValueConverters=_axisParameterValueConverters;
@synthesize userInterfaceIdiom=_userInterfaceIdiom;

- (id)init
{
    self = [super init];
    if (self) {
        self.variablesPreprocessor = [[UISSVariablesPreprocessor alloc] init];
        
        self.propertyValueConverters = [NSArray arrayWithObjects:
                           [[UISSColorValueConverter alloc] init],
                           [[UISSImageValueConverter alloc] init],
                           [[UISSFontValueConverter alloc] init],
                           [[UISSTextAttributesValueConverter alloc] init],
                           
                           [[UISSSizeValueConverter alloc] init],
                           [[UISSPointValueConverter alloc] init],
                           [[UISSEdgeInsetsValueConverter alloc] init],
                           [[UISSRectValueConverter alloc] init],
                           [[UISSOffsetValueConverter alloc] init],

                           [[UISSIntegerValueConverter alloc] init],
                           [[UISSUIntegerValueConverter alloc] init],
                           [[UISSFloatValueConverter alloc] init],
                           nil];
        
        self.axisParameterValueConverters = [NSArray arrayWithObjects:
                                             [[UISSBarMetricsValueConverter alloc] init],
                                             [[UISSControlStateValueConveter alloc] init],
                                             [[UISSSegmentedControlSegmentValueConverter alloc] init],
                                             [[UISSToolbarPositionConverter alloc] init],
                                             [[UISSSearchBarIconValueConverter alloc] init],
                                             
                                             [[UISSIntegerValueConverter alloc] init],
                                             [[UISSUIntegerValueConverter alloc] init],
                                             nil];
    }
    
    return self;
}

- (NSNumber *)convertStringToNumber:(NSString *)string;
{
    static NSDictionary * convertDictionary;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        convertDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithInteger:UIBarMetricsLandscapePhone], @"landscapePhone",
                             nil];
    });
    
    return [NSNumber numberWithInteger:[[convertDictionary objectForKey:string] integerValue]];
}

- (NSArray *)argumentsArrayFrom:(id)value;
{
    if ([value isKindOfClass:[NSArray class]]) {
        return value;
    } else {
        return [NSArray arrayWithObject:value];
    }
}

- (NSString *)setterMethodPrefixForProperty:(NSString *)property;
{
    return [NSString stringWithFormat:@"set%@%@:", [[property substringToIndex:1] uppercaseString], [property substringFromIndex:1]];
}

- (NSArray *)invocationsForProperty:(NSString *)property component:(Class<UIAppearance>)component;
{
    NSString *methodPrefix = [self setterMethodPrefixForProperty:property];
    
    NSLog(@"UISS - methodPrefix: %@", methodPrefix);

    NSMutableArray *invocations = [NSMutableArray array];
    
    unsigned int count = 0;
    
    while ([(Class)component conformsToProtocol:@protocol(UIAppearance)]) {
        Method *methods = class_copyMethodList(component, &count);
        
        for (int i = 0; i < count; i++) {
            SEL selector = method_getName(methods[i]);
            NSString *method = NSStringFromSelector(selector);
            
            if ([method hasPrefix:methodPrefix]) {
                NSLog(@"UISS - got method: %@", method);

                NSMethodSignature *methodSignature = [[component appearance] methodSignatureForSelector:selector];
                NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
                [invocation setSelector:selector];
                
                [invocations addObject:invocation];
            }
        }
        
        free(methods);
        
        component = class_getSuperclass(component);
    }
        
    return invocations;
}

- (NSInvocation *)selectInvocationForArguments:(NSArray *)arguments from:(NSArray *)invocations;
{
    NSInvocation *selected = nil;
    
    for (NSInvocation *invocation in invocations) {
        if ([invocation uissCanAcceptArguments:arguments]) {
            if (selected == nil || (selected.methodSignature.numberOfArguments > invocation.methodSignature.numberOfArguments)) {
                // select invocation with the least number of arguments
                selected = invocation;
            } else if ((selected.methodSignature.numberOfArguments == invocation.methodSignature.numberOfArguments)
                       && (NSStringFromSelector(selected.selector).length > NSStringFromSelector(invocation.selector).length)) {
                selected = invocation;
            }
        }
    }
    
    // return copy
    if (selected) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:selected.methodSignature];
        invocation.selector = selected.selector;
        
        selected = invocation;
    }
    
    return selected;
}

- (id<UISSPropertyValueConverter>)findConverterForProperty:(NSString *)property value:(id)value
                                              argumentType:(NSString *)argumentType;
{
    for (id<UISSPropertyValueConverter> converter in self.propertyValueConverters) {
        if ([converter canConvertPropertyWithName:property value:value argumentType:argumentType]) {
            return converter;
        }
    }
    
    return nil;
}

- (id<UISSAxisParameterValueConverter>)findConverterForAxisParameter:(NSString *)axisParameter value:(id)value
                                                        argumentType:(NSString *)argumentType;
{
    for (id<UISSAxisParameterValueConverter> converter in self.axisParameterValueConverters) {
        if ([converter canConvertAxisParameterWithName:axisParameter value:value argumentType:argumentType]) {
            return converter;
        }
    }
    
    return nil;
}

- (NSString *)axisParameterNameAtIndex:(NSUInteger)index forInvocation:(NSInvocation *)invocation;
{
    NSString *selector = NSStringFromSelector(invocation.selector);
    NSArray *selectorComponents = [selector componentsSeparatedByString:@":"];

    if (index + 1 < selectorComponents.count) {
        NSString *parameterComponent = [selectorComponents objectAtIndex:index + 1];
        return parameterComponent;
    }
    
    return nil;
}

- (void)setupInvocation:(NSInvocation *)invocation forProperty:(NSString *)property withArguments:(NSArray *)arguments;
{
    if (invocation == nil) return;
    
    id value = [arguments objectAtIndex:0];
    NSString *argumentType = [NSString stringWithUTF8String:[invocation.methodSignature getArgumentTypeAtIndex:2]];
    
    id<UISSPropertyValueConverter> converter = [self findConverterForProperty:property value:value argumentType:argumentType];
    id converted = [converter convertPropertyValue:value];
    
    NSLog(@"UISS - converted argument for property: %@ = %@", property, converted);
    
    if ([converted isKindOfClass:[NSValue class]]) {
        NSUInteger size;
        NSGetSizeAndAlignment([converted objCType], &size, NULL);
        char argumentValue[size];
        
        [converted getValue:argumentValue];
        [invocation setArgument:argumentValue atIndex:2];
    } else {
        [invocation setArgument:&converted atIndex:2];
    }
    
    NSArray *axesArguments = [arguments subarrayWithRange:NSMakeRange(1, [arguments count] - 1)];
    [axesArguments enumerateObjectsUsingBlock:^(id argument, NSUInteger index, BOOL *stop) {
        NSInteger argumentIndex = index + 3;
        NSString *argumentType = [NSString stringWithUTF8String:[invocation.methodSignature getArgumentTypeAtIndex:argumentIndex]];

        id<UISSAxisParameterValueConverter> converter = [self findConverterForAxisParameter:[self axisParameterNameAtIndex:index 
                                                                                                             forInvocation:invocation] 
                                                                                      value:argument argumentType:argumentType];
        NSNumber *converted = [converter convertAxisParameter:argument];

        if ([argumentType isEqualToString:[NSString stringWithCString:@encode(NSUInteger) encoding:NSUTF8StringEncoding]]) {
            NSUInteger unsignedInteger = [converted unsignedIntegerValue];
            [invocation setArgument:&unsignedInteger atIndex:argumentIndex];
        } else {
            NSInteger integer = [converted integerValue];
            [invocation setArgument:&integer atIndex:argumentIndex];
        }

    }];
}

- (BOOL)multipleAxisValuesDetectedInArgumentsArray:(NSArray *)array;
{
    if (array.count < 2) return NO;
    if (![array.lastObject isKindOfClass:[NSArray class]]) return NO;
    
    NSUInteger argumentsCount = [array.lastObject count];
    if (argumentsCount < 2) return NO;

    for (id obj in array) {
        if (![obj isKindOfClass:[NSArray class]]) return NO;
        if ([obj count] != argumentsCount) return NO;
    }
    
    return YES;
}

- (void)prepareInvocationForProperty:(NSString *)property arguments:(NSArray *)arguments 
                         invocations:(NSArray *)invocations
                             context:(UISSParserContext *)context
                             handler:(void (^)(NSInvocation *invocation))handler;
{
    NSInvocation *invocation = [self selectInvocationForArguments:arguments from:invocations];
    
    if (invocation) {
        [self setupInvocation:invocation forProperty:property withArguments:arguments];
        invocation.target = [self appearanceTargetForContext:context];
        
        handler(invocation);
    }
}

- (UIUserInterfaceIdiom)userInterfaceIdiomForKey:(NSString *)key;
{
    if ([@"Phone" isEqual:key]) {
        return UIUserInterfaceIdiomPhone;
    } else if ([@"Pad" isEqual:key]) {
        return UIUserInterfaceIdiomPad;
    } else {
        return NSNotFound;
    }
}

- (void)parseDictionary:(NSDictionary *)dictionary handler:(void (^)(NSInvocation *invocation))handler 
                context:(UISSParserContext *)context;
{
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        Class class = NSClassFromString(key);
        
        if ([class conformsToProtocol:@protocol(UIAppearance)]) {
            NSLog(@"UISS -- component: %@", key);
            
            [context.appearanceStack addObject:class];
            [self parseDictionary:obj handler:handler context:context];
            [context.appearanceStack removeLastObject];
        } else if ([class conformsToProtocol:@protocol(UIAppearanceContainer)]) {
            // TODO check if last object is a container
            [context.appearanceStack addObject:class];
            [self parseDictionary:obj handler:handler context:context];
            [context.appearanceStack removeLastObject];
        } else {
            UIUserInterfaceIdiom userInterfaceIdiom = [self userInterfaceIdiomForKey:key];
            
            if (userInterfaceIdiom != NSNotFound) {
                if (userInterfaceIdiom == self.userInterfaceIdiom) {
                    [self parseDictionary:obj handler:handler context:context];
                }
            } else { // property
                NSLog(@"UISS - property: %@", key);
                
                NSString *property = key;
                
                NSArray *invocations = [self invocationsForProperty:property component:context.appearanceStack.lastObject];
                NSArray *arguments = [self argumentsArrayFrom:obj];
                
                // detect multiple values
                if ([self multipleAxisValuesDetectedInArgumentsArray:arguments]) {
                    for (NSArray *args in arguments) {
                        [self prepareInvocationForProperty:property arguments:args 
                                               invocations:invocations context:context handler:handler];
                    }
                } else {
                    [self prepareInvocationForProperty:property arguments:arguments 
                                           invocations:invocations context:context handler:handler];
                }
            }
        }
    }];
}

- (id<UIAppearance>)appearanceTargetForContext:(UISSParserContext *)context;
{
    // This may be the ugliest method I have ever written
    
    Class<UIAppearance> component = context.appearanceStack.lastObject;
    
    switch (context.appearanceStack.count) {
        case 1:
            return [component appearance];
        case 2:
            return [component appearanceWhenContainedIn:
                    [context.appearanceStack objectAtIndex:0],
                    nil];
        case 3:
            return [component appearanceWhenContainedIn:
                    [context.appearanceStack objectAtIndex:1],
                    [context.appearanceStack objectAtIndex:0],
                    nil];
        case 4:
            return [component appearanceWhenContainedIn:
                    [context.appearanceStack objectAtIndex:2],
                    [context.appearanceStack objectAtIndex:1],
                    [context.appearanceStack objectAtIndex:0],
                    nil];
        case 5:
            return [component appearanceWhenContainedIn:
                    [context.appearanceStack objectAtIndex:3],
                    [context.appearanceStack objectAtIndex:2],
                    [context.appearanceStack objectAtIndex:1],
                    [context.appearanceStack objectAtIndex:0],
                    nil];
        case 6:
            return [component appearanceWhenContainedIn:
                    [context.appearanceStack objectAtIndex:4],
                    [context.appearanceStack objectAtIndex:3],
                    [context.appearanceStack objectAtIndex:2],
                    [context.appearanceStack objectAtIndex:1],
                    [context.appearanceStack objectAtIndex:0],
                    nil];
        default:
            return nil;
    }
}

#pragma mark - Public

- (void)parseDictionary:(NSDictionary *)dictionary handler:(void (^)(NSInvocation *invocation))handler;
{
    NSAssert(handler, @"handler block is required");
    
    UISSParserContext *context = [[UISSParserContext alloc] init];
    [self parseDictionary:dictionary handler:handler context:context];
}

@end
