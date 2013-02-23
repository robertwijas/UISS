//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import "UISSIntegerValueConverter.h"
#import "UISSArgument.h"

@implementation UISSIntegerValueConverter

- (BOOL)canConvertValueForArgument:(UISSArgument *)argument
{
    return [argument.type isEqualToString:[NSString stringWithCString:@encode(NSInteger) encoding:NSUTF8StringEncoding]];
}

- (id)convertValue:(id)value
{
    if ([value isKindOfClass:[NSNumber class]]) {
        NSInteger integerValue = [value integerValue];
        return [NSValue value:&integerValue withObjCType:@encode(NSInteger)];
    }
    
    return nil;
}

- (NSString *)generateCodeForValue:(id)value
{
    if ([value respondsToSelector:@selector(integerValue)]) {
        return [NSString stringWithFormat:@"%d", [value integerValue]];
    }
    
    return nil;
}

@end
