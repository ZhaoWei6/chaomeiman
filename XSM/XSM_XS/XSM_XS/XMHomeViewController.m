//
//  XMHomeViewController.m
//  XSM_XS
//
//  Created by Apple on 14/11/26.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMHomeViewController.h"
#import "XMRepairmanListViewController.h"
#import "XMHomeHeadView.h"
#import "XMBanner.h"

#import "JHHomeContentView.h"

@interface XMHomeViewController ()<XMHomeHeadViewDelegate, JHHomeContentViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *bannerArr;

@property (weak, nonatomic) IBOutlet UIScrollView *baseScrollView;

@property (nonatomic, strong) JHHomeContentView *homeContentView;


@end



@implementation XMHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    JHHomeContentView *contentView = [JHHomeContentView homeContentViewWithArray:nil];
    self.homeContentView = contentView;
    contentView.delegate = self;
    
    [self.baseScrollView setFrame:self.view.bounds];
    [contentView setFrame:self.baseScrollView.bounds];
    [self.baseScrollView addSubview:contentView];

    CGSize contentsize;
    
    if (kDeviceHeight > 568) {
        contentsize = CGSizeMake(0, contentView.frame.size.height * 1.2);
    }else{
        contentsize = CGSizeMake(0, 620);
    }
    
    [self.baseScrollView setContentSize:contentsize];
    
}

#pragma mark - 
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!_bannerArr.count) {
        
        [self requestData];
        
    }
}

#pragma mark - 请求数据
- (void)requestData
{
    __block NSMutableArray *temp = [NSMutableArray array];
    [XMHttpTool postWithURL:@"Index/index" params:nil success:^(id json) {
        XMLog(@"%@",json);
        for (NSDictionary *dic in json[@"datalist"]) {
            XMBanner *b = [[XMBanner alloc] init];
            [b setValues:dic];
            [temp addObject:b];
        }
        
        _bannerArr = [NSArray arrayWithArray:temp];
        
        self.homeContentView.bannerArray = _bannerArr;
        
    } failure:^(NSError *error) {
        XMLog(@"失败:%@",error);
    }];
}

#pragma mark 点击按钮,根据按钮的标题进入不同的修神列表
/**
 *  10001:三星--4
 *  10002:华为--6
 *  10003:联想--12
 *  10004:魅族--8
 *  10005:苹果--2
 *  10006:小米--3
 *  10007:微软--5
 *  10008:中兴--7
 *  10009:HTC--13
 *  10010:其他--11
 *  10011:手机回收
 *  10012:修锁--10
 */
- (void)homeContentView:(JHHomeContentView *)homeContentView didSaveInfo:(NSInteger)info
{
    XMRepairmanListViewController *repairList = [[XMRepairmanListViewController alloc] initWithNibName:@"XMRepairmanListViewController" bundle:nil];
    if (info == 10001){  // 三星
        
        repairList.title = @"附近的三星大神";
        repairList.itemcategory = 4;
        
    }else if (info == 10002){  // 华为
        
        repairList.title = @"附近的华为大神";
        repairList.itemcategory = 6;
        
    }else if (info == 10003){  // 联想
        
        repairList.title = @"附近的联想大神";
        repairList.itemcategory = 12;
        
    }else if (info == 10004){  // 魅族
        
        repairList.title = @"附近的魅族大神";
        repairList.itemcategory = 8;
        
    }else if (info == 10005) { // 修苹果
        
        repairList.title = @"附近的苹果修神";
        repairList.itemcategory = 2;
        
    }else if (info == 10006){ // 修小米
        
        repairList.title = @"附近的小米修神";
        repairList.itemcategory = 3;
        
    }else if (info == 10007){  // 微软
        
        repairList.title = @"附近的微软大神";
        repairList.itemcategory = 5;
        
    }else if (info == 10008){  // 中兴
        
        repairList.title = @"附近的中兴大神";
        repairList.itemcategory = 7;
        
    }else if (info == 10009){  // HTC
        
        repairList.title = @"附近的HTC大神";
        repairList.itemcategory = 13;
        
    }else if (info == 10010){  // 其他手机
        
        repairList.title = @"附近的其他大神";
        repairList.itemcategory = 11;
        
    }else{
        
    }
    
    if (info == 10011) {
        
        XMBaseViewController *vc = [[XMBaseViewController alloc] init];
        UIWebView *webView = [[UIWebView alloc] init];
        
        webView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight);
        NSString *urlStr = @"http://app.xiushenma.com/agreement/personage.html";
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
        [webView setBackgroundColor:[UIColor colorWithHexString:@"#F8F8F8"]];
        [vc.view setBackgroundColor:[UIColor colorWithHexString:@"#F8F8F8"]];
        vc.navigationItem.title = @"手机回收";
        [vc.view addSubview:webView];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (info == 10012){  // 修锁
        
        
        XMBaseViewController *vc = [[XMBaseViewController alloc] init];
        UIWebView *webView = [[UIWebView alloc] init];
        
        webView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight);
        NSString *urlStr = @"http://app.xiushenma.com/agreement/fixlock.html";
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
        [webView setBackgroundColor:[UIColor colorWithHexString:@"#F8F8F8"]];
        [vc.view setBackgroundColor:[UIColor colorWithHexString:@"#F8F8F8"]];
        vc.navigationItem.title = @"修锁";
        [vc.view addSubview:webView];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        
        repairList.hidesBottomBarWhenPushed = YES;//进栈时隐藏底部分栏
        [self.navigationController pushViewController:repairList animated:YES];
        
    }
}

#pragma mark 显示隐藏底部tabbar -- 旧方法
- (void) hideTabBar:(BOOL) hidden{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0];
    for(UIView *view in self.tabBarController.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            if (hidden) {
                [view setFrame:CGRectMake(view.frame.origin.x, kDeviceHeight, view.frame.size.width, view.frame.size.height)];
            } else {
                [view setFrame:CGRectMake(view.frame.origin.x, kDeviceHeight-view.height, view.frame.size.width, view.frame.size.height)];
            }
        }
    }
    [UIView commitAnimations];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
