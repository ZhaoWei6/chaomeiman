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
#import "XMContacts.h"
#import "XMRepairmanDetail.h"
#import "XMOrderDetail.h"
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
    [XMHttpTool postWithURL:@"Maintainer/lists" params:params success:^(id json) {
        XMLog(@"json-->%@",json);
        if (([json[@"status"] integerValue] == 1) && json[@"datalist"]!=[NSNull null]) {
            //修神信息
            NSArray *array = json[@"datalist"];
            if (!([array isKindOfClass:[NSArray class]] && array.count)) {
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
            XMLog(@"lsadhfuoasf=%i%i",[json[@"maintaincategory_id"] intValue],[json[@"faultcategory_id"] intValue]);
            int i = [json[@"islast"] intValue];//islast=1 是最后一页，=0 不是最后一页
            success(deals,i);
        }else{
            XMLog(@"请求失败");
            success(@[],1);
        }
    } failure:^(NSError *error) {
        XMLog(@"失败%@",error);
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络异常"];
    }];
}
#pragma mark 获得修神详情信息
- (void)dealsWithMaintainerid:(NSString *)maintainer_id success:(DealsSuccessBlock)success
{
    XMLog(@"%@",maintainer_id);
    
    NSDictionary *params = @{};
    if (flag) {
        params = @{@"maintainer_id":maintainer_id,
                   @"userid":self.userid,
                   @"password":self.password};
    }else{
        params = @{@"maintainer_id":maintainer_id};
    }
    [MBProgressHUD showMessage:@"加载中..."];
    [XMHttpTool postWithURL:@"Maintainer/detail"
                     params:params
                    success:^(id json) {
                        [MBProgressHUD hideHUD];
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
                            [MBProgressHUD showError:@"修神不存在，或参数错误"];
                        }
                    } failure:^(NSError *error) {
                        XMLog(@"失败");
                        [MBProgressHUD hideHUD];
                        [MBProgressHUD showError:@"网络异常"];
                    }];
}
#pragma mark 获得联系人地址信息
- (void)dealsSuccess:(DealsSuccessBlock)success
{
    [XMHttpTool postWithURL:@"user/address"
                     params:@{@"userid":self.userid,@"password":self.password}
                    success:^(id json) {
                        XMLog(@"%@",json[@"datalist"]);
                        NSArray *array = json[@"datalist"];
                        NSMutableArray *deals = [NSMutableArray array];
                        for (NSDictionary *dict in array) {
                            XMContacts *d = [[XMContacts alloc] init];
                            if (dict[@"sex"]) {
                                d.sex = @"先生";
                                continue ;
                            }else{
                                d.sex = @"女士";
                                continue ;
                            }
                            [d setValues:dict];
                            [deals addObject:d];
                        }
                        success(deals,1);
                    } failure:^(NSError *error) {
                        XMLog(@"失败%@",[error localizedDescription]);
                        [MBProgressHUD hideHUD];
                        [MBProgressHUD showError:@"网络异常"];
                    }];
}
#pragma mark 预约上门
- (void)orderWithMaintainerid:(NSString *)maintainer_id itemcategoryid:(int)itemcategory_id faultcategoryid:(int)faultcategory_id success:(OrderSuccessBlock)success
{
    [XMHttpTool postWithURL:@"order/model"
                     params:@{@"userid":self.userid,
                              @"password":self.password,
                              @"maintainer_id":maintainer_id,
                              @"maintaintcategory_id":@(_maintaincategoryid),
                              @"itemcategory_id":@(itemcategory_id),
                              @"faultcategory_id":@(faultcategory_id)
                              }
                    success:^(id json) {
                        XMLog(@"%i",itemcategory_id);
                        XMLog(@"json=%@",json);
                        NSArray *item = json[@"item"];
                        NSArray *attributecategory = json[@"attributecategory"];
                        NSArray *faultcategory = json[@"faultcategory"];
                        XMLog(@"%@--------------------",faultcategory);
                        success(item,attributecategory,faultcategory);
                        
                    } failure:^(NSError *error) {
                        XMLog(@"error%@",error);
                        [MBProgressHUD hideHUD];
                        [MBProgressHUD showError:@"网络异常"];
                    }];
}

#pragma mark 进店订单
- (void)orderWithMaintainerid:(NSString *)maintainer_id itemcategoryid:(NSInteger)itemcategory_id servicecategoryid:(int)servicecategory_id success:(OrderBlock)success
{
    NSDictionary *params = @{@"userid":self.userid,
                             @"password":self.password,
                             @"maintainer_id":maintainer_id,
                             @"maintaincategory_id":@(_maintaincategoryid),
                             @"itemcategory_id":@(itemcategory_id),
                             @"servicecategory_id":@(servicecategory_id)
                             };
    XMLog(@"提交进店订单------>%@",params);
    [XMHttpTool postWithURL:@"order/intoshop" params:params
                    success:^(id json) {
                        XMLog(@"json === %@",json);
                        if ([json[@"status"] integerValue] == 1) {
                            XMLog(@"下单成功");
                        }else{
                            XMLog(@"下单失败");
                        }
                        success(json[@"message"]);
                    } failure:^(NSError *error) {
                        XMLog(@"失败%@",error);
                        [MBProgressHUD hideHUD];
                        [MBProgressHUD showError:@"网络异常"];
                    }];
}

#pragma mark 获得订单列表信息
- (void)orderListWith:(NSDictionary *)parma success:(DealsSuccessBlock)success
{
    XMLog(@"订单列表数据------params-----%@",@{@"userid":self.userid,
                                         @"password":self.password,
                                         @"page":parma[@"page"]
                                         });
    [XMHttpTool postWithURL:@"customer/orderlist"
                     params:@{@"userid":self.userid,
                              @"password":self.password,
                              @"page":parma[@"page"]
                              }
                    success:^(id json) {
                        if ([json[@"status"] integerValue] == 1) {
                            NSArray *orders = json[@"orderlist"];
//                            NSMutableArray *temp = [NSMutableArray array];
//                            for (NSDictionary *dic in orders) {
//                                XMOrderDetail *o = [[XMOrderDetail alloc] init];
//                                [o setValues:dic];
//                                [temp addObject:o];
//                            }
                            XMLog(@"订单列表数据=%@",json);
                            int i = [json[@"islast"] intValue];//islast=1 是最后一页，=0 不是最后一页
                            success(orders,i);
                        }else{
                            success(@[],1);
                            XMLog(@"订单列表获取失败");
                        }
                    }
                    failure:^(NSError *error) {
                        XMLog(@"error=%@",error);
                        [MBProgressHUD hideHUD];
                        [MBProgressHUD showError:@"网络异常"];
                    }];
}

#pragma mark 发表评价
- (void)ratingOrderWithContent:(NSDictionary *)content success:(OrderBlock)success failure:(OrderBlock)failure
{
    NSDictionary *params = @{@"userid":self.userid,
                             @"password":self.password,
                             @"order_id":content[@"order_id"],
                             @"score":content[@"score"],
                             @"description":content[@"description"]
                             };
    [XMHttpTool postWithURL:@"order/addappraise"
                     params:params
                    success:^(id json) {
                        NSString *message = json[@"message"];
                        XMLog(@"%@===%@",params,json);
                        if ([json[@"status"] integerValue] == 1) {
                            success(message);
                        }else{
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                            [alert show];
                            
                            [alert dismissWithClickedButtonIndex:0 animated:0];
                            failure(message);
                        }
                    }
                    failure:^(NSError *error) {
                        XMLog(@"error=%@",[error description]);
                        [MBProgressHUD hideHUD];
                        [MBProgressHUD showError:@"网络异常"];
                    }];
}

#pragma mark 添加联系人地址
- (void)addContactWithContent:(NSDictionary *)content success:(AddressBlock)success failure:(OrderBlock)failure
{
    NSDictionary *params = @{@"userid":self.userid,
                             @"password":self.password,
                             @"area":content[@"area"],
                             @"address":content[@"address"],
                             @"sex":content[@"sex"],
                             @"phone":content[@"phone"],
                             @"nickname":content[@"nickname"]
                             };
    [XMHttpTool postWithURL:@"user/addressadd"
                     params:params
                    success:^(id json) {
                        NSString *message = json[@"message"];
                        //        XMLog(@"%@===%@",params,json);
                        if ([json[@"status"] integerValue] == 1) {
                            success(message,json[@"address_id"]);
                        }else{
                            failure(message);
                        }
                    } failure:^(NSError *error) {
                        XMLog(@"error=%@",[error description]);
                        [MBProgressHUD hideHUD];
                        [MBProgressHUD showError:@"网络异常"];
                    }];
}
#pragma mark 修改联系人地址
- (void)editContactWithContent:(NSDictionary *)content success:(AddressBlock)success failure:(OrderBlock)failure
{
    NSDictionary *params = @{@"userid":self.userid,
                             @"password":self.password,
                             @"address_id":content[@"address_id"],
                             @"area":content[@"area"],
                             @"address":content[@"address"],
                             @"sex":content[@"sex"],
                             @"telephone":content[@"phone"],
                             @"nickname":content[@"nickname"]
                             };
    [XMHttpTool postWithURL:@"user/resetaddress" params:params success:^(id json) {
        NSString *message = json[@"message"];
        //        XMLog(@"%@===%@",params,json);
        if ([json[@"status"] integerValue] == 1) {
            success(message,params[@"addressid"]);
        }else{
            failure(message);
        }
    } failure:^(NSError *error) {
        XMLog(@"error=%@",[error description]);
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络异常"];
    }];
}
#pragma mark 删除联系人地址
- (void)deleteContactWithContact:(NSString *)content success:(OrderBlock)success failure:(OrderBlock)failure
{
    [XMHttpTool postWithURL:@"user/deladdress"
                     params:@{@"userid":self.userid,
                              @"password":self.password,
                              @"address_id":content,
                              }
                    success:^(id json) {
                        NSString *message = json[@"message"];
                        if ([json[@"status"] integerValue] == 1) {
                            success(message);
                        }else{
                            failure(message);
                        }
                    }
                    failure:^(NSError *error) {
                        XMLog(@"error=%@",[error description]);
                        [MBProgressHUD hideHUD];
                        [MBProgressHUD showError:@"网络异常"];
                    }];
}

#pragma mark   技术认证
-(void)dealSuccess:(NSString *)maintainer_id  success:(DevoteBlock)success{
    
    NSDictionary  *param=@{@"maintainer_id":maintainer_id};
    [XMHttpTool  postWithURL:@"Maintainer/techcer"
                      params:param
                     success:^(id json) {
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
                         [MBProgressHUD hideHUD];
                         [MBProgressHUD showError:@"网络异常"];
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
                            NSArray *mainlist = json[@"mainlist"];
                            if ([mainlist isKindOfClass:[NSArray class]] && mainlist.count) {
                                NSMutableArray  *deals=[NSMutableArray array];
                                for (NSDictionary  *dict in mainlist) {
                                    XMMap *map=[[XMMap alloc]init];
                                    [map setValues:dict];
                                    [deals addObject:map];
                                }
                                success(deals,1);//有修神，返回修神
                            }else{
                                success(@[],1);//没有修神
                            }
                        }else{
                            //                                                               failure(message);
                            XMLog(@"获取失败");
                        }
                    }
                    failure:^(NSError *error) {
                        XMLog(@"error=%@",[error description]);
                        [MBProgressHUD hideHUD];
                        [MBProgressHUD showError:@"网络异常"];
                    }];
}

#pragma mark 高德地图(点击坐标点后显示的修神内容)
- (void)repairmanWithMaintainerid:(int)maintainer_id success:(DevoteBlock)success
{
    [XMHttpTool postWithURL:@"Maintainer/map"
                     params:@{@"maintainer_id":@(maintainer_id),
                              @"longitude":@(self.currentLongitude),
                              @"latitude":@(self.currentLatitude),
                              @"itemcategory_id":@(self.itemcategoryid)}
                    success:^(id json) {
                        if ([json[@"status"] integerValue] == 1) {
                            NSDictionary *maintainer = json[@"maintainer"];
                            success(maintainer);
                        }else{
                            XMLog(@"获取失败");
                        }
                    } failure:^(NSError *error) {
                        XMLog(@"error=%@",[error description]);
                        [MBProgressHUD hideHUD];
                        [MBProgressHUD showError:@"网络异常"];
                    }];
}

#pragma mark 修神评价列表
- (void)evaluatelistWithPage:(int)page maintainerid:(NSString *)maintainer_id success:(DealsSuccessBlock)success
{
    [XMHttpTool postWithURL:@"Maintainer/evaluatelist"
                     params:@{@"page":@(page),
                              @"maintainer_id":maintainer_id
                              }
                    success:^(id json)
     {
         XMLog(@"jspn-->%@",json);
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
         [MBProgressHUD hideHUD];
         [MBProgressHUD showError:@"网络异常"];
     }];
}

#pragma mark  修神收藏列表页

-(void)dealWithPage:(int)page  success:(MineBlock)success{
    
    NSDictionary  *parm=@{@"userid":self.userid,@"password":self.password,@"page":@(page)};
    
    [XMHttpTool postWithURL:@"user/collection" params:parm success:^(id json) {
        if ([json[@"status"] integerValue]==1) {
            
            NSArray *deals=json[@"datalist"];
            
            int  i=[json[@"islast"] intValue];
            XMLog(@"shoucangxiushenliebiao=%@",json);
            success(deals,i);
            
        }
        
        
    } failure:^(NSError *error) {
        XMLog(@"请求失败");
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络异常"];
    }];
}

#pragma mark  删除已经收藏的修神
-(void)deleteWithContent:(NSString *)content success:(DeleMineBlock )success  failure:(DeleMineBlock)failure{
    
    [XMHttpTool postWithURL:@"user/delcollection" params:@{@"userid":self.userid,@"password":self.password,@"maintainer_id":content} success:^(id json) {
        NSString *message = json[@"message"];
        if ([json[@"status"] integerValue] == 1) {
            success(message);
            
        }else{
            failure(message);
        }
    } failure:^(NSError *error) {
        XMLog(@"请求失败");
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络异常"];
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

#pragma mark  	用户反馈
- (void)userFeedbackInfoWithParams:(NSDictionary *)dict Success:(FeedbackInfo)success
{
    [XMHttpTool  postWithURL:@"Updatelog/adviced" params:dict success:^(id json) {
        
        XMLog(@"用户反馈%@",json);
        success(json);
    } failure:^(NSError *error) {
        XMLog(@"错误原因：%@",error);
    }];
}

@end
