//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import "UISSColorValueConverter.h"
#import "UISSImageValueConverter.h"
#import "UISSFloatValueConverter.h"
#import "UISSArgument.h"
#import "NSArray+UISS.h"

@interface UISSColorValueConverter ()

@property(nonatomic, strong) UISSImageValueConverter *imageValueConverter;
@property(nonatomic, strong) UISSFloatValueConverter *floatValueConverter;

@end

@implementation UISSColorValueConverter

- (id)init {
    self = [super init];
    if (self) {
        self.imageValueConverter = [[UISSImageValueConverter alloc] init];
        self.floatValueConverter = [[UISSFloatValueConverter alloc] init];
        self.floatValueConverter.precision = 3;
    }

    return self;
}

- (BOOL)canConvertValueForArgument:(UISSArgument *)argument {
    return [argument.type hasPrefix:@"@"] && [[argument.name lowercaseString] hasSuffix:@"color"];
}

- (BOOL)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha
        colorHandler:(void (^)(UIColor *))colorHandler codeHandler:(void (^)(NSString *))codeHandler; {
    if (colorHandler) {
        colorHandler([UIColor colorWithRed:red green:green blue:blue alpha:alpha]);
    }

    if (codeHandler) {
        codeHandler([NSString stringWithFormat:@"[UIColor colorWithRed:%@ green:%@ blue:%@ alpha:%@]",
                                               [self.floatValueConverter generateCodeForFloatValue:red],
                                               [self.floatValueConverter generateCodeForFloatValue:green],
                                               [self.floatValueConverter generateCodeForFloatValue:blue],
                                               [self.floatValueConverter generateCodeForFloatValue:alpha]]);
    }

    return YES;
}

- (BOOL)colorFromHexString:(NSString *)colorString colorHandler:(void (^)(UIColor *))colorHandler codeHandler:(void (^)(NSString *))codeHandler; {
    if ([colorString hasPrefix:@"#"]) {
        NSScanner *scanner = [NSScanner scannerWithString:[colorString substringFromIndex:1]];

        unsigned long long hexValue;
        if ([scanner scanHexLongLong:&hexValue]) {
            CGFloat red = ((hexValue & 0xFF0000) >> 16) / 255.0f;
            CGFloat green = ((hexValue & 0x00FF00) >> 8) / 255.0f;
            CGFloat blue = (hexValue & 0x0000FF) / 255.0f;

            return [self colorWithRed:red green:green blue:blue alpha:1.0 colorHandler:colorHandler
                          codeHandler:codeHandler];
        }
    }

    return NO;
}

- (BOOL)colorFromSelectorString:(NSString *)selectorString colorHandler:(void (^)(UIColor *))colorHandler codeHandler:(void (^)(NSString *))codeHandler; {
    if (![selectorString hasSuffix:@"Color"]) {
        selectorString = [selectorString stringByAppendingString:@"Color"];
    }

    SEL colorSelector = NSSelectorFromString(selectorString);

    if ([UIColor respondsToSelector:colorSelector]) {
        if (colorHandler) {
            colorHandler([UIColor performSelector:colorSelector]);
        }

        if (codeHandler) {
            codeHandler([NSString stringWithFormat:@"[UIColor %@]", selectorString]);
        }

        return YES;
    } else {
        return NO;
    }
}

- (BOOL)colorFromPatternImageString:(NSString *)patternImageString colorHandler:(void (^)(UIColor *))colorHandler codeHandler:(void (^)(NSString *))codeHandler; {
    // UIColor with pattern
    UIImage *patternImage = [self.imageValueConverter convertValue:patternImageString];
    if (patternImage) {
        if (colorHandler) {
            colorHandler([UIColor colorWithPatternImage:patternImage]);
        }

        if (codeHandler) {
            codeHandler([NSString stringWithFormat:@"[UIColor colorWithPatternImage:%@]",
                                                   [self.imageValueConverter generateCodeForValue:patternImageString]]);
        }

        return YES;
    } else {
        return NO;
    }
}

- (BOOL)colorFromString:(NSString *)colorString colorHandler:(void (^)(UIColor *))colorHandler codeHandler:(void (^)(NSString *))codeHandler; {
    if ([self colorFromHexString:colorString colorHandler:colorHandler codeHandler:codeHandler]) {
        return YES;
    };

    if ([self colorFromSelectorString:colorString colorHandler:colorHandler codeHandler:codeHandler]) {
        return YES;
    };

    if ([self colorFromPatternImageString:colorString colorHandler:colorHandler codeHandler:codeHandler]) {
        return YES;
    };

    return NO;
}

- (BOOL)convertValue:(id)value colorHandler:(void (^)(UIColor *))colorHandler codeHandler:(void (^)(NSString *))codeHandler; {
    if ([value isKindOfClass:[NSArray class]]) {
        NSArray *array = (NSArray *) value;
        CGFloat red = 0, green = 0, blue = 0;
        __block CGFloat alpha = 1;

        if (array.count > 0) {
            if ([[array objectAtIndex:0] isKindOfClass:[NSString class]]) {
                return [self colorFromString:[array objectAtIndex:0]
                                colorHandler:^(UIColor *color) {
                                    if (colorHandler) {
                                        if (array.count > 1) {
                                            alpha = [[array objectAtIndex:1] floatValue];
                                            colorHandler([color colorWithAlphaComponent:alpha]);
                                        }
                                    }
                                }
                                 codeHandler:^(NSString *code) {
                                     if (codeHandler) {
                                         if (array.count > 1) {
                                             alpha = [[array objectAtIndex:1] floatValue];
                                             codeHandler([NSString stringWithFormat:@"[%@ colorWithAlphaComponent:%@]",
                                                                                    code,
                                                                                    [self.floatValueConverter generateCodeForFloatValue:alpha]]);
                                         }
                                     }
                                 }];
            } else {
                if ([array canConvertToIntObjectAtIndex:0]) {
                    red = [array[0] floatValue];
                }

                if ([array canConvertToIntObjectAtIndex:1]) {
                    green = [array[1] floatValue];

                    if ([array canConvertToIntObjectAtIndex:2]) {
                        blue = [array[2] floatValue];

                        if ([array canConvertToFloatObjectAtIndex:3]) {
                            alpha = [array[3] floatValue];
                        }
                    }
                }

                BOOL percentValuesPriority = (red <= 1) && (green <= 1) && (blue <= 1);

                if (red > 1 || (red == 1 && percentValuesPriority == NO)) red /= 255.0f;
                if (green > 1 || (green == 1 && percentValuesPriority == NO)) green /= 255.0f;
                if (blue > 1 || (blue == 1 && percentValuesPriority == NO)) blue /= 255.0f;
            }

            return [self colorWithRed:red green:green blue:blue alpha:alpha colorHandler:colorHandler
                          codeHandler:codeHandler];
        }

        return NO;
    } else if ([value isKindOfClass:[NSString class]]) {
        return [self colorFromString:value colorHandler:colorHandler codeHandler:codeHandler];
    } else if ([value isKindOfClass:[NSNull class]]) {
        if (colorHandler) {
            colorHandler(nil);
        }
        if (codeHandler) {
            codeHandler(@"nil");
        }

        return YES;
    } else {
        return NO;
    }

}

- (id)convertValue:(id)value; {
    __block UIColor *result = nil;

    [self convertValue:value
          colorHandler:^(UIColor *color) {
              result = color;
          }
           codeHandler:nil];

    return result;
}

- (NSString *)generateCodeForValue:(id)value {
    __block NSString *result = nil;

    [self convertValue:value colorHandler:nil codeHandler:^(NSString *code) {
        result = code;
    }];

    return result;
}

@end
