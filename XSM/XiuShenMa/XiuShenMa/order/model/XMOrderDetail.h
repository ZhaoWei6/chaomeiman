//
//  XMOrderDetail.h
//  XiuShemMa
//
//  Created by Apple on 14-10-11.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMOrderDetail : NSObject

@property (nonatomic , copy ) NSNumber *ID;//订单编号
@property (nonatomic , copy ) NSString *nickname;//修神
@property (nonatomic , copy ) NSString *mobile;//用户手机号
@property (nonatomic , copy ) NSString *desc;//更多需求描述
@property (nonatomic , copy ) NSString *shop;//店铺名称
@property (nonatomic , copy ) NSString *attr;//设备型号
@property (nonatomic , copy ) NSString *fault;//故障描述
@property (nonatomic , copy ) NSString *customer;//联系人姓名
@property (nonatomic , copy ) NSString *phone;//联系人电话
@property (nonatomic , copy ) NSString *address;//联系人地址
@property (nonatomic , copy ) NSString *calltime;//服务时间
@property (nonatomic , copy ) NSString *createtime;//下单时间
@property (nonatomic , copy ) NSString *orderstatus;//订单状态


@end
