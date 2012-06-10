//
//  UISSTextAttributesValueConverter.h
//  UISS
//
//  Created by Robert Wijas on 5/9/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UISSPropertyValueConverter.h"

#define UISS_FONT_KEY @"font"
#define UISS_TEXT_COLOR_KEY @"textColor"
#define UISS_TEXT_SHADOW_COLOR_KEY @"textShadowColor"
#define UISS_TEXT_SHADOW_OFFSET_KEY @"textShadowOffset"

@interface UISSTextAttributesValueConverter : NSObject <UISSPropertyValueConverter>

@end
