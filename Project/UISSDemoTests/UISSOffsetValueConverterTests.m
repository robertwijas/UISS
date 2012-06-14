//
//  UISSSizeValueConverterTests.m
//  UISS
//
//  Created by Robert Wijas on 5/9/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "UISSOffsetValueConverter.h"

@interface UISSOffsetValueConverterTests : SenTestCase

@property(nonatomic, strong) UISSOffsetValueConverter *converter;

@end

@implementation UISSOffsetValueConverterTests

@synthesize converter = _converter;

- (void)setUp;
{
    self.converter = [[UISSOffsetValueConverter alloc] init];
}

- (void)tearDown;
{
    self.converter = nil;
}

- (void)testOffsetAsArray;
{
    [self testValue:[NSArray arrayWithObjects:[NSNumber numberWithFloat:1], [NSNumber numberWithFloat:2], nil]
            expectedOffset:UIOffsetMake(1, 2) expectedCode:@"UIOffsetMake(1.0, 2.0)"];

    [self testValue:[NSArray arrayWithObjects:[NSNumber numberWithFloat:1.2], [NSNumber numberWithFloat:2.5], nil]
            expectedOffset:UIOffsetMake(1.2, 2.5) expectedCode:@"UIOffsetMake(1.2, 2.5)"];
}

- (void)testOffsetAsNumber;
{
    [self testValue:[NSNumber numberWithFloat:1] expectedOffset:UIOffsetMake(1, 1) expectedCode:@"UIOffsetMake(1.0, 1.0)"];
}

- (void)testValue:(id)value expectedOffset:(UIOffset)expectedOffset expectedCode:(NSString *)expectedCode;
{
    id converted = [self.converter convertValue:value];
    STAssertEquals([converted UIOffsetValue], expectedOffset, nil);

    NSString *code = [self.converter generateCodeForValue:value];
    STAssertEqualObjects(code, expectedCode, nil);
}

@end
