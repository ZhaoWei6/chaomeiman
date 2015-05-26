//
//  XMRepairDetailViewController.h
//  XiuShemMa
//
//  Created by Apple on 14-10-5.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMBaseViewController.h"

@class XMRepairmanDetail;
@interface XMRepairDetailViewController : XMBaseViewController

@property (nonatomic , retain) XMRepairmanDetail *repairman;

@property (nonatomic , copy ) NSString *maintainer_id;

@end
