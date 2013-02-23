//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISSCodeGenerator : NSObject

- (NSString *)generateCodeForPropertySetters:(NSArray *)propertySetters errors:(NSMutableArray *)errors;

@end
