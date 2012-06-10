//
//  UISSCodeGeneratorTests.m
//  UISS
//
//  Created by Robert Wijas on 6/10/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "UISSCodeGenerator.h"
#import "UISSPropertySetter.h"

@interface UISSCodeGeneratorTests : SenTestCase

@property(nonatomic, retain) UISSCodeGenerator *codeGenerator;

@end

@implementation UISSCodeGeneratorTests

@synthesize codeGenerator = _codeGenerator;

- (void)testSimplePropertyWithoutContainment;
{
    UISSPropertySetter *propertySetter = [[UISSPropertySetter alloc] init];

    propertySetter.appearanceClass = [UIToolbar class];

    UISSProperty *tintColorProperty= [[UISSProperty alloc] init];
    tintColorProperty.name = @"tintColor";
    tintColorProperty.value = @"white";

    propertySetter.property = tintColorProperty;

    NSString *code = [self.codeGenerator generateCodeForPropertySetter:propertySetter];

    STAssertEqualObjects(code, @"[[UIToolbar appearance] setTintColor:[UIColor whiteColor]];", nil);
}

- (void)setUp;
{
    self.codeGenerator = [[UISSCodeGenerator alloc] init];
}

@end
