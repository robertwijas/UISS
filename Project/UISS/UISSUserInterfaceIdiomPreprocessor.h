//
//  UISSUserInterfaceIdiomPreprocessor.h
//  UISS
//
//  Created by Robert Wijas on 5/27/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UISSDictionaryPreprocessor.h"

@interface UISSUserInterfaceIdiomPreprocessor : NSObject <UISSDictionaryPreprocessor>

@property (nonatomic, assign) UIUserInterfaceIdiom userInterfaceIdiom;

@end
