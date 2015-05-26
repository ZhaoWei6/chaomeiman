//
//  XMPrepareSubmitController.h
//  XiuShemMa
//
//  Created by Apple on 14/10/22.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMPrepareSubmitController : UIViewController<UIViewControllerTransitioningDelegate>

@property (nonatomic , assign) BOOL isVisit;

//@property (nonatomic , retain) NSDictionary *orderDetail;
@property (nonatomic , retain) NSDictionary *orderDic;

@property (nonatomic , assign) BOOL isOtherMobile;

@end
