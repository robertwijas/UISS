//
//  UISSParser.h
//  UISS
//
//  Created by Robert Wijas on 5/9/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UISSParser : NSObject

@property (nonatomic, strong) NSArray *propertyValueConverters;
@property (nonatomic, strong) NSArray *axisParameterValueConverters;

- (void)parseDictionary:(NSDictionary *)dictionary handler:(void (^)(NSInvocation *invocation))handler;

@end
