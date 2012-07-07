//
//  UISSCodeGeneratorTests.m
//  UISS
//
//  Created by Robert Wijas on 7/7/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "UISSCodeGenerator.h"
#import "UISSPropertySetter.h"
#import "UISSProperty.h"

@interface UISSCodeGeneratorTests : SenTestCase

@property (nonatomic, strong) UISSCodeGenerator *codeGenerator;

@end

@implementation UISSCodeGeneratorTests

@synthesize codeGenerator;


- (void)testCodeGenerationWithGroups;
{
    UISSPropertySetter *propertySetter = [[UISSPropertySetter alloc] init];
    propertySetter.group = @"Group";
    propertySetter.appearanceClass = [UIToolbar class];
    
    UISSProperty *property = [[UISSProperty alloc] init];
    property.name = @"tintColor";
    property.value = @"green";
    
    propertySetter.property = property;
    
    NSMutableArray *errors = [NSMutableArray array];
    
    NSString *code = [self.codeGenerator generateCodeForPropertySetters:[NSArray arrayWithObject:propertySetter] errors:errors];
    
    STAssertNotNil(code, nil);
    STAssertEquals(errors.count, (NSUInteger)0, nil);
    STAssertEqualObjects(code, @"// Group\n[[UIToolbar appearance] setTintColor:[UIColor greenColor]];\n", nil);
}

- (void)setUp;
{
    self.codeGenerator = [[UISSCodeGenerator alloc] init];
}

- (void)tearDown;
{
    self.codeGenerator = nil;
}

@end
