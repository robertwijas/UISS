//
//  UISSImageValueConverterTests.m
//  UISS
//
//  Created by Robert Wijas on 5/16/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "UISSImageValueConverter.h"

@interface UISSImageValueConverterTests : SenTestCase

@property (nonatomic, strong) UISSImageValueConverter *converter;

@end

@implementation UISSImageValueConverterTests

@synthesize converter;

- (void)testSimleImageAsString;
{
    UIImage *image = [self.converter convertPropertyValue:@"background"];
    
    STAssertNotNil(image, nil);
    STAssertEqualObjects(image, [UIImage imageNamed:@"background"], nil);
    
}

- (void)testResizableWithEdgeInsetsDefinedInSubarray;
{
    UIImage *image = [self.converter convertPropertyValue:[NSArray arrayWithObjects:
                                                  @"background",
                                                  [NSArray arrayWithObjects:
                                                   [NSNumber numberWithFloat:1],
                                                   [NSNumber numberWithFloat:2],
                                                   [NSNumber numberWithFloat:3],
                                                   [NSNumber numberWithFloat:4],
                                                   nil],
                                                  nil]];
    
    STAssertNotNil(image, nil);
    STAssertEquals(image.capInsets, UIEdgeInsetsMake(1, 2, 3, 4), nil);
}

- (void)testResizableDefinedInOneArray;
{
    UIImage *image = [self.converter convertPropertyValue:[NSArray arrayWithObjects:
                                                  @"background",
                                                  [NSNumber numberWithFloat:1],
                                                  [NSNumber numberWithFloat:2],
                                                  [NSNumber numberWithFloat:3],
                                                  [NSNumber numberWithFloat:4],
                                                  nil]];
    
    STAssertNotNil(image, nil);
    STAssertEquals(image.capInsets, UIEdgeInsetsMake(1, 2, 3, 4), nil);
}

- (void)setUp;
{
    self.converter = [[UISSImageValueConverter alloc] init];
}

- (void)tearDown;
{
    self.converter = nil;
}

@end
