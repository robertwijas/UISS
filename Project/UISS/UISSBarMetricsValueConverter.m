//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import "UISSBarMetricsValueConverter.h"

@implementation UISSBarMetricsValueConverter

- (id)init
{
    self = [super init];
    if (self) {
        self.stringToValueDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInteger:UIBarMetricsDefault], @"default",
                                        [NSNumber numberWithInteger:UIBarMetricsLandscapePhone], @"landscapePhone",
                                        nil];
        self.stringToCodeDictionary= [NSDictionary dictionaryWithObjectsAndKeys:
                                      @"UIBarMetricsDefault", @"default",
                                      @"UIBarMetricsLandscapePhone", @"landscapePhone",
                                      nil];
    }
    return self;
}

- (NSString *)propertyNameSuffix;
{
    return @"barMetrics";
}

@end
