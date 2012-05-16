//
//  UISSBarMetricsValueConverter.m
//  UISS
//
//  Created by Robert Wijas on 5/16/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import "UISSBarMetricsValueConverter.h"

@implementation UISSBarMetricsValueConverter

- (id)init
{
    self = [super init];
    if (self) {
        self.conversionDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithInteger:UIBarMetricsDefault], @"default",
                                     [NSNumber numberWithInteger:UIBarMetricsLandscapePhone], @"landscapePhone",
                                     nil];
    }
    return self;
}

- (NSString *)propertyNameSuffix;
{
    return @"barMetrics";
}

@end
