//
//  UISSSizeValueConverterTests.m
//  UISS
//
//  Created by Robert Wijas on 5/9/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "UISSPointValueConverter.h"

@interface UISSPointValueConverterTests : SenTestCase

@property(nonatomic, strong) UISSPointValueConverter *converter;

@end

@implementation UISSPointValueConverterTests

@synthesize converter = _converter;

- (void)setUp;
{
    self.converter = [[UISSPointValueConverter alloc] init];
}

- (void)tearDown;
{
    self.converter = nil;
}

- (void)testPointAsArray;
{
    [self testValue:[NSArray arrayWithObjects:[NSNumber numberWithFloat:1], [NSNumber numberWithFloat:2], nil]
            expectedPoint:CGPointMake(1, 2) expectedCode:@"CGPointMake(1.0, 2.0)"];
}

- (void)testPointAsNumber;
{
    [self testValue:[NSNumber numberWithFloat:1] expectedPoint:CGPointMake(1, 1) expectedCode:@"CGPointMake(1.0, 1.0)"];
}

- (void)testValue:(id)value expectedPoint:(CGPoint)expectedPoint expectedCode:(NSString *)expectedCode;
{
    id converted = [self.converter convertValue:value];
    STAssertEquals([converted CGPointValue], expectedPoint, nil);

    NSString *code = [self.converter generateCodeForValue:value];
    STAssertEqualObjects(code, expectedCode, nil);
}

@end
