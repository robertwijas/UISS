//
//  UISS.h
//  UISS
//
//  Created by Robert Wijas on 10/7/11.
//  Copyright (c) 2011 57things. All rights reserved.
//

@interface UISS : NSObject

+ (void)configureWithDictionary:(NSDictionary *)dictionary;
+ (void)configureWithJSONFilePath:(NSString *)filePath;

@end
