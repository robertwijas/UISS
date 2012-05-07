//
//  UISS.m
//  UISS
//
//  Created by Robert Wijas on 10/7/11.
//  Copyright (c) 2011 57things. All rights reserved.
//

#import "UISS+Private.h"
#import <objc/runtime.h>

@implementation UISS

#define TEXT_ATTRIBUTES_PROPERTY_SUFFIX @"TextAttributes"

+ (NSNumber *)convertStringToNumber:(NSString *)string;
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

+ (UIColor *)convertToColor:(id)value;
{
    return [UIColor performSelector:NSSelectorFromString(value)];
}

+ (UIImage *)convertToImage:(id)value;
{
    NSString *imageURL = [[NSBundle bundleForClass:[self class]].resourcePath stringByAppendingPathComponent:value];
    return [UIImage imageWithContentsOfFile:imageURL];
}

+ (NSDictionary *)convertTextAttributesDictionary:(NSDictionary *)dictionary;
{
    NSMutableDictionary *textAttributes = [NSMutableDictionary dictionary];
    
    id fontDescription = [dictionary objectForKey:@"font"];
    UIFont *font = [UIFont systemFontOfSize:[fontDescription floatValue]];
    [textAttributes setObject:font forKey:UITextAttributeFont];
    
    return textAttributes;
}

+ (id)convertObjectValue:(id)value forProperty:(NSString *)property;
{
    if ([property hasSuffix:TEXT_ATTRIBUTES_PROPERTY_SUFFIX]) {
        return [self convertTextAttributesDictionary:value];
    } else if ([property hasSuffix:@"Color"]) {
        return [self convertToColor:value];
    } else if ([property hasSuffix:@"Image"]) {
        return [self convertToImage:value];
    } else {
        return value;
    }
}

+ (NSArray *)argumentsArrayFrom:(id)value;
{
    if ([value isKindOfClass:[NSArray class]]) {
        return value;
    } else {
        return [NSArray arrayWithObject:value];
    }
}

+ (NSString *)setterMethodPrefixForProperty:(NSString *)property;
{
    return [NSString stringWithFormat:@"set%@%@:", [[property substringToIndex:1] uppercaseString], [property substringFromIndex:1]];
}

+ (NSArray *)invocationsForProperty:(NSString *)property component:(Class<UIAppearance>)component;
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

+ (NSInvocation *)selectInvocationForArguments:(NSArray *)arguments from:(NSArray *)invocations;
{
    NSInvocation *selected = nil;
    
    for (NSInvocation *invocation in invocations) {
        if ([invocation canAcceptArguments:arguments]) {
            if (selected == nil || (selected.methodSignature.numberOfArguments > invocation.methodSignature.numberOfArguments)) {
                // select invocation with the least number of arguments
                selected = invocation;
            }
        }
    }
    
    return selected;
}

+ (void)setupInvocation:(NSInvocation *)invocation forProperty:(NSString *)property withArguments:(NSArray *)arguments;
{
    id value = [arguments objectAtIndex:0];
    
    NSString *argumentType = [NSString stringWithUTF8String:[invocation.methodSignature getArgumentTypeAtIndex:2]];
    if ([argumentType hasPrefix:@"@"]) {
        id converted = [self convertObjectValue:value forProperty:property];
        [invocation setArgument:&converted atIndex:2];
    } else if ([argumentType hasPrefix:@"{"]) {
        // structure
        if ([argumentType hasPrefix:@"{UIOffset"]) {
            UIOffset offset = UIOffsetMake([[value objectAtIndex:0] floatValue], [[value objectAtIndex:1] floatValue]);
            [invocation setArgument:&offset atIndex:2];
        }
    } else if ([argumentType hasPrefix:@"f"]) {
        CGFloat floatValue = [value floatValue];
        [invocation setArgument:&floatValue atIndex:2];
    }
    
    NSArray *axesArguments = [arguments subarrayWithRange:NSMakeRange(1, [arguments count] - 1)];
    [axesArguments enumerateObjectsUsingBlock:^(id argument, NSUInteger index, BOOL *stop) {
        id value = argument;
        if ([argument isKindOfClass:[NSDictionary class]]) {
            value = [[argument allObjects] lastObject];
        }
        if ([value isKindOfClass:[NSString class]]) {
            value = [self convertStringToNumber:value];
        }
        if ([value isKindOfClass:[NSNumber class]]) {
            NSInteger argumentIndex = 3+index;
            NSInteger i = [value integerValue];
            [invocation setArgument:&i atIndex:argumentIndex];
        }
    }];
}

+ (void)configureComponent:(Class<UIAppearance>)component withDictionary:(NSDictionary *)dictionary;
{
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id property, id value, BOOL *stop) {
        NSArray *invocations = [self invocationsForProperty:property component:component];
        NSArray *arguments = [self argumentsArrayFrom:value];
        
        NSInvocation *invocation = [self selectInvocationForArguments:arguments from:invocations];
        NSLog(@"selected invocation: %@", [invocation debugDescription]);
        
        [self setupInvocation:invocation forProperty:property withArguments:arguments];
        
        [invocation invokeWithTarget:[component appearance]];
    }];
}

+ (void)configureWithDictionary:(NSDictionary *)dictionary;
{
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        Class class = NSClassFromString(key);
        if ([class conformsToProtocol:@protocol(UIAppearance)]) {
            Class<UIAppearance> component = (Class<UIAppearance>)class;
            [self configureComponent:component withDictionary:obj];
        }
    }];
}

+ (void)configureWithJSONFilePath:(NSString *)filePath;
{
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:filePath]
                                                               options:0 
                                                                 error:NULL];
    [self configureWithDictionary:dictionary];
}

+ (void)configureWithDefaultJSONFile;
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"uiss" ofType:@"json"];
    [self configureWithJSONFilePath:filePath];
}

@end
