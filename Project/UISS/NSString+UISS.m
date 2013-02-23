//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import "NSString+UISS.h"

@implementation NSString (UISS)

- (NSString *)uppercaseFirstCharacterString;
{
    if (self.length > 0) {
        return [[[self substringToIndex:1] uppercaseString] stringByAppendingString:[self substringFromIndex:1]];
    } else {
        return [NSString string];
    }
}

- (NSString *)lowercaseFirstCharacterString;
{
    if (self.length > 0) {
        return [[[self substringToIndex:1] lowercaseString] stringByAppendingString:[self substringFromIndex:1]];
    } else {
        return [NSString string];
    }
}

@end
