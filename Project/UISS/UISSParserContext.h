//
//  UISSParserContext.h
//  UISS
//
//  Created by Robert Wijas on 5/9/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UISSParserContext : NSObject

@property (nonatomic, strong) NSMutableArray *appearanceStack;

@property (nonatomic, strong) NSMutableArray *containment;
@property (nonatomic, strong) Class<UIAppearance> component;

@property (nonatomic, strong) NSMutableArray *errors;

@end
