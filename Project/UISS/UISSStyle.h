//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UISSParser.h"

extern NSString *const UISSStyleWillDownloadNotification;
extern NSString *const UISSStyleDidDownloadNotification;

extern NSString *const UISSStyleWillParseDataNotification;
extern NSString *const UISSStyleDidParseDataNotification;

extern NSString *const UISSStyleWillParseDictionaryNotification;
extern NSString *const UISSStyleDidParseDictionaryNotification;

@interface UISSStyle : NSObject

@property (nonatomic, strong) NSURL *url;

@property (nonatomic, strong) NSData *data;
@property (nonatomic, strong) NSDictionary *dictionary;

@property (nonatomic, strong) NSArray *propertySettersPad;
@property (nonatomic, strong) NSArray *propertySettersPhone;

@property (nonatomic, strong) NSMutableArray *errors;

- (BOOL)downloadData;
- (BOOL)parseData;
- (BOOL)parseDictionaryForUserInterfaceIdiom:(UIUserInterfaceIdiom)userInterfaceIdiom withConfig:(UISSConfig *)config;

- (NSArray *)propertySettersForUserInterfaceIdiom:(UIUserInterfaceIdiom)userInterfaceIdiom;

@end
