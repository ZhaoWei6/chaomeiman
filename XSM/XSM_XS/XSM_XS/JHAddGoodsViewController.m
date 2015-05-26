//
//  JHAddGoodsViewController.m
//  XSM_XS
//
//  Created by Andy on 14-12-17.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "JHAddGoodsViewController.h"
#import "XMCommon.h"

@interface JHAddGoodsViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet UIImageView *goodImageView;
@property (weak, nonatomic) IBOutlet UITextField *babyTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *showPriceLabel;
@property (weak, nonatomic) IBOutlet UITextField *reallyPriceLabel;
@property (nonatomic, assign) BOOL isHaveGoodImage;



@end

@implementation JHAddGoodsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"添加产品或服务"];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStyleDone target:self action:@selector(buttonClickedToOk)]];
    
    self.babyTitleLabel.delegate = self;
    self.showPriceLabel.delegate = self;
    self.reallyPriceLabel.delegate = self;
    
    self.goodImageView.userInteractionEnabled=YES;
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageClickedToChooseImage)];
    [self.goodImageView addGestureRecognizer:singleTap];
    
    if (self.goodDataDictionary != nil) {
        
        NSLog(@"%@", self.goodDataDictionary);
        
        [self.goodImageView setImageWithURL:[NSURL URLWithString:self.goodDataDictionary[@"photo"]]];
        self.babyTitleLabel.text = self.goodDataDictionary[@"goods"];
        self.showPriceLabel.text = self.goodDataDictionary[@"oldprice"];
        self.reallyPriceLabel.text = self.goodDataDictionary[@"newprice"];
        
    }
    
    
}

- (void)buttonClickedToOk
{
    
    if (self.isHaveGoodImage == NO) {
        
        [MBProgressHUD showError:@"请选择宝贝图片！"];
        
    }else{
        
        NSString *babyTitle = self.babyTitleLabel.text;
        if ( babyTitle ==nil || babyTitle.length == 0) {
            [MBProgressHUD showError:@"请输入宝贝标题！"];
            [self.babyTitleLabel becomeFirstResponder];
        }else{
            
            NSString *oldPrice = self.showPriceLabel.text;
            if (oldPrice == nil || oldPrice.length == 0) {
                
                [MBProgressHUD showError:@"请输入宝贝原价！"];
                [self.showPriceLabel becomeFirstResponder];
            }else{
                
                NSString *nowPrice = self.reallyPriceLabel.text;
                if (nowPrice == nil || nowPrice.length == 0) {
                    
                    [MBProgressHUD showError:@"请输入宝贝限价！"];
                    [self.reallyPriceLabel becomeFirstResponder];
                    
                }else{
                    
                    if (self.goodDataDictionary == nil) {
                        
                        NSDictionary *param = @{@"userid":[XMDealTool sharedXMDealTool].userid,
                                                @"password":[XMDealTool sharedXMDealTool].password,
                                                @"photo":@"",
                                                @"goods":self.babyTitleLabel.text,
                                                @"oldprice":self.showPriceLabel.text,
                                                @"newprice":self.reallyPriceLabel.text};
                        
                        [self requestDataForGoodImageWithParams:param];
                        
                    }else{
                        
                        NSDictionary *param = @{@"userid":[XMDealTool sharedXMDealTool].userid,
                                                @"password":[XMDealTool sharedXMDealTool].password,
                                                @"shopgoods_id":self.goodDataDictionary[@"shopgoods_id"],
                                                @"photo":@"",
                                                @"goods":self.babyTitleLabel.text,
                                                @"oldprice":self.showPriceLabel.text,
                                                @"newprice":self.reallyPriceLabel.text};
                        
                        [self requestDataForEditGoodImageWithParams:param];
                        
                        
                    }
                    
                }
            }
        }
        
    }
}

- (void)requestDataForEditGoodImageWithParams:(NSDictionary *)param
{
    NSString *webUrl = [BaseUrl stringByAppendingString:@"Addshop/updataServices"];
    NSData *data = UIImageJPEGRepresentation(self.goodImageView.image,1.0);
    
    // 设置时间格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *imageName = [NSString stringWithFormat:@"%@.png", str];
    
    // 1.创建请求管理对象
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    // 2.上传图片
    [mgr POST:webUrl parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //
        [formData appendPartWithFileData:data name:imageName fileName:imageName mimeType:@"image/png"];
    } success:^(AFHTTPRequestOperation *operation,id responseObject) {
        
        NSString *status = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
        [MBProgressHUD showSuccess:responseObject[@"message"]];
        if ([status isEqualToString:@"1"]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"EDITGOODSIMAGE" object:self.goodImageView.image];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
        [MBProgressHUD showSuccess:[NSString stringWithFormat:@"%@", error]];
    }];
    
}

- (void)requestDataForGoodImageWithParams:(NSDictionary *)param
{
    NSString *webUrl = [BaseUrl stringByAppendingString:@"Addshop/additionalservices"];
    NSData *data = UIImageJPEGRepresentation(self.goodImageView.image,1.0);
    
    // 设置时间格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *imageName = [NSString stringWithFormat:@"%@.png", str];
    
    // 1.创建请求管理对象
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    // 2.上传图片
    [mgr POST:webUrl parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //
        [formData appendPartWithFileData:data name:imageName fileName:imageName mimeType:@"image/png"];
    } success:^(AFHTTPRequestOperation *operation,id responseObject) {
        
        NSString *status = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
        [MBProgressHUD showSuccess:responseObject[@"message"]];
        if ([status isEqualToString:@"1"]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ADDGOODSIMAGE" object:self.goodImageView.image];
            [self.navigationController popViewControllerAnimated:YES];

        }else{
            
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
        [MBProgressHUD showSuccess:[NSString stringWithFormat:@"%@", error]];
    }];
    
}

- (void)imageClickedToChooseImage
{
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [choiceSheet showInView:self.view];
}

#pragma mark - VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    
    //压缩图片
    UIImage *theImage = [self imageWithImageSimple:editedImage scaledToSize:CGSizeMake(500.0, 500.0)];
    
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        
        [self.goodImageView setImage:theImage];
        self.isHaveGoodImage = YES;
        
    }];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.baseView endEditing:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^{
        if (textField.tag > 1) {
            self.baseView.transform =  CGAffineTransformTranslate(self.baseView.transform, 0, - [textField superview].top * 0.5);
        }
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.3 animations:^{
        if (textField.tag > 1) {
            self.baseView.transform = CGAffineTransformIdentity;
        }
    }];
    
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
