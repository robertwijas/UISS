//
//  UISSSizeValueConverterTests.m
//  UISS
//
//  Created by Robert Wijas on 5/9/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "UISSFloatValueConverter.h"

@interface UISSFloatValueConverterTests : SenTestCase

@property(nonatomic, strong) UISSFloatValueConverter *converter;

@end

@implementation UISSFloatValueConverterTests

- (void)setUp; {
    self.converter = [[UISSFloatValueConverter alloc] init];
    self.converter.precision = 4;
}

- (void)tearDown; {
    self.converter = nil;
}

- (void)testConversionFromNumber; {
    id value = [self.converter convertValue:@0.5f];
    STAssertTrue([value isKindOfClass:[NSValue class]], nil);

    CGFloat floatValue = 0;
    [value getValue:&floatValue];

    STAssertEquals(floatValue, 0.5f, nil);
}

- (void)testGeneratedCodeFromString; {
    STAssertEqualObjects([self.converter generateCodeForValue:@"1.123"], @"1.1230", nil);
}

- (void)testGeneratedCodeFromNumber; {
    STAssertEqualObjects([self.converter generateCodeForValue:[NSNumber numberWithFloat:1.123]], @"1.1230", nil);
}

@end
