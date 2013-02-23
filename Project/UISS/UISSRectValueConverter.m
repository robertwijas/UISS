//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import "UISSRectValueConverter.h"
#import "UISSFloatValueConverter.h"
#import "UISSArgument.h"

@interface UISSRectValueConverter ()

@property (nonatomic, strong) UISSFloatValueConverter *floatValueConverter;

@end

@implementation UISSRectValueConverter

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
    return [argument.type isEqualToString:[NSString stringWithCString:@encode(CGRect) encoding:NSUTF8StringEncoding]];
}

- (id)convertValue:(id)value;
{
    if ([value isKindOfClass:[NSArray class]] && [value count] == 4) {
        NSArray *array = (NSArray *) value;
        return [NSValue valueWithCGRect:CGRectMake([[array objectAtIndex:0] floatValue],
                                                   [[array objectAtIndex:1] floatValue],
                                                   [[array objectAtIndex:2] floatValue],
                                                   [[array objectAtIndex:3] floatValue]
                                                   )];
    }
    
    return nil;
}

- (NSString *)generateCodeForValue:(id)value
{
    id converted = [self convertValue:value];
    
    if (converted) {
        CGRect rect = [converted CGRectValue];
        
        return [NSString stringWithFormat:@"CGRectMake(%@, %@, %@, %@)",
                                          [self.floatValueConverter generateCodeForFloatValue:rect.origin.x],
                                          [self.floatValueConverter generateCodeForFloatValue:rect.origin.y],
                                          [self.floatValueConverter generateCodeForFloatValue:rect.size.width],
                                          [self.floatValueConverter generateCodeForFloatValue:rect.size.height]];
    } else {
        return @"CGRectZero";
    }
}

@end
