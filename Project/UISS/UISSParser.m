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

@implementation UISSParser

@synthesize propertyValueConverters=_propertyValueConverters;
@synthesize axisParameterValueConverters=_axisParameterValueConverters;

- (id)init
{
    self = [super init];
    if (self) {
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
    
    NSMutableArray *invocations = [NSMutableArray array];
    
    unsigned int count = 0;
    Method *methods = class_copyMethodList(component, &count);
    
    for (int i = 0; i < count; i++) {
        SEL selector = method_getName(methods[i]);
        NSString *method = NSStringFromSelector(selector);
        
        if ([method hasPrefix:methodPrefix]) {
            NSMethodSignature *methodSignature = [[component appearance] methodSignatureForSelector:selector];
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
            [invocation setSelector:selector];
            
            [invocations addObject:invocation];
        }
    }
    
    free(methods);
        
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

- (void)setupInvocation:(NSInvocation *)invocation forProperty:(NSString *)property withArguments:(NSArray *)arguments;
{
    if (invocation == nil) return;
    
    id value = [arguments objectAtIndex:0];
    NSString *argumentType = [NSString stringWithUTF8String:[invocation.methodSignature getArgumentTypeAtIndex:2]];
    
    id<UISSPropertyValueConverter> converter = [self findConverterForProperty:property value:value argumentType:argumentType];
    id converted = [converter convertPropertyValue:value];
    
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

        id<UISSAxisParameterValueConverter> converter = [self findConverterForAxisParameter:nil value:argument argumentType:argumentType];
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

- (void)parseDictionary:(NSDictionary *)dictionary handler:(void (^)(NSInvocation *invocation))handler 
                context:(UISSParserContext *)context;
{
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        Class class = NSClassFromString(key);
        
        if ([class conformsToProtocol:@protocol(UIAppearance)]) {
            [context.appearanceStack addObject:class];
            [self parseDictionary:obj handler:handler context:context];
            [context.appearanceStack removeLastObject];
        } else if ([class conformsToProtocol:@protocol(UIAppearanceContainer)]) {
            // TODO check if last object is a container
            [context.appearanceStack addObject:class];
            [self parseDictionary:obj handler:handler context:context];
            [context.appearanceStack removeLastObject];
        } else { // property
            NSString *property = key;
            
            NSArray *invocations = [self invocationsForProperty:property component:context.appearanceStack.lastObject];
            NSArray *arguments = [self argumentsArrayFrom:obj];
            
            NSInvocation *invocation = [self selectInvocationForArguments:arguments from:invocations];
            NSLog(@"selected invocation: %@", [invocation debugDescription]);
            
            [self setupInvocation:invocation forProperty:property withArguments:arguments];
            invocation.target = [self appearanceTargetForContext:context];
            
            handler(invocation);
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
                    [context.appearanceStack objectAtIndex:0],
                    [context.appearanceStack objectAtIndex:1],
                    nil];
        case 4:
            return [component appearanceWhenContainedIn:
                    [context.appearanceStack objectAtIndex:0],
                    [context.appearanceStack objectAtIndex:1],
                    [context.appearanceStack objectAtIndex:2],
                    nil];
        case 5:
            return [component appearanceWhenContainedIn:
                    [context.appearanceStack objectAtIndex:0],
                    [context.appearanceStack objectAtIndex:1],
                    [context.appearanceStack objectAtIndex:2],
                    [context.appearanceStack objectAtIndex:3],
                    nil];
        case 6:
            return [component appearanceWhenContainedIn:
                    [context.appearanceStack objectAtIndex:0],
                    [context.appearanceStack objectAtIndex:1],
                    [context.appearanceStack objectAtIndex:2],
                    [context.appearanceStack objectAtIndex:3],
                    [context.appearanceStack objectAtIndex:4],
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
