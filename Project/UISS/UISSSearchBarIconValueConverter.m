//
//  UISSSearchBarIconValueConverter.m
//  UISS
//
//  Created by Robert Wijas on 5/24/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import "UISSSearchBarIconValueConverter.h"

@implementation UISSSearchBarIconValueConverter

- (NSString *)propertyNameSuffix;
{
    return @"searchBarIcon";
}

- (id)init
{
    self = [super init];
    if (self) {
        self.conversionDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithInteger:UISearchBarIconSearch], @"search",
                                     [NSNumber numberWithInteger:UISearchBarIconClear], @"clear",
                                     [NSNumber numberWithInteger:UISearchBarIconBookmark], @"bookmark",
                                     [NSNumber numberWithInteger:UISearchBarIconResultsList], @"resultsList",
                                     nil];
    }
    return self;
}

@end
