//
//  XMBaseViewController.m
//  XiuShenMa
//
//  Created by Apple on 14/11/11.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMBaseViewController.h"
#import "XMOrderStateDetailController.h"

#import "XMLoginViewController.h"
@interface XMBaseViewController ()

@end

@implementation XMBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    kNAVITAIONBACKBUTTON
    self.view.backgroundColor = XMGlobalBg;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
//    [self initNavigationBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userAuthenticationFailed) name:@"UserAuthenticationFailed" object:nil];
}
- (void)viewWillAppear:(BOOL)animated
{
    [self initNavigationBar];
}
- (void)userAuthenticationFailed
{
//    [UserDefaults removeObjectForKey:@"userid"];
//    [UserDefaults removeObjectForKey:@"password"];
//    [UserDefaults removeObjectForKey:@"phone"];
//    [[NSNotificationCenter defaultCenter] postNotificationName:kExitSystemNote object:nil];
    
    XMLoginViewController *loginVC = [[XMLoginViewController alloc] init];
    loginVC.isModal = YES;
    XMBaseNavigationController *login = [[XMBaseNavigationController alloc] initWithRootViewController:loginVC];
    
    [self presentViewController:login animated:YES completion:nil];
}

- (void)initNavigationBar
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    NSDictionary *textAttrs = @{
//                                NSForegroundColorAttributeName : [UIColor whiteColor],
                                NSShadowAttributeName : [[NSShadow alloc] init],
                                NSFontAttributeName : [UIFont systemFontOfSize:19]
                                };
    [navBar setTitleTextAttributes:textAttrs];
    navBar.barTintColor = XMColor(248, 248, 248);//背景色
    navBar.tintColor = XMColor(113, 140, 169);//item颜色
}

- (void)dealloc
{
    [MBProgressHUD hideHUD];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
