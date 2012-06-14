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

@interface UISSParserTests : SenTestCase

@end

@implementation UISSParserTests

#pragma mark - Tests

- (void)test;
{
    //UISSParser *parser = [[UISSParser alloc] init];
}

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

@end

