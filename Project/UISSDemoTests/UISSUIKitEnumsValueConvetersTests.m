//
//  UISSUIKitEnumsValueConvetersTests.m
//  UISS
//
//  Created by Robert Wijas on 5/16/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "UISSBarMetricsValueConverter.h"
#import "UISSControlStateValueConveter.h"
#import "UISSSegmentedControlSegmentValueConverter.h"
#import "UISSToolbarPositionConverter.h"

@interface UISSUIKitEnumsValueConvetersTests : SenTestCase

@end

@implementation UISSUIKitEnumsValueConvetersTests

- (void)testBarMetrics;
{
    UISSBarMetricsValueConverter *converter = [[UISSBarMetricsValueConverter alloc] init];
    
    STAssertEquals([[converter convertAxisParameter:@"default"] integerValue], UIBarMetricsDefault, nil);
    STAssertEquals([[converter convertAxisParameter:@"landscapePhone"] integerValue], UIBarMetricsLandscapePhone, nil);
    
    STAssertNil([converter convertAxisParameter:@"dummy"], nil);
}

- (void)testControlState;
{
    UISSControlStateValueConveter *converter = [[UISSControlStateValueConveter alloc] init];
    
    STAssertEquals([[converter convertAxisParameter:@"normal"] unsignedIntegerValue], (UIControlState)UIControlStateNormal, nil);
    STAssertEquals([[converter convertAxisParameter:@"highlighted"] unsignedIntegerValue], (UIControlState)UIControlStateHighlighted, nil);
    STAssertEquals([[converter convertAxisParameter:@"disabled"] unsignedIntegerValue], (UIControlState)UIControlStateDisabled, nil);
    STAssertEquals([[converter convertAxisParameter:@"selected"] unsignedIntegerValue], (UIControlState)UIControlStateSelected, nil);
    STAssertEquals([[converter convertAxisParameter:@"application"] unsignedIntegerValue], (UIControlState)UIControlStateApplication, nil);
    STAssertEquals([[converter convertAxisParameter:@"reserved"] unsignedIntegerValue], (UIControlState)UIControlStateReserved, nil);
    
    STAssertNil([converter convertAxisParameter:@"dummy"], nil);
}

- (void)testSegmentedControlSegment;
{
    UISSSegmentedControlSegmentValueConverter *converter = [[UISSSegmentedControlSegmentValueConverter alloc] init];
    
    STAssertEquals([[converter convertAxisParameter:@"any"] integerValue], UISegmentedControlSegmentAny, nil);
    STAssertEquals([[converter convertAxisParameter:@"left"] integerValue], UISegmentedControlSegmentLeft, nil);
    STAssertEquals([[converter convertAxisParameter:@"center"] integerValue], UISegmentedControlSegmentCenter, nil);
    STAssertEquals([[converter convertAxisParameter:@"right"] integerValue], UISegmentedControlSegmentRight, nil);
    STAssertEquals([[converter convertAxisParameter:@"alone"] integerValue], UISegmentedControlSegmentAlone, nil);
    
    STAssertNil([converter convertAxisParameter:@"dummy"], nil);
}

- (void)testToolbarPositionCoverter;
{
    UISSToolbarPositionConverter *converter = [[UISSToolbarPositionConverter alloc] init];
    
    STAssertEquals([[converter convertAxisParameter:@"any"] integerValue], UIToolbarPositionAny, nil);
    STAssertEquals([[converter convertAxisParameter:@"bottom"] integerValue], UIToolbarPositionBottom, nil);
    STAssertEquals([[converter convertAxisParameter:@"top"] integerValue], UIToolbarPositionTop, nil);
    
    STAssertNil([converter convertAxisParameter:@"dummy"], nil);
}

@end
