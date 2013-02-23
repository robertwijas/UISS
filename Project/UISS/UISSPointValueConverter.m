//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import "UISSPointValueConverter.h"
#import "UISSFloatValueConverter.h"
#import "UISSArgument.h"

@interface UISSPointValueConverter ()

@property (nonatomic, strong) UISSFloatValueConverter *floatValueConverter;

@end

@implementation UISSPointValueConverter

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
    return [argument.type isEqualToString:[NSString stringWithCString:@encode(CGPoint) encoding:NSUTF8StringEncoding]];
}

- (id)convertValue:(id)value;
{
    if ([value isKindOfClass:[NSArray class]]) {
        CGFloat x = 0, y = 0;
        NSArray *array = (NSArray *)value;
        
        if (array.count > 0) {
            x = [[array objectAtIndex:0] floatValue];
        }
        
        if (array.count > 1) {
            y = [[array objectAtIndex:1] floatValue];
        } else {
            y = x;
        }
        
        return [NSValue valueWithCGPoint:CGPointMake(x, y)];
    } else if ([value isKindOfClass:[NSNumber class]]) {
        return [NSValue valueWithCGPoint:CGPointMake([value floatValue], [value floatValue])];
    }
    
    return nil;
}

- (NSString *)generateCodeForValue:(id)value
{
    id converted = [self convertValue:value];

    if (converted) {
        CGPoint point = [converted CGPointValue];

        return [NSString stringWithFormat:@"CGPointMake(%@, %@)",
                                          [self.floatValueConverter generateCodeForFloatValue:point.x],
                                          [self.floatValueConverter generateCodeForFloatValue:point.y]];
    } else {
        return @"CGPointZero";
    }
}

@end
