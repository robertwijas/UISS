//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "UISSCodeGenerator.h"
#import "UISSPropertySetter.h"

@interface UISSCodeGeneratorTests : SenTestCase

@property(nonatomic, strong) UISSCodeGenerator *codeGenerator;

@end

@implementation UISSCodeGeneratorTests

- (void)testCodeGenerationWithGroups; {
    UISSPropertySetter *propertySetter = [[UISSPropertySetter alloc] init];
    propertySetter.group = @"Group";
    propertySetter.appearanceClass = [UIToolbar class];

    UISSProperty *property = [[UISSProperty alloc] init];
    property.name = @"tintColor";
    property.value = @"green";

    propertySetter.property = property;

    NSMutableArray *errors = [NSMutableArray array];

    NSString *code = [self.codeGenerator generateCodeForPropertySetters:@[propertySetter] errors:errors];

    STAssertNotNil(code, nil);
    STAssertEquals(errors.count, (NSUInteger) 0, nil);

    NSString *expectedCode = [NSString stringWithFormat:@"// Group\n%@\n", [propertySetter generatedCode]];
    STAssertEqualObjects(code, expectedCode, nil);
}

- (void)setUp; {
    self.codeGenerator = [[UISSCodeGenerator alloc] init];
}

- (void)tearDown; {
    self.codeGenerator = nil;
}

@end
