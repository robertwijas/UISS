//
//  UISSDisabledKeysPreprocessor.m
//  UISS
//
//  Created by Robert Wijas on 6/27/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import "UISSDisabledKeysPreprocessor.h"

@implementation UISSDisabledKeysPreprocessor

@synthesize prefix=_prefix;

- (id)init
{
    self = [super init];
    if (self) {
        self.prefix = UISS_DISABLED_KEYS_PREPROCESSOR_DEFAULT_PREFIX;
    }
    return self;
}

- (NSDictionary *)preprocess:(NSDictionary *)dictionary userInterfaceIdiom:(UIUserInterfaceIdiom)userInterfaceIdiom;
{
    NSMutableDictionary *preprocessed = [NSMutableDictionary dictionary];
    
    [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, id object, BOOL *stop) {
        if ([key hasPrefix:self.prefix] == NO) {
            if ([object isKindOfClass:[NSDictionary class]]) {
                object = [self preprocess:object userInterfaceIdiom:userInterfaceIdiom];
            }

            [preprocessed setObject:object forKey:key];
        }
    }];
    
    return preprocessed;
}

@end
