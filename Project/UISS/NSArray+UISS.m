//
//  NSArray+UISS.m
//  UISS
//
//  Created by Robert Wijas on 21/12/2012.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import "NSArray+UISS.h"

@implementation NSArray (UISS)

- (BOOL)canConvertToIntObjectAtIndex:(NSUInteger)index {
    return self.count > index && [self[index] respondsToSelector:@selector(intValue)];
}

- (BOOL)canConvertToFloatObjectAtIndex:(NSUInteger)index {
    return self.count > index && [self[index] respondsToSelector:@selector(floatValue)];
}

@end
