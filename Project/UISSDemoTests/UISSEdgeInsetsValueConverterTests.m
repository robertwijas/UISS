//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "UISSEdgeInsetsValueConverter.h"

@interface UISSEdgeInsetsValueConverterTests : SenTestCase

@property(nonatomic, strong) UISSEdgeInsetsValueConverter *converter;

@end

@implementation UISSEdgeInsetsValueConverterTests

- (void)setUp; {
    self.converter = [[UISSEdgeInsetsValueConverter alloc] init];
}

- (void)tearDown; {
    self.converter = nil;
}

- (void)testEdgeInsetsAsArray; {
    id value = @[@1.0f,
            @2.0f,
            @3.0f,
            @4.0f];

    id converted = [self.converter convertValue:value];
    NSString *code = [self.converter generateCodeForValue:value];

    STAssertNotNil(converted, nil);
    STAssertEquals([converted UIEdgeInsetsValue], UIEdgeInsetsMake(1, 2, 3, 4), nil);

    STAssertEqualObjects(code, @"UIEdgeInsetsMake(1.0, 2.0, 3.0, 4.0)", nil);
}

@end
