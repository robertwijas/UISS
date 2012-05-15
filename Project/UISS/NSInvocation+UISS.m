//
//  NSInvocation+UISS.m
//  UISS
//
//  Created by Robert Wijas on 5/9/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import "NSInvocation+UISS.h"

@implementation NSInvocation (UISS)

- (BOOL)uissCanAcceptArguments:(NSArray *)arguments;
{
    // not enough arguments
    if (self.methodSignature.numberOfArguments < (arguments.count + 2)) return NO;
    
    return YES;
}

@end
