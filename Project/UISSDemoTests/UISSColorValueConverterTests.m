//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "UISSColorValueConverter.h"
#import "UIColor+UISS.h"

@interface UISSColorValueConverterTests : SenTestCase

@property(nonatomic, strong) UISSColorValueConverter *converter;

@end

@implementation UISSColorValueConverterTests

- (void)testNull {
    UIColor *color = [self.converter convertValue:[NSNull null]];
    STAssertNil(color, nil);

    NSString *code = [self.converter generateCodeForValue:[NSNull null]];
    STAssertEqualObjects(code, @"nil", nil);
}

- (void)testExactColorSelector {
    [self testColorValue:@"yellowColor" expectedColor:[UIColor yellowColor] expectedCode:@"[UIColor yellowColor]"];
    [self testColorValue:@"redColor" expectedColor:[UIColor redColor] expectedCode:@"[UIColor redColor]"];
    [self testColorValue:@"badColor" expectedColor:nil expectedCode:nil];
}

- (void)testCustomFactorySelector {
    [self testColorValue:@"uissDemoColor" expectedColor:[UIColor uissDemoColor] expectedCode:@"[UIColor uissDemoColor]"];
    [self testColorValue:@"uissDemo" expectedColor:[UIColor uissDemoColor] expectedCode:@"[UIColor uissDemoColor]"];
}

- (void)testSelectorWithoutColorSuffix {
    [self testColorValue:@"yellow" expectedColor:[UIColor yellowColor] expectedCode:@"[UIColor yellowColor]"];
    [self testColorValue:@"red" expectedColor:[UIColor redColor] expectedCode:@"[UIColor redColor]"];
    [self testColorValue:@"bad" expectedColor:nil expectedCode:nil];
}

- (void)testHexColor {
    [self testColorValue:@"#000000"
           expectedColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]
            expectedCode:@"[UIColor colorWithRed:0.000 green:0.000 blue:0.000 alpha:1.000]"];

    [self testColorValue:@"#ff0000"
           expectedColor:[UIColor redColor]
            expectedCode:@"[UIColor colorWithRed:1.000 green:0.000 blue:0.000 alpha:1.000]"];
}

- (void)testRGBArrayWith255ColorSpace {
    [self testColorValue:@[@0, @0, @0]
           expectedColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]
            expectedCode:@"[UIColor colorWithRed:0.000 green:0.000 blue:0.000 alpha:1.000]"];

    [self testColorValue:@[@255, @0, @0]
           expectedColor:[UIColor redColor]
            expectedCode:@"[UIColor colorWithRed:1.000 green:0.000 blue:0.000 alpha:1.000]"];

    [self testColorValue:@[@1, @2, @3]
           expectedColor:[UIColor colorWithRed:1/255.0f green:2/255.0f blue:3/255.0f alpha:1]
            expectedCode:@"[UIColor colorWithRed:0.004 green:0.008 blue:0.012 alpha:1.000]"];
}

- (void)testRGBArrayWithPercentValues {
    [self testColorValue:@[@0.42, @0.42, @0.42]
           expectedColor:[UIColor colorWithRed:0.42 green:0.42 blue:0.42 alpha:1]
            expectedCode:@"[UIColor colorWithRed:0.420 green:0.420 blue:0.420 alpha:1.000]"];

    [self testColorValue:@[@1, @1, @1]
           expectedColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]
            expectedCode:@"[UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:1.000]"];
}

- (void)testColorsWithAlpha {
    [self testColorValue:@[@255, @0, @0, @0.2f]
           expectedColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:0.2]
            expectedCode:@"[UIColor colorWithRed:1.000 green:0.000 blue:0.000 alpha:0.200]"];

    [self testColorValue:@[@"yellow", @0.2f] expectedColor:[[UIColor yellowColor] colorWithAlphaComponent:0.2]
            expectedCode:@"[[UIColor yellowColor] colorWithAlphaComponent:0.200]"];

    [self testColorValue:@[@"#00ff00", @0.2f] expectedColor:[[UIColor greenColor] colorWithAlphaComponent:0.2]
            expectedCode:@"[[UIColor colorWithRed:0.000 green:1.000 blue:0.000 alpha:1.000] colorWithAlphaComponent:0.200]"];
}

- (void)testColorWithPatternImage {
    [self testColorValue:@"background"
           expectedColor:(id) [NSNull null]
            expectedCode:@"[UIColor colorWithPatternImage:[UIImage imageNamed:@\"background\"]]"];

    [self testColorValue:@"fakeImage"
           expectedColor:nil expectedCode:nil];
}

- (void)testColorValue:(id)value expectedColor:(UIColor *)expectedColor expectedCode:(NSString *)expectedCode {
    UIColor *color = [self.converter convertValue:value];
    NSString *code = [self.converter generateCodeForValue:value];

    if (expectedColor != nil) {
        STAssertNotNil(color, nil);
    }

    if ([expectedColor isKindOfClass:[NSNull class]] == NO) {
        STAssertEqualObjects(color, expectedColor, nil);
    }
    STAssertEqualObjects(code, expectedCode, nil);
}

- (void)setUp {
    self.converter = [[UISSColorValueConverter alloc] init];
}

- (void)tearDown {
    self.converter = nil;
}

@end
