//
//  UISSTests.m
//  UISS
//
//  Created by Robert Wijas on 6/15/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "UISS.h"

@interface UISSTests : SenTestCase

@end

@implementation UISSTests

- (void)testGeneratedCode;
{
    UISS *uiss = [[UISS alloc] init];
    uiss.url = [[NSBundle bundleForClass:[self class]] URLForResource:@"example" withExtension:@"json"];
    [uiss reload];
    
    NSString *code = [uiss generateCode];
    STAssertNotNil(code, nil);
    
    STAssertTrue([code rangeOfString:@"[[UIToolbar appearance] setTintColor:[UIColor yellowColor]];"].location != NSNotFound, nil);
    STAssertTrue([code rangeOfString:@"[[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@\"black\"] forBarMetrics:UIBarMetricsLandscapePhone];"].location != NSNotFound, nil);
}

@end
