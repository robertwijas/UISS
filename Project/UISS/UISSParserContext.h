//
//  UISSParserContext.h
//  UISS
//
//  Created by Robert Wijas on 7/6/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISSParserContext : NSObject

@property (nonatomic, strong) NSMutableArray *appearanceStack;
@property (nonatomic, strong) NSMutableArray *groupsStack;
@property (nonatomic, strong) NSMutableArray *errors;
@property (nonatomic, strong) NSMutableArray *propertySetters;

- (void)addErrorWithCode:(NSInteger)code object:(id)object key:(NSString *)key;

@end
