//
//  UISSColorValueConverterTests.m
//  UISS
//
//  Created by Robert Wijas on 5/8/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "UISSColorValueConverter.h"

@interface UISSColorValueConverterTests : SenTestCase

@property (nonatomic, strong) UISSColorValueConverter *converter;

@end

@implementation UISSColorValueConverterTests

@synthesize converter=_converter;

- (void)testExactColorSelector;
{
    UIColor *color = [self.converter convertPropertyValue:@"yellowColor"];
    STAssertNotNil(color, nil);
    STAssertEqualObjects(color, [UIColor yellowColor], nil);
    
    color = [self.converter convertPropertyValue:@"redColor"];
    STAssertNotNil(color, nil);
    STAssertEqualObjects(color, [UIColor redColor], nil);
    
    color = [self.converter convertPropertyValue:@"badColor"];
    STAssertNil(color, nil);
}

- (void)testSelectorWithoutColorSuffix;
{
    UIColor *color = [self.converter convertPropertyValue:@"yellow"];
    STAssertNotNil(color, nil);
    STAssertEqualObjects(color, [UIColor yellowColor], nil);
    
    color = [self.converter convertPropertyValue:@"red"];
    STAssertNotNil(color, nil);
    STAssertEqualObjects(color, [UIColor redColor], nil);
    
    color = [self.converter convertPropertyValue:@"bad"];
    STAssertNil(color, nil);
}

- (void)testHexColor;
{
    UIColor *color = [self.converter convertPropertyValue:@"#000000"];
    STAssertNotNil(color, nil);
    STAssertEqualObjects(color, [UIColor colorWithRed:0 green:0 blue:0 alpha:1], nil);
    
    color = [self.converter convertPropertyValue:@"#ff0000"];
    STAssertNotNil(color, nil);
    STAssertEqualObjects(color, [UIColor redColor], nil);
}

- (void)testRGBArray;
{
    UIColor *color = [self.converter convertPropertyValue:[NSArray arrayWithObjects:
                                                           [NSNumber numberWithInt:0],
                                                           [NSNumber numberWithInt:0],
                                                           [NSNumber numberWithInt:0],
                                                           nil]];
    
    STAssertNotNil(color, nil);
    STAssertEqualObjects(color, [UIColor colorWithRed:0 green:0 blue:0 alpha:1], nil);
    
    color = [self.converter convertPropertyValue:[NSArray arrayWithObjects:
                                                  [NSNumber numberWithInt:255],
                                                  [NSNumber numberWithInt:0],
                                                  [NSNumber numberWithInt:0],
                                                  nil]];
    
    STAssertNotNil(color, nil);
    STAssertEqualObjects(color, [UIColor redColor], nil);
}

- (void)testColorsWithAlpha;
{
    UIColor *color = [self.converter convertPropertyValue:[NSArray arrayWithObjects:
                                                  [NSNumber numberWithInt:255],
                                                  [NSNumber numberWithInt:0],
                                                  [NSNumber numberWithInt:0],
                                                  [NSNumber numberWithFloat:0.2],
                                                  nil]];
    
    STAssertNotNil(color, nil);
    STAssertEqualObjects(color, [UIColor colorWithRed:1 green:0 blue:0 alpha:0.2], nil);
    
    color = [self.converter convertPropertyValue:[NSArray arrayWithObjects:
                                                  @"yellow",
                                                  [NSNumber numberWithFloat:0.2],
                                                  nil]];
    
    STAssertNotNil(color, nil);
    STAssertEqualObjects(color, [[UIColor yellowColor] colorWithAlphaComponent:0.2], nil);
    
    color = [self.converter convertPropertyValue:[NSArray arrayWithObjects:
                                                  @"#00ff00",
                                                  [NSNumber numberWithFloat:0.2],
                                                  nil]];
    
    STAssertNotNil(color, nil);
    STAssertEqualObjects(color, [[UIColor greenColor] colorWithAlphaComponent:0.2], nil);
}

- (void)setUp;
{
    self.converter = [[UISSColorValueConverter alloc] init];
}

- (void)tearDown;
{
    self.converter = nil;
}

@end
