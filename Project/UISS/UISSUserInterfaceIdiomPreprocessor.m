//
//  UISSUserInterfaceIdiomPreprocessor.m
//  UISS
//
//  Created by Robert Wijas on 5/27/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import "UISSUserInterfaceIdiomPreprocessor.h"

@implementation UISSUserInterfaceIdiomPreprocessor

@synthesize userInterfaceIdiom=_userInterfaceIdiom;

- (id)init
{
    self = [super init];
    if (self) {
        self.userInterfaceIdiom = [UIDevice currentDevice].userInterfaceIdiom;
    }
    return self;
}

- (id)preprocessValueIfNecessary:(id)value;
{
    if ([value isKindOfClass:[NSDictionary class]]) {
        return [self preprocess:value];
    } else {
        return value;
    }
}

- (NSDictionary *)preprocess:(NSDictionary *)dictionary;
{
    NSMutableDictionary *preprocessed = [NSMutableDictionary dictionary];
    
    [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, id object, BOOL *stop) {
        UIUserInterfaceIdiom idiom = [self userInterfaceIdiomFromKey:key];
        
        if (idiom == NSNotFound) {
            [preprocessed setObject:[self preprocessValueIfNecessary:object] forKey:key];
        } else {
            if (idiom == self.userInterfaceIdiom) {
                // skip everything thats not a dictionary
                if ([object isKindOfClass:[NSDictionary class]]) {
                    [preprocessed addEntriesFromDictionary:[self preprocess:object]];
                }
            }
        }
    }];
    
    return preprocessed;
}

- (UIUserInterfaceIdiom)userInterfaceIdiomFromKey:(NSString *)key;
{
    NSString *lowercaseKey = [key lowercaseString];
    
    if ([@"phone" isEqual:lowercaseKey] || [@"iphone" isEqual:lowercaseKey]) {
        return UIUserInterfaceIdiomPhone;
    } else if ([@"pad" isEqual:lowercaseKey] || [@"ipad" isEqual:lowercaseKey]) {
        return UIUserInterfaceIdiomPad;
    } else {
        return NSNotFound;
    }
}

@end
