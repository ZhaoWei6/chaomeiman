//
//  XMPrepareSubmitController.m
//  XiuShemMa
//
//  Created by Apple on 14/10/22.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMPrepareSubmitController.h"
#import "XMOrderStateDetailController.h"
#import "XMHttpTool.h"
#import "XMDealTool.h"
#import "XMBaseNavigationController.h"
#import "ModalAnimation.h"

#define TitleFontSize 16
#define DetailFontSize 15
#define BoldFont(size) [UIFont boldSystemFontOfSize:size]
#define Font(size) [UIFont systemFontOfSize:size]

@interface XMPrepareSubmitController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIScrollView *_contentView;
    ModalAnimation *_modalAnimationController;
    UITableView  *tableview;
    UIView  *headView;
    
}
@end

@implementation XMPrepareSubmitController

- (void)viewDidLoad {
    [super viewDidLoad];
    kRectEdge
    kNAVITAIONBACKBUTTON
    //    self.title = @"提交订单";
    self.view.backgroundColor = XMGlobalBg;
    
    
    tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-44) style:UITableViewStylePlain];
    [self.view addSubview:tableview];
    tableview.dataSource = self;
    tableview.showsVerticalScrollIndicator=NO;
    tableview.delegate = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    _modalAnimationController = [[ModalAnimation alloc] init];
    
    [self loadSubViews];
}

- (void)setOrderDic:(NSDictionary *)orderDic
{
    _orderDic = orderDic;
    XMLog(@"orderDic----->%@",orderDic);
}

- (void)loadSubViews
{
    //        //故障信息
    //    UIView *baseView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 120, kDeviceWidth, 40)];
    //    baseView3.backgroundColor = XMColor(235, 235, 235);
    //    [_contentView addSubview:baseView3];
    //
    //    QHLabel *descLabel = [[QHLabel alloc] init];
    //    descLabel.frame = CGRectMake(15, 5, kDeviceWidth-20, 30);
    //    descLabel.font = [UIFont systemFontOfSize:18];
    //    descLabel.textColor = kTextFontColor333;
    //    descLabel.text = @"故障信息";
    //    [baseView3 addSubview:descLabel];
    //
    //    UIView *sep2 = [[UIView alloc] initWithFrame:CGRectMake(0, descLabel.bottom-1, kDeviceWidth, 1)];
    //    sep2.backgroundColor = kBorderColor;
    //    [baseView3 addSubview:sep2];
    //
    //    [self orderDetailWithBaseView:baseView3 left:@"设备型号：" right:_orderDic[@"model"]];
    //    [self orderDetailWithBaseView:baseView3 left:@"故障描述：" right:_orderDic[@"desc"]];
    //    [self orderDetailWithBaseView:baseView3 left:@"更多需求：" right:_orderDic[@"more"]];
    //
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"确认下单" forState:UIControlStateNormal];
    button.frame = CGRectMake(0, kDeviceHeight-44, kDeviceWidth, kUIButtonHeight);
    button.backgroundColor = XMButtonBg;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    //    button.translatesAutoresizingMaskIntoConstraints = NO;
    //    [UIView setView:button attr:NSLayoutAttributeLeft sAttr:NSLayoutAttributeLeft constant:0];
    //    [UIView setView:button attr:NSLayoutAttributeRight sAttr:NSLayoutAttributeRight constant:0];
    //    [UIView setView:button attr:NSLayoutAttributeTop sAttr:NSLayoutAttributeBottom constant:-(49-kUIButtonHeight)/2-kUIButtonHeight];
    //    [UIView setView:button attr:NSLayoutAttributeBottom sAttr:NSLayoutAttributeBottom constant:-(49-kUIButtonHeight)/2];
    
}

#pragma mark - 提交订单
- (void)buttonClick:(UIButton *)sender
{
    sender.enabled = NO;
    __block NSString *str = @"";
    __block NSNumber *orderID;
    NSDictionary *params = [NSDictionary dictionary];
    
    NSString *userID = [XMDealTool sharedXMDealTool].userid;
    NSString *password = [XMDealTool sharedXMDealTool].password;
    
    
    NSInteger maintaincategory = [XMDealTool sharedXMDealTool].maintaincategoryid;
    if (_isOtherMobile) {
        params = @{
                   @"attr":_orderDic[@"model"],
                   @"maintaincategory_id":@(maintaincategory),
                   @"faultcategory_id":_orderDic[@"faultcategoryid"],
                   @"description":_orderDic[@"more"],
                   @"maintainer_id":_orderDic[@"maintainer_id"],
                   @"calltime":_orderDic[@"serviceDate"],
                   @"useraddress_id":_orderDic[@"useraddress"],
                   @"servicecategory_id":_orderDic[@"servicecategory_id"] ,
                   @"video":_orderDic[@"video"],
                   @"userid":userID,
                   @"password":password
                   };
        XMLog(@"params------>%@",params);
        [XMHttpTool postWithURL:@"Order/otherordercommt" params:params success:^(id json) {
            str = json[@"message"];
            XMLog(@"json------------------%@",json);
            if ([json[@"status"] integerValue] == 1) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kOrderChangeNote object:nil];
                orderID = json[@"order_id"];
                [self nextController:orderID];
            }
        } failure:^(NSError *error) {
            XMLog(@"失败 error-->%@",error);
        }];
    }else{
        params = @{
                   @"item_id":_orderDic[@"item_id"],
                   @"maintaincategory_id":@(maintaincategory),
                   @"faultcategory_id":_orderDic[@"faultcategoryid"],
                   @"description":_orderDic[@"more"],
                   @"maintainer_id":_orderDic[@"maintainer_id"],
                   @"calltime":_orderDic[@"serviceDate"],
                   @"useraddress_id":_orderDic[@"useraddress"],
                   @"servicecategory_id":_orderDic[@"servicecategory_id"] ,
                   @"video":_orderDic[@"video"],
                   @"attributecategory_id":_orderDic[@"attributecategoryid"],
                   @"attribute_id":_orderDic[@"attributeid"],
                   @"userid":userID,
                   @"password":password
                   };
        [XMHttpTool postWithURL:@"order/ordercommt" params:params success:^(id json) {
            str = json[@"message"];
            XMLog(@"json------------------%@",json);
            if ([json[@"status"] integerValue] == 1) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kOrderChangeNote object:nil];
                orderID = json[@"order_id"];
                [self nextController:orderID];
            }
        } failure:^(NSError *error) {
            XMLog(@"失败 error-->%@",error);
        }];
    }
    
    XMLog(@"%@",params);
}


- (void)nextController:(NSNumber *)orderID
{
    if (orderID) {
        XMOrderStateDetailController *orderVC = [[XMOrderStateDetailController alloc] init];
        orderVC.orderID = orderID;
        orderVC.isVisit = self.isVisit;
        //        XMBaseNavigationController *order = [[XMBaseNavigationController alloc] initWithRootViewController:orderVC];
        //        order.isBackToHome = YES;
        [self.navigationController pushViewController:orderVC animated:YES];
        //        order.transitioningDelegate = self;
        //        order.modalPresentationStyle = UIModalPresentationCustom;
        //
        //        [self presentViewController:order animated:YES completion:nil];
    }
}
#pragma mark - Transitioning Delegate (Modal)
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    _modalAnimationController.type = AnimationTypePresent;
    return _modalAnimationController;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    _modalAnimationController.type = AnimationTypeDismiss;
    return _modalAnimationController;
}
//[UIFont systemFontOfSize:fontSize] constrainedToSize: lineBreakMode:UILineBreakModeWordWrap
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ?4:2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    if (indexPath.section==0) {
        //故障信息
        if (indexPath.row==0) {
            cell.backgroundColor=XMGlobalBg;
            
            UIView  *view=[[UIView alloc]initWithFrame:CGRectMake(0, 10, kDeviceWidth, 44)];
            view.backgroundColor = [UIColor  whiteColor];
            [cell addSubview:view];
            
            UIImageView  *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon3_03"]];
            imageView.center = CGPointMake(21.5, 22);
            [view addSubview:imageView];
            
            UILabel *orderLabel = [[UILabel alloc] init];
            orderLabel.frame = CGRectMake(imageView.right+7, (44-TitleFontSize)/2.0, kDeviceWidth-20, TitleFontSize);
            orderLabel.font = Font(TitleFontSize);
            orderLabel.text = @"故障信息";
            orderLabel.textColor = kTextFontColor34;
            [view addSubview:orderLabel];
            
            //段首线
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, view.top, kDeviceWidth, 0.5)];
            lineView.backgroundColor = kBorderColor;
            [cell addSubview:lineView];
            //行尾线
            UIView *rowBottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, view.bottom-0.5, kDeviceWidth, 0.5)];
            rowBottomLineView.backgroundColor = kBorderColor;
            [cell addSubview:rowBottomLineView];
        }else if(indexPath.row==1){
            UILabel  *leftLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, (44-DetailFontSize)/2.0, 100, DetailFontSize)];
            leftLabel.text=@"手机型号：";
            leftLabel.textColor=kTtextFontColor68;
            leftLabel.font=Font(DetailFontSize);
            [cell addSubview:leftLabel];
            
            UILabel  *rightLabel=[[UILabel  alloc]initWithFrame:CGRectMake(leftLabel.right, leftLabel.top, kDeviceWidth-leftLabel.width-20, leftLabel.height)];
            rightLabel.text=_orderDic[@"model"];
            rightLabel.textAlignment = NSTextAlignmentRight;
            rightLabel.textColor=kTextFontColor666;
            rightLabel.font=Font(DetailFontSize);
            [cell addSubview:rightLabel];
            
            
            //行尾线
            UIView *rowBottomLineView = [[UIView alloc] initWithFrame:CGRectMake(10, cell.bottom-0.5, kDeviceWidth-20, 0.5)];
            rowBottomLineView.backgroundColor = kBorderColor;
            [cell addSubview:rowBottomLineView];
        }else if(indexPath.row==2){
            UILabel  *leftLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, (44-DetailFontSize)/2.0, 100, DetailFontSize)];
            leftLabel.text=@"故障描述：";
            leftLabel.textColor=kTtextFontColor68;
            leftLabel.font=Font(DetailFontSize);
            [cell addSubview:leftLabel];
            
            UILabel  *rightLabel=[[UILabel alloc]initWithFrame:CGRectMake(leftLabel.right, leftLabel.top, kDeviceWidth-leftLabel.width-20, leftLabel.height)];
            rightLabel.text=_orderDic[@"desc"];
            rightLabel.textColor=kTextFontColor666;
            rightLabel.textAlignment = NSTextAlignmentRight;
            rightLabel.font=Font(DetailFontSize);
            [cell addSubview:rightLabel];
            
            //行尾线
            UIView *rowBottomLineView = [[UIView alloc] initWithFrame:CGRectMake(10, cell.bottom-0.5, kDeviceWidth-20, 0.5)];
            rowBottomLineView.backgroundColor = kBorderColor;
            [cell addSubview:rowBottomLineView];
        }else if(indexPath.row==3){
            UILabel  *leftLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, (44-DetailFontSize)/2.0, 100, DetailFontSize)];
            leftLabel.text=@"更多需求：";
            leftLabel.textColor=kTtextFontColor68;
            leftLabel.font=Font(DetailFontSize);
            [cell addSubview:leftLabel];
            
            UILabel  *rightLabel=[[UILabel alloc]initWithFrame:CGRectMake(leftLabel.right, leftLabel.top, kDeviceWidth-leftLabel.width-20, leftLabel.height)];
            rightLabel.text=_orderDic[@"more"];
            rightLabel.textColor=kTextFontColor666;
            rightLabel.textAlignment = NSTextAlignmentRight;
            rightLabel.font=Font(DetailFontSize);
            [cell addSubview:rightLabel];
            
            //段尾线
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 44-0.5, kDeviceWidth, 0.5)];
            lineView.backgroundColor = kBorderColor;
            [cell addSubview:lineView];
        }
    }
    else if(indexPath.section==1) {
        //参考报价
        if (indexPath.row==0) {
            UIImageView  *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon2_06"]];
            imageView.center = CGPointMake(21.5, 22);
            [cell addSubview:imageView];
            
            UILabel *orderLabel = [[UILabel alloc] init];
            orderLabel.frame = CGRectMake(imageView.right+7, (44-TitleFontSize)/2.0, kDeviceWidth-20, TitleFontSize);
            orderLabel.font = Font(TitleFontSize);
            orderLabel.text = @"参考报价";
            
            orderLabel.textColor = kTextFontColor34;
            [cell addSubview:orderLabel];
            
            //段首线
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 0.5)];
            lineView.backgroundColor = kBorderColor;
            [cell addSubview:lineView];
            
            //行尾线
            UIView *rowBottomLineView = [[UIView alloc] initWithFrame:CGRectMake(10, cell.bottom-0.5, kDeviceWidth-20, 0.5)];
            rowBottomLineView.backgroundColor = kBorderColor;
            [cell addSubview:rowBottomLineView];
        }else{
            UILabel  *more=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, kDeviceWidth-20, cell.height)];
            more.text=@"实际价格以现场检测为准";
            more.textColor=kTtextFontColor68;
            more.textAlignment = NSTextAlignmentLeft;
            more.font=Font(DetailFontSize);
            [cell addSubview:more];
            
            //段尾线
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, more.bottom-0.5, kDeviceWidth, 0.5)];
            lineView.backgroundColor = kBorderColor;
            [cell addSubview:lineView];
        }
    }
    else {
        //订单信息
        if (indexPath.row==0) {
            
            UIImageView  *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon1_08"]];
            imageView.center = CGPointMake(21.5, 22);
            [cell addSubview:imageView];
            
            UILabel *orderLabel = [[UILabel alloc] init];
            orderLabel.frame = CGRectMake(imageView.right+7, (44-TitleFontSize)/2.0, kDeviceWidth-20, TitleFontSize);
            orderLabel.font = Font(TitleFontSize);
            orderLabel.text = @"订单信息";
            orderLabel.textColor = kTextFontColor34;
            [cell addSubview:orderLabel];
            
            //段首线
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 0.5)];
            lineView.backgroundColor = kBorderColor;
            [cell addSubview:lineView];
            
            //行尾线
            UIView *rowBottomLineView = [[UIView alloc] initWithFrame:CGRectMake(10, cell.bottom-0.5, kDeviceWidth-20, 0.5)];
            rowBottomLineView.backgroundColor = kBorderColor;
            [cell addSubview:rowBottomLineView];
        }else {
            //
            UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 139)];
            [cell addSubview:contentView];
            
            [self orderDetailWithBaseView:contentView left:@"手机号码：" right:_orderDic[@"number"] y:15];
            
            //时间戳转字符串
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateStyle:NSDateFormatterMediumStyle];
            [formatter setTimeStyle:NSDateFormatterShortStyle];
            [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
            NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[_orderDic[@"serviceDate"] longValue]];
            NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
            
            [self orderDetailWithBaseView:contentView left:@"上门时间：" right:confromTimespStr y:41];
            [self orderDetailWithBaseView:contentView left:@"上门地址：" right:_orderDic[@"address"] y:67];
            /*
            UILabel  *leftLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, (44-DetailFontSize)/2.0, 100, DetailFontSize)];
            leftLabel.text=@"手机号码：";
            leftLabel.textColor=kTtextFontColor68;
            leftLabel.font=Font(DetailFontSize);
            [cell addSubview:leftLabel];
            
            UILabel  *rightLabel=[[UILabel  alloc]initWithFrame:CGRectMake(leftLabel.right, leftLabel.top, kDeviceWidth-leftLabel.width-20, leftLabel.height)];
            rightLabel.text=_orderDic[@"number"];
            rightLabel.textColor=kTextFontColor666;
//            rightLabel.textAlignment = NSTextAlignmentRight;
            rightLabel.font=Font(DetailFontSize);
            [cell addSubview:rightLabel];
            
            UILabel  *leftLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, (44-DetailFontSize)/2.0, 100, DetailFontSize)];
            leftLabel.text=@"上门时间：";
            leftLabel.textColor=kTtextFontColor68;
            leftLabel.font=Font(DetailFontSize);
            [cell addSubview:leftLabel];
            
            
            
            UILabel  *rightLabel=[[UILabel alloc]initWithFrame:CGRectMake(leftLabel.right, leftLabel.top, kDeviceWidth-leftLabel.width-20, leftLabel.height)];
            rightLabel.text=confromTimespStr;
            rightLabel.textColor=kTextFontColor666;
//            rightLabel.textAlignment = NSTextAlignmentRight;
            rightLabel.font=Font(DetailFontSize);
            [cell addSubview:rightLabel];
            
            UILabel  *leftLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, (44-DetailFontSize)/2.0, 100, DetailFontSize)];
            leftLabel.text=@"上门地址：";
            leftLabel.textColor=kTtextFontColor68;
            leftLabel.font=Font(DetailFontSize);
            [cell addSubview:leftLabel];
            
            UILabel  *rightLabel=[[UILabel alloc]initWithFrame:CGRectMake(leftLabel.right, leftLabel.top, kDeviceWidth-leftLabel.width-20, leftLabel.height)];
            rightLabel.text=_orderDic[@"address"];
            rightLabel.textColor=kTextFontColor666;
//            rightLabel.textAlignment = NSTextAlignmentRight;
            rightLabel.font=Font(DetailFontSize);
            [cell addSubview:rightLabel];
            */
             
            //段尾线
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, contentView.bottom-0.5, kDeviceWidth, 0.5)];
            lineView.backgroundColor = kBorderColor;
            [cell addSubview:lineView];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        
        return 50;
        
    }else{
        
        return 5;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 &&  indexPath.row == 0) {
        
        return 54;
    }else if (indexPath.section == 2 && indexPath.row == 1){
        return 139;
    }else{
        
        return 44;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        
        return FLT_MIN;
        
    }else{
        
        return 5;
        
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        UIView  *view = [[UIView alloc]init];
        view.frame = CGRectMake(0, 0, kDeviceWidth, 50);
        view.backgroundColor = [UIColor whiteColor];
        
        QHLabel *welcomeLabel = [[QHLabel alloc] init];
        welcomeLabel.frame = CGRectMake(15, 15, 200, 50);
        welcomeLabel.font = Font(14);
        welcomeLabel.textColor = kTtextFontColor68;
        welcomeLabel.text = [NSString stringWithFormat:@"%@  %@， 您好",_orderDic[@"name"],_orderDic[@"sex"]];
        [view addSubview:welcomeLabel];
        
        
        UIView  *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 50-0.5, kDeviceWidth+15, 0.5)];
        lineView.backgroundColor=kBorderColor;
        [view addSubview:lineView];
        
        NSMutableAttributedString *labelString =[[NSMutableAttributedString alloc]initWithString:welcomeLabel.text];
        [labelString addAttribute:NSFontAttributeName value:BoldFont(DetailFontSize) range:NSMakeRange(0,[_orderDic[@"name"] length])];
        welcomeLabel.attributedText = labelString;
        
        return view;
        
    }
    return nil;
}

#pragma mark - 订单信息
- (void)orderDetailWithBaseView:(UIView *)baseView left:(NSString *)left right:(NSString *)right y:(CGFloat)y
{
    //
    QHLabel *leftLabel = [[QHLabel alloc] init];
    QHLabel *rightLabel = [[QHLabel alloc] init];
    //
    leftLabel.font = Font(DetailFontSize);
    rightLabel.font = Font(DetailFontSize);
    //
    leftLabel.textColor = kTtextFontColor68;
    rightLabel.textColor = kTtextFontColor68;
    //frame
    leftLabel.frame = CGRectMake(10, y, DetailFontSize*5, DetailFontSize);
    //对齐方式
//    leftLabel.textAlignment = NSTextAlignmentRight;
    rightLabel.textAlignment = NSTextAlignmentLeft;
    //内容
    leftLabel.text = left;
    rightLabel.text = right;
    //
    if ([left isEqualToString:@"上门地址："]||[left isEqualToString:@"寄修人地址："]||[left isEqualToString:@"更多需求："]) {
        rightLabel.frame = CGRectMake(leftLabel.right, y, kDeviceWidth-20-leftLabel.width, DetailFontSize*2);
        rightLabel.numberOfLines = 2;
    }else{
        rightLabel.frame = CGRectMake(leftLabel.right, y, kDeviceWidth-20-leftLabel.width, DetailFontSize);
    }
    //
    [baseView addSubview:leftLabel];
    [baseView addSubview:rightLabel];
}


@end
