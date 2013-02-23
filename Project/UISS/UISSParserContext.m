//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import "UISSParserContext.h"
#import "UISSError.h"

@implementation UISSParserContext

- (id)init
{
    self = [super init];
    if (self) {
        self.appearanceStack = [NSMutableArray array];
        self.groupsStack = [NSMutableArray array];
        self.errors = [NSMutableArray array];
        self.propertySetters = [NSMutableArray array];
    }
    return self;
}

- (void)addErrorWithCode:(NSInteger)code object:(id)object key:(NSString *)key;
{
    NSDictionary *userInfo = nil;
    if (key) {
        userInfo = [NSDictionary dictionaryWithObject:object forKey:key];
    }
    
    [self.errors addObject:[UISSError errorWithCode:code
                                           userInfo:userInfo]];
}

@end
