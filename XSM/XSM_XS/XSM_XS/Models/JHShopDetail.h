//
//  JHShopDetail.h
//  XSM_XS
//
//  Created by Andy on 14-12-12.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHShopDetail : NSObject
/** 类型 */
@property(nonatomic, copy) NSString *status;
/** 修神ID */
@property(nonatomic, copy) NSString *maintainer_id;
/** 修神修龄 */
@property(nonatomic, copy) NSString *maintainage;
/** 修神性别 */
@property(nonatomic, copy) NSString *sex;
/** 修神纬度 */
@property(nonatomic, copy) NSString *longitude;
/** 修神精度 */
@property(nonatomic, copy) NSString *latitude;
/** 修神店铺名称 */
@property(nonatomic, copy) NSString *shop;
/** 修神名字 */
@property(nonatomic, copy) NSString *nickname;
/** 修神精通 */
@property(nonatomic, copy) NSString *desc;
/** 修神头像 */
@property(nonatomic, copy) NSString *photo;
/** 修神维修总数 */
@property(nonatomic, copy) NSString *maintaincount;
/** 修神店铺评分 */
@property(nonatomic, copy) NSString *evaluate;
/** 修神店铺晒单 */
@property(nonatomic, copy) NSString *shareorder;
/** 修神店铺点赞数 */
@property(nonatomic, copy) NSString *praise;
/** 修神店铺联系方式 */
@property(nonatomic, copy) NSString *telephone;
/** 修神店铺收藏总数 */
@property(nonatomic, copy) NSString *collectionnumber;
/** 修神店铺评分 */
@property(nonatomic, copy) NSString *evaluatecount;
/**店铺广告栏-图片列表 */
@property(nonatomic, strong) NSArray *maintainphoto;
/**店铺商品列表 */
@property(nonatomic, strong) NSArray *goodslist;
/**店铺服务类型列表 */
@property(nonatomic, strong) NSArray *servicelist;
/** 修身是否被收藏 */
@property(nonatomic, copy) NSString *iscollection;

///**店铺名称 */
//@property(nonatomic, strong) NSArray *shop_name;
///**店铺商品 */
//@property(nonatomic, strong) NSArray *goods;
///**店铺服务类型 */
//@property(nonatomic, strong) NSArray *services;
///**店铺维修范围 */
//@property(nonatomic, strong) NSArray *business;
///**店铺维修品类 */
//@property(nonatomic, strong) NSArray *pinlei;
///**店铺维修品牌 */
//@property(nonatomic, strong) NSArray *brand;
///**店铺广告栏 */
//@property(nonatomic, strong) NSArray *adphoto;
///**店铺地址信息 */
//@property(nonatomic, strong) NSArray *address;


+ (instancetype)shopDetailWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
