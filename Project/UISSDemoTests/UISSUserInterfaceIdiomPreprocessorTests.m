//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "UISSUserInterfaceIdiomPreprocessor.h"

@interface UISSUserInterfaceIdiomPreprocessorTests : SenTestCase

@property(nonatomic, strong) UISSUserInterfaceIdiomPreprocessor *preprocessor;

@end

@implementation UISSUserInterfaceIdiomPreprocessorTests

- (void)testDictionaryWithoutIdiomBranches; {
    NSDictionary *dictionary = @{@"k1" : @"v1",
            @"k2" : @"v2"};

    NSDictionary *preprocessed = [self.preprocessor preprocess:dictionary userInterfaceIdiom:UIUserInterfaceIdiomPhone];

    STAssertNotNil(preprocessed, nil);
    STAssertEqualObjects(dictionary, preprocessed, nil);
}

- (void)testDictionaryWithPhoneBranchOnDeviceWithPadIdiom; {
    NSDictionary *dictionary = @{@"k1" : @"v1",
            @"Phone" : @"phone-value"};

    NSDictionary *preprocessed = [self.preprocessor preprocess:dictionary userInterfaceIdiom:UIUserInterfaceIdiomPad];

    STAssertNotNil(preprocessed, nil);
    STAssertEquals(preprocessed.count, (NSUInteger) 1, @"only one object could survive");
    STAssertEquals(preprocessed[@"k1"], @"v1", nil);
}

- (void)testDictionaryWithPhoneAndPadBranchOnDeviceWithPhoneIdiom; {
    NSDictionary *dictionary = @{@"Pad" : @{@"pad-key" : @"pad-value"},
            @"Phone" : @{@"phone-key" : @"phone-value"}};

    NSDictionary *preprocessed = [self.preprocessor preprocess:dictionary userInterfaceIdiom:UIUserInterfaceIdiomPhone];

    STAssertNotNil(preprocessed, nil);
    STAssertEquals(preprocessed.count, (NSUInteger) 1, @"only one object could survive");
    STAssertEqualObjects(preprocessed[@"phone-key"], @"phone-value", nil);
}

- (void)testDictionaryWithNestedPhoneBranchOnPhoneIdiom; {
    NSDictionary *nestedDictionary = @{@"Phone" : @{@"key" : @"value"}};
    NSDictionary *dictionary = @{@"root" : nestedDictionary};

    NSDictionary *preprocessed = [self.preprocessor preprocess:dictionary userInterfaceIdiom:UIUserInterfaceIdiomPhone];
    STAssertTrue([preprocessed.allKeys containsObject:@"root"], nil);
    STAssertEqualObjects(preprocessed[@"root"][@"key"], @"value", nil);
}

- (void)testPreprocessorShouldIgnoreLetterCase; {
    NSDictionary *dictionary = @{@"pad" : @{@"pad-key" : @"pad-value"},
            @"iphone" : @{@"phone-key" : @"phone-value"}};

    NSDictionary *preprocessed = [self.preprocessor preprocess:dictionary userInterfaceIdiom:UIUserInterfaceIdiomPhone];

    STAssertNotNil(preprocessed, nil);
    STAssertEquals(preprocessed.count, (NSUInteger) 1, @"only one object could survive");
    STAssertEqualObjects(preprocessed[@"phone-key"], @"phone-value", nil);
}

- (void)setUp; {
    self.preprocessor = [[UISSUserInterfaceIdiomPreprocessor alloc] init];
}

- (void)tearDown; {
    self.preprocessor = nil;
}

@end
