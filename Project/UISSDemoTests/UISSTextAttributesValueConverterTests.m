//
//  UISSTextAttributesValueConverterTests.m
//  UISS
//
//  Created by Robert Wijas on 5/16/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "UISSTextAttributesValueConverter.h"

@interface UISSTextAttributesValueConverterTests : SenTestCase

@property(nonatomic, strong) UISSTextAttributesValueConverter *converter;

@end

@implementation UISSTextAttributesValueConverterTests

@synthesize converter;

- (void)testTextAttributesWithFont;
{
    [self testValue:[NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:14] forKey:@"font"]
            expectedCode:[NSString stringWithFormat:@"[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14.0], UITextAttributeFont, nil]"]
            assertBlock:^(NSDictionary *attributes) {
                UIFont *font = [attributes objectForKey:UITextAttributeFont];
                STAssertEqualObjects(font, [UIFont systemFontOfSize:14], nil);
            }];
}

- (void)testTextAttributesWithTextColor;
{
    [self testValue:[NSDictionary dictionaryWithObject:@"orange" forKey:@"textColor"]
            expectedCode:[NSString stringWithFormat:@"[NSDictionary dictionaryWithObjectsAndKeys:[UIColor orangeColor], UITextAttributeTextColor, nil]"]
            assertBlock:^(NSDictionary *attributes) {
                UIColor *color = [attributes objectForKey:UITextAttributeTextColor];
                STAssertEqualObjects(color, [UIColor orangeColor], nil);
            }];
}

- (void)testTextAttributesWithTextShadowColor;
{
    [self testValue:[NSDictionary dictionaryWithObject:@"gray" forKey:@"textShadowColor"]
            expectedCode:[NSString stringWithFormat:@"[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor], UITextAttributeTextShadowColor, nil]"]
            assertBlock:^(NSDictionary *attributes) {
                UIColor *color = [attributes objectForKey:UITextAttributeTextShadowColor];
                STAssertEqualObjects(color, [UIColor grayColor], nil);
            }];
}

- (void)testTextAttributesWithTextShadowOffset;
{
    [self testValue:[NSDictionary dictionaryWithObject:[NSArray arrayWithObjects: [NSNumber numberWithFloat:2], nil] forKey:@"textShadowOffset"]
            expectedCode:[NSString stringWithFormat:@"[NSDictionary dictionaryWithObjectsAndKeys:[NSValue valueWithUIOffset:UIOffsetMake(2.0, 2.0)], UITextAttributeTextShadowOffset, nil]"]
            assertBlock:^(NSDictionary *attributes) {
                STAssertNotNil([attributes objectForKey:UITextAttributeTextShadowOffset], nil);
                UIOffset offset = [[attributes objectForKey:UITextAttributeTextShadowOffset] UIOffsetValue];
                STAssertEquals(offset, UIOffsetMake(2, 2), nil);
            }];
}

- (void)testValue:(id)value expectedCode:(NSString *)expectedCode assertBlock:(void (^)(NSDictionary *))assertBlock;
{
    NSDictionary *attributes = [self.converter convertPropertyValue:value];
    STAssertNotNil(attributes, nil);
    assertBlock(attributes);

    NSString *code = [self.converter generateCodeForPropertyValue:value];
    STAssertEqualObjects(code, expectedCode, nil);
}

- (void)setUp;
{
    self.converter = [[UISSTextAttributesValueConverter alloc] init];
}

- (void)tearDown;
{
    self.converter = nil;
}

@end
