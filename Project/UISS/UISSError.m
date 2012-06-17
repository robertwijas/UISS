//
//  UISSError.m
//  UISS
//
//  Created by Robert Wijas on 6/17/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import "UISSError.h"

NSString * const UISSErrorDomain = @"UISSErrorDomain";

@implementation UISSError

+ (UISSError *)errorWithCode:(NSInteger)code;
{
    return [self errorWithDomain:UISSErrorDomain code:code userInfo:nil];
}

@end
