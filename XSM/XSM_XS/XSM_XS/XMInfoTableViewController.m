//
//  XMInfoTableViewController.m
//  XSM_XS
//
//  Created by Apple on 14/12/1.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMInfoTableViewController.h"
#import "UIViewExt.h"
#import "XMCommon.h"
#import "Measurement.h"

#import "XMSkillViewController.h"
#import "XMAddressViewController.h"
#import "XMNavigationViewController.h"
#import "XMAddUserMessageViewController.h"
#import "XMDeleteSkillViewController.h"

#import "UIImageView+WebCache.h"
#import "VPImageCropperViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "XMDealTool.h"
#import "AFNetworking.h"


#define ORIGINAL_MAX_WIDTH 640.0f
#define BaseUrl @"http://123.57.35.205:8866/index.php/mobile/"   //外网
//#define BaseUrl @"http://192.168.1.88/xiushenma/code/v1/index.php/mobile/"   //内网

@interface XMInfoTableViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,VPImageCropperDelegate,UINavigationControllerDelegate>
{
    UIImageView   *photo;//修神头像
    NSDictionary  *dict;
}

@property (nonatomic , assign) BOOL isSkill;

@end

@implementation XMInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    kNAVITAIONBACKBUTTON
    self.title = @"个人中心";
    //注册一个单元格
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    //
//    self.tableView.hidden = YES;
    //设置表头
//    [self loadHeadView];
    //
//    [self loadRepairmanPhoto];
    //单元格分隔线
    [self setExtraCellLineHidden:self.tableView];
    
    //获取修神信息
    [self requestData];
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"CHANGEUSERDATA" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //
//    [self requestData];
}

#pragma mark - 背景
//- (void)loadHeadView
//{
//    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 150)];
//    [backgroundImage setImage:[UIImage imageNamed:@"repairmanBG"]];
//    self.tableView.tableHeaderView = backgroundImage;
//}
#pragma mark - 头像
//- (void)loadRepairmanPhoto
//{
//    photo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"picture01"]];
//    photo.bounds = CGRectMake(0, 0, 100, 100);
//    photo.center = CGPointMake(65, 150);
//    [self.tableView addSubview:photo];
//    
//    photo.layer.cornerRadius = 50;
//    photo.layer.masksToBounds = YES;
//    //
//    [photo setUserInteractionEnabled:YES];
//    [photo addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updateUserPhoto:)]];
//}
//- (void)setRepairmanPhoto
//{
//    //设置修神头像
//    if ([dict[@"photo"] isKindOfClass:[NSString class]] && ![dict[@"photo"] isEqualToString:@""]) {
//        
//        [photo setImageWithURL:[NSURL URLWithString:dict[@"photo"]]];
//    }
//}
#pragma mark -
- (void)requestData
{
//    [MBProgressHUD showMessage:nil];
    NSString *userid = [XMDealTool sharedXMDealTool].userid;
    XMLog(@"%@",userid);
//    NSString *password = [XMDealTool sharedXMDealTool].password;
    [XMHttpTool postWithURL:@"Maintainer/techcer"
                     params:@{@"userid":userid,
//                              @"password":password,
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
    UIImage *theImage = [self imageWithImageSimple:editedImage scaledToSize:CGSizeMake(500.0, 500.0)];
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

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // 拍照
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
        
    } else if (buttonIndex == 1) {
        // 从相册中选取
        if ([self isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
    }
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // 裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
        }];
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
#pragma mark - camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}
#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark 压缩图片
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}
#pragma mark 保存图片到document
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData* imageData = UIImagePNGRepresentation(tempImage);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    
    // and then we write it out
    [imageData writeToFile:fullPathToFile atomically:NO];
    
    XMLog(@"图片路径---->%@",fullPathToFile);
}
#pragma mark 从文档目录下获取Documents路径
- (NSString *)documentFolderPath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}
#pragma mark 上传
- (void)uplodeUserImage:(NSString *)imageName url:(NSString *)url
{
    NSString *webUrl = [BaseUrl stringByAppendingString:url];
    
    NSString *userid = [XMDealTool sharedXMDealTool].userid;
    NSString *password = [XMDealTool sharedXMDealTool].password;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; //path数组里貌似只有一个元素
    NSString *filestr = [NSString stringWithFormat:@"/%@",imageName];
    NSString *newstr = [documentsDirectory stringByAppendingString:filestr];
    
    XMLog(@"需要上传的图片------>%@",newstr);
    
    NSData *dd = [NSData dataWithContentsOfFile:newstr];
    
    // 1.创建请求管理对象
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    // 2.设置参数
    NSDictionary *parameters = @{@"userid":userid,@"password":password,@"photo":@""};
    XMLog(@"%@",parameters);
    // 3.上传图片
    [mgr POST:webUrl parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //
        [formData appendPartWithFileData:dd name:imageName fileName:imageName mimeType:@"image/png"];
    } success:^(AFHTTPRequestOperation *operation,id responseObject) {
        NSLog(@"Success: %@", responseObject);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEUSERDATA" object:nil];
//        if (_isSkill) {
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
//            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        }
        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
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







