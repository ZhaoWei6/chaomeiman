//
//  XMDevote.h
//  XiuShenMa
//
//  Created by Apple on 14/11/13.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMDevote : NSObject

@property (nonatomic , retain)  NSArray *tach;//技能图片列表
@property (nonatomic , copy)  NSString *photo;//修神头像
@property (nonatomic , copy)  NSString *desc;//技能描述
@property (nonatomic , assign)NSInteger maintainage;//维修年龄

@property (nonatomic,copy) NSString  *nickname;//名字

@property (nonatomic , copy)  NSString *shop;//店铺名
@property (nonatomic , copy)  NSString *sex;//性别

@end
