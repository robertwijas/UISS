//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "UISSControlStateValueConverter.h"

@interface UISSControlStateValueConverterTests : SenTestCase

@property(nonatomic, strong) UISSControlStateValueConverter *converter;

@end

@implementation UISSControlStateValueConverterTests

- (void)setUp; {
    self.converter = [[UISSControlStateValueConverter alloc] init];
}

- (void)tearDown; {
    self.converter = nil;
}

- (void)testControlStateNormal {
    STAssertEquals([[self.converter convertValue:@"normal"] unsignedIntegerValue], (UIControlState) UIControlStateNormal, nil);
    STAssertEqualObjects([self.converter generateCodeForValue:@"normal"], @"UIControlStateNormal", nil);
}

- (void)testControlStateHighlighted {
    STAssertEquals([[self.converter convertValue:@"highlighted"] unsignedIntegerValue], (UIControlState) UIControlStateHighlighted, nil);
    STAssertEqualObjects([self.converter generateCodeForValue:@"highlighted"], @"UIControlStateHighlighted", nil);
}

- (void)testControlStateDisabled {
    STAssertEquals([[self.converter convertValue:@"disabled"] unsignedIntegerValue], (UIControlState) UIControlStateDisabled, nil);
    STAssertEqualObjects([self.converter generateCodeForValue:@"disabled"], @"UIControlStateDisabled", nil);
}

- (void)testControlStateSelected {
    STAssertEquals([[self.converter convertValue:@"selected"] unsignedIntegerValue], (UIControlState) UIControlStateSelected, nil);
    STAssertEqualObjects([self.converter generateCodeForValue:@"selected"], @"UIControlStateSelected", nil);
}

- (void)testControlStateApplication {
    STAssertEquals([[self.converter convertValue:@"application"] unsignedIntegerValue], (UIControlState) UIControlStateApplication, nil);
    STAssertEqualObjects([self.converter generateCodeForValue:@"application"], @"UIControlStateApplication", nil);
}

- (void)testControlStateReserved {
    STAssertEquals([[self.converter convertValue:@"reserved"] unsignedIntegerValue], (UIControlState) UIControlStateReserved, nil);
    STAssertEqualObjects([self.converter generateCodeForValue:@"reserved"], @"UIControlStateReserved", nil);
}

- (void)testInvalidValue {
    STAssertNil([self.converter convertValue:@"dummy"], nil);
    STAssertNil([self.converter generateCodeForValue:@"dummy"], nil);
}

- (void)testControlStateSelectedAndHighlighted {
    STAssertEquals([[self.converter convertValue:@"selected|highlighted"] unsignedIntegerValue], (UIControlState) (UIControlStateSelected | UIControlStateHighlighted), nil);
    STAssertEqualObjects([self.converter generateCodeForValue:@"selected|highlighted"], @"UIControlStateSelected|UIControlStateHighlighted", nil);
}

- (void)testControlStateNormalAndHighlighted {
    STAssertEquals([[self.converter convertValue:@"normal|highlighted"] unsignedIntegerValue], (UIControlState) (UIControlStateNormal | UIControlStateHighlighted), nil);
    STAssertEqualObjects([self.converter generateCodeForValue:@"normal|highlighted"], @"UIControlStateNormal|UIControlStateHighlighted", nil);
}

- (void)testControlStateDisabledAndSelected {
    STAssertEquals([[self.converter convertValue:@"disabled|selected"] unsignedIntegerValue], (UIControlState) (UIControlStateDisabled | UIControlStateSelected), nil);
    STAssertEqualObjects([self.converter generateCodeForValue:@"disabled|selected"], @"UIControlStateDisabled|UIControlStateSelected", nil);
}

@end
