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
typedef void (^RegisterBlock)(NSDictionary *deal);//
typedef void (^VerifyShopName) (NSDictionary *deal);
typedef void (^ShopPageInfo) (NSDictionary *deal);
typedef void (^CommonAddressList) (NSDictionary *deal);
typedef void (^AddCommonAddress) (NSDictionary *deal);
typedef void (^EditCommonAddress) (NSDictionary *deal);
typedef void (^DeleteCommonAddress) (NSDictionary *deal);
typedef void (^SetupShop) (NSDictionary *deal);
typedef void (^EditShopInfo) (NSDictionary *deal);
typedef void (^ShowShopDetail) (NSDictionary *deal);
typedef void (^ShowSavedShopInfo) (NSDictionary *deal);
typedef void (^FourPageInfo) (NSDictionary *deal);
typedef void (^HandInFourPageInfo) (NSDictionary *deal);
@interface XMDealTool : NSObject
singleton_interface(XMDealTool)

@property (nonatomic, strong) NSString *phone;//用户手机号
@property (nonatomic, strong) NSString *userid;//用户名
@property (nonatomic, strong) NSString *password;//密码
@property (nonatomic, strong) NSString *approve;//approve审核状态

@property (nonatomic, assign) double currentLongitude;//当前精度
@property (nonatomic, assign) double currentLatitude;//当前纬度
@property (nonatomic, copy) NSString *area;//当前地址
@property (nonatomic, copy) NSString *address;
//@property  (nonatomic,copy)NSString  *maintainerid;//修神id
@property (nonatomic, strong, readonly) NSArray *totalRepairman;//所有的iPhone修神信息
@property (nonatomic, copy) NSString *currentOrderID;//当前订单ID

@property (nonatomic, assign) int maintaincategoryid;//维修类型的id  大类
@property (nonatomic, assign) int itemcategoryid;//维修类型的id   小类
@property (nonatomic, assign) int faultcategory_id;//维修商品的故障id

#pragma mark 获得第page页的修神信息
- (void)dealsWithPage:(int)page itemCategory:(int)itemcategory orderby:(int)orderby success:(DealsSuccessBlock)success;
#pragma mark 获得修神详情信息
- (void)dealsWithMaintainerid:(NSString *)maintainer_id success:(DealsSuccessBlock)success;
#pragma mark 获得订单列表信息
- (void)orderListWith:(NSDictionary *)parma success:(DealsSuccessBlock)success;

#pragma mark 技术认证
- (void)dealSuccess:(NSString *)maintainer_id  success:(DevoteBlock)success;
#pragma mark 高德地图页(坐标点)
- (void)repairmansFromUserAddressSuccess:(DealsSuccessBlock)success;

#pragma mark 修神评价列表
- (void)evaluatelistWithParams:(NSDictionary *)params success:(DealsSuccessBlock)success;


#pragma mark    注册
- (void)dealWitParams:(NSDictionary *)dic Success:(RegisterBlock)success;
#pragma mark    重置密码
- (void)resetPasswordWithParams:(NSDictionary *)params success:(RegisterBlock)success;
#pragma mark  	验证店铺名是否存在
- (void)verifyShopNameWithParams:(NSDictionary *)dict Success:(VerifyShopName)success;
#pragma mark  	获取新建店铺页面信息
- (void)getSettingShopPageInfoWithParams:(NSDictionary *)dict Success:(ShopPageInfo)success;
#pragma mark  	获取常用联系人列表
- (void)getCommonAddressListWithParams:(NSDictionary *)dict Success:(CommonAddressList)success;
#pragma mark  	添加常用联系人
- (void)addCommonAddressWithParams:(NSDictionary *)dict Success:(AddCommonAddress)success;
#pragma mark  	编辑常用联系人
- (void)editCommonAddressWithParams:(NSDictionary *)dict Success:(EditCommonAddress)success;
#pragma mark  	删除常用联系人
- (void)deleteCommonAddressWithParams:(NSDictionary *)dict Success:(DeleteCommonAddress)success;
#pragma mark  	新建店铺
- (void)setupShopWithParams:(NSDictionary *)dict Success:(SetupShop)success;
#pragma mark  	编辑店铺
- (void)editShopInfoWithParams:(NSDictionary *)dict Success:(EditShopInfo)success;
#pragma mark  	显示店铺详情
- (void)showShopDetailWithParams:(NSDictionary *)dict Success:(ShowShopDetail)success;
#pragma mark  	显示已有店铺信息
- (void)showSavedShopInfoWithParams:(NSDictionary *)dict Success:(ShowSavedShopInfo)success;
#pragma mark  	请求四个体验报告信息
- (void)requestFourPageInfoWithParams:(NSDictionary *)dict Success:(FourPageInfo)success;

#pragma mark  	提交四个体验报告信息
- (void)handInFourPageInfoWithParams:(NSDictionary *)dict Success:(HandInFourPageInfo)success;
@end
