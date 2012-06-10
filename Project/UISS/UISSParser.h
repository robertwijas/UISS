//
//  UISSParser.h
//  UISS
//
//  Created by Robert Wijas on 5/9/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UISSConfig;
@class UISSConverter;

@interface UISSParser : NSObject

@property (nonatomic, strong) UISSConfig *config;
@property (nonatomic, strong) UISSConverter *converter;

- (void)parseDictionary:(NSDictionary *)dictionary handler:(void (^)(NSInvocation *invocation))handler;

- (NSArray *)parseDictionary:(NSDictionary *)dictionary;

@end
