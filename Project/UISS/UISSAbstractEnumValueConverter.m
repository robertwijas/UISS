//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import "UISSAbstractEnumValueConverter.h"
#import "UISSArgument.h"

static NSString *const UISSEnumAlternativeOperatorString = @"|";

@interface UISSAbstractEnumValueConverter ()

@property(nonatomic, strong) NSDictionary *stringToValueDictionary;
@property(nonatomic, strong) NSDictionary *stringToCodeDictionary;

@end

@implementation UISSAbstractEnumValueConverter

- (NSString *)propertyNameSuffix {
    return nil;
}

- (NSString *)argumentType; {
    return [NSString stringWithCString:@encode(NSInteger) encoding:NSUTF8StringEncoding];
}

- (BOOL)canConvertValueForArgument:(UISSArgument *)argument {
    if (![argument.type isEqualToString:self.argumentType]) return NO;
    if (![argument.value isKindOfClass:[NSString class]]) return NO;
    if (![[argument.name lowercaseString] hasSuffix:[self.propertyNameSuffix lowercaseString]]) return NO;

    return YES;
}

- (NSString *)generateCodeForValue:(id)value; {
    NSArray *values = [self splitAndConvertValue:value usingBlock:^id(NSString *token) {
        return [self generateCodeForValue:token];
    }];

    if (values) {
        return [values componentsJoinedByString:UISSEnumAlternativeOperatorString];
    } else {
        return [self.stringToCodeDictionary objectForKey:value];
    }
}

- (id)convertValue:(id)value {
    NSArray *values = [self splitAndConvertValue:value usingBlock:^id(NSString *token) {
        return [self convertValue:token];
    }];

    if (values) {
        NSInteger result = 0;
        for (NSString *v in values) {
            result |= [v integerValue];
        }

        return [NSNumber numberWithInteger:result];
    } else {
        return [self.stringToValueDictionary objectForKey:value];
    }
}

#pragma mark - Helper methods

- (NSArray *)splitAndConvertValue:(id)value usingBlock:(id (^)(NSString *token))block {
    if ([value isKindOfClass:[NSString class]]) {
        NSMutableArray *result = [NSMutableArray array];
        NSArray *tokens = [value componentsSeparatedByString:UISSEnumAlternativeOperatorString];
        if (tokens.count > 1) {
            for (NSString *token in tokens) {
                id convertedToken = block(token);
                if (convertedToken) {
                    [result addObject:convertedToken];
                }
            }

            return result;
        }
    }

    return nil;
}

@end
