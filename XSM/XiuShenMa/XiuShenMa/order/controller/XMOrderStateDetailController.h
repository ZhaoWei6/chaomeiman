//
//  XMOrderStateDetailController.h
//  XiuShemMa
//
//  Created by Apple on 14/10/23.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMBaseViewController.h"

@interface XMOrderStateDetailController : XMBaseViewController


@property (nonatomic , retain) NSNumber *orderID;

@property (nonatomic , assign) BOOL isVisit;

@property (nonatomic , assign) BOOL isOrder;//用于判断下单还是订单状态查看

@end
/*
@interface UIButton (XM)

@end
*/