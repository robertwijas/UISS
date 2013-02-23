//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import "UILabel+UISS.h"

@implementation UILabel (UISS)

- (void)setTextAttributes:(NSDictionary *)numberTextAttributes;
{
    UIFont *font = [numberTextAttributes objectForKey:UITextAttributeFont];
    if (font) {
        self.font = font;
    }
    UIColor *textColor = [numberTextAttributes objectForKey:UITextAttributeTextColor];
    if (textColor) {
        self.textColor = textColor;
    }
    UIColor *textShadowColor = [numberTextAttributes objectForKey:UITextAttributeTextShadowColor];
    if (textShadowColor) {
        self.shadowColor = textShadowColor;
    }
    NSValue *shadowOffsetValue = [numberTextAttributes objectForKey:UITextAttributeTextShadowOffset];
    if (shadowOffsetValue) {
        UIOffset shadowOffset = [shadowOffsetValue UIOffsetValue];
        self.shadowOffset = CGSizeMake(shadowOffset.horizontal, shadowOffset.vertical);
    }
}

@end
