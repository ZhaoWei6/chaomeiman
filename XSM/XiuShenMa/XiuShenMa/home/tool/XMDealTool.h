//
//  TGDealTool.h
//  团购
//
//  Created by app04 on 14-7-26.
//  Copyright (c) 2014年 app04. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MapKit/MapKit.h>

#import "Singleton.h"


// deals里面装的模型数据
typedef void (^DealsSuccessBlock)(NSArray *deals,int islast);
typedef void (^OrderBlock)(NSString *deal);
typedef void (^OrderSuccessBlock)(NSArray *item,NSArray *attributecategory,NSArray *faultcategory);
typedef void (^AddressBlock)(NSString *deal,NSString *index);
typedef void (^DevoteBlock) (NSDictionary *deal);
typedef void (^MineBlock)(NSArray *deal ,int ispage);
typedef void (^DeleMineBlock)(NSString *deal);
typedef void (^FourPageInfo) (NSDictionary *deal);
typedef void (^HandInFourPageInfo) (NSDictionary *deal);
typedef void (^FeedbackInfo) (NSDictionary *deal);

@interface XMDealTool : NSObject
singleton_interface(XMDealTool)

@property (nonatomic, strong) NSString *userid;//用户名
@property (nonatomic, strong) NSString *password;//密码

@property (nonatomic, assign) double currentLongitude;//当前精度
@property (nonatomic, assign) double currentLatitude;//当前纬度
@property (nonatomic, copy) NSString *area;//当前地址
@property (nonatomic, copy) NSString *address;
//@property  (nonatomic,copy)NSString  *maintainerid;//修神id
@property (nonatomic, strong, readonly) NSArray *totalRepairman;//所有的iPhone修神信息
@property (nonatomic, copy) NSString *currentOrderID;//当前订单ID

@property (nonatomic, assign) NSInteger maintaincategoryid;//维修类型的id  大类
@property (nonatomic, assign) NSInteger itemcategoryid;//维修类型的id   小类
@property (nonatomic, assign) NSInteger faultcategory_id;//维修商品的故障id

#pragma mark 获得第page页的修神信息
- (void)dealsWithPage:(int)page itemCategory:(int)itemcategory orderby:(int)orderby success:(DealsSuccessBlock)success;
#pragma mark 获得联系人地址信息
- (void)dealsSuccess:(DealsSuccessBlock)success;
#pragma mark 获得修神详情信息
- (void)dealsWithMaintainerid:(NSString *)maintainer_id success:(DealsSuccessBlock)success;
#pragma mark 预约上门
- (void)orderWithMaintainerid:(NSString *)maintainer_id itemcategoryid:(int)itemcategory_id faultcategoryid:(int)faultcategory_id success:(OrderSuccessBlock)success;
#pragma mark 进店订单
- (void)orderWithMaintainerid:(NSString *)maintainer_id itemcategoryid:(int)itemcategory_id servicecategoryid:(int)servicecategory_id success:(OrderBlock)success;
#pragma mark 获得订单列表信息
- (void)orderListWith:(NSDictionary *)parma success:(DealsSuccessBlock)success;
#pragma mark 发表评价
- (void)ratingOrderWithContent:(NSDictionary *)content success:(OrderBlock)success failure:(OrderBlock)failure;
#pragma mark 添加联系人地址
- (void)addContactWithContent:(NSDictionary *)content success:(AddressBlock)success failure:(OrderBlock)failure;
#pragma mark 修改联系人地址
- (void)editContactWithContent:(NSDictionary *)content success:(AddressBlock)success failure:(OrderBlock)failure;
#pragma mark 删除联系人地址
- (void)deleteContactWithContact:(NSString *)content success:(OrderBlock)success failure:(OrderBlock)failure;

#pragma mark 技术认证
- (void)dealSuccess:(NSString *)maintainer_id  success:(DevoteBlock)success;
#pragma mark 高德地图页(坐标点)
- (void)repairmansFromUserAddressSuccess:(DealsSuccessBlock)success;
// -(void)repairmansFromUserAddressSuccess:(int)maintainer_id  success:(DealsSuccessBlock)success;
#pragma mark 高德地图(点击坐标点后显示的修神内容)
- (void)repairmanWithMaintainerid:(int)maintainer_id success:(DevoteBlock)success;

#pragma mark  修神收藏列表页
-(void)dealWithPage:(int)page  success:(MineBlock)success;

#pragma mark 修神评价列表
- (void)evaluatelistWithPage:(int)page maintainerid:(NSString *)maintainer_id success:(DealsSuccessBlock)success;

#pragma mark  删除已经收藏的修神
-(void)deleteWithContent:(NSString *)content success:(DeleMineBlock )success  failure:(DeleMineBlock)failure;

#pragma mark  	请求四个体验报告信息
- (void)requestFourPageInfoWithParams:(NSDictionary *)dict Success:(FourPageInfo)success;

#pragma mark  	提交四个体验报告信息
- (void)handInFourPageInfoWithParams:(NSDictionary *)dict Success:(HandInFourPageInfo)success;
#pragma mark  	用户反馈
- (void)userFeedbackInfoWithParams:(NSDictionary *)dict Success:(FeedbackInfo)success;
@end
