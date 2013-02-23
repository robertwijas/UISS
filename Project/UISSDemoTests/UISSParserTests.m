//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "UISSParser.h"
#import "UISSPropertySetter.h"
#import "UISSError.h"

@interface UISSParserTests : SenTestCase

@property(nonatomic, strong) UISSParser *parser;

@end

@implementation UISSParserTests

#pragma mark - Groups

- (void)testGroups; {
    NSDictionary *dictionary = @{@"UIToolbar" : @{@"tintColor" : @"yellow"}};
    dictionary = @{@"@Group" : dictionary};

    NSMutableArray *errors = [NSMutableArray array];

    NSArray *propertySetters = [self.parser parseDictionary:dictionary errors:errors];

    STAssertEquals(errors.count, (NSUInteger) 0, @"expected no errors");
    STAssertEquals(propertySetters.count, (NSUInteger) 1, @"expected one property setter");

    UISSPropertySetter *propertySetter = [propertySetters lastObject];
    STAssertEqualObjects(propertySetter.group, @"Group", nil);
    STAssertEquals(propertySetter.containment.count, (NSUInteger) 0, nil);
}

#pragma mark - Errors

- (void)testInvalidAppearanceDictionary; {
    NSDictionary *dictionary = @{@"UIToolbar" : @"Invalid dictionary"};
    NSMutableArray *errors = [NSMutableArray array];

    [self.parser parseDictionary:dictionary errors:errors];

    STAssertEquals(errors.count, (NSUInteger) 1, @"expected one error");
    NSError *error = errors.lastObject;
    STAssertEquals(error.code, UISSInvalidAppearanceDictionaryError, nil);
    STAssertEqualObjects((error.userInfo)[UISSInvalidAppearanceDictionaryErrorKey], dictionary, nil);
}

- (void)testUnknownClassNameWithoutContainment; {
    NSDictionary *dictionary = @{@"UnknownClass" : @{@"tintColor" : @"yellow"}};
    NSMutableArray *errors = [NSMutableArray array];

    [self.parser parseDictionary:dictionary errors:errors];

    STAssertEquals(errors.count, (NSUInteger) 1, @"expected one error");
    NSError *error = errors.lastObject;
    STAssertEquals(error.code, UISSUnknownClassError, nil);
    STAssertEqualObjects((error.userInfo)[UISSInvalidClassNameErrorKey], @"UnknownClass", nil);
}

- (void)testInvalidAppearanceContainerClass; {
    NSDictionary *dictionary = @{@"UIToolbar" : @{@"tintColor" : @"yellow"}};
    dictionary = @{@"UIBarButtonItem" : dictionary};
    NSMutableArray *errors = [NSMutableArray array];

    [self.parser parseDictionary:dictionary errors:errors];

    STAssertEquals(errors.count, (NSUInteger) 1, @"expected one error");
    NSError *error = errors.lastObject;
    STAssertEquals(error.code, UISSInvalidAppearanceContainerClassError, nil);
    STAssertEqualObjects((error.userInfo)[UISSInvalidClassNameErrorKey], @"UIBarButtonItem", nil);
}

- (void)testInvalidAppearanceClass; {
    NSDictionary *dictionary = @{@"NSString" : @{@"tintColor" : @"yellow"}};
    NSMutableArray *errors = [NSMutableArray array];

    [self.parser parseDictionary:dictionary errors:errors];

    STAssertEquals(errors.count, (NSUInteger) 1, @"expected one error");
    NSError *error = errors.lastObject;
    STAssertEquals(error.code, UISSInvalidAppearanceClassError, nil);
    STAssertEqualObjects((error.userInfo)[UISSInvalidClassNameErrorKey], @"NSString", nil);
}

- (void)testInvalidAppearanceClassInContainer; {
    NSDictionary *dictionary = @{@"UIBadToolbar" : @{@"tintColor" : @"yellow"}};
    dictionary = @{@"UIPopoverController" : dictionary};
    NSMutableArray *errors = [NSMutableArray array];

    [self.parser parseDictionary:dictionary errors:errors];

    STAssertEquals(errors.count, (NSUInteger) 1, @"expected one error");
    NSError *error = errors.lastObject;
    STAssertEquals(error.code, UISSUnknownClassError, nil);
    STAssertEqualObjects((error.userInfo)[UISSInvalidClassNameErrorKey], @"UIBadToolbar", nil);
}

#pragma mark - Invocations

- (void)testToolbarTintColor; {
    NSDictionary *dictionary = @{@"UIToolbar" : @{@"tintColor" : @"yellow"}};

    [self parserTestWithDictionary:dictionary assertionsAfterInvoke:^(NSInvocation *invocation) {
        STAssertEqualObjects(invocation.target, [UIToolbar appearance], @"expected target to be UIToolbar appearance proxy");
        STAssertEquals(invocation.selector, @selector(setTintColor:), nil);

        UIColor *color;
        [invocation getArgument:&color atIndex:2];
        STAssertEqualObjects(color, [UIColor yellowColor], nil);
    }];
}

- (void)testLabelShadowOffset; {
    NSDictionary *dictionary = @{@"UILabel" : @{@"shadowOffset" : @1.0f}};

    [self parserTestWithDictionary:dictionary assertionsAfterInvoke:^(NSInvocation *invocation) {
        STAssertEqualObjects(invocation.target, [UILabel appearance], @"expected target to be UILabel appearance proxy");
        STAssertEquals(invocation.selector, @selector(setShadowOffset:), nil);

        CGSize shadowOffset;
        [invocation getArgument:&shadowOffset atIndex:2];
        STAssertEquals(shadowOffset, CGSizeMake(1, 1), nil);

        STAssertEquals([[UILabel appearance] shadowOffset], CGSizeMake(1, 1), nil);
    }];
}

- (void)testButtonTitleColorForState; {
    NSDictionary *dictionary = @{@"UIButton" : @{@"titleColor:highlighted" : @"green"}};


    [self parserTestWithDictionary:dictionary assertionsAfterInvoke:^(NSInvocation *invocation) {
        STAssertEqualObjects([[UIButton appearance] titleColorForState:UIControlStateHighlighted], [UIColor greenColor], nil);
    }];
}

- (void)testSimpleContainment; {
    NSDictionary *buttonDictionary = @{@"UIButton" : @{@"titleColor:highlighted" : @"green"}};
    NSDictionary *containmentDictionary = @{@"UINavigationController" : buttonDictionary};


    [self parserTestWithDictionary:containmentDictionary assertionsAfterInvoke:^(NSInvocation *invocation) {
        UIColor *buttonColor = [[UIButton appearanceWhenContainedIn:[UINavigationController class],
                                                                    nil] titleColorForState:UIControlStateHighlighted];
        STAssertEqualObjects(buttonColor, [UIColor greenColor], nil);
    }];
}

- (void)testContainment; {
    NSDictionary *dictionary = @{@"UIButton" : @{@"titleColor:highlighted" : @"yellow"}};
    dictionary = @{@"UIImageView" : dictionary};
    dictionary = @{@"UINavigationController" : dictionary};

    [self parserTestWithDictionary:dictionary assertionsAfterInvoke:^(NSInvocation *invocation) {
        UIColor *buttonColor = [[UIButton appearanceWhenContainedIn:[UIImageView class], [UINavigationController class],
                                                                    nil] titleColorForState:UIControlStateHighlighted];
        STAssertEqualObjects(buttonColor, [UIColor yellowColor], nil);
    }];
}

#pragma mark - Helper Methods

- (void)parserTestWithDictionary:(NSDictionary *)dictionary assertionsAfterInvoke:(void (^)(NSInvocation *))assertions; {
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

- (void)setUp; {
    self.parser = [[UISSParser alloc] init];
}

- (void)tearDown; {
    self.parser = nil;
}

@end

