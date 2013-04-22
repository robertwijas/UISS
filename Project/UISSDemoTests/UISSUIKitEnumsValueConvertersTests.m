//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "UISSBarMetricsValueConverter.h"
#import "UISSControlStateValueConverter.h"
#import "UISSSegmentedControlSegmentValueConverter.h"
#import "UISSToolbarPositionValueConverter.h"
#import "UISSSearchBarIconValueConverter.h"
#import "UISSTextAlignmentValueConverter.h"
#import "UISSImageResizingModeValueConverter.h"

@interface UISSUIKitEnumsValueConvertersTests : SenTestCase

@end

@implementation UISSUIKitEnumsValueConvertersTests

- (void)testBarMetrics {
    UISSBarMetricsValueConverter *converter = [[UISSBarMetricsValueConverter alloc] init];

    STAssertEquals([[converter convertValue:@"default"] integerValue], UIBarMetricsDefault, nil);
    STAssertEquals([[converter convertValue:@"landscapePhone"] integerValue], UIBarMetricsLandscapePhone, nil);

    STAssertNil([converter convertValue:@"dummy"], nil);
}

- (void)testResizingMode {
    UISSImageResizingModeValueConverter *converter = [[UISSImageResizingModeValueConverter alloc] init];

    STAssertEquals([[converter convertValue:@"stretch"] integerValue], UIImageResizingModeStretch, nil);
    STAssertEquals([[converter convertValue:@"tile"] integerValue], UIImageResizingModeTile, nil);

    STAssertNil([converter convertValue:@"dummy"], nil);
}

- (void)testSearchBarIcon {
    UISSSearchBarIconValueConverter *converter = [[UISSSearchBarIconValueConverter alloc] init];

    STAssertEquals([[converter convertValue:@"search"] integerValue], UISearchBarIconSearch, nil);
    STAssertEquals([[converter convertValue:@"clear"] integerValue], UISearchBarIconClear, nil);
    STAssertEquals([[converter convertValue:@"bookmark"] integerValue], UISearchBarIconBookmark, nil);
    STAssertEquals([[converter convertValue:@"resultsList"] integerValue], UISearchBarIconResultsList, nil);

    STAssertNil([converter convertValue:@"dummy"], nil);
}

- (void)testSegmentedControlSegment {
    UISSSegmentedControlSegmentValueConverter *converter = [[UISSSegmentedControlSegmentValueConverter alloc] init];

    STAssertEquals([[converter convertValue:@"any"] integerValue], UISegmentedControlSegmentAny, nil);
    STAssertEquals([[converter convertValue:@"left"] integerValue], UISegmentedControlSegmentLeft, nil);
    STAssertEquals([[converter convertValue:@"center"] integerValue], UISegmentedControlSegmentCenter, nil);
    STAssertEquals([[converter convertValue:@"right"] integerValue], UISegmentedControlSegmentRight, nil);
    STAssertEquals([[converter convertValue:@"alone"] integerValue], UISegmentedControlSegmentAlone, nil);

    STAssertNil([converter convertValue:@"dummy"], nil);
}

- (void)testTextAlignment {
    UISSTextAlignmentValueConverter *converter = [[UISSTextAlignmentValueConverter alloc] init];

    STAssertEquals([[converter convertValue:@"center"] integerValue], NSTextAlignmentCenter, nil);
    STAssertEquals([[converter convertValue:@"justified"] integerValue], NSTextAlignmentJustified, nil);
    STAssertEquals([[converter convertValue:@"left"] integerValue], NSTextAlignmentLeft, nil);
    STAssertEquals([[converter convertValue:@"natural"] integerValue], NSTextAlignmentNatural, nil);
    STAssertEquals([[converter convertValue:@"right"] integerValue], NSTextAlignmentRight, nil);

    STAssertNil([converter convertValue:@"dummy"], nil);
}

- (void)testToolbarPosition {
    UISSToolbarPositionValueConverter *converter = [[UISSToolbarPositionValueConverter alloc] init];

    STAssertEquals([[converter convertValue:@"any"] integerValue], UIToolbarPositionAny, nil);
    STAssertEquals([[converter convertValue:@"bottom"] integerValue], UIToolbarPositionBottom, nil);
    STAssertEquals([[converter convertValue:@"top"] integerValue], UIToolbarPositionTop, nil);

    STAssertNil([converter convertValue:@"dummy"], nil);
}

@end
