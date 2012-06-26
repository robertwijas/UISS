//
//  UISSError.m
//  UISS
//
//  Created by Robert Wijas on 6/17/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import "UISSError.h"
#import "UISSPropertySetter.h"

NSString * const UISSErrorDomain = @"UISSErrorDomain";

NSString * const UISSPopertySetterErrorKey = @"UISSPopertySetterErrorKey";
NSString * const UISSInvalidClassNameErrorKey = @"UISSUnknownClassErrorKey";

@implementation UISSError

+ (UISSError *)errorWithCode:(NSInteger)code;
{
    return [self errorWithCode:code userInfo:nil];
}

+ (UISSError *)errorWithCode:(NSInteger)code userInfo:(NSDictionary *)userInfo;
{
    return [self errorWithDomain:UISSErrorDomain code:code userInfo:userInfo];
}

- (NSString *)descriptionForCode:(UISSErrorCode)code;
{
    switch (code) {
        case UISSPropertySetterGenerateCodeError:
            return [NSString stringWithFormat:@"Cannot generate code for: %@", [self.userInfo objectForKey:UISSPopertySetterErrorKey]];
        case UISSPropertySetterCreateInvocationError:
            return [NSString stringWithFormat:@"Cannot create NSInvocation for: %@", [self.userInfo objectForKey:UISSPopertySetterErrorKey]];
        case UISSUnknownClassError:
            return [NSString stringWithFormat:@"Unknown Class: %@", [self.userInfo objectForKey:UISSInvalidClassNameErrorKey]];
        case UISSInvalidAppearanceClassError:
            return [NSString stringWithFormat:@"Invalid Appearance Class: %@", [self.userInfo objectForKey:UISSInvalidClassNameErrorKey]];
        case UISSInvalidAppearanceContainerClassError:
            return [NSString stringWithFormat:@"Invalid Appearance Container Class: %@", [self.userInfo objectForKey:UISSInvalidClassNameErrorKey]];
        default:
            return nil;
    }
}

- (NSString *)localizedDescription;
{
    return [NSString stringWithFormat:@"%@. (%@ error %d.)", [self descriptionForCode:self.code], self.domain, self.code];
}

@end
