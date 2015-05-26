//
//  NSObject+Value.h
//  Weibo
//
//  Created by mj on 13-8-24.
//  Copyright (c) 2013年 huiyinfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Value)
/**
 *  将values字典的所有键值对赋值给模型属性
 */
- (void)setValues:(NSDictionary *)values;
- (NSDictionary *)values;
@end
