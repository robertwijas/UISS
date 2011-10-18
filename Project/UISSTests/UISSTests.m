//
//  UISSTests.m
//  UISSTests
//
//  Created by Robert Wijas on 10/7/11.
//  Copyright (c) 2011 57things. All rights reserved.
//

#import "UISSTests.h"
#import "UISS.h"

@implementation UISSTests

- (void)setUp
{
  [super setUp];
  
  // Set-up code here.
}

- (void)tearDown
{
  // Tear-down code here.
  
  [super tearDown];
}

- (void)testToolbarTintColor;
{
  NSString *jsonFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"simple" ofType:@"json"];
  [UISS configureWithJSONFilePath:jsonFilePath];
  STAssertEqualObjects([[UIToolbar appearance] tintColor], [UIColor yellowColor], nil);
}

- (void)testToolbarBackgroundImage;
{
  NSString *jsonFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"simple" ofType:@"json"];
  [UISS configureWithJSONFilePath:jsonFilePath];
  
  UIImage *backgroundImage = [[UIToolbar appearance] backgroundImageForToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
  
  STAssertNotNil(backgroundImage, nil);
  STAssertEqualObjects([backgroundImage class], [UIImage class], @"bad property class", nil);
}

- (void)testTabBarItemTitlePositionAdjustment;
{
  NSString *jsonFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"simple" ofType:@"json"];
  [UISS configureWithJSONFilePath:jsonFilePath];
  
  UIOffset titlePositionAdjustment = [[UITabBarItem appearance] titlePositionAdjustment];
  STAssertEquals(titlePositionAdjustment, UIOffsetMake(10, 10), nil);
}

- (void)testNavigationBarTitleVerticalPositionAdjustment;
{
  NSString *jsonFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"simple" ofType:@"json"];
  [UISS configureWithJSONFilePath:jsonFilePath];
  
  STAssertEquals([[UINavigationBar appearance] titleVerticalPositionAdjustmentForBarMetrics:UIBarMetricsDefault], 10.0f, nil);
}

- (void)testNavigationBarBackgroundImageForBarMetricsLandscapePhone;
{
  NSString *jsonFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"simple" ofType:@"json"];
  [UISS configureWithJSONFilePath:jsonFilePath];
  
  STAssertNotNil([[UINavigationBar appearance] backgroundImageForBarMetrics:UIBarMetricsLandscapePhone], nil);
}

#pragma mark - Parameters

@end
