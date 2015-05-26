//
//  NSObject+Value.m
//  Weibo
//
//  Created by mj on 13-8-24.
//  Copyright (c) 2013年 huiyinfeng. All rights reserved.
//

#import "NSObject+Value.h"
#import <objc/message.h>
#import <objc/runtime.h>

@implementation NSObject (Value)
- (void)setValues:(NSDictionary *)values
{
    Class c = [self class];
    
    while (c && c != [NSObject class]) {
        // 1.获得所有的成员变量
        unsigned int outCount = 0;
        Ivar *ivars = class_copyIvarList(c, &outCount);
        
        for (int i = 0; i<outCount; i++) {
            Ivar ivar = ivars[i];
            
            // 2.属性名
            NSMutableString *name = [NSMutableString stringWithUTF8String:ivar_getName(ivar)];
            
            // 删除最前面的_
            [name deleteCharactersInRange:NSMakeRange(0, 1)];
            
            // 3.取出属性值
            NSString *key = name;
            if ([key isEqualToString:@"desc"]) {
                key = @"description";
            }
            if ([key isEqualToString:@"ID"]) {
                key = @"id";
            }
            id value = values[key];
            if (!value) continue;
            
            // 4.KVC赋值
            [self setValue:value forKey:name];
        }
        
        c = class_getSuperclass(c);
    }
}

- (NSDictionary *)values
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    Class c = [self class];
    
    while (c && c != [NSObject class]) {
        // 1.获得所有的成员变量
        unsigned int outCount = 0;
        Ivar *ivars = class_copyIvarList(c, &outCount);
        
        for (int i = 0; i<outCount; i++) {
            Ivar ivar = ivars[i];
            
            // 2.属性名
            NSMutableString *name = [NSMutableString stringWithUTF8String:ivar_getName(ivar)];
            
            // 删除最前面的_
            [name deleteCharactersInRange:NSMakeRange(0, 1)];
            
            // 3.取出属性值
            id value = [self valueForKey:name];
            if (value) {
                dict[name] = value;
            }
        }
        
        c = class_getSuperclass(c);
    }
    return dict;
}
@end
