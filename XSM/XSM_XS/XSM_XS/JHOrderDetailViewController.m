//
//  JHOrderDetailViewController.m
//  XSM_XS
//
//  Created by Andy on 14-12-3.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "JHOrderDetailViewController.h"

#import "JHOrderDetailForDetailView.h"
#import "JHOrderDetailForStatusView.h"
#import "JHOrderStatusTableViewCell.h"
#import "MJRefresh.h"

#import "QHTopMenu.h"

@interface JHOrderDetailViewController ()<UITableViewDataSource, UITableViewDelegate, QHTopMenuItemClickDelegete, MJRefreshBaseViewDelegate>
{
    NSArray *defaultStates;
}
@property (nonatomic, strong) MJRefreshHeaderView *header;
@property(nonatomic, strong) QHTopMenu *topBar;
@property(nonatomic, strong) UIView *buttomBar;
@property(nonatomic, strong) UIView *orderStatusView;
@property(nonatomic, strong) JHOrderDetailForDetailView *orderDetailView;
@property(nonatomic, strong) UITableView *orderStatusTableView;
@property(nonatomic, strong) UIScrollView *orderDetailScrollView;

@property(nonatomic, strong) NSArray *orderStatus;//订单状态

@property(nonatomic, strong) NSDictionary *orderDetail;//订单详情

@end

@implementation JHOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"订单详情"];
    [self setupOrderTableViewCellInfo];
    
    [self initMenuView];
    
//    [self addRefresh];
}

#pragma mark -
- (void)initMenuView
{
    QHTopMenu *topMenu = [QHTopMenu initQHTopMenuWithTitles:@[@"订单状态",@"订单详情"] frame:CGRectMake(0, 64, kDeviceWidth, 44) delegate:self];
    self.topBar = topMenu;
    [self.view addSubview:topMenu];
}

- (void)clickItemWithItem:(NSString *)item
{
    if ([item isEqualToString:@"订单状态"]) {
        
        [self requestDataDetail:NO];
        
    }else{
        
        [self requestDataDetail:YES];
        
    }
    
    
}


#pragma mark 添加刷新控件
- (void)addRefresh
{
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.orderStatusTableView;
    header.delegate = self;
    
    self.header = header;
}

- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    
    [self requestDataDetail:NO];
}

- (void)requestDataDetail:(BOOL)isDetail
{
    NSString *userid = [UserDefaults objectForKey:@"userid"];
    NSString *password = [UserDefaults objectForKey:@"password"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:userid forKey:@"userid"];
    [params setObject:password forKey:@"password"];
    [params setObject:self.order_id forKey:@"order_id"];
    [params setObject:@(1) forKey:@"type"];
    
    if (isDetail) {
        //订单详情
        [XMHttpTool postWithURL:@"order/orderdetailed"
                         params:params
                        success:^(id json) {
                            XMLog(@"json--->%@",json);
                            if ([json[@"status"] integerValue] == 1) {
                                self.orderDetail = json;
                                [self initOrderDetailView];
                            }
                        }
                        failure:^(NSError *error) {
                            XMLog(@"error->%@",error);
                            [MBProgressHUD showError:@"网路异常"];
                        }];
    }else{
        //订单状态
        [XMHttpTool postWithURL:@"order/orderstatus"
                         params:params
                        success:^(id json) {
                            XMLog(@"json--->%@",json);
                            if ([json[@"status"] integerValue] == 1) {
//                                NSArray *orderstatus = json[@"orderstatus"];
                                self.orderStatus = json[@"orderstatus"];
                                
                                [self initOrderStateView];
                                
//                                if (self.orderStatusTableView) {
//                                    [self addRefresh];
//                                }
                                
                                
                            }
                        }
                        failure:^(NSError *error) {
                            XMLog(@"error->%@",error);
                            [MBProgressHUD showError:@"网路异常"];
                        }];
    }
}
#pragma mark - ------------------快速创建按钮--------------------
- (UIButton *)addButtonWithFrame:(CGRect)frame title:(NSString *)title action:(SEL)action baseTag:(NSInteger)tag
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    [button setTag:tag];
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateHighlighted];
    [button setTitleColor:XMButtonBg forState:UIControlStateNormal];
    [button setTitleColor:kTextFontColor666 forState:UIControlStateHighlighted];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

#pragma mark - ------------------初始化ScrollView--------------------
- (void)setupScrollView
{
    [self initOrderStateView];
}
#pragma mark - 订单状态
- (void)initOrderStateView
{
    [self.buttomBar removeFromSuperview];
    [self.orderDetailScrollView removeFromSuperview];
    
    [self setupOrderStatusView];
    [self.view addSubview:self.orderStatusTableView];
}
#pragma mark - 订单详情
- (void)initOrderDetailView
{
    [self.orderStatusTableView removeFromSuperview];
    
    self.orderDetailScrollView = [self addScrollViewWithContentView:[self setupOrderDetailView]];
    
    [self.view addSubview:self.orderDetailScrollView];
    
    if ([self.orderDetail[@"orderstatus"] integerValue] == 0) {
        [self initButtonBar];
    }
}
- (void)initButtonBar
{
    self.buttomBar = [self setupBottomBar];
    [self.view addSubview:self.buttomBar];
}
#pragma mark - ------------------添加ScrollView--------------------
- (UIScrollView *)addScrollViewWithContentView:(UIView *)contentView
{
    // 创建ScrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    CGFloat scrollView_y = CGRectGetMaxY(self.topBar.frame) -1;
    scrollView.frame = CGRectMake(0, scrollView_y, self.view.frame.size.width, self.view.frame.size.height - scrollView_y);
    scrollView.backgroundColor = [UIColor clearColor];
    
    [scrollView addSubview:contentView];
    [scrollView setContentSize:contentView.frame.size];
    
    // 隐藏水平滚动条
    scrollView.showsHorizontalScrollIndicator = NO;
    // 隐藏垂直滚动条
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.bounces = YES;
    
    return scrollView;
}

#pragma mark - ------------------初始化orderStatusTableView--------------------
- (void)setupOrderStatusView
{
    
    CGFloat tableView_y = CGRectGetMaxY(self.topBar.frame);
    CGRect tableView_frame = CGRectMake(0, tableView_y, kDeviceWidth, kDeviceHeight - tableView_y);
    UITableView *tableView = [[UITableView alloc] initWithFrame:tableView_frame style:UITableViewStylePlain];
    [tableView setBackgroundColor:XMGlobalBg];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    self.orderStatusTableView = tableView;
}

#pragma mark - ------------------初始化OrderDetailView--------------------
- (UIView *)setupOrderDetailView
{
    CGFloat orderDetailView_y = 0;
    JHOrderDetailForDetailView *orderDetailView = [JHOrderDetailForDetailView orderDetailForDetailView];
    orderDetailView.contentDic = self.orderDetail;
    [orderDetailView setFrame:CGRectMake(0, orderDetailView_y, kDeviceWidth, kDeviceHeight)];
    orderDetailView.hidden = NO;
    return orderDetailView;
}

#pragma mark - ------------------初始化底部工具栏--------------------
- (UIView *)setupBottomBar
{
    UIView *buttomBar = [[UIView alloc] initWithFrame:CGRectMake(0, kDeviceHeight - 44, kDeviceWidth, 44)];
//    buttomBar.hidden = YES;
    [buttomBar setBackgroundColor:[UIColor whiteColor]];
    
    UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 1)];
    [divider setBackgroundColor:kBorderColor];
    [buttomBar addSubview:divider];
    
    UIButton *notReceiveOrderButton = [self addButtonWithFrame:CGRectMake(0, 0, kDeviceWidth * 0.5, 44) title:@"不接单" action:@selector(buttonAction:) baseTag:1];
    [buttomBar addSubview:notReceiveOrderButton];
    
    UIButton *receiveOrderButton = [self addButtonWithFrame:CGRectMake(kDeviceWidth * 0.5, 0, kDeviceWidth * 0.5, 44) title:@"接单" action:@selector(buttonAction:) baseTag:1];
    [buttomBar addSubview:receiveOrderButton];
    
    
    return buttomBar;
}

#pragma mark - ------------------底部工具栏点击事件--------------------
- (void)buttonAction:(UIButton *)button
{
    NSString *order_id = self.orderDetail[@"id"];
    NSString *userid = [UserDefaults objectForKey:@"userid"];
    NSString *password = [UserDefaults objectForKey:@"password"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:order_id forKey:@"order_id"];
    [params setObject:userid forKey:@"userid"];
    [params setObject:password forKey:@"password"];
    
    NSString *webUrl = @"";
    
    if ([button.titleLabel.text isEqualToString:@"接单"]){
        webUrl = @"order/confirm";
    }else if ([button.titleLabel.text isEqualToString:@"不接单"]){
        webUrl = @"order/ordercancel";
    }
    
    [XMHttpTool postWithURL:webUrl params:params success:^(id json) {
        XMLog(@"json-->%@",json);
        [MBProgressHUD showSuccess:json[@"message"]];
        if ([json[@"status"] integerValue] == 1) {
            [[button superview] setHidden:YES];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHORDERLIST" object:nil];
    } failure:^(NSError *error) {
        XMLog(@"error-->%@",error);
        [MBProgressHUD showError:@"网络异常"];
//        [MBProgressHUD hideHUD];
    }];
}

#pragma mark - ------------------UITableView代理方法--------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dic = [self.orderStatus lastObject];
    if ([dic[@"orderstatus"] intValue] == -1) {
        return 2;
    }
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JHOrderStatusTableViewCell *cell = [JHOrderStatusTableViewCell orderStatusTableViewCellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row < self.orderStatus.count) {
        cell.dictionary = self.orderStatus[indexPath.row];
    }else{
        cell.defaultDictionary = defaultStates[indexPath.row];
    }
    NSDictionary *dic = [self.orderStatus lastObject];
    if ([dic[@"orderstatus"] intValue] == -1) {
        cell.isLast = indexPath.row == 1;
    }else{
        cell.isLast = indexPath.row == 4;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 84;
}

- (void)setupOrderTableViewCellInfo
{
    defaultStates = @[@{@"orderstatus" : @"0"},
                       @{@"orderstatus" : @"1"},
                       @{@"orderstatus" : @"2"},
                       @{@"orderstatus" : @"3"},
                       @{@"orderstatus" : @"4"}];
    
//    self.orderStatus = array;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
