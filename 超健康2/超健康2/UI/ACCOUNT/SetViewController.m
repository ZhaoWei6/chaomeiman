//
//  SetViewController.m
//  Chaomeiman 专家端
//
//  Created by imac on 14-12-15.
//  Copyright (c) 2014年 imac. All rights reserved.
//

#import "SetViewController.h"
#import "LoginViewController.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
@interface SetViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>{
    UITableView *tableViewSpec;
    NSString *infoVersion;
}

@end

@implementation SetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=@"设置";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self addLeftButtonReturn:@selector(dismiss)];
    //表单
    tableViewSpec=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight) style:UITableViewStyleGrouped];
    tableViewSpec.delegate=self;
    tableViewSpec.dataSource=self;
    tableViewSpec.showsVerticalScrollIndicator=NO;
    tableViewSpec.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableViewSpec];
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    //CFShow((__bridge CFTypeRef)(infoDic));
    infoVersion = [infoDic objectForKey:@"CFBundleVersion"];
}

#pragma mark Datasource & Delegrate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 3;
            break;
        default:
            return 1;
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellIden=@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIden];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:nil];
    }
    //推送
    if (indexPath.row==0&&indexPath.section==0) {
        UISwitch *swith=[[UISwitch alloc]initWithFrame:CGRectMake(kDeviceWidth-70, 10, 60, 50)];
        swith.on=YES;
        [cell.contentView addSubview:swith];
        cell.textLabel.text=@"推送";
    }
    //版本更新
    else if (indexPath.row==1&&indexPath.section==0){
        cell.textLabel.text=@"版本更新";
        cell.detailTextLabel.text=infoVersion;
    }
    //清除缓存
    else if(indexPath.row==2&&indexPath.section==0){
        cell.textLabel.text=@"清除缓存";
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%lluB",[[SDImageCache sharedImageCache] getSize]/1024];
    }else{
    //退出登录
        UIButton *turnBack=[UIButton buttonWithType:UIButtonTypeCustom];
        [turnBack setImage:[UIImage imageNamed:@"turnBackSelect"] forState:UIControlStateNormal];
        [turnBack setImage:[UIImage imageNamed:@"turnBack"] forState:UIControlStateHighlighted];
        [turnBack setFrame:CGRectMake(10, 0, kDeviceWidth-20, 50)];
        [turnBack addTarget:self action:@selector(turnBack) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:turnBack];

    }
//    if ((indexPath.section==0&&indexPath.row==1)) {
//        cell.accessoryView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"goBack2"]];
//        cell.selectionStyle=UITableViewCellSelectionStyleNone;
//    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(tintColor)]) {
        if (tableView == tableViewSpec) {
            CGFloat cornerRadius = 5.f;
            cell.backgroundColor = UIColor.clearColor;
            CAShapeLayer *layer = [[CAShapeLayer alloc] init];
            CGMutablePathRef pathRef = CGPathCreateMutable();
            CGRect bounds = CGRectInset(cell.bounds, 10, 0);
            BOOL addLine = NO;
            if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
                CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
            } else if (indexPath.row == 0) {
                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
                addLine = YES;
            } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
            } else {
                CGPathAddRect(pathRef, nil, bounds);
                addLine = YES;
            }
            layer.path = pathRef;
            CFRelease(pathRef);
            layer.fillColor = [UIColor colorWithWhite:1.f alpha:0.8f].CGColor;
            
            if (addLine == YES) {
                CALayer *lineLayer = [[CALayer alloc] init];
                CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
                lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+10, bounds.size.height-lineHeight, bounds.size.width-10, lineHeight);
                lineLayer.backgroundColor = tableView.separatorColor.CGColor;
                [layer addSublayer:lineLayer];
            }
            UIView *testView = [[UIView alloc] initWithFrame:bounds];
            [testView.layer insertSublayer:layer atIndex:0];
            testView.backgroundColor = UIColor.clearColor;
            cell.backgroundView = testView;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==1&&indexPath.section==0) {
        //[self onCheckVersion];
        if (indexPath.row==1) {
            [[LoginUser sharedLoginUser] loadurl:GetVerification(@"client", @"version")
                                            with:@{@"os":@"ios",
                                                   @"version":infoVersion,
                                                   @"type":[NSString stringWithFormat:@"1"]}
                                BlockWithSuccess:^(id mes) {
                                    NSLog(@"%@",mes);
                                    if ([[mes valueForKey:@"success_code"] intValue]==200) {
                                        if ([mes valueForKey:@"success_message"]==[NSNull null]) {
                                            UIAlertView *alte=[[UIAlertView alloc]initWithTitle:@"提示" message:@"已是最新版本" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                                            [alte show];
                                        }
                                        else
                                        {
                                            UIAlertView *alte=[[UIAlertView alloc]initWithTitle:@"发现新版本" message:@"有新版本，是否现在更新？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"更新", nil];
                                            [alte show];
                                        }
                                    }
                                    else
                                    {
                                        UIAlertView *alte=[[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"%@",[mes valueForKey:@"success_message"]] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                                        [alte show];
                                    }
                                    
                                }
                                         Failure:^(NSError *mes) {
                                             
                                         }];
        }
    }
    if (indexPath.row==2&&indexPath.section==0) {
        [[SDImageCache sharedImageCache]clearDisk];
        [[SDImageCache sharedImageCache]clearMemory];
        [[SDWebImageManager sharedManager]cancelAll];
        [tableViewSpec reloadRowsAtIndexPaths: [NSArray arrayWithObject: indexPath] withRowAnimation: UITableViewRowAnimationAutomatic];
    }
    
}


-(void)onCheckVersion
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    //CFShow((__bridge CFTypeRef)(infoDic));
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleVersion"];
    NSString *URL = @"http://itunes.apple.com/lookup?id=526657411";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:URL]];
    [request setHTTPMethod:@"POST"];
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *recervedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:recervedData options:NSJSONReadingMutableContainers error:nil];
    NSArray *infoArray = [dic objectForKey:@"results"];
    if ([infoArray count]) {
        NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
        NSString *lastVersion = [releaseInfo objectForKey:@"version"];
        if (![lastVersion isEqualToString:currentVersion]) {
            //trackViewURL = [releaseInfo objectForKey:@"trackVireUrl"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:@"有新的版本更新，是否前往更新？" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"更新", nil];
            alert.tag = 10000;
            [alert show];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:@"此版本为最新版本" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alert.tag = 10001;
            [alert show];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==10000) {
        if (buttonIndex==1) {
            NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com"];
            [[UIApplication sharedApplication]openURL:url];
        }
    }
}

-(void)turnBack{
    LoginViewController *login=[[LoginViewController alloc]init];
    [self presentViewController:login animated:YES completion:^{
        //退出服务器
        [[LoginUser sharedLoginUser]loadurl:GetVerification(@"client", @"expertLogout") with:@{@"act":[[LoginUser sharedLoginUser]userName]} BlockWithSuccess:^(id mes) {
            MyLog(@"------%@responseObject",mes);
            if ([mes[@"success_code"] intValue]==200) {
                NSString *data=[mes objectForKey:@"success_message"];
                MyLog(@"%@----data",data);
            }
        } Failure:^(NSError *mes) {
            MyLog(@"%@",mes);
        }];
        //退出openfire服务器
        AppDelegate *app=xmppDelegate;
        [app logout];
    }];
    MyLog(@"退出登录");
}

-(void)dismiss{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
