//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import "UISSImageValueConverter.h"
#import "UISSEdgeInsetsValueConverter.h"
#import "UISSArgument.h"

@interface UISSImageValueConverter ()

@property (nonatomic, strong) UISSEdgeInsetsValueConverter *edgeInsetsValueConverter;

@end

@implementation UISSImageValueConverter

- (id)init
{
    self = [super init];
    if (self) {
        self.edgeInsetsValueConverter= [[UISSEdgeInsetsValueConverter alloc] init];
    }
    return self;
}

- (BOOL)canConvertValueForArgument:(UISSArgument *)argument
{
    return [argument.type hasPrefix:@"@"] && [[argument.name lowercaseString] hasSuffix:@"image"];
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

- (BOOL)convertValue:(id)value imageHandler:(void (^)(UIImage *))imageHandler codeHandler:(void (^)(NSString *))codeHandler;
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

        return [self convertValue:[array objectAtIndex:0]
                imageHandler:^(UIImage *image) {
                    if (imageHandler) {
                        if (image && array.count > 1) {
                            id edgeInsetsValue = [self edgeInsetsValueFromImageArray:array];
                            id edgeInsetsConverted  = [self.edgeInsetsValueConverter convertValue:edgeInsetsValue];

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
                            id edgeInsetsCode = [self.edgeInsetsValueConverter generateCodeForValue:edgeInsetsValue];

                            if (edgeInsetsCode) {
                                code = [NSString stringWithFormat:@"[%@ resizableImageWithCapInsets:%@]", code,
                                                                  edgeInsetsCode];
                            }

                            codeHandler(code);
                        }
                    }
                }];
    } else if ([value isKindOfClass:[NSNull class]]) {
        if (imageHandler) {
            imageHandler(nil);
        }
        if (codeHandler) {
            codeHandler(@"nil");
        }
        
        return YES;
    }

    return NO;
}

- (id)convertValue:(id)value;
{
    __block UIImage *result = nil;

    [self convertValue:value
                  imageHandler:^(UIImage *image) {
                      result = image;
                  }
                   codeHandler:nil];

    return result;
}

- (NSString *)generateCodeForValue:(id)value
{
    __block NSString *result = nil;

    [self convertValue:value imageHandler:nil codeHandler:^(NSString *code) {
        result = code;
    }];

    return result;
}

@end
