//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "UISSFontValueConverter.h"
#import "UIFont+UISS.h"

@interface UISSFontValueConverterTests : SenTestCase

@property(nonatomic, strong) UISSFontValueConverter *converter;

@end

@implementation UISSFontValueConverterTests

- (void)testHelveticaNeue {
    id value = @[@"HelveticaNeue", @16.0f];
    [self testValue:value expectedFont:[UIFont fontWithName:@"HelveticaNeue" size:16]
       expectedCode:@"[UIFont fontWithName:@\"HelveticaNeue\" size:16.0]"];
}

- (void)testDefaultSystemFontAsNumber {
    id value = @14.0f;
    [self testValue:value expectedFont:[UIFont systemFontOfSize:14] expectedCode:@"[UIFont systemFontOfSize:14.0]"];
}

- (void)testDefaultSystemFont {
    id value = @[@"system", @14.0f];
    [self testValue:value expectedFont:[UIFont systemFontOfSize:14] expectedCode:@"[UIFont systemFontOfSize:14.0]"];
}

- (void)testDefaultSystemFontWithoutSize {
    [self testValue:@"system"
       expectedFont:[UIFont systemFontOfSize:[UIFont systemFontSize]]
       expectedCode:[NSString stringWithFormat:@"[UIFont systemFontOfSize:%.1f]", [UIFont systemFontSize]]];

    [self testValue:@[@"system"]
       expectedFont:[UIFont systemFontOfSize:[UIFont systemFontSize]]
       expectedCode:[NSString stringWithFormat:@"[UIFont systemFontOfSize:%.1f]", [UIFont systemFontSize]]];
}

- (void)testDefaultSystemBoldFont {
    [self testValue:@[@"bold", @14.0f]
       expectedFont:[UIFont boldSystemFontOfSize:14]
       expectedCode:@"[UIFont boldSystemFontOfSize:14.0]"];
}

- (void)testCustomFactorySelectorWithoutSize {
    [self testValue:@"uissDemo"
       expectedFont:[UIFont uissDemoFontOfSize:[UIFont systemFontSize]]
       expectedCode:[NSString stringWithFormat:@"[UIFont uissDemoFontOfSize:%.1f]", [UIFont systemFontSize]]];
}

- (void)testCustomFactorySelectorWithSize {
    [self testValue:@[@"uissDemo", @42.0f]
       expectedFont:[UIFont uissDemoFontOfSize:42]
       expectedCode:@"[UIFont uissDemoFontOfSize:42.0]"];
}

- (void)testDefaultSystemItalicFont {
    UIFont *font = [self.converter convertValue:@[@"italic", @14.0f]];

    STAssertNotNil(font, nil);
    STAssertEqualObjects(font, [UIFont italicSystemFontOfSize:14], nil);
}

- (void)testValue:(id)value expectedFont:(UIFont *)expectedFont expectedCode:(NSString *)expectedCode {
    UIFont *font = [self.converter convertValue:value];
    STAssertEqualObjects(font, expectedFont, nil);

    NSString *code = [self.converter generateCodeForValue:value];
    STAssertEqualObjects(code, expectedCode, nil);
}

- (void)setUp {
    self.converter = [[UISSFontValueConverter alloc] init];
}

- (void)tearDown {
    self.converter = nil;
}

@end
