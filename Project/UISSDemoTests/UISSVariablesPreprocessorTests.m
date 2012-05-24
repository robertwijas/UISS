//
//  UISSVariablesPreprocessorTests.m
//  UISS
//
//  Created by Robert Wijas on 5/19/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "UISSVariablesPreprocessor.h"

@interface UISSVariablesPreprocessorTests : SenTestCase

@property (nonatomic, strong) UISSVariablesPreprocessor *preprocessor;

@end

@implementation UISSVariablesPreprocessorTests

@synthesize preprocessor;

- (void)testSubstitutionWithRegularValue;
{
    id value = @"test";
    STAssertEquals([self.preprocessor substituteValue:value], value, nil);
}

- (void)testSettingVariable;
{
    NSString *name = @"test";
    id value = @"value";
    
    [self.preprocessor setVariableValue:value forName:name];
    
    STAssertEqualObjects(value, [self.preprocessor getValueForVariableWithName:name], nil);
}

- (void)testSubstitutionOfAddedVariable;
{
    NSString *name = @"test";
    id value = @"value";
    
    [self.preprocessor setVariableValue:value forName:name];
    
    STAssertEquals(value, [self.preprocessor substituteValue:@"$test"], nil);
}

- (void)testNestedVariables;
{
    NSString *name1 = @"v1";
    NSString *name2 = @"v2";
    
    id v1 = @"value 1";
    id v2 = [NSDictionary dictionaryWithObject:@"$v1" forKey:@"test"];
    
    [self.preprocessor setVariableValue:v1 forName:name1];
    [self.preprocessor setVariableValue:v2 forName:name2];
    
    STAssertEqualObjects(v1, [[self.preprocessor getValueForVariableWithName:name2] objectForKey:@"test"], nil);
}

- (void)testNestedUnknownVariableShouldBeResolvedAsNull;
{
    NSString *name = @"v";
    id value = @"$unknown";
    
    [self.preprocessor setVariableValue:value forName:name];
    STAssertEqualObjects([self.preprocessor getValueForVariableWithName:name], [NSNull null], nil);
}

- (void)testNestedVariableCycle;
{
    NSString *name = @"v";
    id value = @"$v";
    
    [self.preprocessor setVariableValue:value forName:name];
    STAssertEqualObjects([self.preprocessor getValueForVariableWithName:name], [NSNull null], nil);
}

- (void)testAddingVariablesFromDictionary;
{
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"value1", @"v1", nil];
    
    [self.preprocessor setVariablesFromDictionary:dictionary];
    STAssertEqualObjects([self.preprocessor getValueForVariableWithName:@"v1"], @"value1", nil);
}

- (void)testAddingVariablesFromDictionaryWithNestedVariables;
{
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"value1", @"v1",
                                @"$v1", @"v2", nil];
    
    [self.preprocessor setVariablesFromDictionary:dictionary];
    
    STAssertEqualObjects([self.preprocessor getValueForVariableWithName:@"v2"], @"value1", nil);
}

- (void)testAddingVariablesFromDictionaryWithNestedVariablesCycle;
{
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"$v2", @"v1",
                                @"$v1", @"v2", nil];
    
    [self.preprocessor setVariablesFromDictionary:dictionary];
    
    STAssertEqualObjects([self.preprocessor getValueForVariableWithName:@"v1"], [NSNull null], nil);
    STAssertEqualObjects([self.preprocessor getValueForVariableWithName:@"v2"], [NSNull null], nil);
}

- (void)testAddingVariablesFromDictionaryWithNestedVariablesCycleAndPredefiniedValue;
{
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"$v2", @"v1",
                                @"$v1", @"v2", nil];
    
    id value = @"v";
    
    [self.preprocessor setVariableValue:value forName:@"v1"];
    [self.preprocessor setVariableValue:value forName:@"v2"];
    [self.preprocessor setVariablesFromDictionary:dictionary];
    
    STAssertEqualObjects([self.preprocessor getValueForVariableWithName:@"v1"], value, nil);
    STAssertEqualObjects([self.preprocessor getValueForVariableWithName:@"v2"], value, nil);
}

- (void)setUp;
{
    self.preprocessor = [[UISSVariablesPreprocessor alloc] init];
}

- (void)tearDown;
{
    self.preprocessor = nil;
}

@end
