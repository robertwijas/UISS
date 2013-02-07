//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import "UISSSettingDescriptor.h"


@implementation UISSSettingDescriptor

- (NSString *)stringValue {
    id value = self.valueProvider();

    if ([value isKindOfClass:[NSNumber class]]) {
        return [value stringValue];
    } else if ([value isKindOfClass:[NSString class]]) {
        return value;
    } else {
        return nil;
    }
}

@end