//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import "UISSVariablesPreprocessor.h"

@interface UISSVariablesPreprocessor ()

@property (nonatomic, strong) NSString *variablesKey;
@property (nonatomic, strong) NSMutableDictionary *variables;
@property (nonatomic, strong) NSString *variablePrefix;

@end

typedef id (^ResolveBlock)(NSString *);

@implementation UISSVariablesPreprocessor

- (id)init
{
    self = [super init];
    if (self) {
        self.variablesKey = UISS_DEFAULT_VARIABLES_KEY;
        self.variables = [NSMutableDictionary dictionary];
        self.variablePrefix = UISS_DEFAULT_VARIABLE_PREFIX;
    }
    return self;
}

- (NSString *)variableNameFromValue:(id)value;
{
    if ([value isKindOfClass:[NSString class]] && [value hasPrefix:self.variablePrefix]) {
        return [value substringFromIndex:self.variablePrefix.length];
    } else {
        return nil;
    }
}

- (id)substituteValue:(id)value withResolveBlock:(ResolveBlock)resolveBlock;
{
    NSString *name = [self variableNameFromValue:value];
    
    if (name) {
        value = resolveBlock(name);
        
        if (value == nil) {
            value = [NSNull null];
        }
        return value;
    }
    
    return value;
}

- (id)substituteValue:(id)value;
{
    return [self substituteValue:value withResolveBlock:^(NSString *name) {
        return [self getValueForVariableWithName:name];
    }];
}

- (id)resolveNestedValuesForValue:(id)value withResolveBlock:(ResolveBlock)resolveBlock;
{
    if ([value isKindOfClass:[NSArray class]]) {
        NSMutableArray *resolved = [NSMutableArray array];
        NSArray *array = value;
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [resolved addObject:[self resolveNestedValuesForValue:obj withResolveBlock:resolveBlock]];
        }];
        return resolved;
    } else if ([value isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *resolved = [NSMutableDictionary dictionary];
        [value enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [resolved setObject:[self resolveNestedValuesForValue:obj withResolveBlock:resolveBlock] forKey:key];
        }];
        return resolved;
    } else {
        return [self substituteValue:value withResolveBlock:resolveBlock];
    }
}

- (id)resolveNestedValuesForValue:(id)value;
{
    return [self resolveNestedValuesForValue:value withResolveBlock:^(NSString *name) {
        return [self getValueForVariableWithName:name];
    }];
}

- (void)setVariableValue:(id)value forName:(NSString *)name withResolveBlock:(ResolveBlock)resolveBlock;
{
    [self.variables setValue:[self resolveNestedValuesForValue:value withResolveBlock:resolveBlock] forKey:name];
}

- (void)setVariableValue:(id)value forName:(NSString *)name;
{
    __weak UISSVariablesPreprocessor *weakSelf = self;
    [self setVariableValue:value forName:name withResolveBlock:^(NSString *n) {
        return [weakSelf getValueForVariableWithName:n];
    }];
}

- (id)getValueForVariableWithName:(NSString *)name;
{
    return [self.variables objectForKey:name];
}

- (void)setVariablesFromDictionary:(NSDictionary *)dictionary;
{
    NSMutableDictionary *unresolved = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    
    ResolveBlock __block __weak weakResolveBlock;
    ResolveBlock resolveBlock = ^(NSString *n) {
        if ([unresolved.allKeys containsObject:n]) {
            id value = [unresolved objectForKey:n];
            [unresolved removeObjectForKey:n];
            
            [self setVariableValue:value forName:n withResolveBlock:weakResolveBlock];
        }
        
        return [self getValueForVariableWithName:n];
    };
    weakResolveBlock = resolveBlock;
    
    while (unresolved.count) {
        // resolveBlock removes objects from this dictionary
        resolveBlock(unresolved.allKeys.lastObject);
    }
}

- (NSDictionary *)preprocess:(NSDictionary *)dictionary userInterfaceIdiom:(UIUserInterfaceIdiom)userInterfaceIdiom;
{
    // clean up
    [self.variables removeAllObjects];
    
    id variablesDictionary = [dictionary objectForKey:self.variablesKey];
    if (variablesDictionary != nil) {
        NSMutableDictionary *preprocessed = [NSMutableDictionary dictionaryWithDictionary:dictionary];
        [preprocessed removeObjectForKey:self.variablesKey];
        
        [self setVariablesFromDictionary:variablesDictionary];
        
        return [self resolveNestedValuesForValue:preprocessed];
    }
    
    return dictionary;
}

@end
