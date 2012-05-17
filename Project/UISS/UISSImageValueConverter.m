//
//  UISSImageValueConverter.m
//  UISS
//
//  Created by Robert Wijas on 5/8/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import "UISSImageValueConverter.h"
#import "UISSEdgeInsetsValueConverter.h"

@implementation UISSImageValueConverter

- (BOOL)canConvertPropertyWithName:(NSString *)name value:(id)value argumentType:(NSString *)argumentType;
{
    return [argumentType hasPrefix:@"@"] && [[name lowercaseString] hasSuffix:@"image"];
}

- (id)convertPropertyValue:(id)value;
{
    if ([value isKindOfClass:[NSString class]]) {
        return [UIImage imageNamed:value];
    } else if ([value isKindOfClass:[NSArray class]]) {
        NSArray *array = (NSArray *)value;
        
        UIImage *image = [self convertPropertyValue:[array objectAtIndex:0]];
        
        if (image && array.count > 1) {
            id edgeInsetsValue;
            
            if (array.count == 2) {
                edgeInsetsValue = [array objectAtIndex:1];
            } else {
                edgeInsetsValue = [array subarrayWithRange:NSMakeRange(1, array.count - 1)];
            }
            
            UISSEdgeInsetsValueConverter *edgeInsetsValueConverter = [[UISSEdgeInsetsValueConverter alloc] init];
            id value = [edgeInsetsValueConverter convertPropertyValue:edgeInsetsValue];
            if (value) {
                UIEdgeInsets edgeInsets = [value UIEdgeInsetsValue];
                image = [image resizableImageWithCapInsets:edgeInsets];
            }
            
            return image;
        }
    }
    
    return nil;
}

@end
