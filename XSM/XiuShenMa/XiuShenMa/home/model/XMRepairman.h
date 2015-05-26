//
//  XMRepairman.h
//  XiuShemMa
//
//  Created by Apple on 14-10-11.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMRepairman : NSObject

@property (nonatomic , copy)  NSString *maintainer_id;//修神id 进入下个页面用
@property (nonatomic , copy)  NSString *shop;//店铺名
@property (nonatomic , copy)  NSString *nickname;//修神名
@property (nonatomic , copy)  NSString *photo;//修神头像
@property (nonatomic , copy)  NSString *desc;//精通技能
@property (nonatomic , assign)NSInteger maintaincount;//维修数量
@property (nonatomic , assign) CGFloat  evaluate;//好评率
@property (nonatomic , assign) CGFloat  distance;//距离
@property (nonatomic , retain) NSArray *servicelist;//服务列表

@end
