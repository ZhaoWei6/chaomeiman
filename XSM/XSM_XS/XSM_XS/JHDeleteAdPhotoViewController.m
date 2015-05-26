//
//  JHDeleteAdPhotoViewController.m
//  XSM_XS
//
//  Created by Andy on 14-12-22.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "JHDeleteAdPhotoViewController.h"

@interface JHDeleteAdPhotoViewController ()<UIAlertViewDelegate>

@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UIImageView *adPhotoImageView;

@end

@implementation JHDeleteAdPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self.navigationItem setTitle:@"店首广告图片"];
    
    [self setupDeleteBar];
    

}

- (void)setupDeleteBar
{
    // 现实的图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight - 108)];
//    [imageView setBackgroundColor:[UIColor redColor]];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    imageView.center = self.view.center;
    [imageView setImageWithURL:[NSURL URLWithString:_adPhotoDictionary[@"photo"]] placeholderImage:[UIImage imageNamed:@"skill_photo"]];
    self.adPhotoImageView = imageView;
    [self.view addSubview:imageView];
    
    // 删除按钮
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.deleteButton = deleteButton;
    [deleteButton setFrame:CGRectMake(0, kDeviceHeight - 44, kDeviceWidth, 44)];
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [deleteButton setTitle:@"删除" forState:UIControlStateHighlighted];
    [deleteButton setBackgroundColor:XMButtonBg];
    [deleteButton addTarget:self action:@selector(buttonClickedToDeletePhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deleteButton];
    
}

- (void)setAdPhotoDictionary:(NSDictionary *)adPhotoDictionary
{
    _adPhotoDictionary = adPhotoDictionary;
    
//    [self.adPhotoImageView setImageWithURL:[NSURL URLWithString:_adPhotoDictionary[@"photo"]] placeholderImage:[UIImage imageNamed:@"skill_photo"]];
    
}

- (void)buttonClickedToDeletePhoto
{
    //确认提示
    [[[UIAlertView alloc] initWithTitle:@"提示"
                                message:@"确认删除此图片"
                               delegate:self
                      cancelButtonTitle:@"取消"
                      otherButtonTitles:@"确定", nil] show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex) {
        //
        NSString *userid = [XMDealTool sharedXMDealTool].userid;
        NSString *password = [XMDealTool sharedXMDealTool].password;
        NSString *maintainerphoto_id = self.adPhotoDictionary[@"id"];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:userid forKey:@"userid"];
        [params setObject:password forKey:@"password"];
        [params setObject:maintainerphoto_id forKey:@"maintainerphoto_id"];
        
        XMLog(@"-----------------------------%@", params);
        [XMHttpTool postWithURL:@"Addshop/delAd" params:params success:^(id json) {
            XMLog(@"------------------删除广告栏%@", json);
            if ([json[@"status"] integerValue] == 1) {
                XMLog(@"删除成功");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"DELETEADPHOTO" object:@(self.selectedIdex)];
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(NSError *error) {
            XMLog(@"error-->%@",error);
        }];
    }
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
