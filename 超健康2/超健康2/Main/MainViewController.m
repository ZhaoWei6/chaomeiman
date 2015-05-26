//
//  MainViewController.m
//  Chaomeiman 专家端
//
//  Created by imac on 14-12-10.
//  Copyright (c) 2014年 imac. All rights reserved.
//

#import "MainViewController.h"
#import "NewsViewController.h"
#import "AccountViewController.h"
#import "AdviceViewController.h"
#import "BaseViewController.h"

#import "MobClick.h"
#import "AppDelegate.h"
@interface MainViewController ()
@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"self.view"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"self.view"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadTarbarViewController];
}


-(void)loadTarbarViewController{
    
    AccountViewController *account=[[AccountViewController alloc]init];
    BaseViewController *Account=[[BaseViewController alloc]initWithRootViewController:account];
    
    AdviceViewController *jobs=[[AdviceViewController alloc]init];
    BaseViewController *Jobs=[[BaseViewController alloc]initWithRootViewController:jobs];
    
    NewsViewController *myJobs=[[NewsViewController alloc]init];
    BaseViewController *Myjobs=[[BaseViewController alloc]initWithRootViewController:myJobs];
    
    NSArray *array=@[Myjobs,Jobs,Account];
    [self setViewControllers:array animated:YES];
    
    //背景颜色
//    self.tabBar.selectedImageTintColor = [UIColor orangeColor];
//    self.tabBar.tintColor = [UIColor orangeColor];
//    self.tabBar.translucent = YES;
//-------效果一样----------
//    self.tabBar.selectedImageTintColor = [UIColor colorWithRed:114.0/255.0 green:158.0/255.0 blue:25.0/255.0 alpha:1];
//    self.tabBar.tintColor = [UIColor colorWithRed:114.0/255.0 green:158.0/255.0 blue:25.0/255.0 alpha:1];
    
    //背景颜色
    self.tabBar.selectedImageTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"text"]];
    self.tabBar.tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"text.jpg"]];
    self.tabBar.translucent = YES;
    
    //分栏项图片
    UITabBarItem * tmp0 = [self.tabBar.items objectAtIndex:0];
    tmp0.image = [[UIImage imageNamed:@"消息1.9.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tmp0.selectedImage=[[UIImage imageNamed:@"消息2.9.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tmp0.title=@"消息";
    messageFlag=tmp0;
    if ([LoginUser sharedLoginUser].messageNum>0) {
        tmp0.badgeValue=[NSString stringWithFormat:@"%d",[LoginUser sharedLoginUser].messageNum];
    }
    else if([LoginUser sharedLoginUser].messageNum>=100)
        tmp0.badgeValue=[NSString stringWithFormat:@"100+"];
    else
        tmp0.badgeValue=nil;
    
    UITabBarItem * tmp1 = [self.tabBar.items objectAtIndex:1];
    tmp1.image = [[UIImage imageNamed:@"我的健康建议书.9.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tmp1.selectedImage=[[UIImage imageNamed:@"我的健康建议书2.9.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tmp1.title=@"我的建议书";
    
    UITabBarItem * tmp2 = [self.tabBar.items objectAtIndex:2];
    tmp2.image = [[UIImage imageNamed:@"账户1.9.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tmp2.selectedImage=[[UIImage imageNamed:@"账户2.9.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tmp2.title=@"我的账户";

}

@end
