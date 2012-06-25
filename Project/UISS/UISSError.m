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
        case UISSParseJSONError:
            return @"Cannot parse JSON";
        case UISSUnknownClassError:
            return @"Unknown Class";
        default:
            return nil;
    }
}

- (NSString *)localizedDescription;
{
    return [NSString stringWithFormat:@"%@. (%@ error %d.)", [self descriptionForCode:self.code], self.domain, self.code];
}

@end
