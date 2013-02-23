//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISSParserContext : NSObject

@property (nonatomic, strong) NSMutableArray *appearanceStack;
@property (nonatomic, strong) NSMutableArray *groupsStack;
@property (nonatomic, strong) NSMutableArray *errors;
@property (nonatomic, strong) NSMutableArray *propertySetters;

- (void)addErrorWithCode:(NSInteger)code object:(id)object key:(NSString *)key;

@end
