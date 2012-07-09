//
//  UISSParserTests.m
//  UISS
//
//  Created by Robert Wijas on 5/9/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "UISSParser.h"
#import "UISSPropertySetter.h"
#import "UISSError.h"

@interface UISSParserTests : SenTestCase

@property (nonatomic, strong) UISSParser *parser;

@end

@implementation UISSParserTests

@synthesize parser=_parser;

#pragma mark - Groups

- (void)testGroups;
{
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:@"yellow" forKey:@"tintColor"]
                                                           forKey:@"UIToolbar"];
    dictionary = [NSDictionary dictionaryWithObject:dictionary forKey:@"@Group"];
    
    NSMutableArray *errors = [NSMutableArray array];
    
    NSArray *propertySetters = [self.parser parseDictionary:dictionary errors:errors];
    
    STAssertEquals(errors.count, (NSUInteger)0, @"expected no errors");
    STAssertEquals(propertySetters.count, (NSUInteger)1, @"expected one property setter");
    
    UISSPropertySetter *propertySetter = [propertySetters lastObject];
    STAssertEqualObjects(propertySetter.group, @"Group", nil);
    STAssertEquals(propertySetter.containment.count, (NSUInteger)0, nil);
}

#pragma mark - Errors

- (void)testInvalidAppearanceDictionary;
{
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:@"Invalid dictionary"
                                                           forKey:@"UIToolbar"];
    NSMutableArray *errors = [NSMutableArray array];
    
    [self.parser parseDictionary:dictionary errors:errors];
    
    STAssertEquals(errors.count, (NSUInteger)1, @"expected one error");
    NSError *error = errors.lastObject;
    STAssertEquals(error.code, UISSInvalidAppearanceDictionaryError, nil);
    STAssertEqualObjects([error.userInfo objectForKey:UISSInvalidAppearanceDictionaryErrorKey], dictionary, nil);
}

- (void)testUnknownClassNameWithoutContainment;
{
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:@"yellow" forKey:@"tintColor"]
                                                           forKey:@"UnknownClass"];
    NSMutableArray *errors = [NSMutableArray array];
    
    [self.parser parseDictionary:dictionary errors:errors];
    
    STAssertEquals(errors.count, (NSUInteger)1, @"expected one error");
    NSError *error = errors.lastObject;
    STAssertEquals(error.code, UISSUnknownClassError, nil);
    STAssertEqualObjects([error.userInfo objectForKey:UISSInvalidClassNameErrorKey], @"UnknownClass", nil);
}

- (void)testInvalidAppearanceContainerClass;
{
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:@"yellow" forKey:@"tintColor"]
                                                           forKey:@"UIToolbar"];
    dictionary = [NSDictionary dictionaryWithObject:dictionary forKey:@"UIBarButtonItem"];
    NSMutableArray *errors = [NSMutableArray array];
    
    [self.parser parseDictionary:dictionary errors:errors];

    STAssertEquals(errors.count, (NSUInteger)1, @"expected one error");
    NSError *error = errors.lastObject;
    STAssertEquals(error.code, UISSInvalidAppearanceContainerClassError, nil);
    STAssertEqualObjects([error.userInfo objectForKey:UISSInvalidClassNameErrorKey], @"UIBarButtonItem", nil);
}

- (void)testInvalidAppearanceClass;
{
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:@"yellow" forKey:@"tintColor"]
                                                           forKey:@"NSString"];
    NSMutableArray *errors = [NSMutableArray array];
    
    [self.parser parseDictionary:dictionary errors:errors];
    
    STAssertEquals(errors.count, (NSUInteger)1, @"expected one error");
    NSError *error = errors.lastObject;
    STAssertEquals(error.code, UISSInvalidAppearanceClassError, nil);
    STAssertEqualObjects([error.userInfo objectForKey:UISSInvalidClassNameErrorKey], @"NSString", nil);
}

- (void)testInvalidAppearanceClassInContainer;
{
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:@"yellow" forKey:@"tintColor"]
                                                           forKey:@"UIBadToolbar"];
    dictionary = [NSDictionary dictionaryWithObject:dictionary forKey:@"UIPopoverController"];
    NSMutableArray *errors = [NSMutableArray array];
    
    [self.parser parseDictionary:dictionary errors:errors];
    
    STAssertEquals(errors.count, (NSUInteger)1, @"expected one error");
    NSError *error = errors.lastObject;
    STAssertEquals(error.code, UISSUnknownClassError, nil);
    STAssertEqualObjects([error.userInfo objectForKey:UISSInvalidClassNameErrorKey], @"UIBadToolbar", nil);
}

#pragma mark - Invocations

- (void)testToolbarTintColor;
{
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:@"yellow" forKey:@"tintColor"]
                                                           forKey:@"UIToolbar"];
    
    [self parserTestWithDictionary:dictionary assertionsAfterInvoke:^(NSInvocation *invocation) {
        STAssertEqualObjects(invocation.target, [UIToolbar appearance], @"expected target to be UIToolbar appearance proxy");
        STAssertEquals(invocation.selector, @selector(setTintColor:), nil);
        
        UIColor *color;
        [invocation getArgument:&color atIndex:2];
        STAssertEqualObjects(color, [UIColor yellowColor], nil);
    }];
}

- (void)testLabelShadowOffset;
{
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:1]
                                                                                              forKey:@"shadowOffset"]
                                                           forKey:@"UILabel"];
    
    [self parserTestWithDictionary:dictionary assertionsAfterInvoke:^(NSInvocation *invocation) {
        STAssertEqualObjects(invocation.target, [UILabel appearance], @"expected target to be UILabel appearance proxy");
        STAssertEquals(invocation.selector, @selector(setShadowOffset:), nil);
        
        CGSize shadowOffset;
        [invocation getArgument:&shadowOffset atIndex:2];
        STAssertEquals(shadowOffset, CGSizeMake(1, 1), nil);
        
        STAssertEquals([[UILabel appearance] shadowOffset], CGSizeMake(1, 1), nil);
    }];
}

- (void)testButtonTitleColorForState;
{
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:[NSArray arrayWithObjects:
                                                                                                      @"green",
                                                                                                      [NSNumber numberWithUnsignedInteger:UIControlStateHighlighted],
                                                                                                      nil]
                                                                                              forKey:@"titleColor"]
                                                           forKey:@"UIButton"];
    
    
    [self parserTestWithDictionary:dictionary assertionsAfterInvoke:^(NSInvocation *invocation) {
        STAssertEqualObjects([[UIButton appearance] titleColorForState:UIControlStateHighlighted], [UIColor greenColor], nil);
    }];
}

- (void)testSimpleContainment;
{
    NSDictionary *buttonDictionary = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:[NSArray arrayWithObjects:
                                                                                                            @"green",
                                                                                                            [NSNumber numberWithUnsignedInteger:UIControlStateHighlighted],
                                                                                                            nil]
                                                                                                    forKey:@"titleColor"]
                                                                 forKey:@"UIButton"];
    NSDictionary *containmentDictionary = [NSDictionary dictionaryWithObject:buttonDictionary forKey:@"UINavigationController"];
    
    
    [self parserTestWithDictionary:containmentDictionary assertionsAfterInvoke:^(NSInvocation *invocation) {
        UIColor *buttonColor = [[UIButton appearanceWhenContainedIn:[UINavigationController class], nil] titleColorForState:UIControlStateHighlighted];
        STAssertEqualObjects(buttonColor, [UIColor greenColor], nil);
    }];
}

- (void)testContainment;
{
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:[NSArray arrayWithObjects:
                                                                                                      @"yellow",
                                                                                                      [NSNumber numberWithUnsignedInteger:UIControlStateHighlighted],
                                                                                                      nil]
                                                                                              forKey:@"titleColor"]
                                                           forKey:@"UIButton"];
    dictionary = [NSDictionary dictionaryWithObject:dictionary forKey:@"UIImageView"];
    dictionary = [NSDictionary dictionaryWithObject:dictionary forKey:@"UINavigationController"];
    
    [self parserTestWithDictionary:dictionary assertionsAfterInvoke:^(NSInvocation *invocation) {
        UIColor *buttonColor = [[UIButton appearanceWhenContainedIn:[UIImageView class], [UINavigationController class], nil] titleColorForState:UIControlStateHighlighted];
        STAssertEqualObjects(buttonColor, [UIColor yellowColor], nil);
    }];
}

#pragma mark - Helper Methods

- (void)parserTestWithDictionary:(NSDictionary *)dictionary assertionsAfterInvoke:(void (^)(NSInvocation *))assertions;
{
    UISSParser *parser = [[UISSParser alloc] init];

    NSMutableArray *invokedInvocations = [NSMutableArray array];

    NSArray *propertySetters = [parser parseDictionary:dictionary];
    for (UISSPropertySetter *propertySetter in propertySetters) {
        NSInvocation *invocation = propertySetter.invocation;
        if (invocation) {
            [invocation invoke];
            [invokedInvocations addObject:invocation];
            assertions(invocation);
        }
    }
    
    STAssertTrue([invokedInvocations count], @"expected at least one invocation");
}

#pragma mark - Setup

- (void)setUp;
{
    self.parser = [[UISSParser alloc] init];
}

- (void)tearDown;
{
    self.parser = nil;
}

@end

