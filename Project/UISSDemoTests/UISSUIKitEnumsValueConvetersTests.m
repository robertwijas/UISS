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
#import "UISSSearchBarIconValueConverter.h"

@interface UISSUIKitEnumsValueConvetersTests : SenTestCase

@end

@implementation UISSUIKitEnumsValueConvetersTests

- (void)testBarMetrics;
{
    UISSBarMetricsValueConverter *converter = [[UISSBarMetricsValueConverter alloc] init];
    
    STAssertEquals([[converter convertValue:@"default"] integerValue], UIBarMetricsDefault, nil);
    STAssertEquals([[converter convertValue:@"landscapePhone"] integerValue], UIBarMetricsLandscapePhone, nil);
    
    STAssertNil([converter convertValue:@"dummy"], nil);
}

- (void)testControlState;
{
    UISSControlStateValueConveter *converter = [[UISSControlStateValueConveter alloc] init];
    
    STAssertEquals([[converter convertValue:@"normal"] unsignedIntegerValue], (UIControlState)UIControlStateNormal, nil);
    STAssertEquals([[converter convertValue:@"highlighted"] unsignedIntegerValue], (UIControlState)UIControlStateHighlighted, nil);
    STAssertEquals([[converter convertValue:@"disabled"] unsignedIntegerValue], (UIControlState)UIControlStateDisabled, nil);
    STAssertEquals([[converter convertValue:@"selected"] unsignedIntegerValue], (UIControlState)UIControlStateSelected, nil);
    STAssertEquals([[converter convertValue:@"application"] unsignedIntegerValue], (UIControlState)UIControlStateApplication, nil);
    STAssertEquals([[converter convertValue:@"reserved"] unsignedIntegerValue], (UIControlState)UIControlStateReserved, nil);
    
    STAssertNil([converter convertValue:@"dummy"], nil);
}

- (void)testSegmentedControlSegment;
{
    UISSSegmentedControlSegmentValueConverter *converter = [[UISSSegmentedControlSegmentValueConverter alloc] init];
    
    STAssertEquals([[converter convertValue:@"any"] integerValue], UISegmentedControlSegmentAny, nil);
    STAssertEquals([[converter convertValue:@"left"] integerValue], UISegmentedControlSegmentLeft, nil);
    STAssertEquals([[converter convertValue:@"center"] integerValue], UISegmentedControlSegmentCenter, nil);
    STAssertEquals([[converter convertValue:@"right"] integerValue], UISegmentedControlSegmentRight, nil);
    STAssertEquals([[converter convertValue:@"alone"] integerValue], UISegmentedControlSegmentAlone, nil);
    
    STAssertNil([converter convertValue:@"dummy"], nil);
}

- (void)testToolbarPositionCoverter;
{
    UISSToolbarPositionConverter *converter = [[UISSToolbarPositionConverter alloc] init];
    
    STAssertEquals([[converter convertValue:@"any"] integerValue], UIToolbarPositionAny, nil);
    STAssertEquals([[converter convertValue:@"bottom"] integerValue], UIToolbarPositionBottom, nil);
    STAssertEquals([[converter convertValue:@"top"] integerValue], UIToolbarPositionTop, nil);
    
    STAssertNil([converter convertValue:@"dummy"], nil);
}

- (void)testSearchBarIcon;
{
    UISSSearchBarIconValueConverter *converter = [[UISSSearchBarIconValueConverter alloc] init];
    
    STAssertEquals([[converter convertValue:@"search"] integerValue], UISearchBarIconSearch, nil);
    STAssertEquals([[converter convertValue:@"clear"] integerValue], UISearchBarIconClear, nil);
    STAssertEquals([[converter convertValue:@"bookmark"] integerValue], UISearchBarIconBookmark, nil);
    STAssertEquals([[converter convertValue:@"resultsList"] integerValue], UISearchBarIconResultsList, nil);
    
    STAssertNil([converter convertValue:@"dummy"], nil);
    
}

@end
