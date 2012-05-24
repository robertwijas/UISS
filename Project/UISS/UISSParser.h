//
//  UISSParser.h
//  UISS
//
//  Created by Robert Wijas on 5/9/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UISSVariablesPreprocessor.h"

@interface UISSParser : NSObject

@property (nonatomic, strong) UISSVariablesPreprocessor *variablesPreprocessor;

@property (nonatomic, strong) NSArray *propertyValueConverters;
@property (nonatomic, strong) NSArray *axisParameterValueConverters;
@property (nonatomic, assign) UIUserInterfaceIdiom userInterfaceIdiom;

- (void)parseDictionary:(NSDictionary *)dictionary handler:(void (^)(NSInvocation *invocation))handler;

@end
