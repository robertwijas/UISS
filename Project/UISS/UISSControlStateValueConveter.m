//
//  UISSControlStateValueConveter.m
//  UISS
//
//  Created by Robert Wijas on 5/16/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import "UISSControlStateValueConveter.h"

@implementation UISSControlStateValueConveter

- (NSString *)propertyNameSuffix;
{
    return @"State";
}

- (id)init
{
    self = [super init];
    if (self) {
        self.conversionDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithUnsignedInteger:UIControlStateNormal], @"normal",
                                     [NSNumber numberWithUnsignedInteger:UIControlStateHighlighted], @"highlighted",
                                     [NSNumber numberWithUnsignedInteger:UIControlStateDisabled], @"disabled",
                                     [NSNumber numberWithUnsignedInteger:UIControlStateSelected], @"selected",
                                     [NSNumber numberWithUnsignedInteger:UIControlStateReserved], @"reserved",
                                     [NSNumber numberWithUnsignedInteger:UIControlStateApplication], @"application",
                                     nil];
    }
    return self;
}

- (NSString *)argumentType;
{
    return [NSString stringWithCString:@encode(NSUInteger) encoding:NSUTF8StringEncoding];
}

@end
