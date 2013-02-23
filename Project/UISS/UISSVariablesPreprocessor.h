//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UISSDictionaryPreprocessor.h"

#define UISS_DEFAULT_VARIABLES_KEY @"Variables"
#define UISS_DEFAULT_VARIABLE_PREFIX @"$"

@interface UISSVariablesPreprocessor : NSObject <UISSDictionaryPreprocessor>

- (id)substituteValue:(id)value;

- (void)setVariableValue:(id)value forName:(NSString *)name;
- (id)getValueForVariableWithName:(NSString *)name;
- (void)setVariablesFromDictionary:(NSDictionary *)dictionary;

@end
