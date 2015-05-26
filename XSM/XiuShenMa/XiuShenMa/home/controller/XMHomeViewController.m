//
//  XMHomeViewController.m
//  XiuShemMa
//
//  Created by Apple on 14-10-5.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMHomeViewController.h"
#import "XMHomeHeadView.h"
#import "XMRepairmanViewController.h"
#import "XMMainViewController.h"
#import "XMWebViewController.h"
#import "XMBaseNavigationController.h"

#import "XMHttpTool.h"
#import "AFNetworking.h"
#import "XMDealTool.h"

#import "XMInfoBtn.h"
#import "XMBanner.h"
#import "NSObject+Value.h"

#import "QHCustomCell.h"

@interface XMHomeViewController ()<UITableViewDataSource,UITableViewDelegate>
{
//    CLLocationManager *locationManager;//定义Manager
    
    UITableView *_tableView;
    XMHomeHeadView *_headView;
    NSArray *_array;
    NSArray *_titleArr;
    NSArray *_itemCategory;
    
    NSArray *_bannerArr;
    UIView *headView1;
}


@end

@implementation XMHomeViewController

/**
 *---品牌------itemcategory
 *--修苹果---------->2
 *--修小米---------->3
 *--修三星---------->4
 *--修微软/诺基亚---->5
 *--修华为---------->6
 *--修中兴---------->7
 *--修魅族---------->8
 *--其他手机维修----->11
 *--修联想---------->12
 *--修HTC---------->13
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"修神马";
    
    [self initTableView];
    [self requestData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickHomeHeadView:) name:@"ClickHomeHeadView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickButton:) name:@"ClickButton" object:nil];
    
    _array = @[@"修三星",@"修华为",@"修联想",@"修魅族",@"修苹果",@"修小米",@"修微软/诺基亚",@"修中兴",@"修HTC",@"其他手机维修"];
    _titleArr = @[@"三星",@"华为",@"联想",@"魅族",@"苹果",@"小米",@"winphone",@"中兴",@"HTC",@"其他手机"];
    _itemCategory = @[@4,@6,@12,@8,@2,@3,@5,@6,@13,@11];
}

- (void)initNavigationBar
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    NSDictionary *textAttrs = @{
                                NSForegroundColorAttributeName : [UIColor whiteColor],
                                NSShadowAttributeName : [[NSShadow alloc] init],
                                NSFontAttributeName : [UIFont systemFontOfSize:19]
                                };
    [navBar setTitleTextAttributes:textAttrs];
    navBar.barTintColor = XMColor(89, 122, 155);//背景色
    navBar.tintColor = [UIColor whiteColor];//item颜色
}

- (void)initTableView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-49) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    [_tableView setContentInset:UIEdgeInsetsMake(64, 0, 0, 0)];
    
    //    _tableView.estimatedRowHeight = 60;
    //    _tableView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark - 请求数据
- (void)requestData
{
    __block NSMutableArray *temp = [NSMutableArray array];
    [XMHttpTool postWithURL:@"Index/index" params:nil success:^(id json) {
        
        for (NSDictionary *dic in json[@"datalist"]) {
            XMBanner *b = [[XMBanner alloc] init];
            [b setValues:dic];
            [temp addObject:b];
        }
        _bannerArr = [NSArray arrayWithArray:temp];
        
        [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    } failure:^(NSError *error) {
        XMLog(@"失败:%@",error);
        [MBProgressHUD showError:@"网络异常"];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    switch (indexPath.row) {
        case 0:
            cell = [[QHCustomCell alloc] initWithStyle:QHCustionCellStyleBunner
                                          contentArray:_bannerArr
                                            identifier:@"QHCustionCellStyleBunner"];
            break;
        case 1:
            cell = [[QHCustomCell alloc] initWithStyle:QHCustionCellStyleMain
                                          contentArray:@[@"修三星",@"修华为",@"修联想",@"修魅族"]
                                            identifier:@"QHCustionCellStyleMain"];
            break;
            break;
        case 2:
            cell = [[QHCustomCell alloc] initWithStyle:QHCustionCellStyleHot
                                          contentArray:@[@"修苹果",@"修小米"]
                                            identifier:@"QHCustionCellStyleHot"];
            break;
        case 3:
            cell = [[QHCustomCell alloc] initWithStyle:QHCustionCellStyleDefault
                                          contentArray:@[@"修微软/诺基亚",@"修中兴",@"修HTC",@"其他手机维修"]
                                            identifier:@"QHCustionCellStyleDefault"];
            break;
        case 4:
            cell = [[QHCustomCell alloc] initWithStyle:QHCustionCellStyleOther
                                          contentArray:@[@"修锁",@"手机回收"]
                                            identifier:@"QHCustionCellStyleOther"];
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return kDeviceWidth*5/18.0f;
    }
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

#pragma mark - 通知处理
- (void)clickHomeHeadView:(NSNotification *)notification
{
    /*
    XMLog(@"notification----->%@",notification.object);
    NSInteger index = [notification.object[@"index"] integerValue];
    XMBanner *banner = _bannerArr[index];
    NSURL *urlStr = [NSURL URLWithString:banner.url];
    
    XMBaseViewController *privyVC = [[XMBaseViewController alloc] init];
    
    privyVC.title = banner.descripe;
    privyVC.view.backgroundColor = XMGlobalBg;
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, kDeviceWidth, kDeviceHeight-64)];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:urlStr];
    
    [webView loadRequest:request];
    
    [privyVC.view addSubview:webView];
    
    [self.navigationController pushViewController:privyVC animated:YES];
     */
}

- (void)clickButton:(NSNotification *)dic
{
    XMLog(@"dic---->%@",dic.object);
    NSString *str = dic.object[@"title"];
    for (int i=0; i<_array.count; i++) {
        XMRepairmanViewController *repairman = [[XMRepairmanViewController alloc] init];
        if ([str isEqualToString:_array[i]]) {
            repairman.title = [NSString stringWithFormat:@"附近的%@修神",_titleArr[i]];
            repairman.itemcategory = [_itemCategory[i] integerValue];
            if (repairman.itemcategory == 0) {
                [[[UIAlertView alloc] initWithTitle:@"提示"
                                           message:@"敬请期待"
                                          delegate:nil
                                 cancelButtonTitle:nil
                                 otherButtonTitles:@"确定", nil] show];
            }else{
                [self.navigationController pushViewController:repairman animated:YES];
            }
        }
    }
    if ([str isEqualToString:@"手机回收"]) {
        //
        [self gotoWebViewWithUrl:@"http://app.xiushenma.com/agreement/personage.html" title:@"手机回收"];
    }else if ([str isEqualToString:@"修锁"]) {
        //
        [self gotoWebViewWithUrl:@"http://app.xiushenma.com/agreement/fixlock.html" title:@"修锁"];
    }
}

- (void)gotoWebViewWithUrl:(NSString *)urlStr title:(NSString *)title
{
    XMBaseViewController *privyVC = [[XMBaseViewController alloc] init];
    
    privyVC.title = title;
    privyVC.view.backgroundColor = XMGlobalBg;
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, kDeviceWidth, kDeviceHeight-64)];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    webView.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
    [webView loadRequest:request];
    
    [privyVC.view addSubview:webView];
    
    [self.navigationController pushViewController:privyVC animated:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
- (void)viewDidLoad
{
    [super viewDidLoad];
    kNAVITAIONBACKBUTTON
    kRectEdge
    
    // 标题
    self.navigationItem.title = @"修神马";
    // 业务
    _array = @[@"修苹果",@"修小米",@"修锁",@"收二手"];
    [self loadSubViews];
}

- (void)initNavigationBar
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    NSDictionary *textAttrs = @{
                                NSForegroundColorAttributeName : [UIColor whiteColor],
                                NSShadowAttributeName : [[NSShadow alloc] init],
                                NSFontAttributeName : [UIFont systemFontOfSize:19]
                                };
    [navBar setTitleTextAttributes:textAttrs];
    navBar.barTintColor = XMColor(89, 122, 155);//背景色
    navBar.tintColor = [UIColor whiteColor];//item颜色
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 让选中单元格处于未选中
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
    // 显示底部分栏
    kShowOrHiddenTabBar(NO);
    
    mainVC.myTabBar.hidden = NO;
    if (!_bannerArr.count) {
        [self requestData];
    }
    if ([_headView isKindOfClass:[XMHomeHeadView class]] &&_bannerArr.count) {
        [self loadHeadView];
    }
}

- (void)loadSubViews
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = XMGlobalBg;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.dataSource = self;
    _tableView.backgroundColor = XMGlobalBg;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.scrollEnabled = NO;
    
    
    [self loadHeadView1];
    
    [_tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSDictionary *dict = NSDictionaryOfVariableBindings(_tableView);
    NSDictionary *metrics = @{@"hpad":@0};
    NSString *vfl0 = @"H:|-hpad-[_tableView]-hpad-|";
    NSString *vfl1 = @"V:|-hpad-[_tableView]-hpad-|";
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl0 options:0 metrics:metrics views:dict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl1 options:0 metrics:metrics views:dict]];
    
    _tableView.contentInset = UIEdgeInsetsMake( 64, 0, 0, 0);
    //设置单元格高度
    _tableView.rowHeight = kInfoButtonHeightStyle1*2+6;
}
#pragma mark - 请求数据
- (void)requestData
{
    __block NSMutableArray *temp = [NSMutableArray array];
    [XMHttpTool postWithURL:@"Index/index" params:nil success:^(id json) {
        
        for (NSDictionary *dic in json[@"datalist"]) {
            XMBanner *b = [[XMBanner alloc] init];
            [b setValues:dic];
            [temp addObject:b];
        }
        _bannerArr = [NSArray arrayWithArray:temp];
        [headView1 removeFromSuperview];
        headView1 = nil;
        [self loadHeadView];
    } failure:^(NSError *error) {
        XMLog(@"失败:%@",error);
        [MBProgressHUD showError:@"网络异常"];
    }];
}

- (void)loadHeadView1
{
    headView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kHomeHeadViewHeight)];
    headView1.backgroundColor = [UIColor whiteColor];
    _tableView.tableHeaderView = headView1;
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(kDeviceWidth/2-20, kHomeHeadViewHeight/2-20, 40, 40);
    [headView1 addSubview:indicator];
    [indicator startAnimating];
}
#pragma mark - 顶部轮播
//加载轮播
- (void)loadHeadView
{
    // 设置轮播内容区的图片
    NSMutableArray *viewsArray = [@[] mutableCopy];
    NSMutableArray *titlesArray = [@[] mutableCopy];
    
    for (int i = 0; i < kPhotoNumber; ++i) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kHomeHeadViewHeight)];
        imageView.contentMode = UIViewContentModeScaleToFill;
        XMBanner *ban = _bannerArr[i];
        [imageView setImageWithURL:[NSURL URLWithString:ban.banner] placeholderImage:[UIImage imageNamed:@"banner_register"]];
        [viewsArray addObject:imageView];
        [titlesArray addObject:ban.descripe];
    }
    // 实例化轮播对象(初始化frame与轮播间隔)
    _headView = [[XMHomeHeadView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kHomeHeadViewHeight) animationDuration:2];
    _headView.titles = titlesArray;
    // 设置轮播的当前页
    _headView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
        return viewsArray[pageIndex];
    };
    // 设置轮播总页数
    _headView.totalPagesCount = ^NSInteger(void){
        return kPhotoNumber;
    };
    // 设置代理
    _headView.delegatee = self;
    _tableView.tableHeaderView = _headView;
}


#pragma mark 表格DataSource方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_array.count%4 == 0){
        return _array.count/4;
    }else{
        return _array.count/4+1;
    }
}

int cellCount = 0;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    for (int i=0; i<4; i++) {
        //实例化一个按钮
        XMInfoBtn *button = [[XMInfoBtn alloc] init];
        //设置按钮的frame
        if (i==0) {
            button.frame = CGRectMake(7, 7, kInfoButtonWidth, kInfoButtonHeightStyle1);
            [button setImage:[UIImage imageNamed:@"icon_home_iphone"] forState:UIControlStateNormal];
        }else if (i == 1){
            button.frame = CGRectMake(kInfoButtonWidth+14, 7, kInfoButtonWidth, kInfoButtonHeightStyle1);
            [button setImage:[UIImage imageNamed:@"icon_home_xiaomi"] forState:UIControlStateNormal];
        }else if (i == 2){
            button.frame = CGRectMake(7, kInfoButtonHeightStyle1+14, kInfoButtonWidth, kInfoButtonHeightStyle1);
            [button setImage:[UIImage imageNamed:@"icon_home_clock"] forState:UIControlStateNormal];
        }else{
            button.frame = CGRectMake(kInfoButtonWidth+14, kInfoButtonHeightStyle1+14, kInfoButtonWidth, kInfoButtonHeightStyle1);
            [button setImage:[UIImage imageNamed:@"icon_home_recycle"] forState:UIControlStateNormal];
        }
        button.backgroundColor = [UIColor whiteColor];
        if(cellCount*4+i>=_array.count){
            return cell;
        }
        //设置按钮标题
        NSString *str = _array[cellCount*4+i];
        [button setTitle:str forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        //
        button.layer.borderColor = kBorderColor.CGColor;
        button.layer.borderWidth = 0.5;
        //设置按钮tag值
        button.tag = indexPath.row*4+i;
        //给按钮添加事件
        [button addTarget:self action:@selector(infoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:button];
    }
    cell.backgroundColor = XMGlobalBg;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cellCount++;
    return cell;
}

#pragma mark - 点击按钮进入不同的二级菜单
- (void)infoButtonClick:(UIButton *)button
{
    if ([button.titleLabel.text isEqualToString:@"修苹果"]) {
        XMRepairmanViewController *repairman = [[XMRepairmanViewController alloc] init];
        repairman.title = @"附近的苹果修神";
        repairman.itemcategory = 2;
        
        [self.navigationController pushViewController:repairman animated:YES];
    }else if ([button.titleLabel.text isEqualToString:@"修锁"]){
        XMRepairmanViewController *repairman = [[XMRepairmanViewController alloc] init];
        repairman.title = @"附近的修锁大神";
        [self.navigationController pushViewController:repairman animated:YES];
    }else if ([button.titleLabel.text isEqualToString:@"修小米"]){
        XMRepairmanViewController *repairman = [[XMRepairmanViewController alloc] init];
        repairman.title = @"附近的小米修神";
        repairman.itemcategory = 3;
        [self.navigationController pushViewController:repairman animated:YES];
    }else if ([button.titleLabel.text isEqualToString:@"收二手"]){
        [[[UIAlertView alloc] initWithTitle:@"提示"
                                   message:@"敬请期待"
                                  delegate:nil
                         cancelButtonTitle:@"确定"
                         otherButtonTitles:nil, nil] show];
    }
}

#pragma mark _headView的delegate方法
- (void)contentViewClick:(NSInteger)index
{
    // 设置轮播图片对应的url
    XMBanner *b = _bannerArr[index];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:b.url]];
    XMWebViewController *webVC = [[XMWebViewController alloc] init];
    webVC.url = b.url;
    [self.navigationController pushViewController:webVC animated:YES];
}
*/

@end


