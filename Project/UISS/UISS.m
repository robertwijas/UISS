//
//  UISS.m
//  UISS
//
//  Created by Robert Wijas on 10/7/11.
//  Copyright (c) 2011 57things. All rights reserved.
//

#import "UISS.h"

#import "UISSParser.h"

@interface UISS ()

@end

@implementation UISS

+ (void)configureWithJSONFilePath:(NSString *)filePath;
{
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:filePath]
                                                               options:0 
                                                                 error:NULL];
    
    UISSParser *parser = [[UISSParser alloc] init];
    [parser parseDictionary:dictionary handler:^(NSInvocation *invocation) {
        [invocation invoke];
    }];
}

+ (void)configureWithDefaultJSONFile;
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"uiss" ofType:@"json"];
    [self configureWithJSONFilePath:filePath];
}

@end
