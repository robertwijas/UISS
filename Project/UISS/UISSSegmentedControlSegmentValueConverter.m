//
//  UISSSegmentedControlSegmentValueConverter.m
//  UISS
//
//  Created by Robert Wijas on 5/16/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import "UISSSegmentedControlSegmentValueConverter.h"

@implementation UISSSegmentedControlSegmentValueConverter

- (NSString *)propertyNameSuffix;
{
    return @"SegmentType";
}

- (id)init
{
    self = [super init];
    if (self) {
        self.conversionDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithInteger:UISegmentedControlSegmentAny], @"any",
                                     [NSNumber numberWithInteger:UISegmentedControlSegmentLeft], @"left",
                                     [NSNumber numberWithInteger:UISegmentedControlSegmentCenter], @"center",
                                     [NSNumber numberWithInteger:UISegmentedControlSegmentRight], @"right",
                                     [NSNumber numberWithInteger:UISegmentedControlSegmentAlone], @"alone",
                                     nil];
    }
    return self;
}

@end
