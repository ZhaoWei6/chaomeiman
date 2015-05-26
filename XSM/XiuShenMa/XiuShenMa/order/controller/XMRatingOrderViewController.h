//
//  XMRatingOrderViewController.h
//  XiuShemMa
//
//  Created by Apple on 14/10/24.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMBaseViewController.h"

@interface XMRatingOrderViewController : XMBaseViewController{

     UIButton   *notShop;

}

@property (nonatomic , strong) NSNumber *orderID;
@property (nonatomic , assign) BOOL isIntoShop;

@end
