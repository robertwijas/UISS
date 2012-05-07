//
//  UISS+Private.m
//  UISS
//
//  Created by Robert Wijas on 10/20/11.
//  Copyright (c) 2011 57things. All rights reserved.
//

#import "UISS+Private.h"

@implementation UISS (Private)

@end

@implementation NSInvocation (UISS)

- (BOOL)canAcceptArguments:(NSArray *)arguments;
{
  // not enough arguments
  if (self.methodSignature.numberOfArguments < (arguments.count + 2)) return NO;
  
  return YES;
}

@end

