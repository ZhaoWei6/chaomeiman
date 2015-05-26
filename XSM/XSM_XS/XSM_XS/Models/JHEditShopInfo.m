//
//  JHEditShopInfo.m
//  XSM_XS
//
//  Created by Andy on 14-12-18.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "JHEditShopInfo.h"

@implementation JHEditShopInfo

+ (instancetype)editShopInfoWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}
- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

@end
