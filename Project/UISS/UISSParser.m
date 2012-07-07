//
//  UISSParser.m
//  UISS
//
//  Created by Robert Wijas on 5/9/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import "UISSParser.h"

#import <objc/runtime.h>

#import "UISSColorValueConverter.h"
#import "UISSConfig.h"
#import "UISSIntegerValueConverter.h"
#import "UISSDictionaryPreprocessor.h"
#import "UISSPropertySetter.h"
#import "UISSError.h"
#import "UISSParserContext.h"

@implementation UISSParser

@synthesize config = _config;
@synthesize userInterfaceIdiom = _userInterfaceIdiom;
@synthesize groupPrefix = _groupPrefix;

- (id)init
{
    self = [super init];
    if (self) {
        self.config = [UISSConfig sharedConfig];
        self.userInterfaceIdiom = [UIDevice currentDevice].userInterfaceIdiom;
        self.groupPrefix = UISS_PARSER_DEFAULT_GROUP_PREFIX;
    }
    
    return self;
}

- (NSArray *)argumentsArrayFrom:(id)value;
{
    if ([value isKindOfClass:[NSArray class]]) {
        return value;
    } else {
        return [NSArray arrayWithObject:value];
    }
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

- (UISSPropertySetter *)propertySetterForName:(NSString *)name withArguments:(NSArray *)arguments
                                      context:(UISSParserContext *)context;
{
    UISSPropertySetter *propertySetter = [[UISSPropertySetter alloc] init];
    
    propertySetter.appearanceClass = context.appearanceStack.lastObject;
    propertySetter.containment = [context.appearanceStack subarrayWithRange:NSMakeRange(0, context.appearanceStack.count - 1)];
    
    UISSProperty *property = [[UISSProperty alloc] init];
    property.name = name;
    property.value = [arguments objectAtIndex:0];
    
    propertySetter.property = property;
    propertySetter.group = context.groupsStack.lastObject;
    
    NSMutableArray *axisParameters = [NSMutableArray array];
    
    for (NSUInteger idx = 1; idx < arguments.count; idx++) {
        UISSAxisParameter *axisParameter = [[UISSAxisParameter alloc] init];
        axisParameter.value = [arguments objectAtIndex:idx];
        [axisParameters addObject:axisParameter];
    }
    
    propertySetter.axisParameters = axisParameters;
    
    return propertySetter;
}

- (void)processClass:(Class)class object:(id)object context:(UISSParserContext *)context;
{
    if ([class conformsToProtocol:@protocol(UIAppearance)] || [class conformsToProtocol:@protocol(UIAppearanceContainer)]) {
        Class currentContainer = context.appearanceStack.lastObject;
        
        if (currentContainer == nil || [currentContainer conformsToProtocol:@protocol(UIAppearanceContainer)]) {
            NSLog(@"UISS - component: %@", NSStringFromClass(class));
            
            if ([object isKindOfClass:[NSDictionary class]]) {
                [context.appearanceStack addObject:class];
                [self parseDictionary:object context:context];
                [context.appearanceStack removeLastObject];                
            } else {
                [context addErrorWithCode:UISSInvalidAppearanceDictionaryError
                                   object:[NSDictionary dictionaryWithObject:object forKey:NSStringFromClass(class)]
                                      key:UISSInvalidAppearanceDictionaryErrorKey];
            }
        } else {
            [context addErrorWithCode:UISSInvalidAppearanceContainerClassError
                               object:NSStringFromClass(currentContainer) 
                                  key:UISSInvalidClassNameErrorKey];
        }
    } else {
        [context addErrorWithCode:UISSInvalidAppearanceClassError
                           object:NSStringFromClass(class)
                              key:UISSInvalidClassNameErrorKey];
    }
}

- (void)processPropertyWithKey:(NSString *)key value:(id)value context:(UISSParserContext *)context;
{
    if ([[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:[key characterAtIndex:0]]) {
        // first letter capitalized so I guess this supposed to be a class
        [context addErrorWithCode:UISSUnknownClassError object:key key:UISSInvalidClassNameErrorKey];
    } else {
        Class currentClass = context.appearanceStack.lastObject;
        
        if (currentClass == nil) {
            [context addErrorWithCode:UISSUnknownClassError object:key key:UISSInvalidClassNameErrorKey];
        } else if ([context.appearanceStack.lastObject conformsToProtocol:@protocol(UIAppearance)] == NO) {
            [context addErrorWithCode:UISSInvalidAppearanceClassError object:NSStringFromClass(currentClass) key:UISSInvalidClassNameErrorKey];
        } else {
            // property
            NSLog(@"UISS - property: %@", key);
            NSArray *arguments = [self argumentsArrayFrom:value];
            
            // detect multiple values
            if ([self multipleAxisValuesDetectedInArgumentsArray:arguments]) {
                for (NSArray *args in arguments) {
                    [context.propertySetters addObject:[self propertySetterForName:key withArguments:args context:context]];
                }
            } else {
                [context.propertySetters addObject:[self propertySetterForName:key withArguments:arguments context:context]];
            }
        }
    }
}

- (void)processKey:(NSString *)key object:(id)object context:(UISSParserContext *)context;
{
    if ([key hasPrefix:self.groupPrefix]) {
        [context.groupsStack addObject:[key substringFromIndex:[self.groupPrefix length]]];
        [self parseDictionary:object context:context];
        [context.groupsStack removeLastObject];
    } else {
        Class class = NSClassFromString(key);
        
        if (class) {
            [self processClass:class object:object context:context];
        } else {
            [self processPropertyWithKey:key value:object context:context];
        }
    }
}

- (void)parseDictionary:(NSDictionary *)dictionary context:(UISSParserContext *)context;
{
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self processKey:key object:obj context:context];
    }];
}

#pragma mark - Public

- (NSArray *)parseDictionary:(NSDictionary *)dictionary errors:(NSMutableArray *)errors;
{
    UISSParserContext *context = [[UISSParserContext alloc] init];
    
    for (id<UISSDictionaryPreprocessor>preprocessor in self.config.preprocessors) {
        dictionary = [preprocessor preprocess:dictionary userInterfaceIdiom:self.userInterfaceIdiom];
    }
    
    [self parseDictionary:dictionary context:context];
    
    [errors addObjectsFromArray:context.errors];
    
    return context.propertySetters;
}

- (NSArray *)parseDictionary:(NSDictionary *)dictionary;
{
    return [self parseDictionary:dictionary errors:nil];
}

@end
