//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import "UISSUserInterfaceIdiomPreprocessor.h"

@implementation UISSUserInterfaceIdiomPreprocessor

- (id)preprocessValueIfNecessary:(id)value userInterfaceIdiom:(UIUserInterfaceIdiom)userInterfaceIdiom;
{
    if ([value isKindOfClass:[NSDictionary class]]) {
        return [self preprocess:value userInterfaceIdiom:userInterfaceIdiom];
    } else {
        return value;
    }
}

- (NSDictionary *)preprocess:(NSDictionary *)dictionary userInterfaceIdiom:(UIUserInterfaceIdiom)userInterfaceIdiom;
{
    NSMutableDictionary *preprocessed = [NSMutableDictionary dictionary];
    
    [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, id object, BOOL *stop) {
        UIUserInterfaceIdiom idiom = (UIUserInterfaceIdiom) [self userInterfaceIdiomFromKey:key];
        
        if (idiom == NSNotFound) {
            [preprocessed setObject:[self preprocessValueIfNecessary:object userInterfaceIdiom:userInterfaceIdiom] forKey:key];
        } else {
            if (idiom == userInterfaceIdiom) {
                // skip everything that's not a dictionary
                if ([object isKindOfClass:[NSDictionary class]]) {
                    [preprocessed addEntriesFromDictionary:[self preprocess:object userInterfaceIdiom:userInterfaceIdiom]];
                }
            }
        }
    }];
    
    return preprocessed;
}

- (NSInteger)userInterfaceIdiomFromKey:(NSString *)key;
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
