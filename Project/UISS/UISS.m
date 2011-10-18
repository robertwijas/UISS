//
//  UISS.m
//  UISS
//
//  Created by Robert Wijas on 10/7/11.
//  Copyright (c) 2011 57things. All rights reserved.
//

#import "UISS.h"
#import <objc/runtime.h>

@implementation UISS

#define PROPERTY_VALUE_KEY @"value"

+ (UIColor *)convertToColor:(id)value;
{
  return [UIColor performSelector:NSSelectorFromString(value)];
}

+ (UIImage *)convertToImage:(id)value;
{
  NSString *imageURL = [[NSBundle bundleForClass:[self class]].resourcePath stringByAppendingPathComponent:value];
  return [UIImage imageWithContentsOfFile:imageURL];
}

+ (id)convertObjectValue:(id)value forProperty:(NSString *)property;
{
  if ([property hasSuffix:@"Color"]) {
    return [self convertToColor:value];
  } else if ([property hasSuffix:@"Image"]) {
    return [self convertToImage:value];
  } else {
    return value;
  }
}

+ (NSDictionary *)argumentsDictionaryFrom:(id)obj;
{
  if ([obj isKindOfClass:[NSDictionary class]]) {
    return obj;
  } else {
    return [NSDictionary dictionaryWithObjectsAndKeys:obj, PROPERTY_VALUE_KEY, nil];
  }
}

+ (NSString *)setterMethodPrefixForProperty:(NSString *)property;
{
  return [NSString stringWithFormat:@"set%@%@:", [[property substringToIndex:1] uppercaseString], [property substringFromIndex:1]];
}

+ (NSArray *)invocationsForProperty:(NSString *)property component:(Class<UIAppearance>)component;
{
  NSString *methodPrefix = [self setterMethodPrefixForProperty:property];

  NSMutableArray *invocations = [NSMutableArray array];
  
  unsigned int count = 0;
  Method *methods = class_copyMethodList(component, &count);
  
  for (int i = 0; i < count; i++) {
    SEL selector = method_getName(methods[i]);
    NSString *method = NSStringFromSelector(selector);
    
    if ([method hasPrefix:methodPrefix]) {
      NSMethodSignature *methodSignature = [[component appearance] methodSignatureForSelector:selector];
      NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
      [invocation setSelector:selector];
      
      [invocations addObject:invocation];
    }
  }
  
  free(methods);
  
  return invocations;
}

+ (NSInvocation *)selectInvocationForArguments:(NSDictionary *)arguments from:(NSArray *)invocations;
{
  NSInvocation *selected = nil;
  
  for (NSInvocation *invocation in invocations) {
    if (invocation.methodSignature.numberOfArguments >= arguments.count + 2) {
      selected = invocation;
    }
  }
  
  return selected;
}

+ (void)setupInvocation:(NSInvocation *)invocation forProperty:(NSString *)property withArguments:(NSDictionary *)arguments;
{
  id value = [arguments objectForKey:PROPERTY_VALUE_KEY];
  
  NSString *argumentType = [NSString stringWithUTF8String:[invocation.methodSignature getArgumentTypeAtIndex:2]];
  if ([argumentType hasPrefix:@"@"]) {
    id converted = [self convertObjectValue:value forProperty:property];
    [invocation setArgument:&converted atIndex:2];
  } else if ([argumentType hasPrefix:@"{"]) {
    // structure
    if ([argumentType hasPrefix:@"{UIOffset"]) {
      UIOffset offset = UIOffsetMake([[value objectAtIndex:0] floatValue], [[value objectAtIndex:1] floatValue]);
      [invocation setArgument:&offset atIndex:2];
    }
  } else if ([argumentType hasPrefix:@"f"]) {
    CGFloat floatValue = [value floatValue];
    [invocation setArgument:&floatValue atIndex:2];
  }
}

+ (void)configureComponent:(Class<UIAppearance>)component withDictionary:(NSDictionary *)dictionary;
{
  [dictionary enumerateKeysAndObjectsUsingBlock:^(id property, id value, BOOL *stop) {
    NSArray *invocations = [self invocationsForProperty:property component:component];
    NSDictionary *arguments = [self argumentsDictionaryFrom:value];
    
    NSInvocation *invocation = [self selectInvocationForArguments:arguments from:invocations];
    
    [self setupInvocation:invocation forProperty:property withArguments:arguments];

    [invocation invokeWithTarget:[component appearance]];
  }];
}

+ (void)configureWithDictionary:(NSDictionary *)dictionary;
{
  [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    Class class = NSClassFromString(key);
    if ([class conformsToProtocol:@protocol(UIAppearance)]) {
      Class<UIAppearance> component = (Class<UIAppearance>)class;
      [self configureComponent:component withDictionary:obj];
    }
  }];
}

+ (void)configureWithJSONFilePath:(NSString *)filePath;
{
  NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:filePath]
                                                             options:0 
                                                               error:NULL];
  [self configureWithDictionary:dictionary];
}

@end
