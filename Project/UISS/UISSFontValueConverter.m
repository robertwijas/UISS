//
//  UISSFontValueConverter.m
//  UISS
//
//  Created by Robert Wijas on 5/8/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import "UISSFontValueConverter.h"
#import "UISSFloatValueConverter.h"
#import "UISSArgument.h"

@interface UISSFontValueConverter ()

@property (nonatomic, strong) UISSFloatValueConverter *floatValueConverter;

@end

@implementation UISSFontValueConverter

@synthesize floatValueConverter;

- (id)init
{
    self = [super init];
    if (self) {
        self.floatValueConverter = [[UISSFloatValueConverter alloc] init];
    }
    return self;
}

- (BOOL)canConvertValueForArgument:(UISSArgument *)argument
{
    return [argument.type hasPrefix:@"@"] && [[argument.name lowercaseString] hasSuffix:@"font"];
}

- (BOOL)convertValue:(id)value fontHandler:(void (^)(UIFont *))fontHandler codeHandler:(void (^)(NSString *))codeHandler;
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
                    codeHandler([NSString stringWithFormat:@"[UIFont systemFontOfSize:%@]",
                                                           [self.floatValueConverter generateCodeForFloatValue:size]]);
                }
            } else if ([name isEqualToString:@"bold"]) {
                if (fontHandler) {
                    fontHandler([UIFont boldSystemFontOfSize:size]);
                }
                if (codeHandler) {
                    codeHandler([NSString stringWithFormat:@"[UIFont boldSystemFontOfSize:%@]",
                                                           [self.floatValueConverter generateCodeForFloatValue:size]]);
                }
            } else if ([name isEqualToString:@"italic"]) {
                if (fontHandler) {
                    fontHandler([UIFont italicSystemFontOfSize:size]);
                }
                if (codeHandler) {
                    codeHandler([NSString stringWithFormat:@"[UIFont italicSystemFontOfSize:%@]",
                                                           [self.floatValueConverter generateCodeForFloatValue:size]]);
                }
            } else {
                if (fontHandler) {
                    fontHandler([UIFont fontWithName:name size:size]);
                }
                if (codeHandler) {
                    codeHandler([NSString stringWithFormat:@"[UIFont fontWithName:@\"%@\" size:%@]", name,
                                                           [self.floatValueConverter generateCodeForFloatValue:size]]);
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
            codeHandler([NSString stringWithFormat:@"[UIFont systemFontOfSize:%@]",
                                                   [self.floatValueConverter generateCodeForFloatValue:size]]);
        }

        return YES;
    }

    return NO;
}

- (id)convertValue:(id)value;
{
    __block UIFont *result = nil;

    [self convertValue:value
                   fontHandler:^(UIFont *font) {
                       result = font;
                   }
                   codeHandler:nil];

    return result;
}

- (NSString *)generateCodeForValue:(id)value
{
    __block NSString *result = nil;

    [self convertValue:value fontHandler:nil codeHandler:^(NSString *code) {
        result = code;
    }];

    return result;
}

@end
