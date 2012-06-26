//
//  UISSStyle.m
//  UISS
//
//  Created by Robert Wijas on 6/18/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import "UISSStyle.h"

NSString *const UISSStyleWillDownloadNotification = @"UISSStyleWillDownloadNotification";
NSString *const UISSStyleDidDownloadNotification = @"UISSStyleDidDownloadNotification";

NSString *const UISSStyleWillParseDataNotification = @"UISSStyleWillParseDataNotification";
NSString *const UISSStyleDidParseDataNotification = @"UISSStyleDidParseDataNotification";

NSString *const UISSStyleWillParseDictionaryNotification = @"UISSStyleWillParseDictionaryNotification";
NSString *const UISSStyleDidParseDictionaryNotification = @"UISSStyleDidParseDictionaryNotification";

@implementation UISSStyle

@synthesize url=_url;
@synthesize data=_data;
@synthesize dictionary=_dictionary;
@synthesize propertySettersPad=_propertySettersPad;
@synthesize propertySettersPhone=_propertySettersPhone;
@synthesize errors=_errors;

- (id)init
{
    self = [super init];
    if (self) {
        self.errors = [NSMutableArray array];
    }
    return self;
}

- (void)setUrl:(NSURL *)url;
{
    if (_url != url) {
        _url = url;
        
        self.data = nil;
    }
}

- (void)setData:(NSData *)data;
{
    if (_data != data) {
        _data = data;
        
        self.dictionary = nil;
        [self.errors removeAllObjects];
    }
}

- (void)setDictionary:(NSDictionary *)dictionary;
{
    if (_dictionary != dictionary) {
        _dictionary = dictionary;
        
        self.propertySettersPad = nil;
        self.propertySettersPhone = nil;
    }
}

- (NSArray *)propertySettersForUserInterfaceIdiom:(UIUserInterfaceIdiom)userInterfaceIdiom;
{
    switch (userInterfaceIdiom) {
        case UIUserInterfaceIdiomPad:
            return self.propertySettersPad;
        default: // UIUserInterfaceIdiomPhone
            return self.propertySettersPhone;
    }
}

- (void)setPropertySetters:(NSArray *)propertySetters forUserInterfaceIdiom:(UIUserInterfaceIdiom)userInterfaceIdiom;
{
    switch (userInterfaceIdiom) {
        case UIUserInterfaceIdiomPad:
            self.propertySettersPad = propertySetters;
            break;
        default: // UIUserInterfaceIdiomPhone
            self.propertySettersPhone = propertySetters;
            break;
    }
}

#pragma mark - Parsing

- (BOOL)downloadData;
{
    [[NSNotificationCenter defaultCenter] postNotificationName:UISSStyleWillDownloadNotification object:self];
    
    BOOL downloadedNewStyle = NO;
    
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:self.url 
                                         options:0 
                                           error:&error];
    
    if (error) {
        [self.errors addObject:error];
    } else {
        if (data && [data isEqualToData:self.data] == NO) {
            self.data = data;
            downloadedNewStyle = YES;
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UISSStyleDidDownloadNotification object:self];
    
    return downloadedNewStyle;
}

- (BOOL)parseData;
{
    if (self.data == nil) {
        if ([self downloadData] == NO) {
            return NO;
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UISSStyleWillParseDataNotification object:self];
    
    BOOL dataParsed = NO;
    
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:self.data
                                                               options:NSJSONReadingMutableContainers
                                                                 error:&error];
    
    if (error) {
        [self.errors addObject:error];
    } else {
        self.dictionary = dictionary;
        dataParsed = YES;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UISSStyleDidParseDataNotification object:self];
    
    return dataParsed;
}

- (BOOL)parseDictionaryForUserInterfaceIdiom:(UIUserInterfaceIdiom)userInterfaceIdiom withConfig:(UISSConfig *)config;
{
    NSArray *propertySetters = [self propertySettersForUserInterfaceIdiom:userInterfaceIdiom];
    
    if (propertySetters) {
        return NO;
    }
        
    if (self.dictionary == nil) {
        if ([self parseData] == NO) {
            return NO;
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UISSStyleWillParseDictionaryNotification object:self];
    
    BOOL dictionaryParsed = NO;
    
    UISSParser *parser = [[UISSParser alloc] init];
    parser.userInterfaceIdiom = userInterfaceIdiom;
    parser.config = config;

    propertySetters = [parser parseDictionary:self.dictionary errors:self.errors];
    
    if (propertySetters) {
        [self setPropertySetters:propertySetters forUserInterfaceIdiom:userInterfaceIdiom];
        dictionaryParsed = YES;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UISSStyleDidParseDictionaryNotification object:self];
    
    return dictionaryParsed;
}


@end
