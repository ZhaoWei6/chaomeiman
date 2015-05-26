//
//  XMOrderStateDetailController.m
//  XiuShemMa
//
//  Created by Apple on 14/10/23.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMOrderStateDetailController.h"
#import "XMOrderStateView.h"
#import "XMRatingOrderViewController.h"
#import "XMExpressViewController.h"
#import "XMReportViewController.h"
#import "XMDealTool.h"
#import "XMHttpTool.h"
#import "QHTopMenu.h"

#define TitleFontSize 16
#define DetailFontSize 15
#define BoldFont(size) [UIFont boldSystemFontOfSize:size]
#define Font(size) [UIFont systemFontOfSize:size]


#import "MJRefresh.h"
@interface XMOrderStateDetailController ()<QHTopMenuItemClickDelegete,UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
//    UIButton *stateBtn;//订单状态
//    UIButton *detailBtn;//订单详情
    
//    UITableView *_tableView;
//    NSMutableArray *_deals;
    
    MJRefreshHeaderView *_header;
    
    
    UITableView *_stateTableView;
    UITableView *_detailTableView;
    
    NSDictionary *_contentDic;
}
@end

@implementation XMOrderStateDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = XMGlobalBg;
    self.title = @"订单详情";
    
    [self initContentView];
    [self addRefresh];
    [self initMenuView];
    
}
/*
- (void)loadSubViews
{
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = XMButtonBg;
    topView.layer.borderWidth = 1;
    topView.layer.borderColor = XMButtonBg.CGColor;
    topView.layer.cornerRadius = 5;
    [self.view addSubview:topView];
    
    stateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [stateBtn setTitle:@"订单状态" forState:UIControlStateNormal];
    [stateBtn addTarget:self action:@selector(stateBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stateBtn];
    
    detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [detailBtn setTitle:@"订单详情" forState:UIControlStateNormal];
    [detailBtn addTarget:self action:@selector(detailBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:detailBtn];
    
    contentView = [[UIScrollView alloc] init];
    contentView.backgroundColor = XMGlobalBg;
    [self.view addSubview:contentView];
    contentView.showsVerticalScrollIndicator = NO;
    
    topView.translatesAutoresizingMaskIntoConstraints = NO;
    stateBtn.translatesAutoresizingMaskIntoConstraints = NO;
    detailBtn.translatesAutoresizingMaskIntoConstraints = NO;
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *dict = NSDictionaryOfVariableBindings(topView,stateBtn, detailBtn, contentView);
    NSDictionary *metrics = @{@"pad0":@10,@"pad1":@0,@"pad2":@64,@"pad3":@118,@"pad4":@74};
    
    //水平关系
    NSString *vfl  = @"H:|-pad0-[topView]-pad0-|";
    NSString *vfl0 = @"H:|-pad0-[stateBtn(==detailBtn)]-[detailBtn]-pad0-|";
    NSString *vfl1 = @"|-pad1-[contentView]-pad1-|";
    //垂直关系
    NSString *vfl2 = @"V:|-pad4-[stateBtn(==detailBtn)]-[contentView]-pad1-|";
    NSString *vfl3 = @"V:|-pad4-[detailBtn(==topView)]-[contentView]-pad1-|";
    NSString *vfl4 = @"V:|-pad3-[contentView]-pad1-|";
    NSString *vfl5 = @"V:|-pad4-[topView]-[contentView]-pad1-|";
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl options:0 metrics:metrics views:dict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl0 options:0 metrics:metrics views:dict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl1 options:0 metrics:metrics views:dict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl2 options:0 metrics:metrics views:dict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl3 options:0 metrics:metrics views:dict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl4 options:0 metrics:metrics views:dict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl5 options:0 metrics:metrics views:dict]];
    
    
    //设置边框
    stateBtn.layer.cornerRadius = 5;
    stateBtn.layer.borderWidth = 1;
    stateBtn.layer.borderColor = XMButtonBg.CGColor;
    detailBtn.layer.cornerRadius = 5;
    detailBtn.layer.borderWidth = 1;
    detailBtn.layer.borderColor = XMButtonBg.CGColor;
    
    //设置
    [stateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [detailBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [stateBtn setTitleColor:XMButtonBg forState:UIControlStateDisabled];
    [detailBtn setTitleColor:XMButtonBg forState:UIControlStateDisabled];
}
*/

#pragma mark - 
- (void)initMenuView
{
    QHTopMenu *topMenu = [QHTopMenu initQHTopMenuWithTitles:@[@"订单状态",@"订单详情"] frame:CGRectMake(0, 64, kDeviceWidth, 44) delegate:self];
    [self.view addSubview:topMenu];
}
- (void)clickItemWithItem:(NSString *)item
{
    NSLog(@"按钮的标题是--%@",item);
    if ([item isEqualToString:@"订单状态"]) {
        [self loadOrderState];
    }else{
        [self loadOrderDetail];
    }
}
/*
- (void)initMenuView
{
    UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(-1, 63, kDeviceWidth+2, 45)];
    menuView.backgroundColor = [UIColor whiteColor];
    menuView.layer.borderWidth = 1;
    menuView.layer.borderColor = kBorderColor.CGColor;
    [self.view addSubview:menuView];
    
    UIButton *stateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [stateButton setTitle:@"订单状态" forState:UIControlStateNormal];
    [detailButton setTitle:@"订单详情" forState:UIControlStateNormal];
    
    [stateButton setTitleColor:kTextFontColor666 forState:UIControlStateNormal];
    [stateButton setTitleColor:XMButtonBg forState:UIControlStateDisabled];
    
    [detailButton setTitleColor:kTextFontColor666 forState:UIControlStateNormal];
    [detailButton setTitleColor:XMButtonBg forState:UIControlStateDisabled];
    
    stateButton.frame = CGRectMake(0, 0, kDeviceWidth/2, menuView.height);
    detailButton.frame = CGRectMake(stateButton.right, stateButton.top, stateButton.width, stateButton.height);
    
    [stateButton addTarget:self action:@selector(changeContentView:) forControlEvents:UIControlEventTouchUpInside];
    [detailButton addTarget:self action:@selector(changeContentView:) forControlEvents:UIControlEventTouchUpInside];
    
    stateButton.tag = 1;
    detailButton.tag = 2;
    
    [menuView addSubview:stateButton];
    [menuView addSubview:detailButton];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 42, stateButton.width, 2)];
    bottomLine.backgroundColor = XMButtonBg;
    bottomLine.tag = 3;
   [menuView addSubview:bottomLine];
    
    UIView *centerLine = [[UIView alloc] init];
    centerLine.backgroundColor = kBorderColor;
    centerLine.frame = CGRectMake((kDeviceWidth-0.5)/2, 11, 0.5, 20);
    [menuView addSubview:centerLine];
    
    [self changeContentView:stateButton];
}
*/
#pragma mark 添加内容视图
- (void)initContentView
{
    _stateTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 108, kDeviceWidth, kDeviceHeight-108) style:UITableViewStylePlain];
    _detailTableView = [[UITableView alloc] initWithFrame:_stateTableView.frame style:UITableViewStylePlain];
    
    [_stateTableView setBackgroundColor:XMGlobalBg];
    [_detailTableView setBackgroundColor:XMGlobalBg];
    
    _stateTableView.showsVerticalScrollIndicator = NO;
    _detailTableView.showsVerticalScrollIndicator = NO;
    
    _stateTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_stateTableView];
    [self.view addSubview:_detailTableView];
    
    _stateTableView.dataSource = self;
    _detailTableView.dataSource = self;
    
    _stateTableView.delegate = self;
    _detailTableView.delegate = self;
    
    _detailTableView.hidden = YES;
}

#pragma mark 添加刷新控件
- (void)addRefresh
{
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = _stateTableView;
    header.delegate = self;
    _header = header;
}


#pragma mark 刷新代理方法
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    XMLog(@"刷新中。。。。。");
    //获取订单状态数据
    NSString *userid = [XMDealTool sharedXMDealTool].userid;
    NSString *password = [XMDealTool sharedXMDealTool].password;
    
    //    [MBProgressHUD showMessage:@"加载中..."];
    XMLog(@"订单状态--params----->%@",@{@"userid":userid,@"password":password,@"order_id":_orderID});
    
    [XMHttpTool postWithURL:@"order/orderstatus" params:@{@"userid":userid,@"password":password,@"order_id":_orderID} success:^(id json) {
        NSArray *arr = json[@"orderstatus"];
        XMLog(@"%@=======",json);
        XMLog(@"%@",arr);
        
        
        _contentDic = json;
        [_stateTableView reloadData];
//        [_header endRefreshing];
        [_header performSelector:@selector(endRefreshing) withObject:nil afterDelay:1];
    } failure:^(NSError *error) {
        XMLog(@"失败%@",error);
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络异常"];
    }];
}


/*
- (void)changeContentView:(UIButton *)sender
{
    sender.enabled = NO;
    
    NSInteger itemTag = sender.tag == 1  ? 2: 1;
    UIButton *button = (UIButton *)[[sender superview] viewWithTag:itemTag];
    button.enabled = YES;
    
    if (sender.tag == 1) {
        [self loadOrderState];
        [self  addRefresh];
        [_header beginRefreshing];
    }else{
        [self loadOrderDetail];
        [self  addRefresh];
        [_header beginRefreshing];
    }

    
    UIView *bottomLine = [[sender superview] viewWithTag:3];
    CGRect frame = bottomLine.frame;
    CGFloat x = [UIScreen mainScreen].bounds.size.width/2.0;
    frame.origin.x = sender.tag == 1 ?0:x;
    
    [UIView animateWithDuration:0.2 animations:^{
        bottomLine.frame = frame;
    }];
}

//点击订单状态按钮
- (void)stateBtnClick
{
    if (stateBtn.selected) {
        return;
    }
    [self loadOrderState];
    
    stateBtn.enabled = NO;
    detailBtn.enabled = YES;
    stateBtn.backgroundColor = [UIColor whiteColor];
    detailBtn.backgroundColor = [UIColor clearColor];

}
//点击订单详情
- (void)detailBtnClick
{
    if (detailBtn.selected) {
        return;
    }
    
    [self loadOrderDetail];
    
    detailBtn.enabled = NO;
    stateBtn.enabled = YES;
    stateBtn.backgroundColor = [UIColor clearColor];
    detailBtn.backgroundColor = [UIColor whiteColor];
}
*/
#pragma mark - 加载订单状态
- (void)loadOrderState
{
    _stateTableView.hidden = NO;
    _detailTableView.hidden = YES;
    [_header beginRefreshing];
//    if (_tableView.subviews.count) {
//        for (UIView *subView in _tableView.subviews) {
//            [subView removeFromSuperview];
//        }
//    }
//    //订单编号
//    UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, kDeviceWidth-20, 30)];
//    numberLabel.textColor = kBorderColor;
//    numberLabel.font = [UIFont systemFontOfSize:14];
//    numberLabel.text = [NSString stringWithFormat:@"订单编号：%@",_orderID];
//    [_tableView addSubview:numberLabel];
//    //获取订单状态数据
//    NSString *userid = [XMDealTool sharedXMDealTool].userid;
//    NSString *password = [XMDealTool sharedXMDealTool].password;
//    
////    [MBProgressHUD showMessage:@"加载中..."];
//    XMLog(@"订单状态--params----->%@",@{@"userid":userid,@"password":password,@"order_id":_orderID});
//    
//    [XMHttpTool postWithURL:@"order/orderstatus" params:@{@"userid":userid,@"password":password,@"order_id":_orderID} success:^(id json) {
//        NSArray *arr = json[@"orderstatus"];
//        XMLog(@"%@=======",json);
//        XMLog(@"%@",arr);
//        
////        [MBProgressHUD hideHUD];
////        [self setOrderStateWithContent:arr title:@"去评价"];
//        
//        _contentDic = json;
//        [_stateTableView reloadData];
//    } failure:^(NSError *error) {
//        XMLog(@"失败%@",error);
//        [MBProgressHUD hideHUD];
//        [MBProgressHUD showError:@"网络异常"];
//    }];
}
#pragma mark - 加载订单详情
- (void)loadOrderDetail
{
    _stateTableView.hidden = YES;
    _detailTableView.hidden = NO;
    
    
    NSString *userid = [XMDealTool sharedXMDealTool].userid;
    NSString *password = [XMDealTool sharedXMDealTool].password;
//    [MBProgressHUD showMessage:@"加载中..."];
    XMLog(@"订单详情--params----->%@",@{@"userid":userid,@"password":password,@"order_id":_orderID});
    [XMHttpTool postWithURL:@"order/orderdetailed" params:@{@"userid":userid,@"password":password,@"order_id":_orderID} success:^(id json) {
//        [MBProgressHUD hideHUD];
        XMLog(@"%@",json);
//        [self requestData:json];
        _contentDic = json;
        [_detailTableView reloadData];
    } failure:^(NSError *error) {
        XMLog(@"%@",error);
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络异常"];
    }];
}
#pragma mark 订单详情数据
- (void)refreshOrderDetailWithDictionary:(NSDictionary *)dic cell:(UITableViewCell *)cell
{
    CGFloat contentHeight = 10;
    /** 故障信息 */
    UIView *baseView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kDeviceWidth, 45)];
    baseView1.backgroundColor = [UIColor whiteColor];
    [cell addSubview:baseView1];
    
    UIImageView *stateImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 21, 21)];
    [stateImage1 setImage:[UIImage imageNamed:@"icon3_03"]];
    [baseView1 addSubview:stateImage1];
    
    QHLabel *descLabel1 = [[QHLabel alloc] init];
    descLabel1.frame = CGRectMake(stateImage1.right+5, (45-TitleFontSize)/2, kDeviceWidth-20, TitleFontSize);
    descLabel1.font = Font(TitleFontSize);
    descLabel1.textColor = kTextFontColor34;
    descLabel1.text = @"故障信息";
    [baseView1 addSubview:descLabel1];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 45, kDeviceWidth, 1)];
    line1.backgroundColor = kBorderColor;
    [baseView1 addSubview:line1];
    
    [self orderDetailWithBaseView:baseView1 left:@"设备型号：" right:dic[@"attr"] leftAlign:NO];
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(10, line1.bottom+44, kDeviceWidth-20, 1)];
    line2.backgroundColor = kBorderColor;
    [baseView1 addSubview:line2];
    [self orderDetailWithBaseView:baseView1 left:@"故障描述：" right:dic[@"fault"] leftAlign:NO];
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(10, line2.bottom+44, kDeviceWidth-20, 1)];
    line3.backgroundColor = kBorderColor;
    [baseView1 addSubview:line3];
    [self orderDetailWithBaseView:baseView1 left:@"更多需求：" right:dic[@"description"] leftAlign:NO];
    
//    baseView1.height = baseView1.height +10;
    XMLog(@"contentHeight = %f",contentHeight);
    contentHeight += baseView1.height;
    [baseView1 makeInsetShadowWithRadius:1 Color:kBorderColor Directions:@[@"top",@"bottom"]];
    /** 参考报价 */
    UIView *baseView2 = [[UIView alloc] initWithFrame:CGRectMake(0, baseView1.bottom+20, kDeviceWidth, 45)];
    baseView2.backgroundColor = [UIColor whiteColor];
    [cell addSubview:baseView2];
    
    UIImageView *stateImage2 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 21, 21)];
    [stateImage2 setImage:[UIImage imageNamed:@"icon2_06"]];
    [baseView2 addSubview:stateImage2];
    
    QHLabel *descLabel2 = [[QHLabel alloc] init];
    descLabel2.frame = CGRectMake(stateImage1.right+5, (45-TitleFontSize)/2, kDeviceWidth-20, TitleFontSize);
    descLabel2.font = Font(TitleFontSize);
    descLabel2.textColor = kTextFontColor34;
    descLabel2.text = @"参考报价";
    [baseView2 addSubview:descLabel2];
    
    
    UIImageView  *separateView2=[[UIImageView alloc]initWithFrame:CGRectMake(10, 45, kDeviceWidth-20, 1)];
    separateView2.backgroundColor=kBorderColor;
    [baseView2 addSubview:separateView2];
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, separateView2.bottom+(44-TitleFontSize)/2, kDeviceWidth-20, DetailFontSize)];
    priceLabel.font = Font(DetailFontSize);
    priceLabel.textColor = kTtextFontColor68;
    priceLabel.text = @"实际价格以现场检测为准";
    [baseView2 addSubview:priceLabel];
    
    baseView2.height = baseView2.height+44;
    XMLog(@"contentHeight = %f",contentHeight);
    contentHeight += baseView2.height;
    [baseView2 makeInsetShadowWithRadius:1 Color:kBorderColor Directions:@[@"top",@"bottom"]];
    /** 我的评价 */
    //有评价时显示下面的评价信息、没有评价时不执行
    if (dic[@"score"]!=[NSNull null] && [dic[@"score"] floatValue]!=0) {
        //评价信息
        UIView *baseView3 = [[UIView alloc] initWithFrame:CGRectMake(0, baseView2.bottom+10, kDeviceWidth, 45)];
        baseView3.backgroundColor = [UIColor whiteColor];
        [cell addSubview:baseView3];
        
        UIImageView *stateImage3 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 21, 21)];
        [stateImage3 setImage:[UIImage imageNamed:@"icon3_04_03"]];
        [baseView3 addSubview:stateImage3];
        
        QHLabel *ratingLabel = [[QHLabel alloc] init];
        ratingLabel.frame = CGRectMake(stateImage3.right+5, (45-TitleFontSize)/2, kDeviceWidth-20, TitleFontSize);
        ratingLabel.font = Font(TitleFontSize);
        ratingLabel.textColor = kTextFontColor34;
        ratingLabel.text = @"评价信息";
        [baseView3 addSubview:ratingLabel];
        
        UIImageView  *separateView3=[[UIImageView alloc]initWithFrame:CGRectMake(0, 45, kDeviceWidth, 1)];
        separateView3.backgroundColor=kBorderColor;
        [baseView3 addSubview:separateView3];
        
        NSString *imgName = [NSString stringWithFormat:@"rating_%@",dic[@"score"]];
        UIImageView *ratingView = [[UIImageView alloc] initWithFrame:CGRectMake(10, separateView3.bottom+5, 80, 15)];
        [ratingView setImage:[UIImage imageNamed:imgName]];
        [baseView3 addSubview:ratingView];
        
        QHLabel *ratingContent = [[QHLabel alloc] init];
        ratingContent.font = Font(DetailFontSize);
        ratingContent.textColor = kTtextFontColor68;
        [baseView3 addSubview:ratingContent];
        ratingContent.text = dic[@"evlcontent"];
        
        CGFloat w = kDeviceWidth-20;
        NSInteger rows = ([dic[@"evlcontent"] length]+w)/w;
        XMLog(@"rows = %li",(long)rows);
        ratingContent.numberOfLines = rows;
        ratingContent.frame = CGRectMake(10, ratingView.bottom+5, w, rows*DetailFontSize);
        
        baseView3.height += (ratingView.height+ratingContent.height+20);
        
        XMLog(@"contentHeight = %f",contentHeight);
        contentHeight += baseView3.height;
        [baseView3 makeInsetShadowWithRadius:1 Color:kBorderColor Directions:@[@"top",@"bottom"]];
//        [self orderDetailWithBaseView:baseView3 left:@"评价星级：" right:dic[@"score"] leftAlign:NO];
//        [self orderDetailWithBaseView:baseView3 left:@"评语：" right:dic[@"evlcontent"] leftAlign:NO];
//        [self orderDetailWithBaseView:baseView3 left:@"评价时间：" right:dic[@"evaluatetime"] leftAlign:NO];
//        
//        CGFloat h = baseView1.height+baseView2.height+baseView3.height+10;
//        if (h<=kDeviceHeight-108) {
//            contentView.contentSize = CGSizeMake(0, kDeviceHeight-107);
//        }else{
//            contentView.contentSize = CGSizeMake(0, h);
//        }
    }
    /** 订单信息 */
    UIView *baseView4 = [[UIView alloc] initWithFrame:CGRectMake(0, contentHeight+37, kDeviceWidth, 45)];
    baseView4.backgroundColor = [UIColor whiteColor];;
    [cell addSubview:baseView4];
    
    UIImageView *stateImage4 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 21, 21)];
    [stateImage4 setImage:[UIImage imageNamed:@"icon1_08"]];
    [baseView4 addSubview:stateImage4];
    
    QHLabel *orderLabel = [[QHLabel alloc] init];
    orderLabel.frame = CGRectMake(stateImage4.right+5, (45-TitleFontSize)/2, kDeviceWidth-90, TitleFontSize);
    orderLabel.font = Font(TitleFontSize);
    orderLabel.textColor = kTextFontColor34;
    orderLabel.text = @"订单信息";
    [baseView4 addSubview:orderLabel];
    
    UIImageView  *separateView4=[[UIImageView alloc]initWithFrame:CGRectMake(0, 45, kDeviceWidth, 1)];
    separateView4.backgroundColor=kBorderColor;
    [baseView4 addSubview:separateView4];
    
    [self orderDetailWithBaseView:baseView4 left:@"手机号码：" right:dic[@"phone"] leftAlign:YES];
    NSString *createtime = [dic[@"createtime"] substringWithRange:NSMakeRange(0, [dic[@"createtime"] length]-3)];
    [self orderDetailWithBaseView:baseView4 left:@"下单时间：" right:createtime leftAlign:YES];
//    if (_isVisit) {
        NSString *calltime = [dic[@"calltime"] substringWithRange:NSMakeRange(0, [dic[@"calltime"] length]-3)];
        [self orderDetailWithBaseView:baseView4 left:@"上门时间：" right:calltime leftAlign:YES];
        NSString *address = [NSString stringWithFormat:@"%@",dic[@"address"]];
        [self orderDetailWithBaseView:baseView4 left:@"上门地址：" right:address leftAlign:YES];
//    }else{
//        NSString *address = [NSString stringWithFormat:@"%@",dic[@"address"]];
//        [self orderDetailWithBaseView:baseView1 left:@"寄修地址：" right:address];
//        [self orderDetailWithBaseView:baseView1 left:@"参考报价：" right:[NSString stringWithFormat:@"￥%i",[dic[@"price"] intValue]]];
//    }
//    baseView4.height = baseView4.height +10;
    XMLog(@"contentHeight = %f",contentHeight);
    contentHeight += baseView4.height+300;
    [baseView4 makeInsetShadowWithRadius:1 Color:kBorderColor Directions:@[@"top",@"bottom"]];
}
#pragma mark 订单详情单项显示内容
- (void)orderDetailWithBaseView:(UIView *)baseView
                           left:(NSString *)left
                          right:(NSString *)right
                      leftAlign:(BOOL)leftAlign
{
    CGFloat h = leftAlign ? 30: 44;
    //
    QHLabel *leftLabel = [[QHLabel alloc] init];
    QHLabel *rightLabel = [[QHLabel alloc] init];
    //
    leftLabel.font = Font(DetailFontSize);
    rightLabel.font = Font(DetailFontSize);
    //frame
    leftLabel.frame = CGRectMake(10, baseView.height+(h-DetailFontSize)/2, DetailFontSize*5, DetailFontSize);
    //对齐方式
    leftLabel.textAlignment = NSTextAlignmentLeft;
    rightLabel.textAlignment = leftAlign ? NSTextAlignmentLeft: NSTextAlignmentRight;
    //内容
    leftLabel.text = left;
    rightLabel.text = right;
    leftLabel.textColor = kTtextFontColor68;
    rightLabel.textColor = kTtextFontColor68;
    /*
    if ([left isEqualToString:@"评价星级："]) {
        rightLabel.hidden = YES;
        XMRatingView *ratingView = [[XMRatingView alloc] initWithFrame:CGRectMake(leftLabel.right+75, leftLabel.top, 0, 0)];
        ratingView.style = kSmallStyle;
        float s;
        char *right1 = (char *)[right UTF8String];
        sscanf(right1, "%f",&s);
        ratingView.ratingScore = s;
        [baseView addSubview:leftLabel];
        [baseView addSubview:ratingView];
        
        CGRect frame = [baseView frame];
        //计算出自适应的高度
        frame.size.height = baseView.height+leftLabel.height;
        baseView.frame = frame;
        
        return;
    }*/
    [baseView addSubview:leftLabel];
    [baseView addSubview:rightLabel];
    
    XMLog(@"right.length = %lu",(unsigned long)[right length]);
    
    CGFloat w = kDeviceWidth-20-leftLabel.width;
    
    NSInteger rows = ([right length]*DetailFontSize+w)/w;
    if ([left isEqualToString:@"上门地址："] || [left isEqualToString:@"更多需求"]) {
//        rightLabel.numberOfLines = rows;
        XMLog(@"rows = %li",(long)rows);
        rightLabel.numberOfLines = rows;
        rightLabel.frame = CGRectMake(leftLabel.right, leftLabel.top, w, rows*DetailFontSize+10);
    }else{
//        rightLabel.numberOfLines = 1;
        rows = 1;
        XMLog(@"rows = %li",(long)rows);
        rightLabel.numberOfLines = rows;
        rightLabel.frame = CGRectMake(leftLabel.right, leftLabel.top, w, rows*DetailFontSize);
    }
    /*
    //自适应
    if ([left isEqualToString:@"上门地址："]||[left isEqualToString:@"更多需求："]||([left isEqualToString:@"评语："])) {
        rightLabel.frame = CGRectMake(leftLabel.right, leftLabel.top, w, 1000);
        rightLabel.numberOfLines = 2;
        
        rightLabel.frame = CGRectMake(leftLabel.right, leftLabel.top, w, leftLabel.height*2);
//        rightLabel.height = [rightLabel.text boundingRectWithSize:CGSizeMake(w, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName:rightLabel.font} context:nil].size.height;
    }else{
        rightLabel.frame = CGRectMake(leftLabel.right, leftLabel.top, w, leftLabel.height);
    }
    */
    
    CGRect frame = [baseView frame];
    //计算出自适应的高度
    if (leftLabel) {
        frame.size.height = baseView.height + rows*h;
    }else{
        frame.size.height = baseView.height+rightLabel.numberOfLines*h;
    }
    baseView.frame = frame;
}

#pragma mark 订单状态
- (void)setOrderStateWithContent:(NSArray *)arr title:(NSString *)title cell:(UITableViewCell *)cell
{
    //
    for (int i=0; i<4; i++) {
        XMOrderStateView *orderView = [[XMOrderStateView alloc] initWithFrame:CGRectMake(30, i*(60+20), kDeviceWidth - 60, 60)];
        if (i<arr.count) {
            [orderView setStateWithDict:arr[i] flag:i<=arr.count index:i];
        }else{
            [orderView setStateWithDict:nil flag:i<=arr.count index:i];
        }
        [cell addSubview:orderView];
        
        if (i<3) {
            UIView *s = [[UIView alloc] initWithFrame:CGRectMake(30+15, orderView.center.y+16, 1, 80-32)];
            if (i<arr.count) {
                s.backgroundColor = XMButtonBg;
            }else{
                s.backgroundColor = kBorderColor;
            }
            [cell addSubview:s];
        }
    }
    UIButton *ratingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [ratingBtn setTitle:title forState:UIControlStateNormal];
    ratingBtn.frame = CGRectMake(20, 40+4*(60+20), kDeviceWidth-40, kUIButtonHeight);
    ratingBtn.layer.cornerRadius = 5;
    ratingBtn.backgroundColor = XMButtonBg;
    [ratingBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:ratingBtn];
    if (arr.count == 4) {
        ratingBtn.titleLabel.text = @"去评价";
        ratingBtn.hidden = NO;
    }else{
        ratingBtn.hidden = YES;
    }
    //
//    _tableView.contentSize = CGSizeMake(0, 40+4*(60+20)+44);
}

- (void)buttonClick:(UIButton *)button
{
    if ([button.titleLabel.text isEqualToString:@"去评价"]) {
        XMRatingOrderViewController *ratingVC = [[XMRatingOrderViewController alloc] init];
        ratingVC.orderID = _orderID;
        XMLog(@"%@",_orderID);
        [self.navigationController pushViewController:ratingVC animated:YES];
    }else if ([button.titleLabel.text isEqualToString:@"去快递"]){
        [self.navigationController pushViewController:[[XMExpressViewController alloc] init] animated:YES];
    }else if ([button.titleLabel.text isEqualToString:@"查看报告"]){
        [self.navigationController pushViewController:[[XMReportViewController alloc] init] animated:YES];
    }else if ([button.titleLabel.text isEqualToString:@"查看物流"]){
        
    }
}

#pragma mark - 表格方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell  *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.backgroundColor = XMGlobalBg;
    
    if (tableView == _stateTableView) {
        [self setOrderStateWithContent:_contentDic[@"orderstatus"] title:@"去评价" cell:cell];
    }else{
        [self refreshOrderDetailWithDictionary:_contentDic cell:cell];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == _stateTableView) {
        UILabel *orderID_Label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 30)];
        orderID_Label.text = [NSString stringWithFormat:@"  订单编号：%@",self.orderID];
        orderID_Label.textColor = kTextFontColor666;
        orderID_Label.font = [UIFont systemFontOfSize:14];
        orderID_Label.backgroundColor = XMGlobalBg;
        return orderID_Label;
    }else{
        return nil;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _stateTableView) {
        return kDeviceHeight-108-20;
    }
    return kDeviceHeight+50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _stateTableView) {
        return 30;
    }
    return FLT_MIN;
}


@end
/*
#pragma mark -
@implementation UIButton (XM)
- (void)setSelected:(BOOL)selected
{
    [self setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
    [super setSelected:selected];
}
@end
 */

