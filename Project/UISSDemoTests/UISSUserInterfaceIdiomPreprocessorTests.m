//
//  UISSUserInterfaceIdiomPreprocessorTests.m
//  UISS
//
//  Created by Robert Wijas on 5/27/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "UISSUserInterfaceIdiomPreprocessor.h"

@interface UISSUserInterfaceIdiomPreprocessorTests : SenTestCase

@property (nonatomic, strong) UISSUserInterfaceIdiomPreprocessor *preprocessor;

@end

@implementation UISSUserInterfaceIdiomPreprocessorTests


@synthesize preprocessor=_preprocessor;

- (void)testDictionaryWithoutIdiomBranches;
{
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"v1", @"k1",
                                @"v2", @"k2", nil];
    
    NSDictionary *preprocessed = [self.preprocessor preprocess:dictionary];
    
    STAssertNotNil(preprocessed, nil);
    STAssertEqualObjects(dictionary, preprocessed, nil);
}

- (void)testDictionaryWithPhoneBranchOnDeviceWithPadIdiom;
{
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"v1", @"k1",
                                @"phone-value", @"Phone", nil];
    
    self.preprocessor.userInterfaceIdiom = UIUserInterfaceIdiomPad;
    
    NSDictionary *preprocessed = [self.preprocessor preprocess:dictionary];
    
    STAssertNotNil(preprocessed, nil);
    STAssertEquals(preprocessed.count, (NSUInteger)1, @"only one object could survive");
    STAssertEquals([preprocessed objectForKey:@"k1"], @"v1", nil);
}

- (void)testDictionaryWithPhoneAndPadBranchOnDeviceWithPhoneIdiom;
{
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSDictionary dictionaryWithObject:@"pad-value" forKey:@"pad-key"], @"Pad",
                                [NSDictionary dictionaryWithObject:@"phone-value" forKey:@"phone-key"], @"Phone", nil];
    
    self.preprocessor.userInterfaceIdiom = UIUserInterfaceIdiomPhone;
    
    NSDictionary *preprocessed = [self.preprocessor preprocess:dictionary];
    
    STAssertNotNil(preprocessed, nil);
    STAssertEquals(preprocessed.count, (NSUInteger)1, @"only one object could survive");
    STAssertEqualObjects([preprocessed objectForKey:@"phone-key"], @"phone-value", nil);
}

- (void)testDictionaryWithNestedPhoneBranchOnPhoneIdiom;
{
    NSDictionary *nestedDictionary = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:@"value" forKey:@"key"]
                                                                 forKey:@"Phone"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:nestedDictionary
                                                           forKey:@"root"];
    
    self.preprocessor.userInterfaceIdiom = UIUserInterfaceIdiomPhone;
    
    NSDictionary *preprocessed = [self.preprocessor preprocess:dictionary];
    STAssertTrue([preprocessed.allKeys containsObject:@"root"], nil);
    STAssertEqualObjects([[preprocessed objectForKey:@"root"] objectForKey:@"key"], @"value", nil);
}

- (void)testPreprocessorShouldIgnoreLetterCase;
{
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSDictionary dictionaryWithObject:@"pad-value" forKey:@"pad-key"], @"pad",
                                [NSDictionary dictionaryWithObject:@"phone-value" forKey:@"phone-key"], @"iphone", nil];
    
    self.preprocessor.userInterfaceIdiom = UIUserInterfaceIdiomPhone;
    
    NSDictionary *preprocessed = [self.preprocessor preprocess:dictionary];
    
    STAssertNotNil(preprocessed, nil);
    STAssertEquals(preprocessed.count, (NSUInteger)1, @"only one object could survive");
    STAssertEqualObjects([preprocessed objectForKey:@"phone-key"], @"phone-value", nil);
}

- (void)setUp;
{
    self.preprocessor = [[UISSUserInterfaceIdiomPreprocessor alloc] init];
}

- (void)tearDown;
{
    self.preprocessor = nil;
}

@end
