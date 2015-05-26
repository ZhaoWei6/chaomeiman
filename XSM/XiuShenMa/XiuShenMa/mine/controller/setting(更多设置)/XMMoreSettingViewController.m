//
//  XMMoreSettingViewController.m
//  XiuShenMa
//
//  Created by Apple on 14/11/4.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMMoreSettingViewController.h"
#import "XMUserController.h"
#import "XMProblemController.h"
#import "XMAboutController.h"
#import "APService.h"
#import "XMDealTool.h"
#import "XMHttpTool.h"
@interface XMMoreSettingViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView *_tableView;
    NSArray     *_titles;
    UIButton  *button;
}
@end

@implementation XMMoreSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    kNAVITAIONBACKBUTTON
    self.title = @"更多设置";
    _titles = @[@[/*@"欢迎页面",*/@"用户协议",@"常见问题"],@[@"关于我们"]];
    [self loadSubViews];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
}

- (void)loadSubViews
{
    self.view.backgroundColor = XMGlobalBg;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kDeviceWidth, kDeviceHeight) style:UITableViewStyleGrouped];
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 50;
    _tableView.separatorInset = UIEdgeInsetsZero;
    _tableView.backgroundColor = XMGlobalBg;
    
    if (flag) {
        button=[[UIButton alloc]initWithFrame:CGRectMake(10, kDeviceHeight-150, kDeviceWidth-20, 50)];
        [button setTitle:@"退出登录" forState:UIControlStateNormal];
        button.backgroundColor=XMButtonBg;
        [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchDown];
        button.layer.cornerRadius=5;
        
        [_tableView  addSubview:button];
    }
}

#pragma mark - UITableViewDataSource UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _titles.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_titles[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    /* if (indexPath.section == 2) {
     QHLabel *label = [[QHLabel alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 50)];
     [cell.contentView addSubview:label];
     label.textColor = [UIColor blackColor];
     label.backgroundColor=XMButtonBg;
     label.textAlignment = NSTextAlignmentCenter;
     label.text = _titles[indexPath.section][indexPath.row];
     label.font = [UIFont boldSystemFontOfSize:24];
     }else {
     cell.textLabel.text = _titles[indexPath.section][indexPath.row];
     //        UIImageView *indicator = [[UIImageView alloc] initWithImage:[UIImage resizedImage:@"icon_go"]];
     //        indicator.contentMode = UIViewContentModeScaleToFill;
     //        indicator.frame = CGRectMake(0, 0, 20, 30);
     //       cell.accessoryView = indicator;
     cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
     
     
     }*/
    cell.textLabel.text = _titles[indexPath.section][indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textColor = kTextFontColor333;
    /*
    if (indexPath.section == 1 && indexPath.row == 0) {
        UILabel *appVersion = [[UILabel alloc] initWithFrame:CGRectMake(150, 0, 130, 50)];
        appVersion.text = [NSString stringWithFormat:@"V%@",AppVersion];
        appVersion.textAlignment = NSTextAlignmentRight;
        appVersion.textColor = kTextFontColor333;
        [cell.contentView addSubview:appVersion];
        XMLog(@"app %@",AppVersion);
    }
    */
    cell.backgroundColor = [UIColor whiteColor];
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    return cell;
}
//UIAlertView  *alert3;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            //用户协议
            XMUserController  *userContorller=[[XMUserController alloc]init];
            [self.navigationController pushViewController:userContorller animated:YES];
        }else {
            //常见问题
            XMProblemController  *problemContorller=[[XMProblemController alloc]init];
            [self.navigationController pushViewController:problemContorller animated:YES];
            
        }/*else{
#warning 欢迎页面
            [[[UIAlertView alloc] initWithTitle:@"提示"
                                       message:@"敬请期待"
                                      delegate:self
                             cancelButtonTitle:@"继续"
                              otherButtonTitles:nil, nil] show];
        }*/
    }else if (indexPath.section==1){
//        if (indexPath.row==1) {
            //关于我们
            XMAboutController  *aboutContorller=[[XMAboutController alloc]init];
            [self.navigationController pushViewController:aboutContorller animated:YES];
            
//        }else {
//            //版本升级
//            [XMHttpTool postWithURL:@"Checkversion/index"
//                             params:@{@"apptype":@(1),@"clienttype":@(1)}
//                            success:^(id json) {
//                                XMLog(@"json-->%@",json);
//                                if ([json[@"status"] integerValue] == 1) {
//                                    NSString *version = json[@"version"];
//                                    if ([version isEqualToString:AppVersion]) {
//                                        [[[UIAlertView alloc] initWithTitle:@"提示"
//                                                                    message:@"已是最新版本，无需下载"
//                                                                   delegate:self
//                                                          cancelButtonTitle:@"确定"
//                                                          otherButtonTitles:nil, nil] show];
//                                    }else{
//                                        UIAlertView *alert = [[UIAlertView alloc]
//                                                              initWithTitle:@"提示"
//                                                              message:@"发现新版本"
//                                                              delegate:self
//                                                              cancelButtonTitle:@"取消"
//                                                              otherButtonTitles:@"去下载", nil];
//                                        alert.tag = 1002;
//                                        [alert show];
//                                    }
//                                }
//                            }
//                            failure:^(NSError *error) {
//                                [MBProgressHUD showError:@"网络异常"];
//                            }];
//        }
    }else if (indexPath.section==2){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"退出登录"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:@"取消", nil];
        alert.tag = 1001;
        [alert show];
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

- (void)alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    NSInteger tag_alert = 0;
    tag_alert = [alert tag];
    
    if ([alert.message isEqualToString:@"您确定要退出登录吗？"]) {
        XMLog(@"退出登录");
        if (!buttonIndex) {
            flag = NO;
            phone_Number = @"";
            button.hidden = YES;
            [APService setAlias:@"" callbackSelector:nil object:nil];
            
            [_tableView reloadData];
            [XMDealTool sharedXMDealTool].password = nil;
            [[NSNotificationCenter defaultCenter] postNotificationName:kExitSystemNote object:nil];
            // 让选中单元格处于未选中
            [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
        }
    }
//    else if (tag_alert == 1002){
//        if (buttonIndex) {
//            XMLog(@"去下载");
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.pgyer.com/ly6V"]];
//        }
//        XMLog(@"点击了alertView上的选项");
//    }
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
}


-(void)buttonAction{
    
    UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定要退出登录吗？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alert2 show];
    
}

@end
