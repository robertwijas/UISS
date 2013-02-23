//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import "UISSImageResizingModeConverter.h"

@implementation UISSImageResizingModeConverter

- (id)init {
    self = [super init];
    if (self) {
        self.stringToValueDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                             [NSNumber numberWithInteger:UIImageResizingModeTile], @"tile",
                                                             [NSNumber numberWithInteger:UIImageResizingModeStretch], @"stretch",
                                                             nil];
        self.stringToCodeDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                            @"UIImageResizingModeTile", @"tile",
                                                            @"UIImageResizingModeStretch", @"stretch",
                                                            nil];
    }
    return self;
}

@end