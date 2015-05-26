//
//  XMMineRepairController.m
//  XiuShenMa
//
//  Created by Apple on 14/11/14.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMMineRepairController.h"
#import "XMMineRepairCell.h"
#import "XMDealTool.h"
#import "XMRepairmanDetail.h"
#import "XMRepairDetailViewController.h"
#import "MJRefresh.h"

#import "NSObject+Value.h"
@interface XMMineRepairController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>{
    
    UITableView  *_tableView;
    NSMutableArray *_deals;
    int  page;
     NSMutableArray *contacts;
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;

}

@end

@implementation XMMineRepairController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"我的修神";
    kNAVITAIONBACKBUTTON
   self.view.backgroundColor=[UIColor whiteColor];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kDeviceWidth, kDeviceHeight-64)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor = XMGlobalBg;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:_tableView];
    //请求数据
//    [self requestData];
     [self addRefresh];
   
    [_header beginRefreshing];
}


//-(void)requestData{
//    
//   [[XMDealTool sharedXMDealTool]dealWithPage:1 success:^(NSArray *deal, int ispage) {
//       XMLog(@"%@",deal);
//       [timer invalidate];
//       [self dismissMessage];
//       if ([deal isKindOfClass:[NSArray class]] && deal.count>0) {
//           _deals = [[NSMutableArray alloc] initWithArray:deal];
//           [_tableView reloadData];
//       }
//   }];
//    
//}


#pragma mark - 表格方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  _deals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifer = @"cell";
    XMMineRepairCell  *cell = [[XMMineRepairCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    cell.backgroundColor = XMGlobalBg;
    cell.mineRepair=_deals[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
    
    }


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 135;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XMRepairDetailViewController  *repair=[[XMRepairDetailViewController alloc]init];
    XMRepairmanDetail *aa = [[XMRepairmanDetail alloc] init];
    [aa setValues:_deals[indexPath.row]];
    
    XMLog(@"aa-->%@",aa.maintainer_id);
    
    repair.maintainer_id = aa.maintainer_id;
    [self.navigationController pushViewController:repair animated:YES];

}

#pragma mark  删除单元格

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle==UITableViewCellEditingStyleDelete) {

        NSString *maintainer_id = _deals[indexPath.row][@"maintainer_id"];
        [[XMDealTool sharedXMDealTool]deleteWithContent:maintainer_id success:^(NSString *deal) {
//            [self saveSuccess:deal];
            [MBProgressHUD showSuccess:deal];
            [_deals removeObjectAtIndex:indexPath.row];
            [_tableView reloadData];
            [_header beginRefreshing];
        } failure:^(NSString *deal) {
//            [self saveFailure:deal];
            [MBProgressHUD showError:deal];
        }];
        
    }
}


#pragma mark 添加刷新控件
- (void)addRefresh
{
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = _tableView;
    header.delegate = self;
    _header = header;
    
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = _tableView;
    footer.delegate = self;
    _footer = footer;
}

#pragma mark - 刷新代理方法
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    
    BOOL isHeader = [refreshView isKindOfClass:[MJRefreshHeaderView class]];
    if (isHeader) { // 下拉刷新
        // 清除图片缓存
        //        [XMImageTool clear];
        page = 1; // 第一页
    } else { // 上拉加载更多
        page++;
        
    }
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(endRefreshList) userInfo:nil repeats:NO];
    
   [[XMDealTool  sharedXMDealTool]dealWithPage:page success:^(NSArray *deal, int ispage) {
       if ([deal isKindOfClass:[NSArray class]] && deal.count) {
           [timer invalidate];
           
           if (isHeader) {
               _deals = [NSMutableArray array];
           }
           // 1.添加数据
           [_deals addObjectsFromArray:deal];
           
           // 2.刷新表格
           [_tableView performSelector:@selector(reloadData) withObject:nil afterDelay:1];
           
           // 3.恢复刷新状态
           [refreshView performSelector:@selector(endRefreshing) withObject:nil afterDelay:1];
           
           _footer.hidden = ispage;
       }else{
           _tableView.hidden = YES;
           [refreshView endRefreshing];
           UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight+64+49)];
         
           [image setImage:[UIImage imageNamed:@"mine_none"]];
           image.contentMode = UIViewContentModeScaleAspectFill; //| UIViewContentModeCenter;
           image.clipsToBounds = YES;//图片可裁剪
           [self.view addSubview:image];
       }
   }];
}

- (void)endRefreshList
{
    [_header endRefreshing];
    [_footer endRefreshing];
    [MBProgressHUD showError:@"网络不给力！"];
}

//#pragma mark 保存成功
//- (void)saveSuccess:(NSString *)addressid
//{
//    [self showAlertWithTitle:@"提示" andMessage:@"操作成功"];
//    [self performSelector:@selector(dismissAlert) withObject:nil afterDelay:0.5];
//
//}
//#pragma mark 保存失败
//- (void)saveFailure:(NSString *)message
//{
//    [self showAlertWithTitle:@"提示" andMessage:message];
//    [self performSelector:@selector(dismissAlert) withObject:nil afterDelay:0.5];
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that ·can be recreated.
}
- (void)dealloc
{
    //    [];
    _header = nil;
    _footer = nil;
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
    _tableView = nil;
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
