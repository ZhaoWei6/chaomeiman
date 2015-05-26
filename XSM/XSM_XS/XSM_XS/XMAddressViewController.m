//
//  XMAddressViewController.m
//  XSM_XS
//
//  Created by Apple on 14/12/3.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMAddressViewController.h"
#import "GeoViewController.h"
@interface XMAddressViewController ()<SetAddressDelegate>
{
    AMapGeoPoint *userLocation;//用于保存用户经纬度
}

@end

@implementation XMAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"修改地址";
    
    [self loadSubViews];
    [self showAddress];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveAddress)];
}

- (void)loadSubViews
{
    [self setTextFiled:self.area icon:@"icon_add" placeholder:@"当前位置"];
    [self setTextFiled:self.address icon:@"icon_edit" placeholder:@"点击输入详细地址"];
    
    [self setTextFiled:self.phone icon:@"icon_phone" placeholder:@"手机号"];
    self.phone.keyboardType = UIKeyboardTypeNumberPad;
}
#pragma mark - 显示修神自己的联系方式
- (void)showAddress
{
    NSString *userid = [XMDealTool sharedXMDealTool].userid;
    NSString *password = [XMDealTool sharedXMDealTool].password;
    [XMHttpTool postWithURL:@"Maintaineredit/showAddress" params:@{@"userid":userid,@"password":password} success:^(id json) {
        XMLog(@"json-->%@",json);
        if ([json[@"status"] integerValue] == 1) {
            self.area.text = json[@"area"];
            self.address.text = json[@"address"];
            self.phone.text = json[@"mobile"];
        }else{
            XMLog(@"获取修神联系方式失败-->%@",json[@"message"]);
        }
    } failure:^(NSError *error) {
        XMLog(@"error = %@",error);
    }];
}
- (void)saveAddress
{
    NSString *userid = [XMDealTool sharedXMDealTool].userid;
    NSString *password = [XMDealTool sharedXMDealTool].password;
    NSString *area = self.area.text;//区域
    NSString *address = self.address.text;//地址
    NSString *phone = self.phone.text;//联系电话
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:userid forKey:@"userid"];
    [params setObject:password forKey:@"password"];
    [params setObject:area forKey:@"area"];
    [params setObject:address forKey:@"address"];
    [params setObject:@(userLocation.longitude) forKey:@"longitude"];
    [params setObject:@(userLocation.latitude) forKey:@"latitude"];
    [params setObject:phone forKey:@"mobile"];
    
    XMLog(@"params = %@",params);
    
    [XMHttpTool postWithURL:@"Maintaineredit/saveAddress" params:params success:^(id json) {
        XMLog(@"json-->%@",json);
        if ([json[@"status"] integerValue] == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            XMLog(@"更新失败-->%@",json[@"message"]);
        }
    } failure:^(NSError *error) {
        XMLog(@"error = %@",error);
    }];
}
#pragma mark - 文本框
- (void)setTextFiled:(UITextField *)textField icon:(NSString *)icon placeholder:(NSString *)placeholder
{
    textField.backgroundColor = [UIColor whiteColor];
    textField.layer.borderWidth = 1;
    textField.layer.cornerRadius = 5;
    textField.layer.borderColor = XMColor(236, 236, 236).CGColor;
    textField.placeholder = placeholder;
    textField.delegate = self;
    
    UIImageView *left = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, textField.height, textField.height)];
    [left setImage:[UIImage imageNamed:icon]];
    left.contentMode = UIViewContentModeScaleAspectFit;
    textField.leftView = left;
    textField.leftViewMode = UITextFieldViewModeAlways;
}
#pragma mark - 隐藏键盘
- (IBAction)View_TouchDown:(id)sender {
    // 发送resignFirstResponder.
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder)
                                               to:nil
                                             from:nil
                                         forEvent:nil];
}
#pragma mark - 选地址
- (IBAction)chooseAddress:(UITextField *)sender {
    XMLog(@"选择地址");
    GeoViewController *address = [[GeoViewController alloc] init];
    address.title = @"当前位置";
    address.delegate = self;
    [self.navigationController pushViewController:address animated:YES];
}
#pragma mark - 
- (void)setAddressWithGeocode:(AMapGeocode *)geocode
{
    self.area.text = geocode.formattedAddress;
    userLocation = geocode.location;
    XMLog(@"所选区域的经纬度为%@",geocode.location);
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
