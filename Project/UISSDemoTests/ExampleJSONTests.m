//
//  UISSJSONTests.m
//  UISS
//
//  Created by Robert Wijas on 10/20/11.
//  Copyright (c) 2011 57things. All rights reserved.
//

#import "ExampleJSONTests.h"
#import "UISS.h"

@implementation ExampleJSONTests

- (void)configureOnce;
{
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    NSString *jsonFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"example" ofType:@"json"];
    [UISS configureWithJSONFilePath:jsonFilePath];
  });
}

- (void)setUp
{
  [super setUp];

  [self configureOnce];
}

- (void)testToolbarTintColor;
{
  STAssertEqualObjects([[UIToolbar appearance] tintColor], [UIColor yellowColor], nil);
}

- (void)_testToolbarBackgroundImage;
{
  UIImage *backgroundImage = [[UIToolbar appearance] backgroundImageForToolbarPosition:UIToolbarPositionAny 
                                                                            barMetrics:UIBarMetricsDefault];
  STAssertNotNil(backgroundImage, nil);
  STAssertEqualObjects([backgroundImage class], [UIImage class], @"bad property class", nil);
}

- (void)_testTabBarItemTitlePositionAdjustment;
{
  UIOffset titlePositionAdjustment = [[UITabBarItem appearance] titlePositionAdjustment];
  STAssertEquals(titlePositionAdjustment, UIOffsetMake(10, 10), nil);
}

- (void)_testNavigationBarTitleVerticalPositionAdjustment;
{
  STAssertEquals([[UINavigationBar appearance] titleVerticalPositionAdjustmentForBarMetrics:UIBarMetricsDefault], 10.0f, nil);
}

- (void)_testNavigationBarBackgroundImageForBarMetricsLandscapePhone;
{
  STAssertNotNil([[UINavigationBar appearance] backgroundImageForBarMetrics:UIBarMetricsLandscapePhone], nil);
}

- (void)_testTabBarItemTitleTextAttributes;
{
  UIFont *font = [[[UITabBarItem appearance] titleTextAttributesForState:UIControlStateNormal] objectForKey:UITextAttributeFont];
  STAssertNotNil(font, nil);
  if (font) {
    STAssertEqualObjects(font, [UIFont systemFontOfSize:24], nil);
  }
}

@end
