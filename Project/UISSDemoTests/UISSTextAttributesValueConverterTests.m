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

@property (nonatomic, strong) UISSTextAttributesValueConverter *converter;

@end

@implementation UISSTextAttributesValueConverterTests

@synthesize converter;

- (void)testTextAttributesWithFont;
{
    NSDictionary *attributes = [self.converter convertPropertyValue:
                                [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:14] 
                                                            forKey:@"font"]];
    
    STAssertNotNil(attributes, nil);
    UIFont *font = [attributes objectForKey:UITextAttributeFont];
    STAssertEqualObjects(font, [UIFont systemFontOfSize:14], nil);
}

- (void)testTextAttributesWithTextColor;
{
    NSDictionary *attributes = [self.converter convertPropertyValue:
                                [NSDictionary dictionaryWithObject:@"orange"
                                                            forKey:@"textColor"]];
    
    STAssertNotNil(attributes, nil);
    UIColor *color = [attributes objectForKey:UITextAttributeTextColor];
    STAssertEqualObjects(color, [UIColor orangeColor], nil);
}

- (void)testTextAttributesWithTextShadowColor;
{
    NSDictionary *attributes = [self.converter convertPropertyValue:
                                [NSDictionary dictionaryWithObject:@"gray"
                                                            forKey:@"textShadowColor"]];
    
    STAssertNotNil(attributes, nil);
    UIColor *color = [attributes objectForKey:UITextAttributeTextShadowColor];
    STAssertEqualObjects(color, [UIColor grayColor], nil);
}

- (void)testTextAttributesWithTextShadowOffset;
{
    NSDictionary *attributes = [self.converter convertPropertyValue:
                                [NSDictionary dictionaryWithObject:[NSArray arrayWithObjects:
                                                                    [NSNumber numberWithFloat:2], nil]
                                                            forKey:@"textShadowOffset"]];
    
    STAssertNotNil(attributes, nil);
    STAssertNotNil([attributes objectForKey:UITextAttributeTextShadowOffset], nil);
    UIOffset offset = [[attributes objectForKey:UITextAttributeTextShadowOffset] UIOffsetValue];
    STAssertEquals(offset, UIOffsetMake(2, 2), nil);
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
