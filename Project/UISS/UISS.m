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

@property (nonatomic, strong) NSURL *url;

@end

@implementation UISS

@synthesize url=_url;

- (void)reload;
{
    NSLog(@"UISS -- configuring with url: %@", self.url);
    
    NSData *data = [NSData dataWithContentsOfURL:self.url];
    if (data) {
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                   options:0 
                                                                     error:NULL];
        
        UISSParser *parser = [[UISSParser alloc] init];
        parser.userInterfaceIdiom = [UIDevice currentDevice].userInterfaceIdiom;
        
        [parser parseDictionary:dictionary handler:^(NSInvocation *invocation) {
            NSLog(@"UISS -- invocation: %@ %@", invocation.target, NSStringFromSelector(invocation.selector));
            [invocation invoke];
        }];
        
        NSLog(@"UISS -- configured");
    } else {
        NSLog(@"UISS -- cannot load file from url: %@", self.url);
    }
}

+ (void)configureWithJSONFilePath:(NSString *)filePath;
{
    UISS *uiss = [[UISS alloc] init];
    uiss.url = [NSURL fileURLWithPath:filePath];
    [uiss reload];
}

+ (void)configureWithDefaultJSONFile;
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"uiss" ofType:@"json"];
    [self configureWithJSONFilePath:filePath];
}

@end
