//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
//

#import "UILabel+UISS.h"

@implementation UILabel (UISS)

- (void)setTextAttributes:(NSDictionary *)textAttributes;
{
    UIFont *font = [textAttributes objectForKey:UITextAttributeFont];
    if (font) {
        self.font = font;
    }
    UIColor *textColor = [textAttributes objectForKey:UITextAttributeTextColor];
    if (textColor) {
        self.textColor = textColor;
    }
    UIColor *textShadowColor = [textAttributes objectForKey:UITextAttributeTextShadowColor];
    if (textShadowColor) {
        self.shadowColor = textShadowColor;
    }
    NSValue *shadowOffsetValue = [textAttributes objectForKey:UITextAttributeTextShadowOffset];
    if (shadowOffsetValue) {
        UIOffset shadowOffset = [shadowOffsetValue UIOffsetValue];
        self.shadowOffset = CGSizeMake(shadowOffset.horizontal, shadowOffset.vertical);
    }
}

@end
