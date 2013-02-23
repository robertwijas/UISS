//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "UISSSizeValueConverter.h"

@interface UISSSizeValueConverterTests : SenTestCase

@property(nonatomic, strong) UISSSizeValueConverter *converter;

@end

@implementation UISSSizeValueConverterTests

- (void)setUp; {
    self.converter = [[UISSSizeValueConverter alloc] init];
}

- (void)tearDown; {
    self.converter = nil;
}

- (void)testSizeAsArray; {
    [self testValue:@[@1.0f, @2.0f]
       expectedSize:CGSizeMake(1, 2) expectedCode:@"CGSizeMake(1.0, 2.0)"];
}

- (void)testSizeAsNumber; {
    [self testValue:@1.0f
       expectedSize:CGSizeMake(1, 1) expectedCode:@"CGSizeMake(1.0, 1.0)"];
}

- (void)testValue:(id)value expectedSize:(CGSize)expectedSize expectedCode:(NSString *)expectedCode; {
    id converted = [self.converter convertValue:value];
    STAssertEquals([converted CGSizeValue], expectedSize, nil);

    NSString *code = [self.converter generateCodeForValue:value];
    STAssertEqualObjects(code, expectedCode, nil);
}

@end
