//
//  XMOrder.h
//  XSM_XS
//
//  Created by Apple on 14/12/11.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface XMOrder : NSObject

/**
 *  订单id
 */
@property (nonatomic , copy) NSString *ID;
/**
 *  店铺的名称
 */
@property (nonatomic , copy) NSString *shop;
/**
 *  手机号
 */
@property (nonatomic , copy) NSString *mobile;
/**
 *  状态名称
 */
@property (nonatomic , copy) NSString *title;
/**
 *  下一个状态
 */
@property (nonatomic , copy) NSString *checkstatus;
/**
 *  服务类型id
 */
@property (nonatomic , copy) NSString *servicecategory_id;

/**
 *  头像
 */
@property (nonatomic, copy) NSString *photo;

/**
 *  故障手机名称
 */
@property (nonatomic, copy) NSString *attr;

/**
 *  故障描述
 */
@property (nonatomic, copy) NSString *fault;

/**
 *  用户下单时间
 */
@property (nonatomic, copy) NSString *createtime;

@end
