//
//  TGDealTool.m
//  团购
//
//  Created by app04 on 14-7-26.
//  Copyright (c) 2014年 app04. All rights reserved.
//

#import "XMDealTool.h"
#import "NSObject+Value.h"
#import "XMHttpTool.h"
#import "XMRepairman.h"
#import "XMCommon.h"
//#import "XMContacts.h"
#import "XMRepairmanDetail.h"
#import "XMOrder.h"
#import "XMDevote.h"
#import "XMMap.h"
#import "XMRatingRepair.h"

typedef void (^RequestBlock)(id result, NSError *errorObj);//保存接收请求成功和失败的数据

@implementation XMDealTool
singleton_implementation(XMDealTool)

- (id)init
{
    if (self = [super init]) {
        //        NSMutableDictionary *_blocks;//键-->请求的地址值  值-->block语句块，包括成功和失败的处理
    }
    return self;
}

#pragma mark 获得第page页的修神数据
- (void)dealsWithPage:(int)page itemCategory:(int)itemcategory orderby:(int)orderby success:(DealsSuccessBlock)success
{
    // 1.封装请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    // 添加页码参数
    [params setObject:@(page) forKey:@"page"];
    // 添加用户精度
    [params setObject:@(self.currentLongitude) forKey:@"longitude"];
    // 添加用户纬度
    [params setObject:@(self.currentLatitude) forKey:@"latitude"];
    // 添加商品分类
    [params setObject:@(itemcategory) forKey:@"itemcategory_id"];
    // 添加排序
    [params setObject:@(orderby) forKey:@"orderby"];
    XMLog(@"请求参数-->%@",params);
    // 2.发送请求
    @try {
        [XMHttpTool postWithURL:@"Maintainer/lists" params:params success:^(id json) {
            if (([json[@"status"] integerValue] == 1) && json[@"datalist"]!=[NSNull null]) {
                //修神信息
                NSArray *array = json[@"datalist"];
                if (!([array isKindOfClass:[NSArray class]]&&array.count)) {
                    return ;
                }
                XMLog(@"===%@",json);
                NSMutableArray *deals = [NSMutableArray array];
                for (NSDictionary *dict in array) {
                    XMRepairman *d = [[XMRepairman alloc] init];
                    [d setValues:dict];
                    [deals addObject:d];
                }
                _maintaincategoryid = [json[@"maintaincategory_id"] intValue];
                _faultcategory_id = [json[@"faultcategory_id"] intValue];
                XMLog(@"修神id=%i%i",[json[@"maintaincategory_id"] intValue],[json[@"faultcategory_id"] intValue]);
                int i = [json[@"islast"] intValue];//islast=1 是最后一页，=0 不是最后一页
                success(deals,i);
            }else{
                XMLog(@"请求失败");
            }
        } failure:^(NSError *error) {
            XMLog(@"失败%@",error);
            [[NSNotificationCenter defaultCenter] postNotificationName:kNetWorkAnomalies object:nil];
        }];
    }
    @catch (NSException *exception) {
        NSLog(@"Caught%@%@", [exception name], [exception reason]);
    }
    @finally {
        
    }
}
#pragma mark 获得修神详情信息
- (void)dealsWithMaintainerid:(NSString *)maintainer_id success:(DealsSuccessBlock)success
{
    XMLog(@"%@",maintainer_id);
    
    NSDictionary *params = [NSDictionary dictionary];
    if (self.userid && self.password) {
        params = @{@"maintainer_id":maintainer_id,
                   @"userid":self.userid,
                   @"password":self.password};
    }else{
        params = @{@"maintainer_id":maintainer_id};
    }
    [XMHttpTool postWithURL:@"Maintainer/detail" params:params success:^(id json) {
        if ([json[@"status"] integerValue] == 1) {
            XMLog(@"params = %@",params);
            NSDictionary *dict = json;
            XMLog(@"json === %@",json);
            NSMutableArray *deals = [NSMutableArray array];
            XMRepairmanDetail *repairDetail = [[XMRepairmanDetail alloc] init];
            [repairDetail setValues:dict];
            [deals addObject:repairDetail];
            if (json[@"iscollection"]==[NSNull null] || [json[@"iscollection"] integerValue]==0) {
                success(deals,0);
            }else{
                success(deals,1);
            }
        }else{
            XMLog(@"修神不存在，或参数错误");
        }
    } failure:^(NSError *error) {
        XMLog(@"失败");
        [[NSNotificationCenter defaultCenter] postNotificationName:kNetWorkAnomalies object:nil];
    }];
}


#pragma mark 获得订单列表信息
- (void)orderListWith:(NSDictionary *)parma success:(DealsSuccessBlock)success
{
    NSDictionary *params = @{@"userid":self.userid,
                             @"password":self.password,
                             @"page":parma[@"page"],
                             @"type":parma[@"type"]
                             };
    
    XMLog(@"请求参数-->%@",params);
    [XMHttpTool postWithURL:@"Maintainers/orderlist"
                     params:params
                    success:^(id json) {
                        
                        
                        XMLog(@"-------订单列表数据=>%@",json);
                        
                        
                        if ([json[@"status"] integerValue] == 1) {
                            NSArray *orders = json[@"orderlist"];
                            NSMutableArray *temp = [NSMutableArray array];
                            if ([orders isKindOfClass:[NSArray class]] && orders.count) {
                                for (NSDictionary *dic in orders) {
                                    XMOrder *o = [[XMOrder alloc] init];
                                    [o setValues:dic];
                                    [temp addObject:o];
                                }
                                int i = [json[@"islast"] intValue];//islast=1 是最后一页，=0 不是最后一页
                                success(temp,i);
                            }else{
                                success(nil,1);
                            }
                        }else{
                            XMLog(@"订单列表获取失败");
                        }
                    }
                    failure:^(NSError *error) {
                        XMLog(@"error=%@",error);
                        [[NSNotificationCenter defaultCenter] postNotificationName:kNetWorkAnomalies object:nil];
                    }];
}



#pragma mark   技术认证
-(void)dealSuccess:(NSString *)maintainer_id  success:(DevoteBlock)success{
    
    NSDictionary  *param=@{@"maintainer_id":maintainer_id};
    [XMHttpTool  postWithURL:@"Maintainer/techcer" params:param success:^(id json) {
        if ([json[@"status"] integerValue]==1) {
            NSDictionary *dic = json;
            XMLog(@"jishurenzheng=%@",json);
            XMDevote  *devote=[[XMDevote alloc]init];
            [devote setValues:dic];
            NSDictionary *dict = @{@"dictionary":devote};
            success(dict);
        }
    } failure:^(NSError *error) {
        XMLog(@"技术认证%@",error);
    }];
}

#pragma mark 高德地图页(坐标点)
- (void)repairmansFromUserAddressSuccess:(DealsSuccessBlock)success
{
    [XMHttpTool postWithURL:@"Maintainer/map"
                     params:@{@"longitude":@(self.currentLongitude),
                              @"latitude":@(self.currentLatitude),
                              @"itemcategory_id":@(self.itemcategoryid)
                              }
                    success:^(id json) {
                        if ([json[@"status"] integerValue] == 1) {
                            XMLog(@"%@",json);
                            NSArray *mainlist = json[@"mainlist"];
                            NSMutableArray  *deals=[NSMutableArray array];
                            if ([mainlist isKindOfClass:[NSArray class]] && mainlist.count) {
                                for (NSDictionary  *dict in mainlist) {
                                    XMMap *map=[[XMMap alloc]init];
                                    [map setValues:dict];
                                    [deals addObject:map];
                                }
                            }
                            
                            success(deals,1);
                        }else{
                            XMLog(@"获取失败");
                        }
                    }
                    failure:^(NSError *error) {
                        
                        XMLog(@"error=%@",[error description]);
                        [[NSNotificationCenter defaultCenter] postNotificationName:kNetWorkAnomalies object:nil];
                    }];
}


#pragma mark 修神评价列表
- (void)evaluatelistWithParams:(NSDictionary *)params success:(DealsSuccessBlock)success
{
    [XMHttpTool postWithURL:@"Maintainer/evaluatelist" params:params success:^(id json)
     {
         if (([json[@"status"] integerValue] == 1) && json[@"datalist"]!=[NSNull null]) {
             //修神信息
             NSArray *array = json[@"evaluatelist"];
             
             XMLog(@"===%@",json);
             NSMutableArray *deals = [NSMutableArray array];
             for (NSDictionary *dict in array) {
                 XMRatingRepair *d = [[XMRatingRepair alloc] init];
                 [d setValues:dict];
                 [deals addObject:d];
             }
             int i = [json[@"islast"] intValue];//islast=1 是最后一页，=0 不是最后一页
             success(deals,i);
         }else{
             XMLog(@"请求失败");
         }
     } failure:^(NSError *error)
     {
         XMLog(@"error=%@",[error description]);
         [[NSNotificationCenter defaultCenter] postNotificationName:kNetWorkAnomalies object:nil];
     }];
}

#pragma mark  	注册页面
-(void)dealWitParams:(NSDictionary *)dic Success:(RegisterBlock)success{
    
    [XMHttpTool  postWithURL:@"register/registered" params:dic success:^(id json) {
        
        XMLog(@"注册信息%@",json);
        success(json);
    } failure:^(NSError *error) {
        XMLog(@"注册失败-->%@",error);
    }];
}

#pragma mark    重置密码
- (void)resetPasswordWithParams:(NSDictionary *)params success:(RegisterBlock)success
{
    [XMHttpTool  postWithURL:@"register/reset" params:params success:^(id json) {
        
        XMLog(@"重置密码%@",json);
        success(json);
        
    } failure:^(NSError *error) {
        XMLog(@"重置密码失败-->%@",error);
    }];
}

#pragma mark  	上传店铺名，并验证是否存在
- (void)verifyShopNameWithParams:(NSDictionary *)dict Success:(VerifyShopName)success
{
    
    [XMHttpTool  postWithURL:@"Addshop/submitshopname" params:dict success:^(id json) {
        
        XMLog(@"上传店铺名，并验证是否存在%@",json);
        success(json);
    } failure:^(NSError *error) {
        XMLog(@"错误原因：%@",error);
    }];
}

#pragma mark  	获取新建店铺页面信息
- (void)getSettingShopPageInfoWithParams:(NSDictionary *)dict Success:(ShopPageInfo)success
{
    
    [XMHttpTool  postWithURL:@"Addshop/getinfoall" params:dict success:^(id json) {
        
        XMLog(@"获取新建店铺页面信息%@",json);
        success(json);
    } failure:^(NSError *error) {
        XMLog(@"错误原因：%@",error);
    }];
}

#pragma mark  	获取常用联系人列表set
- (void)getCommonAddressListWithParams:(NSDictionary *)dict Success:(CommonAddressList)success
{
    
    [XMHttpTool  postWithURL:@"Maintaineraddress/address" params:dict success:^(id json) {
        
        XMLog(@"获取常用联系人列表%@",json);
        success(json);
    } failure:^(NSError *error) {
        XMLog(@"错误原因：%@",error);
    }];
}

#pragma mark  	添加常用联系人
- (void)addCommonAddressWithParams:(NSDictionary *)dict Success:(AddCommonAddress)success
{
    
    [XMHttpTool  postWithURL:@"Maintaineraddress/addressadd" params:dict success:^(id json) {
        
        XMLog(@"添加常用联系人%@",json);
        success(json);
    } failure:^(NSError *error) {
        XMLog(@"错误原因：%@",error);
    }];
}

#pragma mark  	编辑常用联系人
- (void)editCommonAddressWithParams:(NSDictionary *)dict Success:(EditCommonAddress)success
{
    [XMHttpTool  postWithURL:@"Maintaineraddress/resetaddress" params:dict success:^(id json) {
        
        XMLog(@"编辑常用联系人%@",json);
        success(json);
    } failure:^(NSError *error) {
        XMLog(@"错误原因：%@",error);
    }];
}

#pragma mark  	删除常用联系人
- (void)deleteCommonAddressWithParams:(NSDictionary *)dict Success:(DeleteCommonAddress)success
{
    [XMHttpTool  postWithURL:@"Maintaineraddress/deladdress" params:dict success:^(id json) {
        
        XMLog(@"删除常用联系人%@",json);
        success(json);
    } failure:^(NSError *error) {
        XMLog(@"错误原因：%@",error);
    }];
}

#pragma mark  	新建店铺
- (void)setupShopWithParams:(NSDictionary *)dict Success:(SetupShop)success
{
    [XMHttpTool  postWithURL:@"Addshop/add_Identity_info" params:dict success:^(id json) {
        
        XMLog(@"新建店铺%@",json);
        success(json);
    } failure:^(NSError *error) {
        XMLog(@"错误原因：%@",error);
    }];
}

#pragma mark  	编辑店铺
- (void)editShopInfoWithParams:(NSDictionary *)dict Success:(EditShopInfo)success
{
    [XMHttpTool  postWithURL:@"Addshop/updata_Identity_info" params:dict success:^(id json) {
        
        XMLog(@"编辑店铺%@",json);
        success(json);
    } failure:^(NSError *error) {
        XMLog(@"错误原因：%@",error);
    }];
}


#pragma mark  	显示店铺详情
- (void)showShopDetailWithParams:(NSDictionary *)dict Success:(ShowShopDetail)success
{
    [XMHttpTool  postWithURL:@"Maintainer/detail" params:dict success:^(id json) {
        
        XMLog(@"显示店铺详情%@",json);
        success(json);
    } failure:^(NSError *error) {
        XMLog(@"错误原因：%@",error);
    }];
}

#pragma mark  	显示已有店铺信息
- (void)showSavedShopInfoWithParams:(NSDictionary *)dict Success:(ShowSavedShopInfo)success
{
    [XMHttpTool  postWithURL:@"Addshop/show_Identity_info" params:dict success:^(id json) {
        
        XMLog(@"显示已有店铺信息详情%@",json);
        success(json);
    } failure:^(NSError *error) {
        XMLog(@"错误原因：%@",error);
    }];
}

#pragma mark  	请求四个体验报告信息
- (void)requestFourPageInfoWithParams:(NSDictionary *)dict Success:(FourPageInfo)success
{
    [XMHttpTool  postWithURL:@"Appupdatelog/getupdatelog" params:dict success:^(id json) {
        
        XMLog(@"请求四个体验报告信息%@",json);
        success(json);
    } failure:^(NSError *error) {
        XMLog(@"错误原因：%@",error);
    }];
}


#pragma mark  	提交四个体验报告信息
- (void)handInFourPageInfoWithParams:(NSDictionary *)dict Success:(HandInFourPageInfo)success
{
    [XMHttpTool  postWithURL:@"Updatelog/voting" params:dict success:^(id json) {
        
        XMLog(@"提交四个体验报告信息%@",json);
        success(json);
    } failure:^(NSError *error) {
        XMLog(@"错误原因：%@",error);
    }];
}

@end
