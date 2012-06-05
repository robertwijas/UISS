//
//  UISSPropertySetter.h
//  UISS
//
//  Created by Robert Wijas on 6/2/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UISSProperty.h"
#import "UISSAxisParameter.h"

@interface UISSPropertySetter : NSObject

@property (nonatomic, strong) id<UIAppearance> target;
@property (nonatomic, copy) NSArray *containment;
@property (nonatomic, strong) UISSProperty *property;
@property (nonatomic, copy) NSArray *axisParameters;

@end
