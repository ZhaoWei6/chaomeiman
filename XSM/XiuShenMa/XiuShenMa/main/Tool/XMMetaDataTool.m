//
//  TGMetaDataTool.m
//  团购
//
//  Created by app04 on 14-7-23.
//  Copyright (c) 2014年 app04. All rights reserved.
//

#import "XMMetaDataTool.h"
#import "XMCategory.h"
#import "XMOrder.h"
#import "NSObject+Value.h"
#import "XMRepairman.h"
#import "XMHttpTool.h"
#define kFilePath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"visitedCityNames.data"]

@interface XMMetaDataTool()

@end

@implementation XMMetaDataTool
singleton_implementation(XMMetaDataTool)

- (id)init
{
    if (self = [super init]) {
        // 初始化项目中的所有元数据
        
        // 1.初始化城市数据
        
        
        // 2.初始化分类数据
        [self loadCategoryData];
        
        // 3.初始化排序数据
        [self loadOrderData];
        
        // 4.初始化修神数据
        [self loadRepairmanData];
    }
    return self;
}

#pragma mark 初始化排序数据
- (void)loadOrderData
{
    NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Orders.plist" ofType:nil]];
    NSInteger count = array.count;
    NSMutableArray *temp = [NSMutableArray array];
    for (int i = 0; i<count; i++){
        XMOrder *o = [[XMOrder alloc] init];
        o.name = array[i];
        o.index = i + 1;
        [temp addObject:o];
    }
    _totalOrders = temp;
}

- (XMOrder *)orderWithName:(NSString *)name
{
    for (XMOrder *order in _totalOrders) {
        if ([name isEqualToString:order.name]) {
            return order;
        }
    }
    return nil;
}

#pragma mark 初始化分类数据
- (void)loadCategoryData
{
    NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Categories.plist" ofType:nil]];
    int i = categoryStyle;//根据枚举值判断应该调用哪个分类数据
    XMLog(@"%i",i);
    NSDictionary *dic = array[i];
    _currentCategory = [[XMCategory alloc] init];
    [_currentCategory setValues:dic];
}

#pragma mark 初始化修神数据
- (void)loadRepairmanData
{
    NSArray *array = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Repairman_iPhone.json" ofType:nil]] options:NSJSONReadingMutableContainers error:NULL];
    
    NSMutableArray *temp = [NSMutableArray array];
    for (NSDictionary *dic in array){
        XMRepairman *o = [[XMRepairman alloc] init];
        [o setValues:dic];
        [temp addObject:o];
    }
    _totalRepairman = temp;
}

#pragma mark 初始化城市数据
- (void)loadCityData
{
    
}



@end
