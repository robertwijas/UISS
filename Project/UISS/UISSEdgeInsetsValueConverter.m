//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import "UISSEdgeInsetsValueConverter.h"
#import "UISSFloatValueConverter.h"
#import "UISSArgument.h"

@interface UISSEdgeInsetsValueConverter ()

@property (nonatomic, strong) UISSFloatValueConverter *floatValueConverter;

@end

@implementation UISSEdgeInsetsValueConverter

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
    return [argument.type isEqualToString:[NSString stringWithCString:@encode(UIEdgeInsets)
                                                             encoding:NSUTF8StringEncoding]];
}

- (id)convertValue:(id)value;
{
    if ([value isKindOfClass:[NSArray class]] && [value count] == 4) {
        NSArray *array = (NSArray *)value;
        return [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake([[array objectAtIndex:0] floatValue],
                                                               [[array objectAtIndex:1] floatValue],
                                                               [[array objectAtIndex:2] floatValue],
                                                               [[array objectAtIndex:3] floatValue])];
    }
    
    return nil;
}


- (NSString *)generateCodeForValue:(id)value
{
    id converted = [self convertValue:value];
    
    if (converted) {
        UIEdgeInsets edgeInsets = [converted UIEdgeInsetsValue];
        
        return [NSString stringWithFormat:@"UIEdgeInsetsMake(%@, %@, %@, %@)",
                                          [self.floatValueConverter generateCodeForFloatValue:edgeInsets.top],
                                          [self.floatValueConverter generateCodeForFloatValue:edgeInsets.left],
                                          [self.floatValueConverter generateCodeForFloatValue:edgeInsets.bottom],
                                          [self.floatValueConverter generateCodeForFloatValue:edgeInsets.right]];
    } else {
        return @"UIEdgeInsetsZero";
    }
}

@end
