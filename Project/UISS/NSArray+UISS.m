//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
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
