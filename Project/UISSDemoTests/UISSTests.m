//
//  UISSTests.m
//  UISSTests
//
//  Created by Robert Wijas on 10/7/11.
//  Copyright (c) 2011 57things. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "NSInvocation+UISS.h"

@interface UISSTests : SenTestCase

@end

@implementation UISSTests

- (void)setUp
{
  [super setUp];
  
  // Set-up code here.
}

- (void)tearDown
{
  // Tear-down code here.
  
  [super tearDown];
}

- (void)checkCanAcceptArguments:(NSArray *)arguments class:(Class)class selector:(SEL)selector expected:(BOOL)expected;
{
  NSMethodSignature *methodSignature = [class instanceMethodSignatureForSelector:selector];
  STAssertNotNil(methodSignature, nil);
  
  if (methodSignature) {
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    
    if (expected) {
      STAssertTrue([invocation uissCanAcceptArguments:arguments], nil);
    } else {
      STAssertFalse([invocation uissCanAcceptArguments:arguments], nil);
    }
  }
}

- (void)testCanInvocationAcceptArguments;
{
  [self checkCanAcceptArguments:[NSArray array] 
                          class:[UIToolbar class]
                       selector:@selector(setBackgroundImage:forToolbarPosition:barMetrics:) expected:YES];

  [self checkCanAcceptArguments:[NSArray arrayWithObjects:@"yellow", [NSNumber numberWithInteger:0], nil] 
                          class:[UIToolbar class]
                       selector:@selector(setTintColor:) expected:NO];
}

@end
