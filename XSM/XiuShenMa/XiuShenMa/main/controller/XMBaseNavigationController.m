//
//  XMBaseNavigationController.m
//  XiuShemMa
//
//  Created by Apple on 14-10-5.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMBaseNavigationController.h"

@interface XMBaseNavigationController ()

@end

@implementation XMBaseNavigationController

/**
*  第一次使用这个类的时候会调用(1个类只会调用1次)
*/
+ (void)initialize
{
    // 1.设置导航栏主题
//    [self setupNavBarTheme];
    
    // 2.设置导航栏按钮主题
//    [self setupBarButtonItemTheme];
    
    // 3.设置状态栏样式
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

/**
 *  设置导航栏主题
 */
+ (void)setupNavBarTheme
{
    // 取出appearance对象
    UINavigationBar *navBar = [UINavigationBar appearance];
    
    // 2.设置导航栏的样式
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    NSDictionary *textAttrs = @{
//                                NSForegroundColorAttributeName : [UIColor whiteColor],
                                NSShadowAttributeName : [[NSShadow alloc] init],
                                NSFontAttributeName : [UIFont systemFontOfSize:19]
                                };
    [navBar setTitleTextAttributes:textAttrs];
    
//    navBar.barTintColor = XMColor(89, 122, 155);//背景色
//    navBar.tintColor = [UIColor whiteColor];//item颜色
}

/**
 *  设置导航栏按钮主题
 */
+ (void)setupBarButtonItemTheme
{
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    
    // 设置背景
    if (!iOS7) {
        [item setBackgroundImage:[UIImage imageWithName:@"navigationbar_button_background"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [item setBackgroundImage:[UIImage imageWithName:@"navigationbar_button_background_pushed"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
        [item setBackgroundImage:[UIImage imageWithName:@"navigationbar_button_background_disable"] forState:UIControlStateDisabled barMetrics:UIBarMetricsDefault];
    }
    
    // 设置文字属性
    NSDictionary *textAttrs = @{
//                           NSForegroundColorAttributeName : [UIColor whiteColor],
                           NSShadowAttributeName : [[NSShadow alloc] init],
                           NSFontAttributeName : [UIFont systemFontOfSize:16]
                           };
    
    
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateHighlighted];
    
    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionary];
    disableTextAttrs[NSForegroundColorAttributeName] =  kBorderColor;
    [item setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}
- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    for (UIViewController *VC in self.viewControllers) {
        if ([VC isKindOfClass:NSClassFromString(@"XMOrderStateDetailController")]) {
            //用户下单完成之后返回首页
            [self popToRootViewControllerAnimated:YES];
            return nil;
        }
    }
    return [super popViewControllerAnimated:animated];
}


@end
