//
//  XMOrderViewController.h
//  XiuShemMa
//
//  Created by Apple on 14-10-5.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMBaseViewController.h"

//@class XMOrderDetail;
@interface XMOrderListViewController : XMBaseViewController<UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) NSMutableArray *totalOrderDetail;//所有的订单信息

@end
