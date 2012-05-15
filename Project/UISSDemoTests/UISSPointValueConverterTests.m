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

@property (nonatomic, strong) UISSPointValueConverter *converter;

@end

@implementation UISSPointValueConverterTests

@synthesize converter=_converter;

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
    id value = [self.converter convertPropertyValue:[NSArray arrayWithObjects:
                                                     [NSNumber numberWithFloat:1],
                                                     [NSNumber numberWithFloat:2],
                                                     nil]];
    
    STAssertEquals(CGPointMake(1, 2), [value CGPointValue], nil);
}

- (void)testPointAsNumber;
{
    id value = [self.converter convertPropertyValue:[NSNumber numberWithFloat:1]];    
    STAssertEquals(CGPointMake(1, 1), [value CGPointValue], nil);
}

@end
