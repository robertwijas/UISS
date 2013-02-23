//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import "UISSControlStateValueConverter.h"

@implementation UISSControlStateValueConverter

- (NSString *)propertyNameSuffix;
{
    return @"State";
}

- (id)init
{
    self = [super init];
    if (self) {
        self.stringToValueDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithUnsignedInteger:UIControlStateNormal], @"normal",
                                        [NSNumber numberWithUnsignedInteger:UIControlStateHighlighted], @"highlighted",
                                        [NSNumber numberWithUnsignedInteger:UIControlStateDisabled], @"disabled",
                                        [NSNumber numberWithUnsignedInteger:UIControlStateSelected], @"selected",
                                        [NSNumber numberWithUnsignedInteger:UIControlStateReserved], @"reserved",
                                        [NSNumber numberWithUnsignedInteger:UIControlStateApplication], @"application",
                                        nil];
        self.stringToCodeDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                       @"UIControlStateNormal", @"normal",
                                       @"UIControlStateHighlighted", @"highlighted",
                                       @"UIControlStateDisabled", @"disabled",
                                       @"UIControlStateSelected", @"selected",
                                       @"UIControlStateReserved", @"reserved",
                                       @"UIControlStateApplication", @"application",
                                       nil];
    }
    return self;
}

- (NSString *)argumentType;
{
    return [NSString stringWithCString:@encode(NSUInteger) encoding:NSUTF8StringEncoding];
}

@end
