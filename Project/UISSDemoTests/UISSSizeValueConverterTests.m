//
//  UISSSizeValueConverterTests.m
//  UISS
//
//  Created by Robert Wijas on 5/9/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "UISSSizeValueConverter.h"

@interface UISSSizeValueConverterTests : SenTestCase

@property(nonatomic, strong) UISSSizeValueConverter *converter;

@end

@implementation UISSSizeValueConverterTests

@synthesize converter = _converter;

- (void)setUp;
{
    self.converter = [[UISSSizeValueConverter alloc] init];
}

- (void)tearDown;
{
    self.converter = nil;
}

- (void)testSizeAsArray;
{
    [self testValue:[NSArray arrayWithObjects:[NSNumber numberWithFloat:1], [NSNumber numberWithFloat:2], nil]
            expectedSize:CGSizeMake(1, 2) expectedCode:@"CGSizeMake(1.0, 2.0)"];
}

- (void)testSizeAsNumber;
{
    [self testValue:[NSNumber numberWithFloat:1]
            expectedSize:CGSizeMake(1, 1) expectedCode:@"CGSizeMake(1.0, 1.0)"];
}

- (void)testValue:(id)value expectedSize:(CGSize)expectedSize expectedCode:(NSString *)expectedCode;
{
    id converted = [self.converter convertPropertyValue:value];
    STAssertEquals([converted CGSizeValue], expectedSize, nil);

    NSString *code = [self.converter generateCodeForPropertyValue:value];
    STAssertEqualObjects(code, expectedCode, nil);
}

@end
