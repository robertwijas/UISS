//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import "UISSSizeValueConverter.h"
#import "UISSFloatValueConverter.h"
#import "UISSArgument.h"

@interface UISSSizeValueConverter ()

@property (nonatomic, strong) UISSFloatValueConverter *floatValueConverter;

@end

@implementation UISSSizeValueConverter

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
    return [argument.type isEqualToString:[NSString stringWithCString:@encode(CGSize) encoding:NSUTF8StringEncoding]];
}

- (id)convertValue:(id)value;
{
    if ([value isKindOfClass:[NSArray class]]) {
        CGFloat width = 0, height = 0;
        NSArray *array = (NSArray *) value;
        
        if (array.count > 0) {
            width = [[array objectAtIndex:0] floatValue];
        }
        
        if (array.count > 1) {
            height = [[array objectAtIndex:1] floatValue];
        } else {
            height = width;
        }
        
        return [NSValue valueWithCGSize:CGSizeMake(width, height)];
    } else if ([value isKindOfClass:[NSNumber class]]) {
        return [NSValue valueWithCGSize:CGSizeMake([value floatValue], [value floatValue])];
    }
    
    return nil;
}

- (NSString *)generateCodeForValue:(id)value
{
    id converted = [self convertValue:value];
    
    if (converted) {
        CGSize size = [converted CGSizeValue];
        
        return [NSString stringWithFormat:@"CGSizeMake(%@, %@)",
                                          [self.floatValueConverter generateCodeForFloatValue:size.width],
                                          [self.floatValueConverter generateCodeForFloatValue:size.height]];
    } else {
        return @"CGSizeZero";
    }
}

@end
