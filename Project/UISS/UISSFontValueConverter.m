//
//  UISSFontValueConverter.m
//  UISS
//
//  Created by Robert Wijas on 5/8/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import "UISSFontValueConverter.h"
#import "UISSArgument.h"

@implementation UISSFontValueConverter

- (BOOL)canConvertPropertyWithName:(NSString *)name value:(id)value argumentType:(NSString *)argumentType;
{
    return [argumentType hasPrefix:@"@"] && [[name lowercaseString] hasSuffix:@"font"];
}

- (BOOL)convertPropertyValue:(id)value fontHandler:(void (^)(UIFont *))fontHandler codeHandler:(void (^)(NSString *))codeHandler;
{
    if ([value isKindOfClass:[NSArray class]]) {
        NSArray *array = (NSArray *) value;

        if (array.count == 2) {
            NSString *name = [array objectAtIndex:0];
            CGFloat size = [[array objectAtIndex:1] floatValue];

            if ([name isEqualToString:@"system"]) {
                if (fontHandler) {
                    fontHandler([UIFont systemFontOfSize:size]);
                }
                if (codeHandler) {
                    codeHandler([NSString stringWithFormat:@"[UIFont systemFontOfSize:%.1f]", size]);
                }
            } else if ([name isEqualToString:@"bold"]) {
                if (fontHandler) {
                    fontHandler([UIFont boldSystemFontOfSize:size]);
                }
                if (codeHandler) {
                    codeHandler([NSString stringWithFormat:@"[UIFont boldSystemFontOfSize:%.1f]", size]);
                }
            } else if ([name isEqualToString:@"italic"]) {
                if (fontHandler) {
                    fontHandler([UIFont italicSystemFontOfSize:size]);
                }
                if (codeHandler) {
                    codeHandler([NSString stringWithFormat:@"[UIFont italicSystemFontOfSize:%.1f]", size]);
                }
            } else {
                if (fontHandler) {
                    fontHandler([UIFont fontWithName:name size:size]);
                }
                if (codeHandler) {
                    codeHandler([NSString stringWithFormat:@"[UIFont fontWithName:@\"%@\" size:%.1f]", name, size]);
                }
            }

            return YES;
        }
    } else if ([value isKindOfClass:[NSNumber class]]) {
        CGFloat size = [value floatValue];

        if (fontHandler) {
            fontHandler([UIFont systemFontOfSize:size]);
        }
        if (codeHandler) {
            codeHandler([NSString stringWithFormat:@"[UIFont systemFontOfSize:%.1f]", size]);
        }

        return YES;
    }

    return NO;
}

- (id)convertPropertyValue:(id)value;
{
    __block UIFont *result = nil;

    [self convertPropertyValue:value
                   fontHandler:^(UIFont *font) {
                       result = font;
                   }
                   codeHandler:nil];

    return result;
}

- (NSString *)generateCodeForPropertyValue:(id)value
{
    __block NSString *result = nil;

    [self convertPropertyValue:value fontHandler:nil codeHandler:^(NSString *code) {
        result = code;
    }];

    return result;
}

- (BOOL)canConvertValueForArgument:(UISSArgument *)argument
{
    return [self canConvertPropertyWithName:argument.name value:argument.value argumentType:argument.type];
}

- (NSString *)generateCodeForArgument:(UISSArgument *)argument
{
    return [self generateCodeForPropertyValue:argument.value];
}

- (id)convertValueForArgument:(UISSArgument *)argument
{
    return [self convertPropertyValue:argument.value];
}


@end
