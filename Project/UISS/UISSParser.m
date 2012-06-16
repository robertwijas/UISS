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

@implementation UISSParser

@synthesize config = _config;
@synthesize userInterfaceIdiom = _userInterfaceIdiom;

- (id)init
{
    self = [super init];
    if (self) {
        self.config = [UISSConfig sharedConfig];
        self.userInterfaceIdiom = [UIDevice currentDevice].userInterfaceIdiom;
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
                                      appearanceStack:(NSArray *)appearanceStack;
{
    UISSPropertySetter *propertySetter = [[UISSPropertySetter alloc] init];

    propertySetter.appearanceClass = appearanceStack.lastObject;
    propertySetter.containment = [appearanceStack subarrayWithRange:NSMakeRange(0, appearanceStack.count - 1)];

    UISSProperty *property = [[UISSProperty alloc] init];
    property.name = name;
    property.value = [arguments objectAtIndex:0];

    propertySetter.property = property;

    NSMutableArray *axisParameters = [NSMutableArray array];

    for (NSUInteger idx = 1; idx < arguments.count; idx++) {
        UISSAxisParameter *axisParameter = [[UISSAxisParameter alloc] init];
        axisParameter.value = [arguments objectAtIndex:idx];
        [axisParameters addObject:axisParameter];
    }

    propertySetter.axisParameters = axisParameters;

    return propertySetter;
}

- (NSArray *)parseDictionary:(NSDictionary *)dictionary appearanceStack:(NSMutableArray *)appearanceStack;
{
    NSMutableArray *propertySetters = [NSMutableArray array];

    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        Class class = NSClassFromString(key);
        
        if ([class conformsToProtocol:@protocol(UIAppearance)]) {
            NSLog(@"UISS -- component: %@", key);
            
            [appearanceStack addObject:class];
            [propertySetters addObjectsFromArray:[self parseDictionary:obj appearanceStack:appearanceStack]];
            [appearanceStack removeLastObject];
        } else if ([class conformsToProtocol:@protocol(UIAppearanceContainer)]) {
            // TODO check if last object is a container
            [appearanceStack addObject:class];
            [propertySetters addObjectsFromArray:[self parseDictionary:obj appearanceStack:appearanceStack]];
            [appearanceStack removeLastObject];
        } else {
            // property
            NSLog(@"UISS - property: %@", key);
            NSArray *arguments = [self argumentsArrayFrom:obj];
            
            // detect multiple values
            if ([self multipleAxisValuesDetectedInArgumentsArray:arguments]) {
                for (NSArray *args in arguments) {
                    [propertySetters addObject:[self propertySetterForName:key withArguments:args appearanceStack:appearanceStack]];
                }
            } else {
                [propertySetters addObject:[self propertySetterForName:key withArguments:arguments appearanceStack:appearanceStack]];
            }
        }
    }];

    return propertySetters;
}

#pragma mark - Public

- (NSArray *)parseDictionary:(NSDictionary *)dictionary;
{
    for (id<UISSDictionaryPreprocessor>preprocessor in self.config.preprocessors) {
        dictionary = [preprocessor preprocess:dictionary userInterfaceIdiom:self.userInterfaceIdiom];
    }

    return [self parseDictionary:dictionary appearanceStack:[NSMutableArray array]];
}

@end
