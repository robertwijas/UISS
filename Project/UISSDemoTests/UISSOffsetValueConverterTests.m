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

@property (nonatomic, strong) UISSOffsetValueConverter *converter;

@end

@implementation UISSOffsetValueConverterTests

@synthesize converter=_converter;

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
    id value = [self.converter convertPropertyValue:[NSArray arrayWithObjects:
                                                     [NSNumber numberWithFloat:1],
                                                     [NSNumber numberWithFloat:2],
                                                     nil]];
    
    STAssertEquals(UIOffsetMake(1, 2), [value UIOffsetValue], nil);
}

- (void)testOffsetAsNumber;
{
    id value = [self.converter convertPropertyValue:[NSNumber numberWithFloat:1]];    
    STAssertEquals(UIOffsetMake(1, 1), [value UIOffsetValue], nil);
}

@end
