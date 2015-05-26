//
//  JHOrdersViewController.m
//  XSM_XS
//
//  Created by Andy on 14-12-2.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "JHOrdersViewController.h"
#import "MJRefresh.h"
#import "JHSingleButton.h"

#import "JHOrdersTableViewCell.h"
#import "JHOrderListCell.h"
#import "JHOrderDetailViewController.h"
#import "XMNavigationViewController.h"
#import "XMLoginViewController.h"
#import "JHNotLoginPushView.h"
#import "XMOrderDetailAboutVisitViewController.h"

#import "MJRefresh.h"
#import "XMDealTool.h"

#import "XMOrder.h"

@interface JHOrdersViewController ()<UITableViewDataSource, UITableViewDelegate, JHNotLoginPushViewDelegate,MJRefreshBaseViewDelegate>
{
    UIView *_headView;
    UITableView *_tableView;
    
    NSMutableArray *_deals;
    int _page; // 页码
    int _type; // 类型   1：上门服务 2：寄修 3：进店修 0:空为显示全部订单
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
}

@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *singleBar;

@property (nonatomic, strong) NSMutableArray *totalOrderDetail;//所有的订单信息

@end

@implementation JHOrdersViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self loadSubViews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadSubViews) name:kLoginSuccessNote object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadSubViews) name:kExitSystemNote object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestDate) name:@"CHANGEORDER" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestDate) name:@"REFRESHORDERLIST" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)loadSubViews
{
    NSString *userid = [NSString stringWithFormat:@"%@", [UserDefaults objectForKey:@"userid"]];
    
    if (userid == nil || userid.length == 0 || [userid isEqualToString:@"(null)"]) {
        if (self.view.subviews.count) {
            for (UIView *view in self.view.subviews) {
                [view removeFromSuperview];
            }
        }
        
        JHNotLoginPushView *notLoginPushView = [JHNotLoginPushView notLoginPushView];
        notLoginPushView.frame = self.view.bounds;
        notLoginPushView.delegate = self;
        [self.view addSubview:notLoginPushView];
        
    }else{
        if (self.view.subviews.count) {
            for (UIView *view in self.view.subviews) {
                [view removeFromSuperview];
            }
        }
        // 顶部选择框
        [self setupSingleBar];
        // 初始化列表
        [self setupTableView];
        // 添加刷新控件
        [self addRefresh];
        
        [self requestDate];
    }
}
- (void)requestDate
{
    [_header beginRefreshing];
}
#pragma mark - ****************添加刷新控件
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
#pragma mark ****************刷新代理方法
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    BOOL isHeader = [refreshView isKindOfClass:[MJRefreshHeaderView class]];
    if (isHeader) { // 下拉刷新
        _page = 1; // 第一页
    } else { // 上拉加载更多
        _page++;
    }
    
    NSDictionary *params = @{@"page":@(_page), @"type":@(_type)};
    
    [[XMDealTool sharedXMDealTool] orderListWith:params success:^(NSArray *deals, int islast) {
                                             
                                             if ([deals isKindOfClass:[NSArray class]] && deals.count) {
                                                 
                                                 [self removeImage];
                                                 
                                                 if (isHeader) {
                                                     _totalOrderDetail = [NSMutableArray array];
                                                 }
                                                 // 1.添加数据
                                                 [_totalOrderDetail addObjectsFromArray:deals];
                                                 
                                                 
                                                 
                                                 // 2.刷新表格
                                                 [_tableView performSelector:@selector(reloadData) withObject:nil afterDelay:1];
                                                 
                                                 // 3.恢复刷新状态
                                                 [refreshView performSelector:@selector(endRefreshing) withObject:nil afterDelay:1];
                                                 
                                                 _footer.hidden = islast;
                                             }else{
                                                 //
                                                 [self removeImage];
                                                 [self showOerderNone];
                                                 [refreshView endRefreshing];
                                             }
        
                                         }];
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

#pragma mark - ------------------初始化TableView--------------------
- (void)setupTableView
{
    CGFloat tableView_y = CGRectGetMaxY(self.singleBar.frame) - 1;
    CGRect tableView_frame = CGRectMake(0, tableView_y, kDeviceWidth, kDeviceHeight - tableView_y - 44);
    UITableView *tableView = [[UITableView alloc] initWithFrame:tableView_frame style:UITableViewStyleGrouped];
    [tableView setBackgroundColor:XMGlobalBg];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    self.tableView = tableView;
    [self.view addSubview:tableView];
}


#pragma mark - ------------------初始化TableView代理方法--------------------

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
//    JHOrdersTableViewCell *cell = [JHOrdersTableViewCell ordersTableViewCellWithTableView:tableView];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    XMOrder *order = _totalOrderDetail[indexPath.row];
//    cell.order = order;
    
    JHOrderListCell *cell = [JHOrderListCell ordersListCellWithTableView:tableView];
    
    XMOrder *order = _totalOrderDetail[indexPath.section];
    cell.order = order;

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((_type == 1) || (_type == 2)) {
        XMLog(@"上门单/寄修单");
        JHOrderDetailViewController *orderDetailViewController = [[JHOrderDetailViewController alloc] init];
        XMOrder *order = _totalOrderDetail[indexPath.row];
        orderDetailViewController.order_id = order.ID;
        [self.navigationController pushViewController:orderDetailViewController animated:YES];
    }else if (_type == 3){
        XMLog(@"进店单");
        XMOrderDetailAboutVisitViewController *orderDetailVC = [[XMOrderDetailAboutVisitViewController alloc] init];
        XMOrder *order = _totalOrderDetail[indexPath.row];
        orderDetailVC.order_id = order.ID;
        [self.navigationController pushViewController:orderDetailVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return FLT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 9;
}


#pragma mark - ------------------初始化单选按钮工具栏--------------------
- (void)setupSingleBar
{
    UIView *singleBar = [self addOrderTypeBarWithTitle:@[@"上门修", @"寄修单", @"进店单"] andToolFrame:CGRectMake(0, 64, kDeviceWidth, 44) andInterval:CGPointMake(0, 0) andBasicTag:1000];
    self.singleBar = singleBar;
    
    [self.view addSubview:singleBar];
}

#pragma mark - --------------------添加单选按钮工具栏--------------------
- (UIView *)addOrderTypeBarWithTitle:(NSArray *)titleArray andToolFrame:(CGRect)toolFrame andInterval:(CGPoint)interval andBasicTag:(NSInteger )basicTag
{
    UIView *toolBar = [[UIView alloc] initWithFrame:toolFrame];
    toolBar.backgroundColor = [UIColor whiteColor];
    // 底部分隔线
    UIView *bottom = [[UIButton alloc] initWithFrame:CGRectMake(0, 44-1, kDeviceWidth, 1)];
    bottom.backgroundColor = kBorderColor;
    [toolBar addSubview:bottom];
    // 间隔
    CGFloat marginX = interval.x;
    CGFloat marginY = interval.y;
    // 列数
    NSInteger rownum = titleArray.count;
    
    // 按钮宽高
    CGFloat button_w = (toolFrame.size.width - marginX * 2)/rownum;
    CGFloat button_h = toolFrame.size.height - 2 * marginY;
    
    for (int index = 0; index < titleArray.count; index ++) {
        
        // 设置frame
        int row = index / rownum;
        int col = index % rownum;
        
        // 计算x和y
        CGFloat button_x = marginX + col * button_w;
        CGFloat button_y = marginY + row * (button_h + marginY);
        
        // 创建按钮
        JHSingleButton *button = [[JHSingleButton alloc] initWithFrame:CGRectMake(button_x, button_y, button_w, button_h)];
        button.tag = basicTag + index + 1;
        
        // 设置标题
        [button setTitle:titleArray[index] forState:UIControlStateNormal];
        [button setTitle:titleArray[index] forState:UIControlStateSelected];
        
        [button setTitleColor:kTextFontColor666 forState:UIControlStateNormal];
        [button setTitleColor:XMButtonBg forState:UIControlStateSelected];
        
//        [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
        
        // 设置背景
        [button setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"icon_line"] forState:UIControlStateSelected];
        
        // 添加点击事件
        [button addTarget:self action:@selector(clickButtonTosearchOrderViewType:) forControlEvents:UIControlEventTouchUpInside];
        
        if (button.tag == basicTag +1) {
            [self clickButtonTosearchOrderViewType:button];
        }
        
        [toolBar addSubview:button];
        
        if (index > 0) {
            
            UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(button_x, button_h * 0.25, 1, button_h * 0.5)];
            divider.backgroundColor = kBorderColor;
            [toolBar addSubview:divider];
            
        }
    }
    
    return toolBar;
}


#pragma mark - --------------------单选按钮事件处理--------------------
- (void)clickButtonTosearchOrderViewType:(UIButton *)button
{
    // 设置按钮的状态
    self.selectButton.selected = NO;
    button.selected = YES;
    self.selectButton = button;
    
    // 界面切换
    if (button.tag == 1001) { // 上门修
        XMLog(@"-----------上门修---------");
        _type = 1;
//        [_header beginRefreshing];
    }else if (button.tag == 1002){ // 寄修单
        XMLog(@"-----------寄修单---------");
        _type = 2;
//        [_header beginRefreshing];
    }else{  // 进店单
        XMLog(@"-----------进店单---------");
        _type = 3;
//        [_header beginRefreshing];
    }
    
    if (_header.isRefreshing || _footer.isRefreshing) {
        [_header endRefreshing];
        [_footer endRefreshing];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEORDER" object:nil];
}

- (void)notLoginPushView:(JHNotLoginPushView *)notLoginPushView didselectedWithButtonTag:(NSInteger)tag
{
    XMLoginViewController *loginViewController = [[XMLoginViewController alloc] init];
    loginViewController.isModal = YES;
    XMNavigationViewController *nav = [[XMNavigationViewController alloc] initWithRootViewController:loginViewController];
    
    [self presentViewController:nav animated:YES completion:nil];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
