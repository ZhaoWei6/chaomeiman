//
//  XMMineViewController.m
//  XiuShemMa
//
//  Created by Apple on 14-10-5.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMMineViewController.h"
#import "XMMainViewController.h"
#import "XMLoginViewController.h"
#import "XMBaseNavigationController.h"
#import "XMMineRepairController.h"
#import "XMAddressBookViewController.h"
#import "XMMoreSettingViewController.h"

#import "UMSocial.h"
#import "XMIdeaViewController.h"
#import "APService.h"
#import "XMHttpTool.h"
#import "XMDealTool.h"
@interface XMMineViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    UIView *_headView;
    NSArray *_titles;
}
@end

@implementation XMMineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"个人中心";
    self.view.backgroundColor = XMGlobalBg;
    
    kRectEdge
    kNAVITAIONBACKBUTTON
    _titles = @[@"常用地址",@"我的修神",@"告诉朋友",/*@"给修神马好评",@"意见反馈",*/@"更多设置"];
    
    [self loadContentView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadHeadView) name:kExitSystemNote object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 让选中单元格处于未选中
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
    
    [self loadHeadView];
    kShowOrHiddenTabBar(NO);
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
#pragma mark - 加载子视图
- (void)loadContentView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kDeviceWidth, kDeviceHeight-49-64) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tag=2;
    
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = XMGlobalBg;
    
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kMineHeadViewHeight)];
    _headView.backgroundColor = kBorderColor;
    _tableView.tableHeaderView = _headView;
    _headView.userInteractionEnabled = YES;
    UIGestureRecognizer *top = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(login)];
    [_headView addGestureRecognizer:top];
}


- (void)loadHeadView
{
    for (UIView *subView in _headView.subviews) {
        [subView removeFromSuperview];
    }
    
    QHLabel *label = [[QHLabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.frame = CGRectMake(0, _headView.center.y-15, kDeviceWidth, 30);
    
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = kTextFontColor333;
    
    QHLabel  *label1=[[QHLabel alloc]initWithFrame:CGRectMake(label.left, label.bottom, label.width, label.height)];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font=[UIFont systemFontOfSize:14];
    label1.textColor = kTextFontColor666;
    
    if (flag) {
        
        UIImageView *bg = [[UIImageView alloc] initWithFrame:_headView.bounds];
        [bg setImage:[UIImage imageNamed:@"banner_register"]];
        bg.contentMode = UIViewContentModeScaleAspectFill;
        [_headView addSubview:bg];
        label.text = phone_Number;
        label1.text = @"修神马——您身边的手机维修专家！";
        [_headView addSubview:label];
        [_headView addSubview:label1];
        
    }else{
        UIImageView *bg = [[UIImageView alloc] initWithFrame:_headView.bounds];
        [bg setImage:[UIImage imageNamed:@"banner_login"]];
        bg.contentMode = UIViewContentModeScaleAspectFill;
        [_headView addSubview:bg];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if(section==1){
        return 2;
    }else{
        return 1;
    
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.textColor = kTextFontColor333;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    cell.backgroundColor = [UIColor grayColor];
    
    if (indexPath.section < 2) {
        cell.textLabel.text = _titles[indexPath.section + indexPath.row];
    }else{
        cell.textLabel.text = _titles[indexPath.section + indexPath.row + 1];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 25;
    }else
        return 1;
    
    
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!flag && indexPath.section != 2) {
        UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还未登录修神马，现在登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录", nil];
        alert1.tag = 101;
        [alert1 show];
    }else{
        if (indexPath.section == 0) {
            //联系人信息
            XMAddressBookViewController *addressVC = [[XMAddressBookViewController alloc] init];
            addressVC.title = @"联系人信息";
            addressVC.isAllowEdit = YES;
            [self.navigationController pushViewController:addressVC animated:YES];
        }
        else if (indexPath.section == 2){
            /*
            if (indexPath.row == 0) {
                //给修神马好评
                [[[UIAlertView alloc] initWithTitle:@"提示"
                                            message:@"谢谢您的支持"
                                           delegate:nil
                                  cancelButtonTitle:@"确定"
                                  otherButtonTitles:nil, nil] show];
            }else if (indexPath.row == 1){
                //意见反馈
                XMIdeaViewController  *idea=[[XMIdeaViewController alloc]init];
                [self.navigationController pushViewController:idea animated:YES];
             }else{
             */
                //更多设置
                XMMoreSettingViewController *moreSetVC = [[XMMoreSettingViewController alloc] init];
                [self.navigationController pushViewController:moreSetVC animated:YES];
            //}
        }
        else{
            if(indexPath.row){
                //告诉朋友
                [UMSocialSnsService presentSnsIconSheetView:self
                                                     appKey:@"54680edefd98c5e1160084a0"
                                                  shareText:@"维修就用修神马\n和谐、便宜不败家"
                                                 shareImage:[UIImage imageNamed:@"Icon"]
                                            shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone,UMShareToSms,nil]
                                                   delegate:nil];
            }else{
                //我的修神
                XMMineRepairController  *mineRepair=[[XMMineRepairController alloc]init];
                [self.navigationController pushViewController:mineRepair animated:YES];
            }
        }
    }
}




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
#pragma mark - 登录||退出
- (void)login
{
    if (flag) {
//        UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"退出登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
//        [alert2 show];
    }else{
        
//        [self presentViewController:[[XMBaseNavigationController alloc] initWithRootViewController:[[XMLoginViewController alloc] init]] animated:YES completion:^{
//            kShowOrHiddenTabBar(YES);
//        }];
        XMLoginViewController  *login=[[XMLoginViewController alloc]init];
        [self.navigationController pushViewController:login animated:YES];
        
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (!buttonIndex) {
        if (alertView.tag != 101) {
            flag = NO;
            phone_Number = @"";
            [self loadHeadView];
            
            [APService setAlias:@"" callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
            [XMDealTool sharedXMDealTool].password = nil;
            [_tableView reloadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:kExitSystemNote object:nil];
        }
        // 让选中单元格处于未选中
        [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
    }else{
        if (alertView.tag == 101) {
//            [self presentViewController:[[XMBaseNavigationController alloc] initWithRootViewController:[[XMLoginViewController alloc] init]] animated:YES completion:^{
//                kShowOrHiddenTabBar(YES);
//            }];
            
            XMLoginViewController  *login=[[XMLoginViewController alloc]init];
            [self.navigationController pushViewController:login animated:YES];
        }
    }
}

- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}


//- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    [UIView animateWithDuration:0.3 animations:^{
//        if (tableView.tag>1) {
//            tableView.contentOffset=CGPointMake(0, 0);
//        }
//    }];
//
//}

-(void)viewDidAppear:(BOOL)animated{
    
    _tableView.contentOffset=CGPointMake(0, 0);


}


@end
