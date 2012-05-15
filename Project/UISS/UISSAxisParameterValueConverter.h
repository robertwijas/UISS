//
//  UISSAxisParameterValueConverter.h
//  UISS
//
//  Created by Robert Wijas on 5/8/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UISSAxisParameterValueConverter <NSObject>

- (BOOL)canConvertAxisParameterWithName:(NSString *)name value:(id)value argumentType:(NSString *)argumentType;
- (NSNumber *)convertAxisParameter:(id)value;

@end
