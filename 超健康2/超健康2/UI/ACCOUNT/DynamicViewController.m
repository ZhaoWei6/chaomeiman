//
//  DynamicViewController.m
//  Chaomeiman 专家端
//
//  Created by imac on 14-12-15.
//  Copyright (c) 2014年 imac. All rights reserved.
//

#import "DynamicViewController.h"
#import "PublicDynamicController.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "WeDetailImageViewController.h"
#import "BaseViewController.h"
#import "PaintActiveViewCell.h"

@interface DynamicViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate,UIAlertViewDelegate,PaintActiveViewCellDelegrate>{
    UITableView *table;
    
    NSMutableArray *listArray;//存放数组
//    NSMutableArray *indexArray;//存放数组
    NSIndexPath    *_removedIndexPath;
    
    UIActivityIndicatorView *sys_pendingView; //风火轮
    int from;
    int num;
    MJRefreshFooterView *_footer;
}

@end

@implementation DynamicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=@"专家动态";
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    from=0;
    listArray=[[NSMutableArray alloc]init];
    [self refreshViewBeginRefreshing:_footer];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    listArray=[[NSMutableArray alloc]init];
    num=5;
    //1.---定义表格
    [self customTable];
    UINib *nib=[UINib nibWithNibName:@"PaintActiveViewCell" bundle:nil];
    [table registerNib:nib forCellReuseIdentifier:@"Cell"];
    //2.---下拉刷新
    [self MJfresh];
    //3.---风火轮
    [self activity];
    
    [self addLeftButtonReturn:@selector(dismiss)];
    [self addRightButtonReturn:@"发布动态" with:@selector(rightDismiss)];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

-(void)customTable{
    table =[[UITableView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth, kDeviceHeight-20-44) style:UITableViewStylePlain];
    table.delegate=self;
    table.dataSource=self;
    [self.view addSubview:table];
}

-(void)MJfresh{
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = table;
    footer.delegate = self;
    _footer = footer;
    //[self refreshViewBeginRefreshing:_footer];
}

-(void)activity{
    sys_pendingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    sys_pendingView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
    [sys_pendingView setFrame:CGRectMake(0, 0,kDeviceWidth, kDeviceHeight-44-20)];
    [sys_pendingView setAlpha:1.0];
    [self.view addSubview:sys_pendingView];
}
#pragma mark - 刷新代理方法
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (!_footer.hidden) {
        from+=1;
    }
    else
    {
        from=1;
    }
    [sys_pendingView startAnimating];
    
    if (refreshView==_footer) {
        [[LoginUser sharedLoginUser]loadurl:GetVerification(@"client", @"getMyDynamics")
                                       with:@{
                                              @"expert_id":[[NSUserDefaults standardUserDefaults]objectForKey:E_id], //专家id
                                              @"page":@(from),
                                              @"rows":@(num)
                                              }
                           BlockWithSuccess:^(NSDictionary * mes) {
                               MyLog(@"%@",mes);
                               if ([[mes valueForKey:@"success_code"] integerValue]==200)
                               {
                                   NSArray *arr=[mes valueForKey:@"success_message"] ;
                                   for (int i=0; i<arr.count; i++) {
                                       ExpertActive *act=[[ExpertActive alloc]initWithDictionary:arr[i]];
                                       [listArray addObject:act];
                                   }
                                   
                                   [table reloadData];
                                   
                                   _footer.hidden=(arr.count <1);
                                   
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
                               [table reloadData];
                           }];
    }
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [listArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExpertActive *act=listArray[indexPath.row];
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:16]};
    CGSize sizezz = [act.AcContent boundingRectWithSize:CGSizeMake(204, 9999) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    if (act.imageArr.count>3) {
        return sizezz.height+60+60;
    }
    else if(act.imageArr.count>0){
        return sizezz.height+75;
    }
    else
        return sizezz.height+20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentity=@"Cell";
    PaintActiveViewCell *cell=[tableView dequeueReusableCellWithIdentifier:indentity];
    cell.act=listArray[indexPath.row];
    cell.delegrate=self;
    return cell;
}

-(void)touchImage:(NSString *)url
{
    WeDetailImageViewController *vimage=[[WeDetailImageViewController alloc]init];
    vimage.message=url;
    BaseViewController*nav=[[BaseViewController alloc]initWithRootViewController:vimage];
    [self.navigationController presentViewController:nav animated:YES completion:^{}];
}


-(void)dismiss{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightDismiss{
    PublicDynamicController *pub=[[PublicDynamicController alloc]init];
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:pub animated:YES];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
//    UILabel *detail1 = (UILabel *)[cell.contentView viewWithTag:2016];
//    CGSize size =[self hightForText:listArray[indexPath.row][@"dynamic_content"] Font:[UIFont systemFontOfSize:16] Wigth:kDeviceWidth-detail1.right-15];
//    if( [listArray[indexPath.row][@"pic_urlList"] count]==0)
//    {
//        return size.height+40;
//    }
//    if ([listArray[indexPath.row][@"pic_urlList"] count]>0&&[listArray[indexPath.row][@"pic_urlList"] count]<=3) {
//        return size.height+40+65;
//    }
//    return size.height+40+130;
//}
//
//--------------------专家可以删除数据，从后台数据库删除--------------
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"是否彻底删除专家动态" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        // 记录住要删除的表格行索引
        _removedIndexPath = indexPath;
        [alert show];
        
    }else if(editingStyle == UITableViewCellEditingStyleInsert)
    {
        [listArray insertObject:@"new Item" atIndex:indexPath.row];
        [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - UIAlertView代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    ExpertActive *act=listArray[_removedIndexPath.row];
    // 2. 将用户数据删除
    if (_removedIndexPath.row<[listArray count]) {
        [[LoginUser sharedLoginUser]loadurl:GetVerification(@"client", @"deleteMyDynamic") with:@{@"dynamic_id":[NSString stringWithFormat:@"%@",act.AcId]} BlockWithSuccess:^(id mes) {
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

//根据内容获取高度
-(CGSize)hightForText:(NSString *)text Font:(UIFont *)font Wigth:(CGFloat)wigth
{
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGSize sizezz = [text boundingRectWithSize:CGSizeMake(wigth, 9999) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return sizezz;
}


//- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
//{
//    if (refreshView==_footer) {
//        [[LoginUser sharedLoginUser]loadurl:GetVerification(@"client", @"getMyDynamics")
//                                       with:@{
//                                              @"expert_id":[[NSUserDefaults standardUserDefaults]objectForKey:E_id],
//                                              @"page":@(num),
//                                              @"rows":@(from)
//                                              }
//                           BlockWithSuccess:^(NSDictionary * mes) {
//                               if ([[mes valueForKey:@"success_code"] integerValue]==200)
//                               {
//                                   MyLog(@"%@",mes);
//                                   NSMutableArray *arr=[mes valueForKey:@"success_message"];
//                                   if (listArray.count==indexArray.count) {
//                                       for (int i=0; i<arr.count; i++) {
//                                           ExpertActive *act=[[ExpertActive alloc]initWithDictionary:arr[i]];
//                                           [listArray addObject:act];
//                                       }
//                                   }
//
//                                   if (listArray.count!=arr.count) {
//                                       for (int i=listArray.count; i<arr.count; i++) {
//                                           ExpertActive *act=[[ExpertActive alloc]initWithDictionary:arr[i]];
//                                           [listArray addObject:act];
//                                       }
//                                   }
//
//                                   [table reloadData];
//                                   _footer.hidden=(arr.count <1);
//                                   [refreshView endRefreshing];
//                               }
//                               else
//                               {
//                                   UIAlertView *alte=[[UIAlertView alloc]initWithTitle:@"修改失败" message:[mes valueForKey:@"success_message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//                                   [alte show];
//                               }
//                               [sys_pendingView stopAnimating];
//                           } Failure:^(NSError *mes) {
//                               [sys_pendingView stopAnimating];
//                           }];
//    }
//    if (!_footer.hidden) {
//        from+=5;
//    }
//    else
//    {
//        from=1;
//    }
//    [sys_pendingView startAnimating];
//}

@end
