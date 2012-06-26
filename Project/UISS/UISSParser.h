//
//  UISSParser.h
//  UISS
//
//  Created by Robert Wijas on 5/9/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UISSConfig;

@interface UISSParser : NSObject

@property (nonatomic, strong) UISSConfig *config;
@property (nonatomic, assign) UIUserInterfaceIdiom userInterfaceIdiom;

// returns array of PropertySetters
- (NSArray *)parseDictionary:(NSDictionary *)dictionary;
- (NSArray *)parseDictionary:(NSDictionary *)dictionary errors:(NSMutableArray *)errors;

@end
