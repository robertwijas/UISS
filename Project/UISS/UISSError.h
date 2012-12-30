//
//  UISSError.h
//  UISS
//
//  Created by Robert Wijas on 6/17/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const UISSErrorDomain;

extern NSString * const UISSPropertySetterErrorKey;
extern NSString * const UISSInvalidClassNameErrorKey;
extern NSString * const UISSInvalidAppearanceDictionaryErrorKey;

typedef NS_ENUM(NSInteger, UISSErrorCode) {
    UISSPropertySetterGenerateCodeError = 5701,
    UISSPropertySetterCreateInvocationError = 5702,
    UISSUnknownClassError = 5703,
    UISSInvalidAppearanceClassError = 5704,
    UISSInvalidAppearanceContainerClassError = 5705,
    UISSInvalidAppearanceDictionaryError = 5706
};

@interface UISSError : NSError

+ (UISSError *)errorWithCode:(NSInteger)code;
+ (UISSError *)errorWithCode:(NSInteger)code userInfo:(NSDictionary *)userInfo;

@end
