//
//  XMOrderViewController.m
//  XiuShemMa
//
//  Created by Apple on 14-10-5.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMOrderListViewController.h"
#import "XMMainViewController.h"
#import "XMBaseNavigationController.h"
#import "XMOrderStateDetailController.h"
#import "XMLoginViewController.h"

#import "MJRefresh.h"

#import "XMOrderDetailCell.h"
#import "XMShopOrderViewController.h"
#import "XMRatingOrderViewController.h"
#import "XMExpressViewController.h"
#import "XMReportViewController.h"
#import "XMDealTool.h"
#import "XMOrderListCell.h"
//#import "ModalAnimation.h"
@interface XMOrderListViewController ()<UITableViewDataSource,UITableViewDelegate,XMOrderRatingDelegate,MJRefreshBaseViewDelegate>
{
    UITableView *_tableView;
    int line;
    
    int _page; // 页码
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
    
//    ModalAnimation *_modalAnimationController;
}
@end

@implementation XMOrderListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"当前订单";
   
    [self loadSubViews];
//    _modalAnimationController = [[ModalAnimation alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshOrder) name:kOrderStateChange object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadSubViews) name:kExitSystemNote object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadSubViews) name:kLoginSuccessNote object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[self.tabBarController.tabBar selectedItem] setBadgeValue:nil];
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

- (void)loadSubViews
{
    self.view.backgroundColor = XMGlobalBg;
    if (self.view.subviews.count) {
        for (UIView *subView in self.view.subviews) {
            [subView removeFromSuperview];
        }
    }
    //当用户处于未登录状态时,提示用户登录
    if (!flag) {
        self.view.backgroundColor = XMGlobalBg;
        
        UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake((kDeviceWidth-135)/2, kDeviceHeight/3-135/2.0, 135, 135)];
        [bg setImage:[UIImage imageNamed:@"logo"]];
        [self.view addSubview:bg];
        
        QHLabel *remindLabel = [[QHLabel alloc] init];
        remindLabel.backgroundColor = [UIColor clearColor];
        remindLabel.frame = CGRectMake(0, bg.bottom+50, kDeviceWidth, 20);
        remindLabel.font = [UIFont systemFontOfSize:20];
        remindLabel.textAlignment = NSTextAlignmentCenter;
        remindLabel.text = @"您当前还没有登录修神马";
        remindLabel.textColor = kTextFontColor333;
        [self.view addSubview:remindLabel];
        
        UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        loginButton.frame = CGRectMake(20, remindLabel.bottom+15, kDeviceWidth-40, kUIButtonHeight);
        [loginButton setTitle:@"立即登录" forState:UIControlStateNormal];
        loginButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        loginButton.backgroundColor = XMButtonBg;
        loginButton.layer.cornerRadius = 5;
        [loginButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:loginButton];
        
        self.navigationItem.rightBarButtonItem = nil;
    }else{
        [self loadOrder];
        [self addRefresh];
        
        [_header beginRefreshing];
    }
}

- (void)loadOrder
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kDeviceWidth, kDeviceHeight-49-64) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = XMGlobalBg;
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 100;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.contentInset = UIEdgeInsetsZero;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    self.editButtonItem.title = @"编辑";
//    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark 添加刷新控件
- (void)addRefresh
{
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = _tableView;
    header.delegate = self;
    _header = header;
    
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = _tableView;
    footer.delegate = self;
    _footer = footer;
}

- (void)refreshOrder
{
    [_header beginRefreshing];
}
#pragma mark - 刷新代理方法
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    BOOL isHeader = [refreshView isKindOfClass:[MJRefreshHeaderView class]];
    if (isHeader) { // 下拉刷新
        // 清除图片缓存
//        [XMImageTool clear];
        _page = 1; // 第一页
    } else { // 上拉加载更多
        _page++;
//        [XMImageTool clear];
    }
    XMLog(@"-------------------当前是第%i页订单",_page);
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(endRefreshList) userInfo:nil repeats:NO];
    
    [[XMDealTool sharedXMDealTool] orderListWith:@{@"page":@(_page),
                                                   @"pagecount":@(10)
                                                   } success:^(NSArray *deals, int islast) {
        if ([deals isKindOfClass:[NSArray class]] && deals.count) {
            
            [timer invalidate];
            
            [self removeImage];
            
            if (isHeader) {
                _totalOrderDetail = [NSMutableArray array];
            }
            // 1.添加数据
            [_totalOrderDetail addObjectsFromArray:deals];
            [_tableView reloadData];
            [refreshView endRefreshing];
            // 2.刷新表格
//            [_tableView performSelector:@selector(reloadData) withObject:nil afterDelay:1];
            
            // 3.恢复刷新状态
//            [refreshView performSelector:@selector(endRefreshing) withObject:nil afterDelay:1];
            
            _footer.hidden = islast;
        }else{
            [refreshView endRefreshing];
            _footer.hidden = YES;
            [self removeImage];
            [self showOerderNone];
        }
    }];
}

- (void)endRefreshList
{
    [_header endRefreshing];
    [_footer endRefreshing];
    [MBProgressHUD showError:@"网络不给力！"];
}

#pragma mark - 没订单
- (void)showOerderNone
{
    _tableView.hidden = YES;
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64+44, kDeviceWidth, kDeviceHeight-64-44-49)];
    [image setImage:[UIImage imageNamed:@"order_none"]];
    image.tag = 101;
    image.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:image];
}
- (void)removeImage
{
    _tableView.hidden = NO;
    UIImageView *image = (UIImageView *)[self.view viewWithTag:101];
    if (image) {
        [image removeFromSuperview];
    }
}

#pragma mark 表格方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _totalOrderDetail.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XMOrderDetailCell *cell = [[XMOrderDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.delegate = self;
    
    
    cell.orderDetail = _totalOrderDetail[indexPath.section];
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

//点击单元格
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *o = _totalOrderDetail[indexPath.section];
    if ([o[@"servicecategory_id"] intValue] == 1) {
        //上门
        XMOrderStateDetailController *detailVC = [[XMOrderStateDetailController alloc] init];
        detailVC.orderID = o[@"id"];
        [self.navigationController pushViewController:detailVC animated:YES];
    }else if ([o[@"servicecategory_id"] intValue] == 2){
        //进店
        XMLog(@"寄修");
//        kShowOrHiddenTabBar(YES)
    }else{
        XMLog(@"进店");
        XMShopOrderViewController *shopVC = [[XMShopOrderViewController alloc] init];
        shopVC.title = o[@"shop"];
        shopVC.orderID = o[@"id"];
        [self.navigationController pushViewController:shopVC animated:YES];
        kShowOrHiddenTabBar(YES)
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return FLT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}

//设置编辑非编辑状态
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    if (_tableView.editing) {
        [_tableView setEditing:NO animated:YES];
//        self.editButtonItem.title = @"编辑";
    }else {
        [_tableView setEditing:YES animated:YES];
//        self.editButtonItem.title = @"完成";
    }
}

// 设置单元格编辑的样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{

//    XMOrderDetailCell *cell = (XMOrderDetailCell *)[tableView cellForRowAtIndexPath:indexPath];
//    if ([cell.orderDetail.state isEqualToString:@"已完成"]) {
//        return UITableViewCellEditingStyleDelete;
//    }

//    XMOrderDetailCell *cell = (XMOrderDetailCell *)[tableView cellForRowAtIndexPath:indexPath];
//    if ([cell.orderDetail.state isEqualToString:@"已完成"]) {
//        return UITableViewCellEditingStyleDelete;
//    }

    return UITableViewCellEditingStyleNone;
}

//添加删除单元格
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:_totalOrderDetail];
        [array removeObjectAtIndex:indexPath.row];
        _totalOrderDetail = array;
        [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
    }
}

////移动单元格
//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath*)sourceIndexPath
//      toIndexPath:(NSIndexPath *)destinationIndexPath
//{
//    NSMutableArray *array = [NSMutableArray arrayWithArray:_totalOrderDetail];
//    NSDictionary *item = [array objectAtIndex:sourceIndexPath.row];
//    [array removeObjectAtIndex:sourceIndexPath.row];
//    [array insertObject:item atIndex:destinationIndexPath.row];
//}

#pragma mark 点击登录按钮
- (void)buttonClick
{
//    [self.navigationController presentViewController:[[XMBaseNavigationController alloc] initWithRootViewController:[[XMLoginViewController alloc] init]] animated:YES completion:^{
//    }];
    
    XMLoginViewController  *login=[[XMLoginViewController alloc]init];
    [self.navigationController pushViewController:login animated:YES];
    
    
}

#pragma mark XMOrderRatingDelegate
- (void)clickButton:(NSString *)str orderid:(NSNumber *)orderid isIntoShop:(BOOL)isIntoShop
{
    if ([str isEqualToString:@"去评价"]) {
        XMRatingOrderViewController *ratingVC = [[XMRatingOrderViewController alloc] init];
        ratingVC.orderID = orderid;
        ratingVC.isIntoShop = isIntoShop;
        [self.navigationController pushViewController:ratingVC animated:YES];
    }else if ([str isEqualToString:@"去快递"]){
        [self.navigationController pushViewController:[[XMExpressViewController alloc] init] animated:YES];
    }else if ([str isEqualToString:@"查看报告"]){
        [self.navigationController pushViewController:[[XMReportViewController alloc] init] animated:YES];
    }else if ([str isEqualToString:@"查看物流"]){
        
    }
}
/*
#pragma mark - Transitioning Delegate (Modal)
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    _modalAnimationController.type = AnimationTypePresent;
    return _modalAnimationController;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    _modalAnimationController.type = AnimationTypeDismiss;
    return _modalAnimationController;
}
*/
#ifdef iOS8
-(void)viewDidLayoutSubviews
{
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}



-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
#else

#endif

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _header = nil;
    _footer = nil;
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
    _tableView = nil;
}

@end
