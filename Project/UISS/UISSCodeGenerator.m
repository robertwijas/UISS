//
// Copyright (c) 2013 Robert Wijas. All rights reserved.
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
                                              userInfo:[NSDictionary dictionaryWithObject:propertySetter
                                                                                   forKey:UISSPropertySetterErrorKey]]];
        }
    }
    
    for (NSString *groupCode in groups.allValues) {
        [code appendString:groupCode];
    }

    return code;
}

@end
