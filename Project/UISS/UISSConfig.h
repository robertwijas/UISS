//
//  UISSConfig.h
//  UISS
//
//  Created by Robert Wijas on 6/10/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UISSConfig : NSObject

@property (nonatomic, strong) NSArray *propertyValueConverters;
@property (nonatomic, strong) NSArray *axisParameterValueConverters;
@property (nonatomic, strong) NSArray *preprocessors;

+ (UISSConfig *)sharedConfig;

@end
