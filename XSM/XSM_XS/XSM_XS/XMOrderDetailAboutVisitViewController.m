//
//  XMOrderDetailAboutVisitViewController.m
//  XSM_XS
//
//  Created by Apple on 14/12/30.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMOrderDetailAboutVisitViewController.h"
#import "JHOrderDetailForDetailView.h"
#import "JHOrderDetailForStatusView.h"

@interface XMOrderDetailAboutVisitViewController ()
{
    NSArray *defaultStates;
}
@property(nonatomic, strong) UIView *topBar;
@property(nonatomic, strong) UIView *buttomBar;
@property(nonatomic, strong) UIView *orderStatusView;
@property(nonatomic, strong) JHOrderDetailForDetailView *orderDetailView;
@property(nonatomic, strong) UITableView *orderStatusTableView;
@property(nonatomic, strong) UIScrollView *orderDetailScrollView;

@property(nonatomic, strong) NSArray *orderStatus;//订单状态


@property(nonatomic, strong) NSDictionary *orderDetail;//订单详情

@end

@implementation XMOrderDetailAboutVisitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"订单详情";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self requestDataDetail];
}

- (void)requestDataDetail
{
    NSString *userid = [UserDefaults objectForKey:@"userid"];
    NSString *password = [UserDefaults objectForKey:@"password"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:userid forKey:@"userid"];
    [params setObject:password forKey:@"password"];
    [params setObject:self.order_id forKey:@"order_id"];
    [params setObject:@(1) forKey:@"type"];
    
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
}
#pragma mark - 订单详情
- (void)initOrderDetailView
{
    self.orderDetailScrollView = [self addScrollViewWithContentView:[self setupOrderDetailView]];
    
    [self.view addSubview:self.orderDetailScrollView];
    
    if ([self.orderDetail[@"orderstatus"] integerValue] == 0) {
        [self initButtonBar];
    }
}
#pragma mark - ------------------添加ScrollView--------------------
- (UIScrollView *)addScrollViewWithContentView:(UIView *)contentView
{
    // 创建ScrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    CGFloat scrollView_y = CGRectGetMaxY(self.topBar.frame);
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
#pragma mark - ------------------初始化OrderDetailView--------------------
- (UIView *)setupOrderDetailView
{
    UIView *orderDetailView = [[UIView alloc] init];
    orderDetailView.frame = CGRectMake(0, 64, kDeviceWidth, kDeviceHeight-64);
    
    UILabel *topText = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, kDeviceWidth-20, 24)];
    topText.font = [UIFont boldSystemFontOfSize:18];
    topText.text = @"订单信息";
    [orderDetailView addSubview:topText];
    
    UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(0, topText.bottom+5, kDeviceWidth, 1)];
    sep.backgroundColor = kBorderColor;
    [orderDetailView addSubview:sep];
    
    CGFloat h = sep.bottom;
    NSArray *text_left = @[@"下单手机号：",@"下单时间：",@"订单编号："];
    NSArray *text_right = @[self.orderDetail[@"phone"],self.orderDetail[@"createtime"],self.orderDetail[@"id"]];
    for (int i=0; i<3; i++) {
        //
        UILabel *label_left = [[UILabel alloc] initWithFrame:CGRectMake(0, h+5, kDeviceWidth/3, 20)];
        UILabel *label_right = [[UILabel alloc] initWithFrame:CGRectMake(label_left.right, label_left.top, label_left.width*2, label_left.height)];
        //
        label_left.textAlignment = NSTextAlignmentRight;
        label_right.textAlignment = NSTextAlignmentLeft;
        //
        [orderDetailView addSubview:label_left];
        [orderDetailView addSubview:label_right];
        //
        label_left.text = text_left[i];
        label_right.text = text_right[i];
        
        h+=25;
    }
    
    return orderDetailView;
}
- (void)initButtonBar
{
    self.buttomBar = [self setupBottomBar];
    [self.view addSubview:self.buttomBar];
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
