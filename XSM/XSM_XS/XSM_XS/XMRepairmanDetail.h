//
//  XMRepairmanDetail.h
//  XiuShenMa
//
//  Created by Apple on 14/11/6.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface XMRepairmanDetail : NSObject

@property (nonatomic , copy ) NSString *maintainer_id;//修神id
@property (nonatomic , copy ) NSString *shop;//店铺名
@property (nonatomic , copy ) NSString *nickname;//修神名
@property (nonatomic , copy ) NSString *desc;//精通技能
@property (nonatomic , copy ) NSString *photo;//修神头像
@property (nonatomic , assign)NSInteger maintaincount;//维修数量
@property (nonatomic , assign)CGFloat   evaluate;//好评率
@property (nonatomic , assign)CGFloat   distance;//距离
@property (nonatomic , assign)NSInteger shareorder;//晒单数量
@property (nonatomic , assign)NSInteger collectionnumber;//收藏数量
@property (nonatomic , copy ) NSString *telephone;//修神电话
@property (nonatomic , assign)NSInteger evaluatecount;//评价数量
@property (nonatomic , retain)NSArray  *maintainphoto;//照片墙
@property (nonatomic , retain)NSArray  *goodslist;//商品列表
@property (nonatomic , retain)NSArray  *servicelist;//服务选项


               
@end
