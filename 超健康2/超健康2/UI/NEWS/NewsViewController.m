//
//  NewsViewController.m
//  Chaomeiman 专家端
//
//  Created by imac on 14-12-10.
//  Copyright (c) 2014年 imac. All rights reserved.
//

#import "NewsViewController.h"
#import "MainViewController.h"

#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "ChatViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "UIImageView+WebCache.h"

@interface NewsViewController ()<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate,NSFetchedResultsControllerDelegate,CLLocationManagerDelegate>{
    UITableView *table;
    //存放数据
    NSMutableArray *listArray;
    
    NSFetchedResultsController  *_fetchedResultsController;
    NSIndexPath                 *_removedIndexPath;
    CLLocationManager *locationManager;
    
    NSMutableArray *messageList;
    //消息条数
    UILabel *messageNumlab;
}

@end

@implementation NewsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=@"消息";
    }
    return self;
}

#pragma mark - 实例化NSFetchedResultsController
- (void)setupFetchedController
{
    [[LoginUser sharedLoginUser]loadurl:GetVerification(@"client", @"getChatList") with:@{@"id":[[NSUserDefaults standardUserDefaults]objectForKey:E_id],@"type":[NSString stringWithFormat:@"1"],@"page":@(1),@"rows":@(5)                                          } BlockWithSuccess:^(id mes) {
        if ([[mes valueForKey:@"success_code"] integerValue]==200)
        {
            messageList=mes[@"success_message"][@"messageList"];
            MyLog(@"%@",messageList);
            listArray=[NSMutableArray arrayWithArray:messageList];
            [table reloadData];
//            for(int i=0;i<messageList.count;i++){
//                NSDictionary *dic=[messageList objectAtIndex:i];
//                MyLog(@"i%@",dic);
//                MemberClass *menber=[[MemberClass alloc]initWithDictionary:dic];
//                [listArray addObject:menber];
//            }
        }else{
            UIAlertView *alte=[[UIAlertView alloc]initWithTitle:@"请求失败" message:[mes valueForKey:@"success_message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alte show];
        }
    } Failure:^(NSError *mes) {
        MyLog(@"%@",mes);
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [table reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     self.edgesForExtendedLayout = UIRectEdgeNone;
//    listArray=[NSMutableArray array];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tableReload) name:KNoticationCenter object:nil];
//0.----获取专家列表
    [self tableReload];
//1.---定义表格
    [self customTable];
//2.----定位位置
    [self getLocations];
//4----点击删除按钮
    self.editButtonItem.title=@"删除";
    self.navigationItem.rightBarButtonItem=self.editButtonItem;
}

-(void)tableReload{
    [self setupFetchedController];
}

-(void)getLocations{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate=self;
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] > 8.0)
    {
        //设置定位权限 仅ios8有意义
        //        [locationManager requestWhenInUseAuthorization];// 前台定位
        
        //        [locationManager requestAlwaysAuthorization];// 前后台同时定位
        [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    MyLog(@"\n定位成功\n %@",locations[0]);
    CLLocation *loc=locations[0];
    [LoginUser sharedLoginUser].longitu=[NSString stringWithFormat:@"%f",loc.coordinate.longitude];
    [LoginUser sharedLoginUser].latitu=[NSString stringWithFormat:@"%f",loc.coordinate.latitude];
    [locationManager stopUpdatingLocation];
    
    [[LoginUser sharedLoginUser]loadurl:GetVerification(@"client", @"setExpertAddress") with:@{@"expert_id":[[NSUserDefaults standardUserDefaults]objectForKey:E_id],@"expert_latitude":[[LoginUser sharedLoginUser]latitu],@"expert_longitude":[[LoginUser sharedLoginUser]longitu]} BlockWithSuccess:^(id responseObject) {
        if ([responseObject[@"success_code"] intValue]==200) {
            NSString *data=[responseObject objectForKey:@"success_message"];
            MyLog(@"%@----data",data);
        }
    } Failure:^(NSError *mes) {
        MyLog(@"%@error",mes);
    }];
}


-(void)customTable{
    table =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight) style:UITableViewStylePlain];
    table.delegate=self;
    table.dataSource=self;
//    table.separatorColor=[UIColor orangeColor];
    if(IOS7){
    table.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    [self.view addSubview:table];
}

#pragma mark - UITableView数据源方法
#pragma mark 表格分组数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}

#pragma mark 对应分组中表格的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *indentity=@"indenty";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:indentity];
    NSDictionary * dic=listArray[indexPath.row];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentity];
        
        // 图片
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 75, 75)];
        imgView.tag = 2013;
        [cell.contentView addSubview:imgView];
        
        
        // 主标题
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(imgView.right+10, imgView.top, kDeviceWidth-200, 45)];
        title.font = [UIFont boldSystemFontOfSize:16];
        title.tag = 2014;
        [cell.contentView addSubview:title];
        
        
        // 副标题
        UILabel *detail = [[UILabel alloc] initWithFrame:CGRectMake(imgView.right+10, title.bottom-5, kDeviceWidth-100, 25)];
        detail.font = [UIFont systemFontOfSize:14];
        detail.textColor = [UIColor lightGrayColor];
        detail.tag = 2015;
        [cell.contentView addSubview:detail];
        
        //时间
        UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(title.right+50, imgView.top+10, 50, 45)];
        time.font = [UIFont boldSystemFontOfSize:16];
        time.textColor = [UIColor lightGrayColor];
        time.tag = 2016;
        [cell.contentView addSubview:time];
        
        //右侧消息
        UILabel *messageNumlab1 = [[UILabel alloc] initWithFrame:CGRectMake(title.right+60, time.bottom-10, 20, 20)];
        messageNumlab1.textAlignment=NSTextAlignmentCenter;
        messageNumlab1.font = [UIFont boldSystemFontOfSize:16];
        messageNumlab1.backgroundColor=[UIColor redColor];
        messageNumlab1.layer.cornerRadius=messageNumlab1.frame.size.width/2;
        messageNumlab1.clipsToBounds=YES;
        messageNumlab1.tag = 2017;
        messageNumlab1.textColor=[UIColor whiteColor];
        [cell.contentView addSubview:messageNumlab1];
    }
    
#pragma mark 获取用户的image
    UIImageView *imgView = (UIImageView *)[cell.contentView viewWithTag:2013];
    [imgView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dic valueForKey:@"member_head"]]] placeholderImage:[UIImage imageNamed:@"头像1.jpg"] options:SDWebImageLowPriority | SDWebImageRetryFailed ];
    imgView.layer.masksToBounds =YES;
    imgView.layer.cornerRadius =imgView.frame.size.width/2;
    imgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    imgView.layer.borderWidth=0.1;
    
    // 取出子视图
    UILabel *title  = (UILabel *)[cell.contentView viewWithTag:2014];
//    if (([[LoginUser sharedLoginUser].changeName length]!=0)&&(indexPath.row==[[LoginUser sharedLoginUser].selectNumber integerValue])) {
//        title.text=[LoginUser sharedLoginUser].changeName;
//    }else
        title.text=[NSString stringWithFormat:@"%@",[dic valueForKey:@"member_name"]];
    
    UILabel *detail = (UILabel *)[cell.contentView viewWithTag:2015];
    NSString *text=[NSString stringWithFormat:@"%@",[dic valueForKey:@"type"]];
    if ([text isEqualToString:@"2"]) {
        detail.text=[NSString stringWithFormat:@"［图片］"];
    }
    else
       detail.text=[NSString stringWithFormat:@"%@",[dic valueForKey:@"content"]];
    
    
    UILabel *time1=(UILabel *)[cell.contentView viewWithTag:2016];
    NSDictionary *time=[dic valueForKey:@"create_date"];
    int hour=[[time valueForKey:@"hours"] intValue]+1;
    int minute=[[time valueForKey:@"minutes"] intValue];
    time1.text=[NSString stringWithFormat:@"%02d:%02d",hour,minute];
    
    //消息条数
    messageNumlab  = (UILabel *)[cell.contentView viewWithTag:2017];
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithDictionary:[LoginUser sharedLoginUser].messageNumDic];
    int num=[[dict valueForKey:[NSString stringWithFormat:@"%@",[dic valueForKey:@"member_phone"]]] intValue];
    if (num==0 && num<100) {
        messageNumlab.hidden=YES;
    }
    else if(num>=100)
    {
        messageNumlab.hidden=NO;
        messageNumlab.text=@"100+";
    }
    else
    {
        messageNumlab.hidden=NO;
        messageNumlab.text=[NSString stringWithFormat:@"%d",num];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"ChatViewController" bundle:nil];
    ChatViewController *controller=[storyboard instantiateViewControllerWithIdentifier:@"ChatViewController"];
    MyLog(@"%@",listArray[indexPath.row]);
    NSDictionary * dic=listArray[indexPath.row];

//    if (([[LoginUser sharedLoginUser].changeName length]!=0)&&([[LoginUser sharedLoginUser].changeName isEqualToString:[NSString stringWithFormat:@"%@",[dic valueForKey:@"member_name"]]])) {
//        controller.bareName=[LoginUser sharedLoginUser].changeName;
//    }else
       controller.bareName=[NSString stringWithFormat:@"%@",[dic valueForKey:@"member_name"]];
    controller.bareJidStr =[NSString stringWithFormat:@"%@@%@",[dic valueForKey:@"member_phone"],kHostName];
    controller.bareImageUrl =[NSString stringWithFormat:@"%@",[dic valueForKey:@"member_head"]];
    controller.bareId=[NSString stringWithFormat:@"%@",[dic valueForKey:@"member_id"]];
    controller.number=indexPath.row;
    [[LoginUser sharedLoginUser]setMember_id:controller.bareId];
    
    // 取出对话方的头像数据
    controller.myImageUrl =[[NSUserDefaults standardUserDefaults]objectForKey:kPersonHeadImage];
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:controller animated:YES];
    self.hidesBottomBarWhenPushed=NO;
    
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithDictionary:[LoginUser sharedLoginUser].messageNumDic];
    int num=[[dict valueForKey:[NSString stringWithFormat:@"%@",[dic valueForKey:@"member_phone"]]] intValue];//
    
    [dict removeObjectForKey:[NSString stringWithFormat:@"%@",[dic valueForKey:@"member_phone"]]];
    
    [LoginUser sharedLoginUser].messageNum-=num;
    
    if ([LoginUser sharedLoginUser].messageNum>0) {
        messageFlag.badgeValue=[NSString stringWithFormat:@"%ld",(long)[LoginUser sharedLoginUser].messageNum];
    }
    else if([LoginUser sharedLoginUser].messageNum>=100)
        messageFlag.badgeValue=[NSString stringWithFormat:@"100+"];
    else
        messageFlag.badgeValue=nil;
    [LoginUser sharedLoginUser].messageNumDic=dict;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

//点击
-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [table setEditing:editing animated:YES];
    if (self.editing) {
        self.editButtonItem.title = @"完成";
    } else {
        self.editButtonItem.title = @"删除";
    }
}

#pragma mark 允许表格编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark 提交表格编辑
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 提示，如果没有另行执行，editingStyle就是删除
    if (UITableViewCellEditingStyleDelete == editingStyle) {
        /*
         在OC开发中，是MVC架构的，数据绑定到表格，如果要删除表格中的数据，应该：
         1. 删除数据
         2. 刷新表格
         
         注意不要直接删除表格行，而不删除数据。
         */
        // 删除数据
        // 1. 取出当前的用户数据
        
        // 发现问题，删除太快，没有任何提示，不允许用户后悔
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"是否删除对话框" message:[NSString stringWithFormat:@"%@",[listArray[indexPath.row] valueForKey:@"member_name"]] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        // 记录住要删除的表格行索引
        _removedIndexPath = indexPath;
        [alert show];
    }
}

#pragma mark - UIAlertView代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSDictionary * dic=listArray[_removedIndexPath.row];
    
    // 2. 将用户数据删除
    if (1 == buttonIndex) {
        if (_removedIndexPath.row<[listArray count]) {
        [[LoginUser sharedLoginUser]loadurl:GetVerification(@"client", @"deleteChatList") with:@{@"expert_id":[[NSUserDefaults standardUserDefaults]objectForKey:E_id],@"member_id":[NSString stringWithFormat:@"%@",listArray[_removedIndexPath.row][@"member_id"]]} BlockWithSuccess:^(id mes) {
            if ([mes[@"success_code"] intValue]==200) {
                NSString *data=[mes objectForKey:@"success_message"];
                MyLog(@"%@----data",data);
            }
        } Failure:^(NSError *mes) {
                MyLog(@"%@",mes);
        }];
            
            [listArray removeObjectAtIndex:_removedIndexPath.row];//移除数据源的数据
  //---------//
            NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithDictionary:[LoginUser sharedLoginUser].messageNumDic];
            int num=[[dict valueForKey:[NSString stringWithFormat:@"%@",[dic valueForKey:@"member_phone"]]] intValue];//
            
            [dict removeObjectForKey:[NSString stringWithFormat:@"%@",[dic valueForKey:@"member_phone"]]];
            
            [LoginUser sharedLoginUser].messageNum-=num;
            
            if ([LoginUser sharedLoginUser].messageNum>0) {
                messageFlag.badgeValue=[NSString stringWithFormat:@"%d",[LoginUser sharedLoginUser].messageNum];
            }
            else if([LoginUser sharedLoginUser].messageNum>=100)
                messageFlag.badgeValue=[NSString stringWithFormat:@"100+"];
            else
                messageFlag.badgeValue=nil;
            [LoginUser sharedLoginUser].messageNumDic=dict;
 //---------//
            [table deleteRowsAtIndexPaths:[NSArray arrayWithObject:_removedIndexPath] withRowAnimation:UITableViewRowAnimationLeft];//移除tableView中的数据
        }
    }
}

@end
