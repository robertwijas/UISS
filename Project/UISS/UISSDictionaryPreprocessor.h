//
//  UISSDictionaryPreprocessor.h
//  UISS
//
//  Created by Robert Wijas on 5/27/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UISSDictionaryPreprocessor <NSObject>

- (NSDictionary *)preprocess:(NSDictionary *)dictionary;

@end
