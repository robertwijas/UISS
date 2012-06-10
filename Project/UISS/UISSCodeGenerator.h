//
//  UISSCodeGenerator.h
//  UISS
//
//  Created by Robert Wijas on 6/7/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UISSPropertySetter;
@class UISSConverter;

@interface UISSCodeGenerator : NSObject

@property (nonatomic, strong) UISSConverter *converter;

- (NSString *)generateCodeForPropertySetter:(UISSPropertySetter *)setter;

@end
