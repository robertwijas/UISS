//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UISSProperty.h"
#import "UISSAxisParameter.h"

@interface UISSPropertySetter : NSObject

@property(nonatomic, strong) Class appearanceClass;
@property(nonatomic, copy) NSArray *containment; // array of Class<UIAppearanceContainer>

@property(nonatomic, strong) UISSProperty *property;
@property(nonatomic, copy) NSArray *axisParameters;

@property(nonatomic, strong) NSString *group;

#pragma mark - calculated properties

@property(nonatomic, strong, readonly) NSMethodSignature *methodSignature;

@property(nonatomic, assign, readonly) SEL selector;
@property(nonatomic, readonly) NSArray *selectorParts;

@property(nonatomic, readonly) id target;

@property(nonatomic, readonly) NSString *generatedCode;
@property(nonatomic, readonly) NSInvocation *invocation;

@end
