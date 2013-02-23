//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "UISSIntegerValueConverter.h"

@interface UISSIntegerValueConverterTests : SenTestCase

@property(nonatomic, strong) UISSIntegerValueConverter *converter;

@end

@implementation UISSIntegerValueConverterTests

- (void)setUp; {
    self.converter = [[UISSIntegerValueConverter alloc] init];
}

- (void)tearDown; {
    self.converter = nil;
}

- (void)testUnsignedInteger; {
    id value = [self.converter convertValue:@10U];
    STAssertTrue([value isKindOfClass:[NSValue class]], nil);

    NSUInteger unsignedIntegerValue = 0;
    [value getValue:&unsignedIntegerValue];

    STAssertEquals(unsignedIntegerValue, (NSUInteger) 10, nil);
}

- (void)testInteger; {
    id value = [self.converter convertValue:@-10];
    STAssertTrue([value isKindOfClass:[NSValue class]], nil);

    NSInteger integerValue = 0;
    [value getValue:&integerValue];

    STAssertEquals(integerValue, (NSInteger) -10, nil);
}

@end
