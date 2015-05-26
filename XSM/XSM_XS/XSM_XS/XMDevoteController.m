//
//  XMDevoteController.m
//  XSM_XS
//
//  Created by Apple on 14/12/9.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMDevoteController.h"
#import "XMRepairmanDetail.h"
#import "XMDevote.h"
#import "XMDealTool.h"
#import "UIImage+XM.h"
#import "XMAlbumViewController.h"

#define pictureWidth 105

@interface XMDevoteController ()<UITableViewDataSource,UITableViewDelegate>{
    
    UIImageView  *headView;
    UIImageView  *picture;
    UITableView  *_tableView;
    UILabel  *name;
    //    实名认证
    UIButton  *approve;
    UILabel  *year;
    UILabel  *master;
    UILabel *masterLabel;
    //    技术认证
    UILabel  *skill;
    
    UIImageView  *skillView;
    
    CGRect frame_first;
    
    UIImageView *fullImageView;
}


@end

@implementation XMDevoteController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    表内容
    [self loadTableView];
    
    
    //请求数据
    [self requestData];
}

-(void)loadTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = XMGlobalBg;
    
}


-(void)loadHeadView{
    headView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDetailPhotoHeight)];
    _tableView.tableHeaderView=headView;
    headView.userInteractionEnabled = YES;
    [headView setImage:[UIImage resizedImage:@"repairmanBG"]];
    //    [headView setImageWithURL:[NSURL URLWithString:_repairman.photo]];
    XMLog(@"xiushentouxiang=%@",_devote.photo);
    picture=[[UIImageView alloc]initWithFrame:CGRectMake(15, kDetailPhotoHeight-pictureWidth/2, pictureWidth, pictureWidth)];
    picture.layer.cornerRadius=pictureWidth/2.0;
    picture.layer.masksToBounds=YES;
    [picture setImageWithURL:[NSURL URLWithString:_devote.photo] placeholderImage:[UIImage imageNamed:@"picture01"]];
    if ([_devote.photo isEqualToString:@"http://123.57.35.205:8866"]) {
        [picture setImage:[UIImage imageNamed:@"picture01"]];
    }
    [_tableView addSubview:picture];
    
    picture.userInteractionEnabled = YES;
    [picture addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap:)]];
}


#pragma mark 请求数据
- (void)requestData{
    
    
    
    [[XMDealTool sharedXMDealTool] dealSuccess:_maintainer_id success:^(NSDictionary  *deal) {
        
        _devote = deal[@"dictionary"];
        
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView reloadData];
        
        //    加载顶部视图
        [self loadHeadView];
    }];
}
#pragma mark 表格方法
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    CGRect frame = [cell frame];
    if (indexPath.row == 0) {
        //姓名
        name=[[UILabel alloc]initWithFrame:CGRectMake(picture.right+15, 15, 1000, 25)];
        name.text=_devote.nickname;
        name.font=[UIFont boldSystemFontOfSize:20];
        name.textColor = kTextFontColor333;
        [cell addSubview:name];
        //自适应姓名标签宽度
        name.width = [name.text boundingRectWithSize:CGSizeMake(MAXFLOAT, name.height) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName:name.font} context:nil].size.width;
        //实名认证icon
        approve=[[UIButton alloc]initWithFrame:CGRectMake(name.right+30, name.top-10, 50, 50)];
        approve.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [approve setImage:[UIImage imageNamed:@"icon_certification"] forState:UIControlStateNormal];
        [approve addTarget:self action:@selector(approveAction) forControlEvents:UIControlEventTouchDown];
        [cell addSubview:approve];
        //修神修龄
        year=[[UILabel alloc]initWithFrame:CGRectMake(name.left, name.bottom, 100, 20)];
        year.text=[NSString stringWithFormat:@"修龄：%i年",_devote.maintainage];
        year.font=[UIFont systemFontOfSize:15];
        year.textColor = kTextFontColor666;
        [cell addSubview:year];
        //分割线
        UIImageView  *separateView=[[UIImageView alloc]initWithFrame:CGRectMake(0, year.bottom+14.5, kDeviceWidth, 0.5)];
        separateView.backgroundColor=kBorderColor;
        [cell addSubview:separateView];
        //设置高度
        frame.size.height = name.height+year.height+30;
    }else if (indexPath.row == 1){
        //技能
        master=[[UILabel alloc]initWithFrame:CGRectMake(15, 15, 1000, 20)];
        master.text=@"修神精通";
        master.font=kDetailLabelFont;
        master.textColor = kTextFontColor666;
        [cell addSubview:master];
        //自适应姓名标签宽度
        master.width = [master.text boundingRectWithSize:CGSizeMake(MAXFLOAT, master.height) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName:master.font} context:nil].size.width;
        //描述
        masterLabel=[[UILabel alloc]initWithFrame:CGRectMake(master.right+10, master.top, kDeviceWidth-master.width-30, 1000)];
        masterLabel.text=[_devote.desc isEqualToString:@""] ?@"无":_devote.desc;
        masterLabel.font=kDetailLabelFont;
        masterLabel.textColor = kTextFontColor333;
        masterLabel.numberOfLines=0;
        [cell addSubview:masterLabel];
        //高度自适应
        masterLabel.height = [masterLabel.text boundingRectWithSize:CGSizeMake(masterLabel.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName:masterLabel.font} context:nil].size.height;
        //分割线
        UIImageView  *separateView=[[UIImageView alloc]initWithFrame:CGRectMake(0, masterLabel.bottom+14.5, kDeviceWidth, 0.5)];
        separateView.backgroundColor=kBorderColor;
        [cell addSubview:separateView];
        //设置高度
        frame.size.height = masterLabel.height+30;
    }else{
        //认证
        skill=[[UILabel alloc]initWithFrame:CGRectMake(15, 15, master.width, 20)];
        skill.text=@"技术认证";
        skill.font=kDetailLabelFont;
        skill.textColor = kTextFontColor666;
        [cell addSubview:skill];
        if ([_devote.tach isKindOfClass:[NSArray class]] && _devote.tach.count) {
            float width = 133/2.0;
            float s = (kDeviceWidth-skill.width-30-133*3/2.0-15)/2.0;
            for (int i=0; i<_devote.tach.count; i++) {
                skillView=[[UIImageView alloc]initWithFrame:CGRectMake(skill.right+10+i*(width+s), skill.top, width, 165/2.0)];
                NSString *url = _devote.tach[i][@"photo"];
                skillView.contentMode = UIViewContentModeScaleAspectFit;//UIViewContentModeScaleAspectFill  UIViewContentModeScaleAspectFit
                skillView.clipsToBounds = YES;
                [skillView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"skill_photo"]];
                // skillView.backgroundColor=[UIColor lightGrayColor];
                [cell addSubview:skillView];
                XMLog(@"tupianurl=%@",url);
                skillView.userInteractionEnabled = YES;
                [skillView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap:)]];
            }
            frame.size.height = skillView.height+30;
        }else{
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(skill.right+10, skill.top, 100, skill.height)];
            label.text = @"无";
            label.font = kDetailLabelFont;
            label.textColor = kTextFontColor333;
            [cell addSubview:label];
            frame.size.height = skill.height+30;
        }
    }
    
//    CGRect frame = [baseView frame];
//    //计算出自适应的高度
//    frame.size.height = baseView.height+rightLabel.height;
    cell.frame = frame;
    cell.backgroundColor=[UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)approveAction{
    
    UIAlertView  *alert1=[[UIAlertView alloc]initWithTitle:@"修神100%实名认证，岗前严格背景调查" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    [alert1 show];
    
    
    
}
// 设置单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

#pragma mark 点击修神详情界面照片
- (void)actionTap:(UITapGestureRecognizer *)sender
{
    UIImageView *imageView=(UIImageView *)[sender view];
    if ([[imageView superview] isKindOfClass:[UITableView class]]) {
        frame_first=CGRectMake(_tableView.frame.origin.x+imageView.frame.origin.x, _tableView.frame.origin.y+imageView.frame.origin.y-_tableView.contentOffset.y, imageView.width, imageView.height);
    }
    else{
        UITableViewCell *cell = (UITableViewCell *)[_tableView  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        frame_first=CGRectMake(cell.frame.origin.x+imageView.frame.origin.x, cell.frame.origin.y+15-_tableView.contentOffset.y, imageView.frame.size.width, imageView.frame.size.height);
    }
    
    fullImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceHeight, kDeviceWidth)];
    fullImageView.backgroundColor=[UIColor blackColor];
    fullImageView.userInteractionEnabled=YES;
    [fullImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap2:)]];
    fullImageView.contentMode=UIViewContentModeScaleAspectFit;
    
    if (![fullImageView superview]) {
        fullImageView.image=imageView.image;
        [self.view.window addSubview:fullImageView];
        fullImageView.frame=frame_first;
        [UIView animateWithDuration:0.5 animations:^{
            fullImageView.frame=CGRectMake(0, 0, kDeviceWidth, kDeviceHeight);
        } completion:^(BOOL finished) {
            [UIApplication sharedApplication].statusBarHidden=YES;
        }];
    }
}
-(void)actionTap2:(UITapGestureRecognizer *)sender{
    [UIView animateWithDuration:0.5 animations:^{
        fullImageView.frame=frame_first;
    } completion:^(BOOL finished) {
        [fullImageView removeFromSuperview];
    }];
    
    [UIApplication sharedApplication].statusBarHidden=NO;
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
