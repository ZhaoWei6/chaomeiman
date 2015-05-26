//
//  InformatiomViewController.m
//  超健康
//
//  Created by imac on 14/12/11.
//  Copyright (c) 2014年 ChaoMeiman. All rights reserved.
//

#import "InformatiomViewController.h"
#import "ChangeNameController.h"
#import "ChangeAgeController.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
@interface InformatiomViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,changeNameDelegate,changeAgeDelegate,UITextViewDelegate,UITextViewDelegate>
{
    UITableView *tableViewSpec;
    
//－－－－－－－－－－－－－－－都需要写入SQL数据库----------------------
    //头像的设置
    UIImage *headImage;
    //男 女的设置
    NSString *title;
    NSString *sex;
    //姓名的设置
    NSString *name;
    //年龄
    NSString *age;
    //个人语录
    UITextView *descriptionText;

//-------------------------------------------------------------
    
}


@end

@implementation InformatiomViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [tableViewSpec reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];    
    [self addLeftButtonReturn:@selector(dismiss)];
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    
    
    self.title=@"个人资料";
    
    descriptionText=[[UITextView alloc]initWithFrame:CGRectMake(15, 0, kDeviceWidth-30, 60)];
    descriptionText.delegate=self;
    descriptionText.userInteractionEnabled=YES;
    
    tableViewSpec=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-64) style:UITableViewStyleGrouped];
    tableViewSpec.delegate=self;
    tableViewSpec.dataSource=self;
    tableViewSpec.showsVerticalScrollIndicator=NO;
    tableViewSpec.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableViewSpec];
    
    title=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:kPersonGender]];
    if ([title isEqualToString:@"1"]) {
        title=@"男";
    }else
        title=@"女";
    name=[[NSUserDefaults standardUserDefaults]objectForKey:kPersonHeadName];
    age=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:kPersonAge]];
    
#pragma mark  -----------AFHTTPRequest网络请求数据----------
    [[LoginUser sharedLoginUser]loadurl:GetVerification(@"client", @"expertLogin") with:@{@"act":[[LoginUser sharedLoginUser]userName],@"pwd":[[LoginUser sharedLoginUser]password]} BlockWithSuccess:^(id responseObject) {
        if ([responseObject[@"success_code"] intValue]==200) {
            _uid=[[responseObject objectForKey:@"success_message"]objectForKey:@"id"];
        }
    } Failure:^(NSError *mes) {
        MyLog(@"%@error",mes);
    }];
}

-(void)dismiss{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Datasource & Delegrate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 5;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellIden=@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIden];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:nil];
    }
    if (indexPath.section==0) {
        if (headImage) {
            cell.imageView.image=headImage;
        }else
            [cell.imageView setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults]objectForKey:kPersonHeadImage]] placeholderImage:[UIImage imageNamed:@"头像1.jpg"]options:SDWebImageRetryFailed|SDWebImageLowPriority];
        cell.textLabel.text=@"头像";
        cell.imageView.layer.masksToBounds =YES;
        cell.imageView.layer.cornerRadius =40;
    }
    else
    {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text=@"姓名";
                cell.detailTextLabel.text=name;
                break;
            case 1:
                cell.textLabel.text=@"性别";
                cell.detailTextLabel.text=title;
                break;
            case 2:
                cell.textLabel.text=@"年龄";
                cell.detailTextLabel.text=age;
                break;
            case 3:
                cell.textLabel.text=@"个人语录";
                break;
            case 4:
                if ([[NSUserDefaults standardUserDefaults]objectForKey:kPersonLanguage]) {
                    descriptionText.text=[[NSUserDefaults standardUserDefaults]objectForKey:kPersonLanguage];
                }else
                    descriptionText.text=@"测试数据";
                [cell.contentView addSubview:descriptionText];
                break;
            default:
                break;
        }
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row==4 &&indexPath.section==1) {
        cell.accessoryType=UITableViewCellAccessoryNone;
    }else{
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
    return 60;
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
    if (indexPath.section==0) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"选择照片", nil];
        [sheet showInView:self.view];
    }
    else
    {
        if (indexPath.row==0) {
            ChangeNameController *change=[[ChangeNameController alloc]init];
            change.ID=_uid;
            change.hidesBottomBarWhenPushed=YES;
            change.delegate=self;
            [self.navigationController pushViewController:change animated:YES];
            change.hidesBottomBarWhenPushed=NO;
        }
        else if (indexPath.row==1)
        {
            UIAlertView *alte=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择性别" delegate:self cancelButtonTitle:nil otherButtonTitles:@"女",@"男" , nil];
            [alte show];
        }
        else if (indexPath.row==2)
        {
            ChangeAgeController *age1=[[ChangeAgeController alloc]init];
            age1.ID=_uid;
            age1.hidesBottomBarWhenPushed=YES;
            age1.delegate=self;
            [self.navigationController pushViewController:age1 animated:YES];
            age1.hidesBottomBarWhenPushed=NO;

        }
        else if (indexPath.row==3)
        {
            
        }
    }
}

//穿title参数
-(void)changeTitle:(NSString *)title1{
    name=title1;
    [tableViewSpec reloadData];
}
//传age参数
-(void)changeAge:(NSString *)age1{
    age=age1;
    [tableViewSpec reloadData];
}

#pragma mark - ActionSheet代理方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 2) {
        return;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    // 1. 设置照片源，提示在模拟上不支持相机！
    if (buttonIndex == 0) {
        [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
    } else {
        [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    // 2. 允许编辑
    [picker setAllowsEditing:YES];
    // 3. 设置代理
    [picker setDelegate:self];
    // 4. 显示照片选择控制器
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - 照片选择代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 1. 设置头像
    headImage = info[UIImagePickerControllerEditedImage];
    NSData *headData=UIImagePNGRepresentation(headImage);
//    NSString *imageString=[[NSString alloc]initWithData:headData encoding:NSUTF8StringEncoding];
//    [[NSUserDefaults standardUserDefaults]setObject:imageString forKey:kPersonHeadImage];
    //1.1 清除缓存
    [[SDImageCache sharedImageCache]clearDisk];
    [[SDImageCache sharedImageCache]clearMemory];
    
    // 2. 保存名片
    [tableViewSpec reloadData];
    
    //-------－－－－－－－AFN网络请求数据-------------
    // 可以在上传时使用当前的系统事件作为文件名
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    // 设置时间格式
//    formatter.dateFormat = @"yyyyMMddHHmmss";
//    NSString *str = [formatter stringFromDate:[NSDate date]];
//    NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
    
    [[LoginUser sharedLoginUser]postToServerWithUrl:GetVerification(@"client", @"editExpertHead") parameters:@{@"expert_id":_uid} fileData:headData name:@"expert_head" fileName:@"expert_head.png" success:^(id response) {
    } failure:^(NSError *mes) {
    }];
//    //压缩图片尺寸
//    CGSize smallSize;
//    smallSize.width=70;
//    smallSize.height=70;
//    UIImage *image=[self scaleToSize:headImage size:smallSize];
//    //压缩图片质量
//    NSData *headData1=UIImageJPEGRepresentation(headImage, 0.5);
    // 3. 关闭照片选择器
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//图片尺寸压缩
-(UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsGetCurrentContext();
    return scaledImage;
}

#pragma mark -UIAlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        title=@"女";
        sex=@"0";
    }else if(buttonIndex==1){
        title=@"男";
        sex=@"1";
    }
    [tableViewSpec reloadData];
    
#pragma mark  -----------AFHTTPRequest网络请求数据----------
    //-------－－－－－－－AFN网络请求数据-------------
    [[LoginUser sharedLoginUser]loadurl:GetVerification(@"client", @"editExpertInfo") with:@{@"id":_uid,@"expert_gender":sex} BlockWithSuccess:^(id responseObject) {
        MyLog(@"------%@responseObject",responseObject);
        if ([responseObject[@"success_code"] intValue]==200) {
            NSString *data=[responseObject objectForKey:@"success_message"];
            NSLog(@"%@----data",data);
            //存取用户性别
            [[NSUserDefaults standardUserDefaults]setObject:sex forKey:kPersonGender];
        }

    } Failure:^(NSError *mes) {
         MyLog(@"%@error",mes);
    }];
}


//取消第一响应
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text1 {
    if ([text1 isEqualToString:@"\n"]) {
#pragma mark  -----------AFHTTPRequest网络请求数据----------
        
        [[LoginUser sharedLoginUser]loadurl:GetVerification(@"client", @"editExpertInfo") with:@{@"id":_uid,@"expert_motto":descriptionText.text} BlockWithSuccess:^(id responseObject) {
            MyLog(@"------%@responseObject",responseObject);
            if ([responseObject[@"success_code"] intValue]==200) {
                NSString *data=[responseObject objectForKey:@"success_message"];
                NSLog(@"%@----data",data);
                //存取用户性别
                [[NSUserDefaults standardUserDefaults]setObject:sex forKey:kPersonGender];
            }
            
        } Failure:^(NSError *mes) {
            MyLog(@"%@error",mes);
        }];

        //存取专家语录
        [[NSUserDefaults standardUserDefaults]setObject:descriptionText.text forKey:kPersonLanguage];
        [textView resignFirstResponder];
        [tableViewSpec reloadData];
        return NO;
    }
    return YES;
}


- (void)textViewDidBeginEditing:(UITextView *)textView{
    //键盘遮住了文本字段，视图整体上移
    CGRect frame = self.view.frame;
    frame.origin.y -=180;
    frame.size.height +=180;
    
    [UIView beginAnimations:@"111" context:nil];
    [UIView setAnimationDuration:0.5];
    self.view.frame = frame;
    [UIView commitAnimations];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    //之前视图上移了  现在移回来
    CGRect frame = self.view.frame;
    frame.origin.y +=180;
    frame.size.height -=180;
    [UIView beginAnimations:@"111" context:nil];
    [UIView setAnimationDuration:0.5];
    self.view.frame = frame;
    [UIView commitAnimations];
    //如果允许要调用resignFirstResponder 方法，这回导致结束编辑，而键盘会被收起
    [textView resignFirstResponder];//查一下resign这个单词的意思就明白这个方法了
}
@end
