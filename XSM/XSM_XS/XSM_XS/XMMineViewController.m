//
//  XMMineViewController.m
//  XSM_XS
//
//  Created by Apple on 14/12/1.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMMineViewController.h"
#import "UIViewExt.h"
#import "XMCommon.h"
#import "Measurement.h"
#import "XMDealTool.h"

#import "UMSocial.h"
#import "APService.h"

#import "XMNavigationViewController.h"

#import "XMLoginViewController.h"
#import "XMInfoTableViewController.h"
#import "XMAddUserMessageViewController.h"
#import "JHMyShopViewController.h"
#import "XMUserResponseViewController.h"
#import "JHCommonAddressViewController.h"

#import "XMInformationViewController.h"
#import "XMRatingListViewController.h"
@interface XMMineViewController ()<UIAlertViewDelegate>
{
    UIView *_headView;
    NSArray *_titles;
}

@end

@implementation XMMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    kNAVITAIONBACKBUTTON
    
    _titles = @[@[/*@"我的店铺", @"我的客户",*/@"我的评价"],
                @[@"常用地址",@"告诉朋友"],
                @[/*@"给修神马好评",@"用户反馈",*/@"退出登录"]];
    //
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    //
    [self initHeadView];
    // 0:未登录
    int approve = [[UserDefaults objectForKey:@"approve"] intValue];
    if (approve == 1 || approve == 3){
        //未提交审核  活审核失败
        [self addUserMessage];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 让选中单元格处于未选中
//    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    
    
    [self loadHeadView];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    self.tableView.contentOffset=CGPointMake(0, -64);

}

- (void)initHeadView
{
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kMineHeadViewHeight)];
    _headView.backgroundColor = kBorderColor;
    self.tableView.tableHeaderView = _headView;
    _headView.contentMode = UIViewContentModeScaleAspectFit;
    _headView.clipsToBounds = YES;
    _headView.userInteractionEnabled = YES;
    UIGestureRecognizer *top = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(login)];
    [_headView addGestureRecognizer:top];
}
- (void)loadHeadView
{
    for (UIView *subView in _headView.subviews) {
        [subView removeFromSuperview];
    }
    
    NSString *phone = [XMDealTool sharedXMDealTool].phone;
    if (![phone isEqualToString:@""] && [phone isKindOfClass:[NSString class]]) {
        //设置背景
        UIImageView *bg = [[UIImageView alloc] initWithFrame:_headView.bounds];
        [bg setImage:[UIImage imageNamed:@"banner_register"]];
        bg.contentMode = UIViewContentModeScaleAspectFill;
        [_headView addSubview:bg];
        
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.frame = CGRectMake(0, _headView.center.y-20, kDeviceWidth, 20);
        
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = kTextFontColor333;
        
        UILabel  *label1=[[UILabel alloc]initWithFrame:CGRectMake(label.left, label.bottom, label.width, label.height)];
        label1.textAlignment = NSTextAlignmentCenter;
        label1.font=[UIFont systemFontOfSize:14];
        label1.textColor = kTextFontColor666;
        
        label.text = phone;
        label1.text = @"修神马——您身边的手机维修专家！";
        [_headView addSubview:label];
        [_headView addSubview:label1];
        //获取用户
        if ([[UserDefaults objectForKey:@"approve"] integerValue]<5 && [[UserDefaults objectForKey:@"approve"] integerValue]>0) {
            [self getApprove];
        }
    }else{
        UIImageView *bg = [[UIImageView alloc] initWithFrame:_headView.bounds];
        [bg setImage:[UIImage imageNamed:@"banner_login"]];
        bg.contentMode = UIViewContentModeScaleAspectFill;
        [_headView addSubview:bg];
        [UserDefaults setObject:@"0" forKey:@"approve"];
    }
}
#pragma mark - UITableViewDataSource
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_titles count];
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_titles[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *cellIdentifier = @"cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.textColor = kTextFontColor333;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.text = _titles[indexPath.section][indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if (section==0) {
        return 15;
//    }else
//        return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UserDefaults objectForKey:@"approve"] integerValue]) {
        
        if (indexPath.section == 0) { // 我的店铺  我的客户  评价我的
            int approve = [[UserDefaults objectForKey:@"approve"] intValue];
            if (approve == 1 || approve == 3){
                //未提交审核  活审核失败
                [self addUserMessage];
            }else{
                if (indexPath.row == 0) {
                    //我的店铺
                    JHMyShopViewController *myShopViewController = [[JHMyShopViewController alloc] init];
                    
                    myShopViewController.isHaveShop = [[UserDefaults objectForKey:@"approve"] integerValue]==5;
//                    myShopViewController.isHaveShop = NO;
                    
                    [self.navigationController pushViewController:myShopViewController animated:YES];
                }/*
                else if (indexPath.row == 1){
                    //我的客户
                    UIViewController *VC = [[UIViewController alloc] init];
                    VC.title = @"我的客户";
                    VC.view.backgroundColor = XMGlobalBg;
                    [self.navigationController pushViewController:VC animated:YES];
                }*/
                else{
                    //评价我的
//                    UIViewController *VC = [[UIViewController alloc] init];
//                    VC.title = @"评价我的";
//                    VC.view.backgroundColor = XMGlobalBg;
//                    [self.navigationController pushViewController:VC animated:YES];
                    
                    XMRatingListViewController *ratingList = [[XMRatingListViewController alloc] init];
                    ratingList.isRepair = YES;
                    [self.navigationController pushViewController:ratingList animated:YES];
                }
            }
        }else if (indexPath.section == 1){ // 常用地址  告诉朋友
            if (indexPath.row == 0) {
                //常用地址
                int approve = [[UserDefaults objectForKey:@"approve"] intValue];
                if (approve == 1 || approve == 3){
                    //未提交审核  活审核失败
                    [self addUserMessage];
                }else{
                    JHCommonAddressViewController *commonAddressViewController = [[JHCommonAddressViewController alloc] init];
                    commonAddressViewController.isDisplay = YES;
                    [self.navigationController pushViewController:commonAddressViewController animated:YES];
                    
                }
            }
            else{
                //告诉朋友
                //分享到新浪微博、腾讯微博
                [UMSocialSnsService presentSnsIconSheetView:self
                                                     appKey:@"54680edefd98c5e1160084a0"
                                                  shareText:@"修神马真好用，快来试试吧。。。。。。"
                                                 shareImage:[UIImage imageNamed:@"Icon"]
                                            shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone,UMShareToSms,nil]
                                                   delegate:nil];
            }
        }else if (indexPath.section == 2){
            /*
            if (indexPath.row == 1) {
                //用户反馈
                XMUserResponseViewController *userResponseVC = [[XMUserResponseViewController alloc] init];
                [self.navigationController pushViewController:userResponseVC animated:YES];
            }
            else if (indexPath.row == 2){
             */
                //更多设置
//#warning 用于测试，将此处改为退出登录
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"亲，您真要退出登录吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 102;
            [alert show];
            
            /*
            }
            else{
                //给修神马好评
#warning -------------此处待修改-------------------
                [self requestDataForTest];
//                [MBProgressHUD showSuccess:@"..."];
            }
             */
        }
        else{
            
            [[[UIAlertView alloc] initWithTitle:@"提示" message:@"正在完善" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            
        }
        
    }else{
        UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还未登录修神马，现在登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录", nil];
        alert1.tag = 101;
        [alert1 show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if (alertView.tag == 101) {
        
        if (buttonIndex == 1) {
            [self.navigationController pushViewController:[[XMLoginViewController alloc] init] animated:YES];
        }
        
    }else if (alertView.tag == 102){
        
        if (buttonIndex) {
            
            [UserDefaults removeObjectForKey:@"userid"];
            [UserDefaults removeObjectForKey:@"password"];
            [UserDefaults removeObjectForKey:@"phone"];
            [UserDefaults setObject:@"0" forKey:@"approve"];
            [XMDealTool sharedXMDealTool].userid = nil;
            [XMDealTool sharedXMDealTool].password = nil;
            [XMDealTool sharedXMDealTool].phone = nil;
            [XMDealTool sharedXMDealTool].approve = @"0";

            [APService setAlias:nil callbackSelector:nil object:self];
            
            [self loadHeadView];
            [[NSNotificationCenter defaultCenter] postNotificationName:kExitSystemNote object:nil];
            [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
        }
        
    }else{
        
        
    }
    
    
}

- (void)requestDataForTest
{
    NSString *webUrl = @"http://www.taobaichi.com/mobilecode.php?m=integralFree&a=detail";
    
    // 1.创建请求管理对象
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    // 2.设置参数
    NSDictionary *parameters = @{@"goods_id" : @"704232" , @"user_id" : @"791"};
    // 3.上传图片
    [mgr POST:webUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        XMLog(@"---------------%@", responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        XMLog(@"------------------%@", error);
        
    }];
}

#ifdef iOS8
-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
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


#pragma mark - 获取用户审核状态
- (void)getApprove
{
    NSString *userid = [XMDealTool sharedXMDealTool].userid;
    NSString *password = [XMDealTool sharedXMDealTool].password;
//    NSInteger approve = [[UserDefaults objectForKey:@"approve"] integerValue];
//    if (approve>0 && approve<4) {
        [XMHttpTool postWithURL:@"Detection/index" params:@{@"userid":userid,@"password":password} success:^(id json) {
            XMLog(@"message = %@",json[@"message"]);
            if ([json[@"status"] integerValue] == 1) {
                [XMDealTool sharedXMDealTool].approve = json[@"approve"];
                NSString *approve = json[@"approve"];
                [UserDefaults setObject:approve forKey:@"approve"];
            }
        } failure:^(NSError *error) {
            XMLog(@"获取失败%@",error);
        }];
//    }
}
#pragma mark -
- (void)login
{
    NSString *phone = [XMDealTool sharedXMDealTool].phone;
    if (![phone isEqualToString:@""] && [phone isKindOfClass:[NSString class]]) {
        int approve = [[UserDefaults objectForKey:@"approve"] intValue];
        XMLog(@"approve--%i",approve);
        if (approve >= 4) {
            //已审核通过
//            XMInfoTableViewController *userInfo = [[XMInfoTableViewController alloc] init];
//            userInfo.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:userInfo animated:YES];
            
            
            XMInformationViewController *userinfo = [[XMInformationViewController alloc] init];
            [self.navigationController pushViewController:userinfo animated:YES];
        }else if (approve == 1 || approve == 3){
            //未提交审核  活审核失败
            [self addUserMessage];
        }
        //审核中
        else{
            [[[UIAlertView alloc] initWithTitle:@"提示" message:@"正在审核中" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil] show];
        }
    }else{
        [self.navigationController pushViewController:[[XMLoginViewController alloc] init] animated:YES];
//        [self presentViewController:[[XMNavigationViewController alloc] initWithRootViewController:[[XMLoginViewController alloc] init]] animated:YES completion:^{
//        }];
    }
    
}
#pragma mark - 补全信息
- (void)addUserMessage
{
    //
    XMAddUserMessageViewController *userVC = [[XMAddUserMessageViewController alloc] init];
    XMNavigationViewController *user = [[XMNavigationViewController alloc] initWithRootViewController:userVC];
    [self presentViewController:user animated:YES completion:^{}];
//    [self.navigationController pushViewController:userVC animated:YES];
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
