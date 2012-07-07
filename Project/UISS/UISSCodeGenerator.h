//
//  UISSCodeGenerator.h
//  UISS
//
//  Created by Robert Wijas on 7/7/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISSCodeGenerator : NSObject

- (NSString *)generateCodeForPropertySetters:(NSArray *)propertySetters errors:(NSMutableArray *)errors;

@end
