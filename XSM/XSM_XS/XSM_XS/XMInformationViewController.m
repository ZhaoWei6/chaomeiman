//
//  XMInformationViewController.m
//  XSM_XS
//
//  Created by Apple on 14/12/15.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMInformationViewController.h"

#import "XMSkillViewController.h"
#import "XMAddressViewController.h"
#import "XMAddUserMessageViewController.h"
#import "XMDeleteSkillViewController.h"

#import "XMSkillImageView.h"
@interface XMInformationViewController ()<XMSkillImageViewDelegate>
{
    UIImageView   *photo;//修神头像
    NSDictionary  *dict;
}

@property (nonatomic , assign) BOOL isSkill;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation XMInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人中心";
    
    //
    //单元格分隔线
    [self setExtraCellLineHidden:self.tableView];
    
    //获取修神信息
    [self requestData];
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"CHANGEUSERDATA" object:nil];
}

#pragma mark -
- (void)requestData
{
    NSString *userid = [XMDealTool sharedXMDealTool].userid;
    [XMHttpTool postWithURL:@"Maintainer/techcer"
                     params:@{@"userid":userid,
                              @"type":@(1)}
                    success:^(id json) {
                        XMLog(@"json = %@",json);
                        dict = json;
                        [self refreshUI];
                    } failure:^(NSError *error) {
                        XMLog(@"%@",error);
//        [MBProgressHUD showError:@""];
                    }];
}
- (void)refreshUI
{
    [MBProgressHUD hideHUD];
    [self.tableView reloadData];
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    // Configure the cell...
    if (indexPath.row == 0) {
        //背景
        UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 150)];
        [backgroundImage setImage:[UIImage imageNamed:@"repairmanBG"]];
        //头像
        photo = [[UIImageView alloc] init];
        photo.bounds = CGRectMake(0, 0, 100, 100);
        photo.center = CGPointMake(65, 150);
        photo.layer.cornerRadius = 50;
        photo.layer.masksToBounds = YES;
        [photo setUserInteractionEnabled:YES];
        if ([dict[@"photo"] isKindOfClass:[NSString class]] && ![dict[@"photo"] isEqualToString:@""]) {
            [photo setImageWithURL:[NSURL URLWithString:dict[@"photo"]] placeholderImage:[UIImage imageNamed:@"picture01"]];
        }else{
            [photo setImage:[UIImage imageNamed:@"picture01"]];
        }
        [photo addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updateUserPhoto:)]];
        //姓名
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(photo.right, backgroundImage.bottom+5, 100, 25)];
        nameLabel.text = dict[@"nickname"];
        nameLabel.font = [UIFont boldSystemFontOfSize:18];
        //
        UILabel *informationLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.left, nameLabel.bottom+5, kDeviceWidth-130, 20)];
        NSString *sexLabel = [dict[@"sex"] isEqualToString:@"1"]?@"男":@"女";
        informationLabel.text = [NSString stringWithFormat:@"修龄：%@年  性别：%@",dict[@"maintainage"],sexLabel];
        informationLabel.textColor = kTextFontColor666;
        //
        [cell.contentView addSubview:backgroundImage];
        [cell.contentView addSubview:photo];
        [cell.contentView addSubview:nameLabel];
        [cell.contentView addSubview:informationLabel];
    }else {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(photo.left, 40, 100, 20)];
        label.textColor = kTextFontColor666;
        
        UILabel *detailLabel = [[UILabel alloc] init];
        detailLabel.textColor = kTextFontColor333;
        if (indexPath.row == 1){
            //修神精通
            label.text = @"修神精通";
            if (dict[@"description"] == [NSNull null] || [dict[@"description"] isEqualToString:@""]) {
                detailLabel.text = @"点击编辑您的精通技能";
            }else{
                detailLabel.text = dict[@"description"];
            }
            [cell.contentView addSubview:detailLabel];
        }
//        else if (indexPath.row == 2){
//            //修神联系方式
//            label.text = @"联系方式";
//
//            NSString *str = @"";
//            if (dict[@"address"] != [NSNull null]) {
//                str = [NSString stringWithFormat:@"%@\n%@%@",dict[@"address"][@"mobile"],dict[@"address"][@"area"],dict[@"address"][@"address"]];
//                XMLog(@"%@",str);
//            }
//
//            if ([str isKindOfClass:[NSString class]] && ![str isEqualToString:@""]) {
//                label.width = [label.text boundingRectWithSize:CGSizeMake(MAXFLOAT, label.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:label.font} context:nil].size.width+5;
//
//                detailLabel.frame = CGRectMake(label.right, label.top-label.height/2-2, kDeviceWidth-photo.left*2-label.width-5, label.height*2+4);
//                detailLabel.numberOfLines = 2;
//
//                detailLabel.text = str;
//            }else{
//                detailLabel.text = @"点击编辑您的联系方式";
//                detailLabel.frame = CGRectMake(label.right, label.top, kDeviceWidth-photo.left*2-label.width, label.height);
//            }
//            [cell.contentView addSubview:detailLabel];
//        }
        else{
            //修神技术认证图片
            label.text = @"技术认证";
            
            CGFloat x = photo.left+73;
            CGFloat w = (kDeviceWidth-73-photo.left*2-20 -6)/3.0;
            
            UIButton *addSkillButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [addSkillButton setImage:[UIImage imageNamed:@"addSkill"] forState:UIControlStateNormal];
            [addSkillButton addTarget:self action:@selector(addSkillPhoto) forControlEvents:UIControlEventTouchUpInside];
            
            if ([dict[@"tach"] isKindOfClass:[NSArray class]] && [dict[@"tach"] count]) {
                NSInteger count = [dict[@"tach"] count];
                if (count < 3) {
                    for (int i=0; i<count; i++) {
                        XMSkillImageView *skillImage = [[XMSkillImageView alloc] initWithFrame:CGRectMake(x+i*(w+7), 10, w, 80)];
                        [skillImage setImageWithURL:[NSURL URLWithString:dict[@"tach"][i][@"photo"]] placeholderImage:[UIImage imageNamed:@"skill_photo"]];
                        skillImage.skillImageID = dict[@"tach"][i][@"id"];
                        skillImage.skillImageUrl = dict[@"tach"][i][@"photo"];
                        skillImage.delegate = self;
                        [cell.contentView addSubview:skillImage];
                    }
                    [cell.contentView addSubview:addSkillButton];
                    
                    addSkillButton.frame = CGRectMake(x+(w+7)*count, 10, w, 80);
                }else{
                    for (int i=0; i<count; i++) {
                        XMSkillImageView *skillImage = [[XMSkillImageView alloc] initWithFrame:CGRectMake(x+i*(w+7), 10, w, 80)];
                        [skillImage setImageWithURL:[NSURL URLWithString:dict[@"tach"][i][@"photo"]] placeholderImage:[UIImage imageNamed:@"skill_photo"]];
                        skillImage.skillImageID = dict[@"tach"][i][@"id"];
                        skillImage.skillImageUrl = dict[@"tach"][i][@"photo"];
                        skillImage.delegate = self;
                        [cell.contentView addSubview:skillImage];
                    }
                }
                
            }else{
                [cell.contentView addSubview:addSkillButton];
                
                addSkillButton.frame = CGRectMake(x, 10, w, 80);
            }
        }
        
        label.width = [label.text boundingRectWithSize:CGSizeMake(MAXFLOAT, label.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:label.font} context:nil].size.width+5;
        
        XMLog(@"%.2f",label.width);
        [cell.contentView addSubview:label];
        
        if (indexPath.row != 2) {
            detailLabel.frame = CGRectMake(label.right, label.top, kDeviceWidth-photo.left*2-label.width, label.height);
        }
    }
    cell.accessoryType = indexPath.row != 1 ?UITableViewCellAccessoryNone:UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        //修神精通
        [self.navigationController pushViewController:[[XMSkillViewController alloc] init] animated:YES];
    }
//    else if (indexPath.row == 2){
//        //联系方式
//        [self.navigationController pushViewController:[[XMAddressViewController alloc] init] animated:YES];
//    }else if (indexPath.row == 3){
//        //技术认证
//    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 220;
    }else if (indexPath.row == 1){
        
    }
    return 100;
}
//设置当单元格中无数据时隐藏分隔线
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    
    view.backgroundColor = [UIColor clearColor];
    
    [tableView setTableFooterView:view];
}

#pragma mark - 修改头像
- (void)updateUserPhoto:(UITapGestureRecognizer *)sender
{
    XMLog(@"修改用户头像");
    self.isSkill = NO;
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [choiceSheet showInView:self.view];
}
#pragma mark - 添加技术认证图片
- (void)addSkillPhoto
{
    XMLog(@"点击了添加技术认证");
    self.isSkill = YES;
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [choiceSheet showInView:self.view];
}
#pragma mark - VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    //    photo.image = editedImage;
    
    //压缩图片
    UIImage *theImage = [self imageWithImageSimple:editedImage scaledToSize:CGSizeMake(100.0, 100.0)];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置时间格式
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
    
    //保存图片到本地
    [self saveImage:theImage WithName:fileName];
    
    if (self.isSkill) {
        //上传修神技能认证图片
        [self uplodeUserImage:fileName url:@"Maintaineredit/addcertification"];
    }else{
        //上传修神头像
        [self uplodeUserImage:fileName url:@"Maintaineredit/headportrait"];
    }
    
    [MBProgressHUD showMessage:nil];
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];
}

#pragma mark - 删除技能认证图片
- (void) deleteSkillImageView:(NSString *)skillImageID url:(NSString *)url
{
    XMLog(@"您将要删除id为(%@)的技能认证图片",skillImageID);
    XMDeleteSkillViewController *deleteSkill = [[XMDeleteSkillViewController alloc] init];
    deleteSkill.skillImageID = skillImageID;
    deleteSkill.skillImageUrl = url;
    [self.navigationController pushViewController:deleteSkill animated:YES];
}

#pragma mark -
#ifdef iOS8
-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
