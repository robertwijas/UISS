//
// Copyright 2013 Taptera Inc. All rights reserved.
//

#import "UISSTextAlignmentValueConverter.h"


@implementation UISSTextAlignmentValueConverter

- (NSString *)propertyNameSuffix; {
    return @"TextAlignment";
}

- (id)init {
    self = [super init];
    if (self) {
        self.stringToValueDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                             [NSNumber numberWithInteger:NSTextAlignmentCenter], @"center",
                                                             [NSNumber numberWithInteger:NSTextAlignmentJustified], @"justified",
                                                             [NSNumber numberWithInteger:NSTextAlignmentRight], @"right",
                                                             [NSNumber numberWithInteger:NSTextAlignmentLeft], @"left",
                                                             [NSNumber numberWithInteger:NSTextAlignmentNatural], @"natural",
                                                             nil];
        self.stringToCodeDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                            @"NSTextAlignmentCenter", @"center",
                                                            @"NSTextAlignmentJustified", @"justified",
                                                            @"NSTextAlignmentRight", @"right",
                                                            @"NSTextAlignmentLeft", @"left",
                                                            @"NSTextAlignmentNatural", @"natural",
                                                            nil];
    }
    return self;
}

@end