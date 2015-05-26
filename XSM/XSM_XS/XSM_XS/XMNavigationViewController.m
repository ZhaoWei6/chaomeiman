//
//  XMNavigationViewController.m
//  XSM_XS
//
//  Created by Apple on 14/11/27.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMNavigationViewController.h"
#import "XMCommon.h"
@interface XMNavigationViewController ()

@end

@implementation XMNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  第一次使用这个类的时候会调用(1个类只会调用1次)
 */
+ (void)initialize
{
    // 1.设置导航栏主题
    [self setupNavBarTheme];
    
    // 2.设置导航栏按钮主题
    [self setupBarButtonItemTheme];
    
    // 3.设置状态栏样式
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

/**
 *  设置导航栏主题
 */
+ (void)setupNavBarTheme
{
    // 取出appearance对象
    UINavigationBar *navBar = [UINavigationBar appearance];
    
    // 2.设置导航栏的样式
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    NSDictionary *textAttrs = @{
                                NSForegroundColorAttributeName : [UIColor whiteColor],
                                NSShadowAttributeName : [[NSShadow alloc] init],
                                NSFontAttributeName : [UIFont boldSystemFontOfSize:20]
                                };
    [navBar setTitleTextAttributes:textAttrs];
    
    navBar.barTintColor = XMButtonBg;//背景色
    navBar.tintColor = [UIColor whiteColor];//item颜色
}

/**
 *  设置导航栏按钮主题
 */
+ (void)setupBarButtonItemTheme
{
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    
    
    // 设置文字属性
    NSDictionary *textAttrs = @{
                                NSForegroundColorAttributeName : [UIColor whiteColor],
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
            return [self popToRootViewControllerAnimated:YES][0];
        } 
    }
    return [super popViewControllerAnimated:animated];
}


@end
