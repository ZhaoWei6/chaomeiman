//
//  JHAddOrEditAddressViewController.m
//  XSM_XS
//
//  Created by 李江辉 on 14-12-10.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "JHAddOrEditAddressViewController.h"

#import "GeoViewController.h"

@interface JHAddOrEditAddressViewController ()<SetAddressDelegate>

@property (weak, nonatomic)  UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UITextField *contactNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *manButton;
@property (weak, nonatomic) IBOutlet UIButton *womanButton;
@property (weak, nonatomic) IBOutlet UIButton *addressButton;
@property (weak, nonatomic) IBOutlet UITextField *detailAdressTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@property (nonatomic, assign) BOOL isChoosePoint;

@property (copy, nonatomic)  NSString *ID;

// 地址相关
/** 区域 */
//@property (copy, nonatomic)  NSString *area;
@property (assign, nonatomic)  double latitude;
@property (assign, nonatomic)  double longitude;

@end

@implementation JHAddOrEditAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationItemTitle];
    
    if (self.commonAdress != nil) {
        NSString *print = [NSString stringWithFormat:@"{%f,%f}", self.commonAdress.latitude, self.commonAdress.longitude];
        [self.addressButton setTitle:print forState:UIControlStateNormal];
        self.detailAdressTextField.text = self.commonAdress.address;
        self.phoneTextField.text = self.commonAdress.telephone;
        
    }
    
}

- (void)setCommonAdress:(JHCommonAdress *)commonAdress
{
    _commonAdress = commonAdress;
    self.latitude = _commonAdress.latitude;
    self.longitude = _commonAdress.longitude;
    self.ID = _commonAdress.ID;
//    self.area = _commonAdress.area;
    
}

- (void)setupNavigationItemTitle
{
    if (self.commonAdress == nil) {
        [self.navigationItem setTitle:@"添加常用地址"];
    }else{
        [self.navigationItem setTitle:@"编辑常用地址"];
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(buttonClickedToSaveContacts)];
    [self.view setBackgroundColor:XMGlobalBg];
}

- (void)buttonClickedToSaveContacts
{
    if (![self.addressButton.titleLabel.text isEqualToString:@"定位地址坐标"]) {
        self.isChoosePoint = YES;
    }
    
    if (self.isChoosePoint == YES) {
        
        if ([JHCommonTool isValidateMobile:self.phoneTextField.text]) {
            
            if (self.commonAdress == nil) { // 添加联系人
                
                [self requestDataForAddCommonAddress];
                
            }else{ // 编辑联系人
                
                [self requestDataForEditCommonAddress];
                
            }
            
        }else{
            
            [self ShowMessage:@"手机号不正确！"];
            
        }
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请定位您的地址坐标" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    
}

/** 添加联系人 */
- (void)requestDataForAddCommonAddress
{
    
    NSDictionary *param = @{@"userid" : [UserDefaults objectForKey:@"userid"],
                            @"password" : [UserDefaults objectForKey:@"password"],
                            @"latitude" : @(self.latitude),
                            @"longitude" : @(self.longitude),
//                            @"area" : self.area,
                            @"address" : self.detailAdressTextField.text,
                            @"telephone" : self.phoneTextField.text};
    [[XMDealTool sharedXMDealTool] addCommonAddressWithParams:param Success:^(NSDictionary *deal) {
        
        if ([deal[@"status"] isEqual: @1]) {
            
            NSLog(@"增加联系人：%@", deal[@"message"]);
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:deal[@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
        
    }];
    
}

/** 编辑联系人 */
- (void)requestDataForEditCommonAddress
{
//    NSLog(@"----------%f--------%f-----ID：%@--------手机号：%@--------详细地址：%@",self.latitude, self.longitude, self.ID, self.phoneTextField.text,self.detailAdressTextField.text);
    
    NSDictionary *param = @{@"userid" : [UserDefaults objectForKey:@"userid"],
                            @"password" : [UserDefaults objectForKey:@"password"],
                            @"latitude" : @(self.latitude),
                            @"longitude" : @(self.longitude),
//                            @"area" : self.area,
                            @"address" : self.detailAdressTextField.text,
                            @"telephone" : self.phoneTextField.text,
                            @"address_id" : self.commonAdress.ID};
    
    [[XMDealTool sharedXMDealTool] editCommonAddressWithParams:param Success:^(NSDictionary *deal){
        
        if ([deal[@"status"] isEqual: @1]) {
            
            NSLog(@"增加联系人：%@", deal[@"message"]);
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:deal[@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
        
    }];
    
}


- (IBAction)buttonClickedToChooseSex:(UIButton *)sender {
    
    self.selectButton.selected = NO;
    sender.selected = YES;
    self.selectButton = sender;
    
}
- (IBAction)buttonClickedToChooseAddress:(UIButton *)sender {
    
    GeoViewController *address = [[GeoViewController alloc] init];
    address.title = @"当前位置";
    address.delegate = self;
    [self.navigationController pushViewController:address animated:YES];
    
}

- (void)setAddressWithGeocode:(AMapGeocode *)geocode
{
    
    self.isChoosePoint = YES;
    NSString *coord = [NSString stringWithFormat:@"{%lf,%lf}",geocode.location.longitude,geocode.location.latitude];
    [self.addressButton setTitle:coord forState:UIControlStateNormal];
    [self.addressButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    self.area = geocode.formattedAddress;
    self.longitude = geocode.location.longitude;
    self.latitude = geocode.location.latitude;
    
    self.detailAdressTextField.text = geocode.formattedAddress;
    
    XMLog(@"所选区域的经纬度为%@地址%@",geocode.location,geocode.formattedAddress);
}

- (void)ShowMessage:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
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
