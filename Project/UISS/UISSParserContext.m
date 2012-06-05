//
//  UISSParserContext.m
//  UISS
//
//  Created by Robert Wijas on 5/9/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import "UISSParserContext.h"

@implementation UISSParserContext

@synthesize appearanceStack=_appearanceStack;
@synthesize containment=_containment;
@synthesize component=_component;
@synthesize errors=_errors;

- (id)init
{
    self = [super init];
    if (self) {
        self.appearanceStack = [NSMutableArray array];
        self.errors = [NSMutableArray array];
    }
    return self;
}

@end
