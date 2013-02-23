//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import "UISSArgument.h"

@interface UISSArgument ()

@property (nonatomic, readonly) id<UISSArgumentValueConverter> converter;

@end

@implementation UISSArgument

- (id)init
{
    self = [super init];
    if (self) {
        self.config = [UISSConfig sharedConfig];
    }
    return self;
}

- (id<UISSArgumentValueConverter>)converter;
{
    for (id<UISSArgumentValueConverter> converter in self.availableConverters) {
        if ([converter canConvertValueForArgument:self]) {
            return converter;
        }
    }
    
    return nil;
}

- (id)convertedValue;
{
    return [self.converter convertValue:self.value];
}

- (NSString *)generatedCode;
{
    return [self.converter generateCodeForValue:self.value];
}

@end
