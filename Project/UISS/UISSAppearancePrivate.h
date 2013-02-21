//
//  UISSAppearancePrivate.h
//  UISS
//
//  Created by Robert Wijas on 6/14/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import <Foundation/Foundation.h>

#if UISS_DEBUG

@protocol UISSAppearancePrivate <NSObject>

- (NSMutableArray *)_appearanceInvocations;

@end

#endif
