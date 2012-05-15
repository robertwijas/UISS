//
//  UISSParserTests.m
//  UISS
//
//  Created by Robert Wijas on 5/9/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import "UISSParserTests.h"
#import "UISSParser.h"

@implementation UISSParserTests

#pragma mark - Tests

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
        UIColor *buttonColor = [[UIButton appearanceWhenContainedIn:[UINavigationController class], [UIImageView class], nil] titleColorForState:UIControlStateHighlighted];
        STAssertEqualObjects(buttonColor, [UIColor yellowColor], nil);
    }];
}

#pragma mark - Helper Methods

- (void)parserTestWithDictionary:(NSDictionary *)dictionary assertionsAfterInvoke:(void (^)(NSInvocation *))assertions;
{
    UISSParser *parser = [[UISSParser alloc] init];
    
    __block BOOL handlerCalled = NO;
    [parser parseDictionary:dictionary handler:^(NSInvocation *invocation) {
        handlerCalled = YES;
        [invocation invoke];
        
        assertions(invocation);
    }];
    
    STAssertTrue(handlerCalled, nil);
}

@end

