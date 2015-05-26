//
//  JHEditShopInfo.h
//  XSM_XS
//
//  Created by Andy on 14-12-18.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHEditShopInfo : NSObject
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSArray *shop_name;
@property (nonatomic, strong) NSArray *goods;
@property (nonatomic, strong) NSArray *services;
@property (nonatomic, strong) NSArray *business;
@property (nonatomic, strong) NSArray *brand;
@property (nonatomic, strong) NSArray *adphoto;
@property (nonatomic, strong) NSArray *address;

+ (instancetype)editShopInfoWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
