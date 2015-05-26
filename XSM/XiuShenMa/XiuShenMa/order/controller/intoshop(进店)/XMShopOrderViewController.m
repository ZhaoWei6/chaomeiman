//
//  XMShopOrderViewController.m
//  XiuShenMa
//
//  Created by Apple on 14/11/21.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMShopOrderViewController.h"
#import "XMDealTool.h"
#import "XMHttpTool.h"
#import "XMRatingOrderViewController.h"
@interface XMShopOrderViewController (){
    
    UIButton *detailBtn;//订单详情
    
    UIScrollView *contentView;//内容区域
}

@end

@implementation XMShopOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    contentView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    contentView.backgroundColor = XMGlobalBg;
    [self.view addSubview:contentView];
    [self loadData];
}

- (void)loadData
{
    [MBProgressHUD showMessage:@"加载中..."];
    NSString *userid = [XMDealTool sharedXMDealTool].userid;
    NSString *password = [XMDealTool sharedXMDealTool].password;
    [XMHttpTool postWithURL:@"order/orderdetailed" params:@{@"userid":userid,@"password":password,@"order_id":_orderID} success:^(id json) {
        XMLog(@"%@",json);
        [self requestData:json];
        [MBProgressHUD hideHUD];
    } failure:^(NSError *error) {
        XMLog(@"%@",error);
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络异常"];
    }];
}

- (void)requestData:(NSDictionary *)dic
{
    //订单信息
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kDeviceWidth, 40)];
    baseView.backgroundColor = XMColor(235, 235, 235);
    [contentView addSubview:baseView];
    
    QHLabel *orderLabel = [[QHLabel alloc] init];
    orderLabel.frame = CGRectMake(10, 5, kDeviceWidth-20, 30);
    orderLabel.font = [UIFont boldSystemFontOfSize:18];
    orderLabel.text = @"订单信息";
    orderLabel.textColor = kTextFontColor333;
    [baseView addSubview:orderLabel];
    
    UIImageView  *separateView=[[UIImageView alloc]initWithFrame:CGRectMake(0, orderLabel.bottom, kDeviceWidth, 0.5)];
    separateView.backgroundColor=kBorderColor;
    [baseView addSubview:separateView];
    
    [self orderDetailWithBaseView:baseView left:@"下单手机号：" right:dic[@"phone"]];
    [self orderDetailWithBaseView:baseView left:@"下单时间：" right:dic[@"createtime"]];
    NSString *orderID = [NSString stringWithFormat:@"%@",_orderID];
    [self orderDetailWithBaseView:baseView left:@"订单编号：" right:orderID];
    
    if ([dic[@"orderstatus"] intValue]!=-1 && dic[@"score"] == [NSNull null]) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20, baseView.bottom+20, kDeviceWidth-40, 44)];
        button.backgroundColor = XMButtonBg;
        [contentView addSubview:button];
        button.layer.cornerRadius = 5;
        [button setTitle:@"评价" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(ratingOrder) forControlEvents:UIControlEventTouchUpInside];
    }
    
    contentView.contentSize = CGSizeMake(0, kDeviceHeight);
}

#pragma mark 订单信息
- (void)orderDetailWithBaseView:(UIView *)baseView left:(NSString *)left right:(NSString *)right
{
    //
    QHLabel *leftLabel = [[QHLabel alloc] init];
    QHLabel *rightLabel = [[QHLabel alloc] init];
    //frame
    leftLabel.frame = CGRectMake(0, baseView.height, kOrderDetailLeftLabelWidth, kOrderDetailLabelHeight);
    rightLabel.frame = CGRectMake(leftLabel.right, leftLabel.top, kOrderDetailRightLabelWidth, kOrderDetailLabelHeight);
    //对齐方式
    leftLabel.textAlignment = NSTextAlignmentRight;
    rightLabel.textAlignment = NSTextAlignmentLeft;
    //内容
    leftLabel.text = left;
    rightLabel.text = right;
    [baseView addSubview:leftLabel];
    [baseView addSubview:rightLabel];
    
    CGRect frame = [baseView frame];
    //计算出自适应的高度
    frame.size.height = baseView.height+rightLabel.height;
    baseView.frame = frame;
}

- (void)ratingOrder
{
    XMRatingOrderViewController *ratingVC = [[XMRatingOrderViewController alloc] init];
    ratingVC.isIntoShop = YES;
    ratingVC.orderID = _orderID;
    [self.navigationController pushViewController:ratingVC animated:YES];
}

@end
