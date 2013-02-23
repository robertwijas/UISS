//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import "UISSError.h"

NSString * const UISSErrorDomain = @"UISSErrorDomain";

NSString * const UISSPropertySetterErrorKey = @"UISSPropertySetterErrorKey";
NSString * const UISSInvalidClassNameErrorKey = @"UISSUnknownClassErrorKey";
NSString * const UISSInvalidAppearanceDictionaryErrorKey = @"UISSInvalidAppearanceDictionaryErrorKey";

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
            return [NSString stringWithFormat:@"Cannot generate code for: %@",
                             [self.userInfo objectForKey:UISSPropertySetterErrorKey]];
        case UISSPropertySetterCreateInvocationError:
            return [NSString stringWithFormat:@"Cannot create NSInvocation for: %@",
                             [self.userInfo objectForKey:UISSPropertySetterErrorKey]];
        case UISSUnknownClassError:
            return [NSString stringWithFormat:@"Unknown Class: %@",
                                              [self.userInfo objectForKey:UISSInvalidClassNameErrorKey]];
        case UISSInvalidAppearanceClassError:
            return [NSString stringWithFormat:@"Invalid Appearance Class: %@",
                                              [self.userInfo objectForKey:UISSInvalidClassNameErrorKey]];
        case UISSInvalidAppearanceContainerClassError:
            return [NSString stringWithFormat:@"Invalid Appearance Container Class: %@",
                                              [self.userInfo objectForKey:UISSInvalidClassNameErrorKey]];
        case UISSInvalidAppearanceDictionaryError:
            return [NSString stringWithFormat:@"Invalid Appearance Dictionary: %@",
                                              [self.userInfo objectForKey:UISSInvalidAppearanceDictionaryErrorKey]];
        default:
            return nil;
    }
}

- (NSString *)localizedDescription;
{
    return [NSString stringWithFormat:@"%@. (%@ error %d.)", [self descriptionForCode:(UISSErrorCode) self.code], self.domain, self.code];
}

@end
