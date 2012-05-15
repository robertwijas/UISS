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

@property (nonatomic, strong) UISSSizeValueConverter *converter;

@end

@implementation UISSSizeValueConverterTests

@synthesize converter=_converter;

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
    id value = [self.converter convertPropertyValue:[NSArray arrayWithObjects:
                                                     [NSNumber numberWithFloat:1],
                                                     [NSNumber numberWithFloat:2],
                                                     nil]];
    
    STAssertEquals(CGSizeMake(1, 2), [value CGSizeValue], nil);
}

- (void)testSizeAsNumber;
{
    id value = [self.converter convertPropertyValue:[NSNumber numberWithFloat:1]];    
    STAssertEquals(CGSizeMake(1, 1), [value CGSizeValue], nil);
}

@end
