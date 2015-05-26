//
//  UserDetailController.m
//  Chaomeiman 专家端
//
//  Created by imac on 14-12-12.
//  Copyright (c) 2014年 imac. All rights reserved.
//

#import "UserDetailController.h"
//#import "AlterCommentController.h"
#import "UIImageView+WebCache.h"
@interface UserDetailController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>{
    UITableView *tableViewSpec;
    //个人健康描述内容
    UITextView *descriptionText;
    //个人健康描述
    UILabel *description;
    //------------------------------------------------------------
}

@end

@implementation UserDetailController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=@"用户详情";
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self loadMemberById];
}

-(void)loadMemberById{
    
    [[LoginUser sharedLoginUser]loadurl:GetVerification(@"client", @"getMemberById") with:@{@"member_id":[LoginUser sharedLoginUser].member_id} BlockWithSuccess:^(id mes) {
        MyLog(@"%@",mes);
        if ([mes[@"success_code"]integerValue]==200) {
            [[LoginUser sharedLoginUser]setMember_age:[NSString stringWithFormat:@"%@",mes[@"success_message"][@"member_age"]]];
            [[LoginUser sharedLoginUser]setMember_gender:[NSString stringWithFormat:@"%@",mes[@"success_message"][@"member_gender"]]];
            [[LoginUser sharedLoginUser]setMember_head:[NSString stringWithFormat:@"%@",mes[@"success_message"][@"member_head"]]];
            [[LoginUser sharedLoginUser]setMember_health_description:[NSString stringWithFormat:@"%@",mes[@"success_message"][@"member_health_description"]]];
            [[LoginUser sharedLoginUser]setMember_nickname:[NSString stringWithFormat:@"%@",mes[@"success_message"][@"member_nickname"]]];
            [tableViewSpec reloadData];
        }
    } Failure:^(NSError *mes) {
        MyLog(@"%@",mes);
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadTable];
    [self addLeftButtonReturn:@selector(dismiss)];
    //[self addRightButtonReturn:@"修改备注" with:@selector(rightPush)];

    description=[[UILabel alloc]initWithFrame:CGRectMake(10, -10, kDeviceWidth-20,60)];
    
    descriptionText=[[UITextView alloc]initWithFrame:CGRectMake(10, description.bottom-10, kDeviceWidth-20, 80)];
    descriptionText.layer.cornerRadius=5;
    descriptionText.layer.borderWidth = 1.0;
    descriptionText.layer.borderColor=[UIColor lightGrayColor].CGColor;
    descriptionText.userInteractionEnabled=NO;
}

-(void)loadTable{
    tableViewSpec=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight) style:UITableViewStyleGrouped];
    tableViewSpec.delegate=self;
    tableViewSpec.dataSource=self;
    tableViewSpec.showsVerticalScrollIndicator=NO;
    tableViewSpec.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableViewSpec];
}

-(void)dismiss{
    [self.navigationController popViewControllerAnimated:YES];
}

//-(void)rightPush{
//    AlterCommentController *alter=[[AlterCommentController alloc]init];
//    self.hidesBottomBarWhenPushed=YES;
//    [self.navigationController pushViewController:alter animated:YES];
//}

#pragma mark Datasource & Delegrate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 3;
            break;
        default:
            return 0;
            break;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

//－－－－－－－从服务器后台读取－－－－－－－
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellIden=@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIden];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:nil];
    }
    if (indexPath.section==0) {
        UIImageView *ima=[[UIImageView alloc]initWithFrame:CGRectMake(15, 5, 70, 70)];
        
        [ima setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",[LoginUser sharedLoginUser].member_head]]] placeholderImage:[UIImage imageNamed:@"头像1.jpg"]options:SDWebImageRetryFailed|SDWebImageLowPriority];
        ima.layer.masksToBounds =YES;
        ima.layer.cornerRadius =ima.frame.size.width/2;
        [cell.contentView addSubview:ima];
        
        if ([[LoginUser sharedLoginUser].changeName length]!=0) {
            cell.detailTextLabel.text=[LoginUser sharedLoginUser].changeName;
        }else
            cell.detailTextLabel.text=[LoginUser sharedLoginUser].member_nickname;
    }
    else
    {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text=@"性别";
                if ([[LoginUser sharedLoginUser].member_gender intValue]==0) {
                    cell.detailTextLabel.text=@"女";
                }else
                    cell.detailTextLabel.text=@"男";
                break;
            case 1:
                cell.textLabel.text=@"年龄";
                cell.detailTextLabel.text=[LoginUser sharedLoginUser].member_age;
                break;
            case 2:
                description.text=@"个人健康描述";
                [cell.contentView addSubview:description];
                descriptionText.text=[LoginUser sharedLoginUser].member_health_description;
                [cell.contentView addSubview:descriptionText];
                break;
            default:
                break;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 80;
    }else if (indexPath.row==2){
        return 120;
    }
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
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
@end
