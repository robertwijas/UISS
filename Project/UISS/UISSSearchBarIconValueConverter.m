//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
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
        self.stringToValueDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInteger:UISearchBarIconSearch], @"search",
                                        [NSNumber numberWithInteger:UISearchBarIconClear], @"clear",
                                        [NSNumber numberWithInteger:UISearchBarIconBookmark], @"bookmark",
                                        [NSNumber numberWithInteger:UISearchBarIconResultsList], @"resultsList",
                                        nil];
        self.stringToCodeDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                       @"UISearchBarIconSearch", @"search",
                                       @"UISearchBarIconClear", @"clear",
                                       @"UISearchBarIconBookmark", @"bookmark",
                                       @"UISearchBarIconResultsList", @"resultsList",
                                       nil];
    }
    return self;
}

@end
