//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
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
        self.stringToValueDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInteger:UIToolbarPositionAny], @"any",
                                        [NSNumber numberWithInteger:UIToolbarPositionBottom], @"bottom",
                                        [NSNumber numberWithInteger:UIToolbarPositionTop], @"top",
                                        nil];
        self.stringToCodeDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                       @"UIToolbarPositionAny", @"any",
                                       @"UIToolbarPositionBottom", @"bottom",
                                       @"UIToolbarPositionTop", @"top",
                                       nil];
    }
    return self;
}

@end
