//
//  AdviceViewController.m
//  Chaomeiman 专家端
//
//  Created by imac on 14-12-10.
//  Copyright (c) 2014年 imac. All rights reserved.
//

#import "AdviceViewController.h"
#import "AdviceDetailController.h"

#import "MJRefresh.h"

@interface AdviceViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate,UIAlertViewDelegate>{
    UITableView *table;

    NSMutableArray *listArray;//存放数组
    
    NSMutableArray *content_array; //存放数据
    
    NSIndexPath    *_removedIndexPath;
    
    UIActivityIndicatorView *sys_pendingView; //风火轮
    
    int from;
    
    int num;
    MJRefreshFooterView *_footer;
}
@end

@implementation AdviceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=@"我的建议书";
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self getMyCreateAdvice];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    listArray=[[NSMutableArray alloc]init];
    //1.---定义表格
    [self customTable];
    //2.---我的健康建议书
    [self getMyCreateAdvice];
}

-(void)customTable{
    table =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth,kDeviceHeight-20-44-40) style:UITableViewStylePlain];
    table.delegate=self;
    table.dataSource=self;
    [self.view addSubview:table];
    
    from=1;
    num=1;
    
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = table;
    footer.delegate = self;
    _footer = footer;
    
    sys_pendingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    sys_pendingView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
    [sys_pendingView setFrame:CGRectMake(0, 0,kDeviceWidth, kDeviceHeight-44-20)];
    [sys_pendingView setAlpha:1.0];
    [self.view addSubview:sys_pendingView];
}

-(void)getMyCreateAdvice{
    
    [[LoginUser sharedLoginUser]loadurl:GetVerification(@"client", @"myCreateAdvices") with:@{
                                                                                             @"expert_id":[[NSUserDefaults standardUserDefaults]objectForKey:E_id],                                              @"page":@(num),
                                                                                             @"rows":@(from)
                                                                                             }
 BlockWithSuccess:^(id mes) {
     if ([[mes valueForKey:@"success_code"] integerValue]==200)
     {
         listArray=[NSMutableArray arrayWithArray:mes[@"success_message"]];
         [table reloadData];
     }
     
 } Failure:^(NSError *mes) {
     MyLog(@"%@",mes);
 }];
    
}


- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (!_footer.hidden) {
        from+=5;
    }
    else
    {
        from=1;
    }
    [sys_pendingView startAnimating];
    
    
    if (refreshView==_footer) {
        [[LoginUser sharedLoginUser]loadurl:GetVerification(@"client", @"myCreateAdvices")
                                       with:@{
                                              @"expert_id":[[NSUserDefaults standardUserDefaults]objectForKey:E_id],                                              @"page":@(num),
                                              @"rows":@(from)
                                              }
                           BlockWithSuccess:^(NSDictionary * mes) {
                               MyLog(@"%@",mes);
                               if ([[mes valueForKey:@"success_code"] integerValue]==200)
                               {
                                   listArray=[NSMutableArray arrayWithArray:mes[@"success_message"]];
                                   [table reloadData];
                                   [refreshView endRefreshing];
                               }
                               else
                               {
                                   UIAlertView *alte=[[UIAlertView alloc]initWithTitle:@"修改失败" message:[mes valueForKey:@"success_message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                                   [alte show];
                               }
                               [sys_pendingView stopAnimating];
                           } Failure:^(NSError *mes) {
                               [sys_pendingView stopAnimating];
                           }];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [listArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentity=@"indenty";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:indentity];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentity];
        // 图片
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        imgView.tag = 2013;
        [cell.contentView addSubview:imgView];
        
        // 主标题
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
        title.font = [UIFont boldSystemFontOfSize:16];
        title.tag = 2014;
        title.numberOfLines=0;
        [cell.contentView addSubview:title];
        
        
        // 副标题
        UILabel *detail = [[UILabel alloc] initWithFrame:CGRectZero];
        detail.font = [UIFont systemFontOfSize:14];
        detail.textColor = [UIColor lightGrayColor];
        detail.tag = 2015;
        [cell.contentView addSubview:detail];
    }
    UIImageView *imgView = (UIImageView *)[cell.contentView viewWithTag:2013];
    imgView.image=[UIImage imageNamed:@"advice"];
    imgView.frame=CGRectMake(10, cell.height/5,kDeviceWidth-240, 65);
    // 取出子视图
    UILabel *adviceTitle =(UILabel *)[cell.contentView viewWithTag:2014];
    adviceTitle.text=listArray[indexPath.row][@"advice_content"];
    CGSize size =[self hightForText:adviceTitle.text Font:[UIFont systemFontOfSize:16] Wigth:kDeviceWidth-imgView.right-20];
    adviceTitle.frame=CGRectMake(imgView.right+5, imgView.top, kDeviceWidth-imgView.right-10, size.height);
    adviceTitle.numberOfLines=0;
    
    
    UILabel *detail = (UILabel *)[cell.contentView viewWithTag:2015];
    NSDictionary *time=listArray[indexPath.row][@"advice_create_date"];
    int year=[[time valueForKey:@"year"] intValue]+1900;
    int month=[[time valueForKey:@"month"] intValue]+1;
    int day=[[time valueForKey:@"date"] intValue];
    int hour=[[time valueForKey:@"hours"] intValue]+1;
    int minute=[[time valueForKey:@"minutes"] intValue];
    int seconds=[[time valueForKey:@"seconds"] intValue];
    detail.text=[NSString stringWithFormat:@"%02d-%02d-%02d %02d:%02d:%02d",year,month,day,hour,minute,seconds];
    detail.frame=CGRectMake(imgView.right+5, adviceTitle.bottom+10, 220, 15);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AdviceDetailController *detail=[[AdviceDetailController alloc]init];
    detail.name=listArray[indexPath.row][@"advice_content"];
    detail.time=listArray[indexPath.row][@"advice_create_date"];
    detail.member_ID=listArray[indexPath.row][@"member_id"];
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:detail animated:YES];
    self.hidesBottomBarWhenPushed=NO;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    UILabel *detail1 = (UILabel *)[cell.contentView viewWithTag:2015];
    UIImageView *imgView = (UIImageView *)[cell.contentView viewWithTag:2013];
    CGSize size =[self hightForText:listArray[indexPath.row][@"advice_content"] Font:[UIFont systemFontOfSize:16] Wigth:kDeviceWidth-imgView.right-20];
    return size.height+detail1.height+35;
}

//根据内容获取高度
-(CGSize)hightForText:(NSString *)text Font:(UIFont *)font Wigth:(CGFloat)wigth
{
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGSize sizezz = [text boundingRectWithSize:CGSizeMake(wigth, 9999) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return sizezz;
}

//删除消息
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete; //return UITableViewCellEditingStyleInsert;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"是否彻底删除建议书" message:nil delegate:self cancelButtonTitle:@"彻底" otherButtonTitles:@"不彻底", nil];
        // 记录住要删除的表格行索引
        _removedIndexPath = indexPath;
        [alert show];
        
        //删除数据
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:kBool];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
    }else if(editingStyle == UITableViewCellEditingStyleInsert)
    {
        [listArray insertObject:@"new Item" atIndex:indexPath.row];
        [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - UIAlertView代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    MyLog(@"%li",(long)buttonIndex);
    // 2. 将用户数据删除
        if (_removedIndexPath.row<[listArray count]) {
            [[LoginUser sharedLoginUser]loadurl:GetVerification(@"client", @"deleteAdvice") with:@{@"advice_id":[NSString stringWithFormat:@"%@",listArray[_removedIndexPath.row][@"id"]],@"flag":[NSString stringWithFormat:@"%li",(long)buttonIndex]} BlockWithSuccess:^(id mes) {
                MyLog(@"%@",mes);
                if ([mes[@"success_code"]integerValue]==200) {
                    MyLog(@"%@",mes[@"success_message"]);
                    [listArray removeObjectAtIndex:_removedIndexPath.row];
                    [table deleteRowsAtIndexPaths:[NSArray arrayWithObject:_removedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                }
            } Failure:^(NSError *mes) {
                MyLog(@"%@",mes);
            }];
        }
}

@end
