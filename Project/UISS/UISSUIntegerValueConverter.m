//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import "UISSUIntegerValueConverter.h"
#import "UISSArgument.h"

@implementation UISSUIntegerValueConverter

- (BOOL)canConvertValueForArgument:(UISSArgument *)argument
{
    return [argument.type isEqualToString:[NSString stringWithCString:@encode(NSUInteger) encoding:NSUTF8StringEncoding]];
}

- (NSNumber *)convertValue:(id)value;
{
    if ([value isKindOfClass:[NSNumber class]]) {
        return value;
    } else {
        return nil;
    }
}

- (NSString *)generateCodeForValue:(id)value
{
    if ([value respondsToSelector:@selector(unsignedIntegerValue)]) {
        return [NSString stringWithFormat:@"%d", [value unsignedIntegerValue]];
    }
    
    return nil;
}

@end
