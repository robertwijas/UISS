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
    NSLog(@"UISS -- configuring with JSON file: %@", filePath);
    
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:filePath]
                                                               options:0 
                                                                 error:NULL];
    
    UISSParser *parser = [[UISSParser alloc] init];
    parser.userInterfaceIdiom = [UIDevice currentDevice].userInterfaceIdiom;
    
    [parser parseDictionary:dictionary handler:^(NSInvocation *invocation) {
        NSLog(@"UISS -- invocation: %@ %@", invocation.target, NSStringFromSelector(invocation.selector));
        [invocation invoke];
    }];
    
    NSLog(@"UISS -- configured");
}

+ (void)configureWithDefaultJSONFile;
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"uiss" ofType:@"json"];
    [self configureWithJSONFilePath:filePath];
}

@end
