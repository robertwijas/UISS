//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import "UISS.h"
#import <SenTestingKit/SenTestingKit.h>

@interface ExampleJSONTests : SenTestCase

@property(nonatomic, strong) UISS *uiss;

@end

@implementation ExampleJSONTests

- (void)setUp {
    [super setUp];

    NSString *jsonFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"example" ofType:@"json"];
    self.uiss = [UISS configureWithJSONFilePath:jsonFilePath];
}

- (void)testGeneratedCodeForPad; {
    [self.uiss generateCodeForUserInterfaceIdiom:UIUserInterfaceIdiomPad
                                     codeHandler:^(NSString *code, NSArray *errors) {
                                         STAssertTrue(errors.count == 0, @"errors are unexpected");
                                         STAssertNotNil(code, nil);
                                         STAssertTrue([code rangeOfString:@"[[UINavigationBar appearance] setTintColor:[UIColor greenColor]];"].location != NSNotFound, nil);
                                     }];
}

- (void)testGeneratedCodeForPhone; {
    [self.uiss generateCodeForUserInterfaceIdiom:UIUserInterfaceIdiomPhone
                                     codeHandler:^(NSString *code, NSArray *errors) {
                                         STAssertTrue(errors.count == 0, @"errors are unexpected");
                                         STAssertNotNil(code, nil);
                                         STAssertTrue([code rangeOfString:@"[[UINavigationBar appearance] setTintColor:[UIColor redColor]];"].location != NSNotFound, nil);
                                     }];
}

- (void)testToolbarTintColor; {
    STAssertEqualObjects([[UIToolbar appearance] tintColor], [UIColor yellowColor], nil);
}

- (void)testToolbarBackgroundImage; {
    UIImage *backgroundImage = [[UIToolbar appearance] backgroundImageForToolbarPosition:UIToolbarPositionAny
                                                                              barMetrics:UIBarMetricsDefault];
    STAssertNotNil(backgroundImage, nil);
    STAssertEqualObjects([backgroundImage class], [UIImage class], @"bad property class", nil);
}

- (void)testTabBarItemTitlePositionAdjustment; {
    UIOffset titlePositionAdjustment = [[UITabBarItem appearance] titlePositionAdjustment];
    STAssertEquals(titlePositionAdjustment, UIOffsetMake(10, 10), nil);
}

- (void)testNavigationBarTitleVerticalPositionAdjustment; {
    STAssertEquals([[UINavigationBar appearance] titleVerticalPositionAdjustmentForBarMetrics:UIBarMetricsDefault], 10.0f, nil);
}

- (void)testNavigationBarBackgroundImageForBarMetricsLandscapePhone; {
    STAssertNotNil([[UINavigationBar appearance] backgroundImageForBarMetrics:UIBarMetricsLandscapePhone], nil);
}

- (void)testTabBarItemTitleTextAttributes; {
    UIFont *font = [[UITabBarItem appearance] titleTextAttributesForState:UIControlStateNormal][UITextAttributeFont];
    STAssertNotNil(font, nil);
    if (font) {
        STAssertEqualObjects(font, [UIFont systemFontOfSize:24], nil);
    }
}

@end
