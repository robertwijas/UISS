//
//  UISSPropertySetterTests.m
//  UISS
//
//  Created by Robert Wijas on 6/10/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "UISSPropertySetter.h"

@interface UISSPropertySetterTests : SenTestCase

@end

@implementation UISSPropertySetterTests

- (void)testAccessingSelectorWithoutAxisParameters;
{
    UISSPropertySetter *propertySetter = [[UISSPropertySetter alloc] init];
    propertySetter.appearanceClass = [UIToolbar class];

    UISSProperty *property = [[UISSProperty alloc] init];
    property.name = @"tintColor";
    propertySetter.property = property;

    STAssertEquals(propertySetter.selector, @selector(setTintColor:), nil);
}

- (void)testAccessingSelectorWithOneAxisParameter;
{
    UISSPropertySetter *propertySetter = [[UISSPropertySetter alloc] init];
    propertySetter.appearanceClass = [UIButton class];

    UISSProperty *property = [[UISSProperty alloc] init];
    property.name = @"titleColor";
    propertySetter.property = property;

    UISSAxisParameter *axisParameter = [[UISSAxisParameter alloc] init];
    propertySetter.axisParameters = [NSArray arrayWithObject:axisParameter];

    STAssertEquals(propertySetter.selector, @selector(setTitleColor:forState:), nil);
}

- (void)testAccessingSelectorWithTwoAxisParameters;
{
    UISSPropertySetter *propertySetter = [[UISSPropertySetter alloc] init];
    propertySetter.appearanceClass = [UIBarButtonItem class];

    UISSProperty *property = [[UISSProperty alloc] init];
    property.name = @"backgroundImage";
    propertySetter.property = property;

    UISSAxisParameter *axisParameter1 = [[UISSAxisParameter alloc] init];
    UISSAxisParameter *axisParameter2 = [[UISSAxisParameter alloc] init];

    propertySetter.axisParameters = [NSArray arrayWithObjects:axisParameter1, axisParameter2, nil];

    STAssertEquals(propertySetter.selector, @selector(setBackgroundImage:forState:barMetrics:), nil);
}

- (void)testShouldFailToRecognizeSelectorIfThereAreToManyAxisParameters;
{
    UISSPropertySetter *propertySetter = [[UISSPropertySetter alloc] init];
    propertySetter.appearanceClass = [UIButton class];

    UISSProperty *property = [[UISSProperty alloc] init];
    property.name = @"titleColor";
    propertySetter.property = property;

    UISSAxisParameter *axisParameter1 = [[UISSAxisParameter alloc] init];
    UISSAxisParameter *axisParameter2 = [[UISSAxisParameter alloc] init];

    propertySetter.axisParameters = [NSArray arrayWithObjects:axisParameter1, axisParameter2, nil];

    STAssertEquals(propertySetter.selector, (SEL)NULL, nil);
}

#pragma mark - Code Generation & Invocations

- (void)testSimplePropertyWithoutContainment;
{
    UISSPropertySetter *propertySetter = [[UISSPropertySetter alloc] init];
    propertySetter.appearanceClass = [UIToolbar class];
    
    UISSProperty *tintColorProperty= [[UISSProperty alloc] init];
    tintColorProperty.name = @"tintColor";
    tintColorProperty.value = @"white";
    
    propertySetter.property = tintColorProperty;
    
    STAssertEqualObjects(propertySetter.generatedCode, @"[[UIToolbar appearance] setTintColor:[UIColor whiteColor]];", nil);
    
    NSInvocation *invocation = propertySetter.invocation;
    STAssertNotNil(invocation, nil);
}

- (void)testSimplePropertyWithContainment;
{
    UISSPropertySetter *propertySetter = [[UISSPropertySetter alloc] init];
    propertySetter.appearanceClass = [UIToolbar class];
    propertySetter.containment = [NSArray arrayWithObject:[UIPopoverController class]];
    
    UISSProperty *tintColorProperty= [[UISSProperty alloc] init];
    tintColorProperty.name = @"tintColor";
    tintColorProperty.value = @"white";
    
    propertySetter.property = tintColorProperty;
    
    STAssertEqualObjects(propertySetter.generatedCode, @"[[UIToolbar appearanceWhenContainedIn:[UIPopoverController class], nil] setTintColor:[UIColor whiteColor]];", nil);
}

- (void)testSimplePropertyWithDeepContainment;
{
    UISSPropertySetter *propertySetter = [[UISSPropertySetter alloc] init];
    propertySetter.appearanceClass = [UIToolbar class];
    propertySetter.containment = [NSArray arrayWithObjects:[UIPopoverController class], [UIView class], nil];
    
    UISSProperty *tintColorProperty= [[UISSProperty alloc] init];
    tintColorProperty.name = @"tintColor";
    tintColorProperty.value = @"white";
    
    propertySetter.property = tintColorProperty;
    
    STAssertEqualObjects(propertySetter.generatedCode, @"[[UIToolbar appearanceWhenContainedIn:[UIView class], [UIPopoverController class], nil] setTintColor:[UIColor whiteColor]];", nil);
}

- (void)testPropertyWithAxisParameter;
{
    UISSPropertySetter *propertySetter = [[UISSPropertySetter alloc] init];
    propertySetter.appearanceClass = [UIBarButtonItem class];
    
    UISSProperty *tintColorProperty = [[UISSProperty alloc] init];
    tintColorProperty.name = @"titlePositionAdjustment";
    tintColorProperty.value = [NSNumber numberWithFloat:10];
    
    UISSAxisParameter *axisParameter = [[UISSAxisParameter alloc] init];
    axisParameter.value = @"default";
    
    propertySetter.property = tintColorProperty;
    propertySetter.axisParameters = [NSArray arrayWithObject:axisParameter];
    
    STAssertEqualObjects(propertySetter.generatedCode, @"[[UIBarButtonItem appearance] setTitlePositionAdjustment:UIOffsetMake(10.0, 10.0) forBarMetrics:UIBarMetricsDefault];", nil);
}

@end
