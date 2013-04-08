//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import "UISSFontValueConverter.h"
#import "UISSFloatValueConverter.h"
#import "UISSArgument.h"
#import "NSArray+UISS.h"

@interface UISSFontValueConverter ()

@property(nonatomic, strong) UISSFloatValueConverter *floatValueConverter;

@end

@implementation UISSFontValueConverter

- (id)init {
    self = [super init];
    if (self) {
        self.floatValueConverter = [[UISSFloatValueConverter alloc] init];
    }
    return self;
}

- (BOOL)canConvertValueForArgument:(UISSArgument *)argument {
    return [argument.type hasPrefix:@"@"] && [[argument.name lowercaseString] hasSuffix:@"font"];
}

- (BOOL)fontFromSelectorString:(NSString *)selectorString fontHandler:(void (^)(UIFont *))fontHandler codeHandler:(void (^)(NSString *))codeHandler fontSize:(CGFloat)fontSize {
    if (![selectorString hasSuffix:@"Font"]) {
        selectorString = [selectorString stringByAppendingString:@"Font"];
    }

    selectorString = [selectorString stringByAppendingString:@"OfSize:"];

    SEL fontSelector = NSSelectorFromString(selectorString);

    if ([UIFont respondsToSelector:fontSelector]) {
        if (fontHandler) {
            NSMethodSignature *methodSignature = [UIFont methodSignatureForSelector:fontSelector];
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];

            invocation.selector = fontSelector;
            invocation.target = [UIFont class];

            [invocation setArgument:&fontSize atIndex:2];

            [invocation invoke];
            
            __unsafe_unretained UIFont *font = nil;
            [invocation getReturnValue:&font];
            
            fontHandler(font);
        }

        if (codeHandler) {
            codeHandler([NSString stringWithFormat:@"[UIFont %@%.1f]", selectorString, fontSize]);
        }

        return YES;
    } else {
        return NO;
    }
}

- (BOOL)convertValue:(id)value fontHandler:(void (^)(UIFont *))fontHandler codeHandler:(void (^)(NSString *))codeHandler {
    CGFloat fontSize = [UIFont systemFontSize];
    NSString *fontName = @"system";

    if ([value isKindOfClass:[NSArray class]]) {
        NSArray *array = (NSArray *) value;

        if (array.count && [array[0] isKindOfClass:[NSString class]]) {
            fontName = array[0];
        }

        if ([array canConvertToFloatObjectAtIndex:1]) {
            fontSize = [array[1] floatValue];
        }
    } else if ([value isKindOfClass:[NSNumber class]]) {
        fontSize = [value floatValue];
    } else if ([value isKindOfClass:[NSString class]]) {
        fontName = value;
    }

    if ([fontName isEqualToString:@"bold"] || [fontName isEqualToString:@"italic"]) {
        fontName = [fontName stringByAppendingString:@"System"];
    }

    if ([self fontFromSelectorString:fontName fontHandler:fontHandler codeHandler:codeHandler fontSize:fontSize]) {
        return YES;
    } else {
        if (fontHandler) {
            fontHandler([UIFont fontWithName:fontName size:fontSize]);
        }
        if (codeHandler) {
            codeHandler([NSString stringWithFormat:@"[UIFont fontWithName:@\"%@\" size:%@]", fontName,
                                                   [self.floatValueConverter generateCodeForFloatValue:fontSize]]);
        }
    }

    return NO;
}

- (id)convertValue:(id)value {
    __block UIFont *result = nil;

    [self convertValue:value
           fontHandler:^(UIFont *font) {
               result = font;
           }
           codeHandler:nil];

    return result;
}

- (NSString *)generateCodeForValue:(id)value {
    __block NSString *result = nil;

    [self convertValue:value fontHandler:nil codeHandler:^(NSString *code) {
        result = code;
    }];

    return result;
}

@end
