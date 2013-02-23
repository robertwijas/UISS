//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UISSDictionaryPreprocessor.h"

#define UISS_DISABLED_KEYS_PREPROCESSOR_DEFAULT_PREFIX @"-"

// removes from dictionary all keys that begins with a configured prefix (default is '-')
@interface UISSDisabledKeysPreprocessor : NSObject <UISSDictionaryPreprocessor>

@property (nonatomic, strong) NSString *prefix;

@end
