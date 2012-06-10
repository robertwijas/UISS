//
//  NSString+UISS.m
//  UISS
//
//  Created by Robert Wijas on 6/10/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import "NSString+UISS.h"

@implementation NSString (UISS)

- (NSString *)firstLetterCapitalizedString;
{
    if (self.length > 0) {
        return [[[self substringToIndex:1] uppercaseString] stringByAppendingString:[self substringFromIndex:1]];
    } else {
        return [NSString string];
    }
}

@end
