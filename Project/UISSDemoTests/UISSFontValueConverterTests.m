//
//  UISSFontValueConverterTests.m
//  UISS
//
//  Created by Robert Wijas on 5/16/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "UISSFontValueConverter.h"

@interface UISSFontValueConverterTests : SenTestCase

@property(nonatomic, strong) UISSFontValueConverter *converter;

@end

@implementation UISSFontValueConverterTests

@synthesize converter;

- (void)testHelveticaNeue;
{
    id value = [NSArray arrayWithObjects:@"HelveticaNeue",
                                         [NSNumber numberWithFloat:16],
                                         nil];
    [self testValue:value expectedFont:[UIFont fontWithName:@"HelveticaNeue" size:16] expectedCode:@"[UIFont fontWithName:@\"HelveticaNeue\" size:16.0]"];
}

- (void)testDefaultSystemFontAsNumber;
{
    id value = [NSNumber numberWithFloat:14];
    [self testValue:value expectedFont:[UIFont systemFontOfSize:14] expectedCode:@"[UIFont systemFontOfSize:14.0]"];
}

- (void)testDefaultSystemFont;
{
    id value = [NSArray arrayWithObjects:@"system", [NSNumber numberWithFloat:14], nil];
    [self testValue:value expectedFont:[UIFont systemFontOfSize:14] expectedCode:@"[UIFont systemFontOfSize:14.0]"];
}

- (void)testDefaultSystemBoldFont;
{
    id value = [NSArray arrayWithObjects:@"bold", [NSNumber numberWithFloat:14], nil];
    [self testValue:value expectedFont:[UIFont boldSystemFontOfSize:14] expectedCode:@"[UIFont boldSystemFontOfSize:14.0]"];
}

- (void)testDefaultSystemItalicFont;
{
    UIFont *font = [self.converter convertPropertyValue:[NSArray arrayWithObjects:
            @"italic",
            [NSNumber numberWithFloat:14],
            nil]];

    STAssertNotNil(font, nil);
    STAssertEqualObjects(font, [UIFont italicSystemFontOfSize:14], nil);
}

- (void)testValue:(id)value expectedFont:(UIFont *)expectedFont expectedCode:(NSString *)expectedCode;
{
    UIFont *font = [self.converter convertPropertyValue:value];
    STAssertEqualObjects(font, expectedFont, nil);

    NSString *code = [self.converter generateCodeForPropertyValue:value];
    STAssertEqualObjects(code, expectedCode, nil);
}

- (void)setUp;
{
    self.converter = [[UISSFontValueConverter alloc] init];
}

- (void)tearDown;
{
    self.converter = nil;
}

@end
