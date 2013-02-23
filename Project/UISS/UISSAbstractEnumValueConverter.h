//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UISSArgumentValueConverter.h"

@interface UISSAbstractEnumValueConverter : NSObject <UISSArgumentValueConverter>

@end

@interface UISSAbstractEnumValueConverter (Subclass)

@property (nonatomic, readonly) NSString *propertyNameSuffix;
@property (nonatomic, readonly) NSString *argumentType;

@property (nonatomic, strong) NSDictionary *stringToValueDictionary;
@property (nonatomic, strong) NSDictionary *stringToCodeDictionary;

@end