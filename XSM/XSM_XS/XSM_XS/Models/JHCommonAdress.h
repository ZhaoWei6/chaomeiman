//
//  JHCommonAdress.h
//  XSM_XS
//
//  Created by Andy on 14-12-11.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHCommonAdress : NSObject

/** 常用地址id */
@property(nonatomic, copy) NSString *ID;

/** 区域 */
@property(nonatomic, copy) NSString *area;

/** 详细地址 */
@property(nonatomic, copy) NSString *address;

/** 性别 */
@property(nonatomic, copy) NSString *sex;

/** 手机号 */
@property(nonatomic, copy) NSString *telephone;

/** 姓名 */
@property(nonatomic, copy) NSString *nickname;

/** 精度 */
@property(nonatomic, assign) double longitude;

/** 纬度 */
@property(nonatomic, assign) double latitude;

@end
