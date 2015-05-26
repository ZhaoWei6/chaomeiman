//
//  XMMainViewController.m
//  XiuShemMa
//
//  Created by Apple on 14-10-5.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMMainViewController.h"
#import "XMBaseNavigationController.h"
#import "XMHomeViewController.h"
#import "XMOrderListViewController.h"
#import "XMMineViewController.h"
#import "JHFeedBackViewController.h"

@interface XMMainViewController ()
//添加子控制器
- (void)loadSubControllers;
//自定义分栏
//- (void)customItem;

@end

@implementation XMMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadSubControllers];
//    [self customItem];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitSystem) name:kExitSystemNote object:nil];
}


//- (void)loadSubControllers
//{
//    XMBaseNavigationController *home = [[XMBaseNavigationController alloc] initWithRootViewController:[[XMHomeViewController alloc] init]];
//    
//    XMBaseNavigationController *order = [[XMBaseNavigationController alloc] initWithRootViewController:[[XMOrderListViewController alloc] init]];
//    
//    XMBaseNavigationController *mine = [[XMBaseNavigationController alloc] initWithRootViewController:[[XMMineViewController alloc] init]];
//    
//    NSArray *controllers = @[home,order,mine];
//    self.viewControllers = controllers;
//}

- (void)loadSubControllers
{
    XMBaseNavigationController *home = [[XMBaseNavigationController alloc] initWithRootViewController:[[XMHomeViewController alloc] init]];
    
    
    XMBaseNavigationController *order = [[XMBaseNavigationController alloc] initWithRootViewController:[[XMOrderListViewController alloc] init]];
    
    // 四格体验
    XMBaseNavigationController *feedBack = [[XMBaseNavigationController alloc] initWithRootViewController:[[JHFeedBackViewController alloc] init]];
    
    XMBaseNavigationController *mine = [[XMBaseNavigationController alloc] initWithRootViewController:[[XMMineViewController alloc] init]];

    UITabBarItem  *homeItem=[[UITabBarItem alloc]init];
    home.tabBarItem=homeItem;

    UITabBarItem  *orderItem=[[UITabBarItem alloc]init];
    order.tabBarItem=orderItem;
    
    // 四个体验Item
    UITabBarItem  *feedBackItem = [[UITabBarItem alloc]init];
    feedBack.tabBarItem = feedBackItem;

    UITabBarItem  *mineItem=[[UITabBarItem alloc]init];
    mine.tabBarItem=mineItem;
    
    homeItem.selectedImage = [[UIImage imageNamed:@"tabbar_home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeItem.image = [[UIImage imageNamed:@"tabbar_home_gray"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeItem.title = @"首页";
    
    orderItem.selectedImage = [[UIImage imageNamed:@"tabbar_order"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    orderItem.image = [[UIImage imageNamed:@"tabbar_order_gray"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    orderItem.title = @"订单";
    
    feedBackItem.selectedImage = [[UIImage imageNamed:@"tabbar_feed"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    feedBackItem.image = [[UIImage imageNamed:@"tabbar_feed_gray"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    feedBackItem.title = @"四格";
    
    mineItem.selectedImage = [[UIImage imageNamed:@"tabbar_mine"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mineItem.image = [[UIImage imageNamed:@"tabbar_mine_gray"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mineItem.title = @"我的";
    
    [homeItem setTitleTextAttributes:@{NSForegroundColorAttributeName : kTextFontColor666} forState:UIControlStateNormal];
    [homeItem setTitleTextAttributes:@{NSForegroundColorAttributeName : XMButtonBg} forState:UIControlStateSelected];
    [orderItem setTitleTextAttributes:@{NSForegroundColorAttributeName : kTextFontColor666} forState:UIControlStateNormal];
    [orderItem setTitleTextAttributes:@{NSForegroundColorAttributeName : XMButtonBg} forState:UIControlStateSelected];
    [feedBackItem setTitleTextAttributes:@{NSForegroundColorAttributeName : kTextFontColor666} forState:UIControlStateNormal];
    [feedBackItem setTitleTextAttributes:@{NSForegroundColorAttributeName : XMButtonBg} forState:UIControlStateSelected];
    [mineItem setTitleTextAttributes:@{NSForegroundColorAttributeName : kTextFontColor666} forState:UIControlStateNormal];
    [mineItem setTitleTextAttributes:@{NSForegroundColorAttributeName : XMButtonBg} forState:UIControlStateSelected];
    
    NSArray *controllers = @[home, order, feedBack, mine];
    self.viewControllers = controllers;
}

//- (void)customItem
//{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        // 1.删除默认的tab按钮
//        [self.tabBar removeFromSuperview];
//        
//        // 2.创建tabbar
//        _myTabBar = [[XMTabBar alloc] init];
//        _myTabBar.frame = self.tabBar.frame;
//        
//        _myTabBar.delegate = self;
//        
//       [self.view addSubview:_myTabBar];
//        
//        // 3.添加3个按钮
//        NSArray *array = @[@"首页",@"订单",@"我的"];
////        for (int i = 1; i<=3; i++) {
////            [_myTabBar addTabBarItem:array[i-1]];
////        }
//        NSArray *icons = @[@"icon_home_home_gray",@"icon_home_order_gray",@"icon_home_my_gray"];
//        NSArray *selectIcons = @[@"icon_home_home",@"icon_home_order",@"icon_home_my"];
//        for (int i=1; i<=3; i++) {
//            [_myTabBar addTabBarItemWithTitle:array[i-1] icon:icons[i-1] selectIcon:selectIcons[i-1]];
//        }
//        // 4.添加分隔线
//        UIView *separateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 0.5)];
//        separateView.backgroundColor = kBorderColor;
//        [_myTabBar addSubview:separateView];
//    });
//}

#pragma mark - tabbar代理方法
- (void)tabBar:(XMTabBar *)tabBar didSelectItemFrom:(NSUInteger)from to:(NSUInteger)to
{
    self.selectedIndex = to;
}


#pragma mark - 控制分栏是否隐藏
/**
 *  @param isHidden 为YES时隐藏底部分栏,NO时显示
 */
- (void)showOrHiddenTabBarView:(BOOL)isHidden
{
    [UIView animateWithDuration:0.25 animations:^{
        if (isHidden) {
            CGRect frame = _myTabBar.frame;
            frame.origin.x -= frame.size.width;
            _myTabBar.frame = frame;
        }else {
            CGRect frame = _myTabBar.frame;
            frame.origin.x = 0;
            _myTabBar.frame = frame;
        }
    }];
}

#pragma mark - 退出系统
- (void)exitSystem
{
    [UserDefaults removeObjectForKey:@"userid"];
    [UserDefaults removeObjectForKey:@"password"];
    [UserDefaults removeObjectForKey:@"phone"];
}

@end
