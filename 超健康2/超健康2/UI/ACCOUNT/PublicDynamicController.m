//
//  PublicDynamicController.m
//  Chaomeiman 专家端
//
//  Created by imac on 14-12-15.
//  Copyright (c) 2014年 imac. All rights reserved.
//

#import "PublicDynamicController.h"
#import "AFNetworking.h"

@interface PublicDynamicController ()<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UITextViewDelegate,UIAlertViewDelegate>{
    
    UIImageView *addImage;
    
//    NSMutableArray *array;
//    bool flag;
    UITextView *text;
    UIView  *view;
    int i,j;
    NSMutableArray *array;
}

@end

@implementation PublicDynamicController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=@"发布动态";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    array=[NSMutableArray array];
    i=0;
    j=0;
//    array=[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:kDText]];
//    if (array==nil) {
//        array=[NSMutableArray array];
//    }
//    flag=[[NSUserDefaults standardUserDefaults]boolForKey:kDBool];
	// Do any additional setup after loading the view.
    [self addLeftButtonReturn:@selector(dismiss)];
    
    view=[[UIView alloc]initWithFrame:CGRectMake(5, 70, kDeviceWidth-10, kDeviceHeight/2-100)];
    view.layer.cornerRadius=4;
    view.layer.borderWidth=1;
    view.layer.borderColor=[UIColor lightGrayColor].CGColor;
    [self.view addSubview:view];
    
    text=[[UITextView alloc]initWithFrame:CGRectMake(10, 75, kDeviceWidth-20, kDeviceHeight/2-110)];
    text.delegate=self;
//    if (flag==YES) {
//        text.text=[[[NSUserDefaults standardUserDefaults]objectForKey:kDText]objectAtIndex:0];
//    }else{
        text.text=@"您还没发布动态吗？请发布您的动态！";
//    }
    text.autoresizingMask=UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:text];
    
    //添加图片
        addImage=[[UIImageView alloc]initWithFrame:CGRectMake(view.left+10, view.bottom+10, 70, 60)];
        addImage.image=[UIImage imageNamed:@"tianjia"];
        addImage.userInteractionEnabled=YES;
        [self.view addSubview:addImage];
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSelect)];
        [addImage addGestureRecognizer:tap];
    
    
    //确认发布
    [self addViewInButtonInHigh:@"确认发布－.9.png" HighLight:@"确认发布－点击之后的.9.png" rect:CGRectMake(addImage.left+10, addImage.bottom+80, kDeviceWidth-((addImage.left+10)*2), 40) with:@selector(surePublic)];
}

-(void)dismiss{
   [self.navigationController popViewControllerAnimated:YES];
}

-(void)tapSelect{
    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"选择照片", nil];
    [sheet showInView:self.view];
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

//－－－－－－－－－照片存到数据库，上传到服务器－－－－－－－
#pragma mark - 照片选择代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 1. 设置头像
    addImage.image = info[UIImagePickerControllerEditedImage];
//    //压缩图片尺寸
//    CGSize smallSize;
//    smallSize.width=70;
//    smallSize.height=70;
//    //压缩图片质量
//    NSData *imageData=UIImageJPEGRepresentation([self scaleToSize:addImage.image size:smallSize], 0.9);
    NSData *imageData=UIImageJPEGRepresentation(addImage.image, 0.9);
    if (addImage.image) {
        i+=1;
        [array addObject:imageData];
        if (i>=3&&i<=6) {
            j=j+1;
            i=0;
        }
        addImage=[[UIImageView alloc]initWithFrame:CGRectMake(view.left+10+90*i, view.bottom+10+70*j, 70, 60)];
        if (array.count==6) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"只能输入六张照片，请确定后发送" message:nil delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"确定", nil];
            [alert show];
            [self dismissViewControllerAnimated:YES completion:nil];
            return;
        }
        addImage.image=[UIImage imageNamed:@"tianjia"];
        addImage.userInteractionEnabled=YES;
        [self.view addSubview:addImage];
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSelect)];
        [addImage addGestureRecognizer:tap];
    }
    // 2. 保存名片
    //[tableViewSpec reloadData];
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

//-----------------------存到服务器，数据库------------------------------
//确认发布
-(void)surePublic{
    MyLog(@"确认发布");
//    [array addObject:text.text];
//    
//    NSUserDefaults *defaultDafaults=[NSUserDefaults standardUserDefaults];
//    [defaultDafaults setObject:array forKey:kDText];
//    [defaultDafaults setBool:YES forKey:kDBool];
//    [defaultDafaults synchronize];
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:GetVerification(@"client", @"sendExpertDynamic") parameters:@{@"expert_id":[[NSUserDefaults standardUserDefaults] objectForKey:E_id],@"dynamic_content":text.text} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (int k=0; k<array.count; k++) {
            [formData appendPartWithFileData:array[k] name:[NSString stringWithFormat:@"dynamic_pic_url%d",k+1] fileName:[NSString stringWithFormat:@"dynamic_pic_url%d.png",k+1] mimeType:@"image/png"];
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        MyLog(@"上传文件成功%@",responseObject);
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        MyLog(@"上传文件失败%@",error);
    }];
    
    

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (1==buttonIndex) {
        MyLog(@"确定");
    }
}

//取消第一响应
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text1 {
    if ([text1 isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


- (void)textViewDidBeginEditing:(UITextView *)textView{
    textView.text=@"";
}

@end
