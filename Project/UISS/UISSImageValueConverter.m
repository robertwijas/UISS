//
//  UISSImageValueConverter.m
//  UISS
//
//  Created by Robert Wijas on 5/8/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import "UISSImageValueConverter.h"
#import "UISSEdgeInsetsValueConverter.h"
#import "UISSArgument.h"

@interface UISSImageValueConverter ()

@property (nonatomic, strong) UISSEdgeInsetsValueConverter *edgeInsetsValueConverter;

@end

@implementation UISSImageValueConverter

@synthesize edgeInsetsValueConverter = _edgeInsetsValueConverter;

- (id)init
{
    self = [super init];
    if (self) {
        self.edgeInsetsValueConverter= [[UISSEdgeInsetsValueConverter alloc] init];
    }
    return self;
}

- (BOOL)canConvertPropertyWithName:(NSString *)name value:(id)value argumentType:(NSString *)argumentType;
{
    return [argumentType hasPrefix:@"@"] && [[name lowercaseString] hasSuffix:@"image"];
}

- (id)edgeInsetsValueFromImageArray:(NSArray *)array;
{
    id edgeInsetsValue;

    if (array.count == 2) {
        edgeInsetsValue = [array objectAtIndex:1];
    } else {
        edgeInsetsValue = [array subarrayWithRange:NSMakeRange(1, array.count - 1)];
    }

    return edgeInsetsValue;
}

- (BOOL)convertPropertyValue:(id)value imageHandler:(void (^)(UIImage *))imageHandler codeHandler:(void (^)(NSString *))codeHandler;
{
    if ([value isKindOfClass:[NSString class]]) {
        if (imageHandler) {
            imageHandler([UIImage imageNamed:value]);
        }

        if (codeHandler) {
            codeHandler([NSString stringWithFormat:@"[UIImage imageNamed:@\"%@\"]", value]);
        }

        return YES;
    } else if ([value isKindOfClass:[NSArray class]]) {
        NSArray *array = (NSArray *) value;

        return [self convertPropertyValue:[array objectAtIndex:0]
                imageHandler:^(UIImage *image) {
                    if (imageHandler) {
                        if (image && array.count > 1) {
                            id edgeInsetsValue = [self edgeInsetsValueFromImageArray:array];
                            id edgeInsetsConverted  = [self.edgeInsetsValueConverter convertPropertyValue:edgeInsetsValue];

                            if (edgeInsetsConverted) {
                                UIEdgeInsets edgeInsets = [edgeInsetsConverted UIEdgeInsetsValue];
                                image = [image resizableImageWithCapInsets:edgeInsets];
                            }

                            imageHandler(image);
                        }
                    }
                }
                codeHandler:^(NSString *code) {
                    if (codeHandler) {
                        if (code && array.count > 1) {
                            id edgeInsetsValue = [self edgeInsetsValueFromImageArray:array];
                            id edgeInsetsCode = [self.edgeInsetsValueConverter generateCodeForPropertyValue:edgeInsetsValue];

                            if (edgeInsetsCode) {
                                code = [NSString stringWithFormat:@"[%@ resizableImageWithCapInsets:%@]", code, edgeInsetsCode];
                            }

                            codeHandler(code);
                        }
                    }
                }];
    }

    return NO;
}

- (id)convertPropertyValue:(id)value;
{
    __block UIImage *result = nil;

    [self convertPropertyValue:value
                  imageHandler:^(UIImage *image) {
                      result = image;
                  }
                   codeHandler:nil];

    return result;
}

- (NSString *)generateCodeForPropertyValue:(id)value
{
    __block NSString *result = nil;

    [self convertPropertyValue:value imageHandler:nil codeHandler:^(NSString *code) {
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
