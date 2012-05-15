//
//  UISSSizeValueConverterTests.m
//  UISS
//
//  Created by Robert Wijas on 5/9/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "UISSRectValueConverter.h"

@interface UISSRectValueConverterTests : SenTestCase

@property (nonatomic, strong) UISSRectValueConverter *converter;

@end

@implementation UISSRectValueConverterTests

@synthesize converter=_converter;

- (void)setUp;
{
    self.converter = [[UISSRectValueConverter alloc] init];
}

- (void)tearDown;
{
    self.converter = nil;
}

- (void)testRectAsArray;
{
    id value = [self.converter convertPropertyValue:[NSArray arrayWithObjects:
                                                     [NSNumber numberWithFloat:1],
                                                     [NSNumber numberWithFloat:2],
                                                     [NSNumber numberWithFloat:3],
                                                     [NSNumber numberWithFloat:4],
                                                     nil]];
    
    STAssertEquals(CGRectMake(1, 2, 3, 4), [value CGRectValue], nil);
}

@end
