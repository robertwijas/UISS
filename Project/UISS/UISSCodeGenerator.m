//
//  UISSCodeGenerator.m
//  UISS
//
//  Created by Robert Wijas on 7/7/12.
//  Copyright (c) 2012 57things. All rights reserved.
//

#import "UISSCodeGenerator.h"
#import "UISSPropertySetter.h"
#import "UISSError.h"

@implementation UISSCodeGenerator

- (NSString *)generateCodeForPropertySetters:(NSArray *)propertySetters errors:(NSMutableArray *)errors;
{
    NSMutableString *code = [NSMutableString string];
    NSMutableDictionary *groups = [NSMutableDictionary dictionary];
    
    for (UISSPropertySetter *propertySetter in propertySetters) {
        NSString *generatedCode = propertySetter.generatedCode;
        
        if (generatedCode) {
            if (propertySetter.group) {
                NSMutableString *groupCode = [groups objectForKey:propertySetter.group];
                if (groupCode == nil) {
                    groupCode = [NSMutableString stringWithFormat:@"// %@\n", propertySetter.group];
                    [groups setObject:groupCode forKey:propertySetter.group];
                }
                
                [groupCode appendFormat:@"%@\n", generatedCode];
            } else {
                [code appendFormat:@"%@\n", generatedCode];
            }
        } else {
            [errors addObject:[UISSError errorWithCode:UISSPropertySetterGenerateCodeError 
                                              userInfo:[NSDictionary dictionaryWithObject:propertySetter forKey:UISSPopertySetterErrorKey]]];
        }
    }
    
    for (NSString *groupCode in groups.allValues) {
        [code appendString:groupCode];
    }

    return code;
}

@end
