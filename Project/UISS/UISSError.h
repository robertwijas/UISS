//
//  UISSError.h
//  UISS
//
//  Created by Robert Wijas on 6/17/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const UISSErrorDomain;

enum {
    UISSPropertySetterGenerateCodeError = 5701,
    UISSPropertySetterCreateInvocationError = 5702,
    UISSParseJSONError = 5703,
    UISSUnknownClassError = 5704
} UISSErrorCode;

@interface UISSError : NSError

+ (UISSError *)errorWithCode:(NSInteger)code;

@end
