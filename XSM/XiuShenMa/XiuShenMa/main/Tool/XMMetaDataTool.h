//
//  TGMetaDataTool.h
//  团购
//
//  Created by app04 on 14-7-23.
//  Copyright (c) 2014年 app04. All rights reserved.
//

//  元数据管理类
// 1.城市数据
// 2.下属分区数据
// 3.分类数据

#import <Foundation/Foundation.h>
#import "Singleton.h"

@class XMOrder,XMCategory,XMRepairman;

@interface XMMetaDataTool : NSObject
singleton_interface(XMMetaDataTool)

@property (nonatomic, strong, readonly) NSArray *totalOrders;// 所有的排序数据

@property (nonatomic, strong) XMOrder *currentOrder; // 当前选中的排序
@property (nonatomic, strong) XMCategory *currentCategory; // 当前选中的分类

@property (nonatomic, strong, readonly) NSArray *totalRepairman;//所有的iPhone修神信息


@property (nonatomic, strong) NSString *currentOrderTitle;
@property (nonatomic, strong) NSString *currentCategoryTitle;



- (XMOrder *)orderWithName:(NSString *)name;

@end
