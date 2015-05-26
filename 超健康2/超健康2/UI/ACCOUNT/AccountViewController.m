//
//  AccountViewController.m
//  Chaomeiman 专家端
//
//  Created by imac on 14-12-10.
//  Copyright (c) 2014年 imac. All rights reserved.
//

#import "AccountViewController.h"
#import "InformatiomViewController.h"
#import "DynamicViewController.h"
#import "SetViewController.h"
#import "FeedbackViewController.h"
#import "AboutUsViewController.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#define NUM @"number"
@interface AccountViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *tableViewSpec;
    NSArray *segmentedArray;
    UISegmentedControl *seg;
}
@end

@implementation AccountViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=@"我的账户";
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    
    tableViewSpec=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-64-44) style:UITableViewStyleGrouped];
    tableViewSpec.delegate=self;
    tableViewSpec.dataSource=self;
    tableViewSpec.showsVerticalScrollIndicator=NO;
    tableViewSpec.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableViewSpec];
    
    segmentedArray=[[NSArray alloc]initWithObjects:@"在线", @"离线",@"忙",nil];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [tableViewSpec reloadData];
}

#pragma mark Datasource & Delegrate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 1;
            break;
        case 3:
            return 3;
            break;
        default:
            return 0;
            break;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellIden=@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIden];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:nil];
    }
    if (indexPath.section==0) {
        
        UIImageView *ima=[[UIImageView alloc]initWithFrame:CGRectMake(15, 5, 70, 70)];
        [ima setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:kPersonHeadImage]]] placeholderImage:[UIImage imageNamed:@"头像1.jpg"]options:SDWebImageRetryFailed|SDWebImageLowPriority];
        ima.layer.masksToBounds =YES;
        ima.layer.cornerRadius =ima.frame.size.width/2;
        [cell.contentView addSubview:ima];
        
        UILabel *text1=[[UILabel alloc]initWithFrame:CGRectMake(ima.right+10, ima.top+5, 200, 30)];
        text1.text=[NSString stringWithFormat:@"姓名:%@",[[NSUserDefaults standardUserDefaults]objectForKey:kPersonHeadName]];
        text1.font=[UIFont boldSystemFontOfSize:17];
        text1.textColor=[UIColor grayColor];
        [cell.contentView addSubview:text1];
        
        UILabel *text2=[[UILabel alloc]initWithFrame:CGRectMake(ima.right+10, text1.bottom, 200, 30)];
        NSString *telePhone=[NSString stringWithFormat:@"手机号:%@",[[NSUserDefaults standardUserDefaults]objectForKey:kXMPPUserNameKey]];
        text2.text=telePhone;
        text2.font=[UIFont boldSystemFontOfSize:17];
        text2.textColor=[UIColor grayColor];
        [cell.contentView addSubview:text2];
        
    }
    else if (indexPath.section==1)
    {
        seg=[[UISegmentedControl alloc]initWithItems:segmentedArray];
        seg.frame=CGRectMake(0, 0, kDeviceWidth, 50);
        if (seg.selected) {
            seg.selectedSegmentIndex=0;
        }else{
            seg.selectedSegmentIndex=[[NSUserDefaults standardUserDefaults]integerForKey:NUM];
        }
        [seg addTarget:self action:@selector(segmentAction:)forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:seg];
    }
    else if (indexPath.section==2){
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text=@"动态";
                break;
            default:
                break;
        }
    }
    else
    {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text=@"设置";
                break;
            case 1:
                cell.textLabel.text=@"反馈";
                break;
            case 2:
                cell.textLabel.text=@"关于我们";
                break;
            default:
                break;
        }
    }
    if (indexPath.section!=1) {
        cell.accessoryView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"goBack2"]];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 80;
    }
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


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0 && indexPath.section==0)
    {
        InformatiomViewController *info=[[InformatiomViewController alloc]init];
        self.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:info animated:YES];
        self.hidesBottomBarWhenPushed=NO;
    }
    else if (indexPath.section==2){
        DynamicViewController *dyn=[[DynamicViewController alloc]init];
        self.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:dyn animated:YES];
        self.hidesBottomBarWhenPushed=NO;
    }else if (indexPath.section==3&&indexPath.row==0){
        SetViewController *set=[[SetViewController alloc]init];
        self.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:set animated:YES];
        self.hidesBottomBarWhenPushed=NO;
    }else if (indexPath.section==3&&indexPath.row==1){
        FeedbackViewController *feed=[[FeedbackViewController alloc]init];
        self.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:feed animated:YES];
        self.hidesBottomBarWhenPushed=NO;
    }else if (indexPath.section==3&&indexPath.row==2){
        AboutUsViewController *us=[[AboutUsViewController alloc]init];
        self.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:us animated:YES];
        self.hidesBottomBarWhenPushed=NO;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectio{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)sectio{
    return 8;
}

-(void)segmentAction:(UISegmentedControl *)Seg
{
    NSInteger index = Seg.selectedSegmentIndex;
    AppDelegate *applegate=xmppDelegate;
    switch (index) {
        case 0:
            MyLog(@"0 clicked.");
            [applegate connectWithCompletion:nil failed:^{
                MyLog(@"连接openfire服务器");
            }];
            break;
        case 1:
            [applegate disconnect];
            MyLog(@"1 clicked.");
            break;
        case 2:
            [applegate disconnect];
            MyLog(@"2 clicked.");
            break;
    }
    
    [[NSUserDefaults standardUserDefaults]setInteger:index forKey:NUM];
}
@end
