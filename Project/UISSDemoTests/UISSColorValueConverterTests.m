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

@property(nonatomic, strong) UISSColorValueConverter *converter;

@end

@implementation UISSColorValueConverterTests

@synthesize converter = _converter;

- (void)testExactColorSelector;
{
    [self testColorValue:@"yellowColor" expectedColor:[UIColor yellowColor] expectedCode:@"[UIColor yellowColor]"];
    [self testColorValue:@"redColor" expectedColor:[UIColor redColor] expectedCode:@"[UIColor redColor]"];
    [self testColorValue:@"badColor" expectedColor:nil expectedCode:nil];
}

- (void)testSelectorWithoutColorSuffix;
{
    [self testColorValue:@"yellow" expectedColor:[UIColor yellowColor] expectedCode:@"[UIColor yellowColor]"];
    [self testColorValue:@"red" expectedColor:[UIColor redColor] expectedCode:@"[UIColor redColor]"];
    [self testColorValue:@"bad" expectedColor:nil expectedCode:nil];
}

- (void)testHexColor;
{
    [self testColorValue:@"#000000"
           expectedColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]
            expectedCode:@"[UIColor colorWithRed:0.000 green:0.000 blue:0.000 alpha:1.000]"];

    [self testColorValue:@"#ff0000"
           expectedColor:[UIColor redColor]
            expectedCode:@"[UIColor colorWithRed:1.000 green:0.000 blue:0.000 alpha:1.000]"];
}

- (void)testRGBArray;
{
    [self testColorValue:[NSArray arrayWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:0], [NSNumber numberWithInt:0], nil]
            expectedColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]
            expectedCode:@"[UIColor colorWithRed:0.000 green:0.000 blue:0.000 alpha:1.000]"];

    [self testColorValue:[NSArray arrayWithObjects:[NSNumber numberWithInt:255], [NSNumber numberWithInt:0], [NSNumber numberWithInt:0], nil]
            expectedColor:[UIColor redColor]
            expectedCode:@"[UIColor colorWithRed:1.000 green:0.000 blue:0.000 alpha:1.000]"];
}

- (void)testColorsWithAlpha;
{
    [self testColorValue:[NSArray arrayWithObjects:[NSNumber numberWithInt:255], [NSNumber numberWithInt:0], [NSNumber numberWithInt:0], [NSNumber numberWithFloat:0.2], nil]
            expectedColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:0.2]
            expectedCode:@"[UIColor colorWithRed:1.000 green:0.000 blue:0.000 alpha:0.200]"];

    [self testColorValue:[NSArray arrayWithObjects:@"yellow", [NSNumber numberWithFloat:0.2],nil]
            expectedColor:[[UIColor yellowColor] colorWithAlphaComponent:0.2]
            expectedCode:@"[[UIColor yellowColor] colorWithAlphaComponent:0.200]"];

    [self testColorValue:[NSArray arrayWithObjects:@"#00ff00", [NSNumber numberWithFloat:0.2],nil]
            expectedColor:[[UIColor greenColor] colorWithAlphaComponent:0.2]
            expectedCode:@"[[UIColor colorWithRed:0.000 green:1.000 blue:0.000 alpha:1.000] colorWithAlphaComponent:0.200]"];
}

- (void)testColorWithPatternImage;
{
    [self testColorValue:@"background"
            expectedColor:(id)[NSNull null]
            expectedCode:@"[UIColor colorWithPatternImage:[UIImage imageNamed:@\"background\"]]"];

    [self testColorValue:@"fakeImage"
            expectedColor:nil
            expectedCode:nil];
}

- (void)testColorValue:(id)value expectedColor:(UIColor *)expectedColor expectedCode:(NSString *)expectedCode;
{
    UIColor *color = [self.converter convertPropertyValue:value];
    NSString *code = [self.converter generateCodeForPropertyValue:value];

    if (expectedColor != nil) {
        STAssertNotNil(color, nil);
    }

    if ([expectedColor isKindOfClass:[NSNull class]] == NO) {
        STAssertEqualObjects(color, expectedColor, nil);
    }
    STAssertEqualObjects(code, expectedCode, nil);
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
