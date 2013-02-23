//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import "UISSFloatValueConverter.h"
#import "UISSArgument.h"

@implementation UISSFloatValueConverter

- (id)init
{
    self = [super init];
    if (self) {
        self.precision = UISS_FLOAT_VALUE_CONVERTER_DEFAULT_PRECISION;
    }
    return self;
}

- (BOOL)canConvertValueForArgument:(UISSArgument *)argument
{
    return [argument.type isEqualToString:[NSString stringWithCString:@encode(CGFloat) encoding:NSUTF8StringEncoding]];
}

- (id)convertValue:(id)value;
{
    if ([value isKindOfClass:[NSNumber class]]) {
        CGFloat floatValue = [value floatValue];
        return [NSValue value:&floatValue withObjCType:@encode(CGFloat)];
    }
    
    return nil;
}

- (NSString *)generateCodeForFloatValue:(CGFloat)floatValue;
{
    NSString *format = [NSString stringWithFormat:@"%%.%df", self.precision];
    return [NSString stringWithFormat:format, floatValue];
}

- (NSString *)generateCodeForValue:(id)value
{
    if ([value respondsToSelector:@selector(floatValue)]) {
        return [self generateCodeForFloatValue:[value floatValue]];
    }

    return nil;
}

@end
