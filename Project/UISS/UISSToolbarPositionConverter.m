//
//  UISSToolbarPositionConverter.m
//  UISS
//
//  Created by Robert Wijas on 5/18/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import "UISSToolbarPositionConverter.h"

@implementation UISSToolbarPositionConverter

- (NSString *)propertyNameSuffix;
{
    return @"ToolbarPosition";
}

- (id)init
{
    self = [super init];
    if (self) {
        self.conversionDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithInteger:UIToolbarPositionAny], @"any",
                                     [NSNumber numberWithInteger:UIToolbarPositionBottom], @"bottom",
                                     [NSNumber numberWithInteger:UIToolbarPositionTop], @"top",
                                     nil];
    }
    return self;
}

@end
