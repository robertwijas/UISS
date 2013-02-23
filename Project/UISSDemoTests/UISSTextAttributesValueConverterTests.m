//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "UISSTextAttributesValueConverter.h"

@interface UISSTextAttributesValueConverterTests : SenTestCase

@property(nonatomic, strong) UISSTextAttributesValueConverter *converter;

@end

@implementation UISSTextAttributesValueConverterTests

- (void)testTextAttributesWithFont; {
    [self testValue:@{@"font" : @14.0f}
       expectedCode:[NSString stringWithFormat:@"[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14.0], UITextAttributeFont, nil]"]
        assertBlock:^(NSDictionary *attributes) {
            UIFont *font = attributes[UITextAttributeFont];
            STAssertEqualObjects(font, [UIFont systemFontOfSize:14], nil);
        }];
}

- (void)testTextAttributesWithTextColor; {
    [self testValue:@{@"textColor" : @"orange"}
       expectedCode:[NSString stringWithFormat:@"[NSDictionary dictionaryWithObjectsAndKeys:[UIColor orangeColor], UITextAttributeTextColor, nil]"]
        assertBlock:^(NSDictionary *attributes) {
            UIColor *color = attributes[UITextAttributeTextColor];
            STAssertEqualObjects(color, [UIColor orangeColor], nil);
        }];
}

- (void)testTextAttributesWithTextShadowColor; {
    [self testValue:@{@"textShadowColor" : @"gray"}
       expectedCode:[NSString stringWithFormat:@"[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor], UITextAttributeTextShadowColor, nil]"]
        assertBlock:^(NSDictionary *attributes) {
            UIColor *color = attributes[UITextAttributeTextShadowColor];
            STAssertEqualObjects(color, [UIColor grayColor], nil);
        }];
}

- (void)testTextAttributesWithTextShadowOffset; {
    [self testValue:@{@"textShadowOffset" : @[@2.0f]}
       expectedCode:[NSString stringWithFormat:@"[NSDictionary dictionaryWithObjectsAndKeys:[NSValue valueWithUIOffset:UIOffsetMake(2.0, 2.0)], UITextAttributeTextShadowOffset, nil]"]
        assertBlock:^(NSDictionary *attributes) {
            STAssertNotNil(attributes[UITextAttributeTextShadowOffset], nil);
            UIOffset offset = [attributes[UITextAttributeTextShadowOffset] UIOffsetValue];
            STAssertEquals(offset, UIOffsetMake(2, 2), nil);
        }];
}

- (void)testValue:(id)value expectedCode:(NSString *)expectedCode assertBlock:(void (^)(NSDictionary *))assertBlock; {
    NSDictionary *attributes = [self.converter convertValue:value];
    STAssertNotNil(attributes, nil);
    assertBlock(attributes);

    NSString *code = [self.converter generateCodeForValue:value];
    STAssertEqualObjects(code, expectedCode, nil);
}

- (void)setUp; {
    self.converter = [[UISSTextAttributesValueConverter alloc] init];
}

- (void)tearDown; {
    self.converter = nil;
}

@end
