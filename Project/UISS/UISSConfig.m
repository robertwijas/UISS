//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import "UISSConfig.h"
#import "UISSColorValueConverter.h"
#import "UISSImageValueConverter.h"
#import "UISSFontValueConverter.h"
#import "UISSTextAttributesValueConverter.h"
#import "UISSSizeValueConverter.h"
#import "UISSPointValueConverter.h"
#import "UISSEdgeInsetsValueConverter.h"
#import "UISSRectValueConverter.h"
#import "UISSOffsetValueConverter.h"
#import "UISSIntegerValueConverter.h"
#import "UISSUIntegerValueConverter.h"
#import "UISSFloatValueConverter.h"
#import "UISSBarMetricsValueConverter.h"
#import "UISSControlStateValueConverter.h"
#import "UISSSegmentedControlSegmentValueConverter.h"
#import "UISSToolbarPositionValueConverter.h"
#import "UISSSearchBarIconValueConverter.h"
#import "UISSUserInterfaceIdiomPreprocessor.h"
#import "UISSVariablesPreprocessor.h"
#import "UISSDisabledKeysPreprocessor.h"
#import "UISSTextAlignmentValueConverter.h"

@implementation UISSConfig

+ (UISSConfig *)sharedConfig;
{
    static UISSConfig *sharedConfig;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedConfig = [[UISSConfig alloc] init];
    });
    
    return sharedConfig;
}

- (NSArray *)defaultPropertyValueConverters
{
    return [NSArray arrayWithObjects:
                            [[UISSColorValueConverter alloc] init],
                            [[UISSImageValueConverter alloc] init],
                            [[UISSFontValueConverter alloc] init],
                            [[UISSTextAttributesValueConverter alloc] init],

                            [[UISSSizeValueConverter alloc] init],
                            [[UISSPointValueConverter alloc] init],
                            [[UISSEdgeInsetsValueConverter alloc] init],
                            [[UISSRectValueConverter alloc] init],
                            [[UISSOffsetValueConverter alloc] init],
            
                            [[UISSTextAlignmentValueConverter alloc] init],

                            [[UISSIntegerValueConverter alloc] init],
                            [[UISSUIntegerValueConverter alloc] init],
                            [[UISSFloatValueConverter alloc] init],
                            nil];
}

- (NSArray *)defaultAxisParameterValueConverters
{
    return [NSArray arrayWithObjects:
                            [[UISSBarMetricsValueConverter alloc] init],
                            [[UISSControlStateValueConverter alloc] init],
                            [[UISSSegmentedControlSegmentValueConverter alloc] init],
                            [[UISSToolbarPositionValueConverter alloc] init],
                            [[UISSSearchBarIconValueConverter alloc] init],

                            [[UISSIntegerValueConverter alloc] init],
                            [[UISSUIntegerValueConverter alloc] init],
                            nil];
}

- (NSArray *)defaultPreprocessors
{
    return [NSArray arrayWithObjects:
                            [[UISSDisabledKeysPreprocessor alloc] init],
                            [[UISSUserInterfaceIdiomPreprocessor alloc] init],
                            [[UISSVariablesPreprocessor alloc] init],
                            nil];
}

- (id)init
{
    self = [super init];
    
    if (self) {
        self.propertyValueConverters = [self defaultPropertyValueConverters];
        self.axisParameterValueConverters = [self defaultAxisParameterValueConverters];
        self.preprocessors = [self defaultPreprocessors];
    }
    
    return self;
}


@end
