//
//  XMDevoteController.h
//  XiuShemMa
//
//  Created by Apple on 14/10/29.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMBaseViewController.h"

@class XMDevote;
@interface XMDevoteController : XMBaseViewController
@property (nonatomic , copy ) NSString *maintainer_id;
@property(nonatomic,retain)XMDevote  *devote;

@end
