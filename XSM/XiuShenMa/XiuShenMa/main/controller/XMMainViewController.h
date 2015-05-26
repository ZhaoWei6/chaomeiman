//
//  XMMainViewController.h
//  XiuShemMa
//
//  Created by Apple on 14-10-5.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMTabBar.h"
@interface XMMainViewController : UITabBarController<XMTabBarDelegate>
//{
//    XMTabBar *myTabBar;
//}
@property (nonatomic , retain) XMTabBar *myTabBar;


@property (nonatomic , strong) NSDictionary *message;


- (void)showOrHiddenTabBarView:(BOOL)isHidden;

@end
