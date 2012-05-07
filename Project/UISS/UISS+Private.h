//
//  UISS+Private.h
//  UISS
//
//  Created by Robert Wijas on 10/20/11.
//  Copyright (c) 2011 57things. All rights reserved.
//

#import "UISS.h"

@interface UISS (Private)

@end

@interface NSInvocation (UISS)

- (BOOL)canAcceptArguments:(NSArray *)arguments;

@end
