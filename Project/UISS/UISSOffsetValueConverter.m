//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import "UISSOffsetValueConverter.h"
#import "UISSFloatValueConverter.h"
#import "UISSArgument.h"
#import "NSArray+UISS.h"

@interface UISSOffsetValueConverter ()

@property (nonatomic, strong) UISSFloatValueConverter *floatValueConverter;

@end

@implementation UISSOffsetValueConverter

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
    return [argument.type isEqualToString:[NSString stringWithCString:@encode(UIOffset) encoding:NSUTF8StringEncoding]];
}

- (id)convertValue:(id)value;
{
    if ([value isKindOfClass:[NSArray class]]) {
        NSArray *array = (NSArray *)value;
        CGFloat horizontal = 0, vertical = 0;

        if ([array canConvertToFloatObjectAtIndex:0]) {
            horizontal = [[array objectAtIndex:0] floatValue];
        }

        if ([array canConvertToFloatObjectAtIndex:1]) {
            vertical = [[array objectAtIndex:1] floatValue];
        } else {
            vertical = horizontal;
        }
        
        return [NSValue valueWithUIOffset:UIOffsetMake(horizontal, vertical)];
    } else if ([value isKindOfClass:[NSNumber class]]) {
        return [NSValue valueWithUIOffset:UIOffsetMake([value floatValue], [value floatValue])];
    }
    
    return nil;
}

- (NSString *)generateCodeForValue:(id)value
{
    id converted = [self convertValue:value];
    
    if (converted) {
        UIOffset offset = [converted UIOffsetValue];
        
        return [NSString stringWithFormat:@"UIOffsetMake(%@, %@)",
                                          [self.floatValueConverter generateCodeForFloatValue:offset.horizontal],
                                          [self.floatValueConverter generateCodeForFloatValue:offset.vertical]];
    } else {
        return @"UIOffsetZero";
    }
}

@end
