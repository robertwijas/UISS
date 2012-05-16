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

@property (nonatomic, strong) UISSFontValueConverter *converter;

@end

@implementation UISSFontValueConverterTests

@synthesize converter;

- (void)testHelveticaNeue;
{
    UIFont *font = [self.converter convertPropertyValue:[NSArray arrayWithObjects:
                                                         @"HelveticaNeue",
                                                         [NSNumber numberWithFloat:16],
                                                         nil]];
    
    STAssertNotNil(font, nil);
    STAssertEqualObjects(font.fontName, @"HelveticaNeue", nil);
    STAssertEquals(font.pointSize, 16.0f, nil);
}

- (void)testDefaultSystemFontAsNumber;
{
    UIFont *font = [self.converter convertPropertyValue:[NSNumber numberWithFloat:14]];
    
    STAssertNotNil(font, nil);
    STAssertEqualObjects(font, [UIFont systemFontOfSize:14], nil);
}

- (void)testDefaultSystemFont;
{
    UIFont *font = [self.converter convertPropertyValue:[NSArray arrayWithObjects:
                                                         @"system",
                                                         [NSNumber numberWithFloat:14],
                                                         nil]];
    
    STAssertNotNil(font, nil);
    STAssertEqualObjects(font, [UIFont systemFontOfSize:14], nil);
}

- (void)testDefaultSystemBoldFont;
{
    UIFont *font = [self.converter convertPropertyValue:[NSArray arrayWithObjects:
                                                         @"bold",
                                                         [NSNumber numberWithFloat:14],
                                                         nil]];
    
    STAssertNotNil(font, nil);
    STAssertEqualObjects(font, [UIFont boldSystemFontOfSize:14], nil);
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

- (void)setUp;
{
    self.converter = [[UISSFontValueConverter alloc] init];
}

- (void)tearDown;
{
    self.converter = nil;
}

@end
