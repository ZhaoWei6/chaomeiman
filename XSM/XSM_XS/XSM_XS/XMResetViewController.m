//
//  XMResetViewController.m
//  XSM_XS
//
//  Created by Apple on 14/12/3.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMResetViewController.h"

@interface XMResetViewController ()
{
    int time;//用于记录按钮上显示的秒数
    NSTimer *testTimer;//用于刷新按钮上显示的数字
}

@end

@implementation XMResetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"重置密码";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.contentView.contentSize = CGSizeMake(kDeviceWidth, kDeviceHeight-64);
    [self loadSubViews];
    self.view.userInteractionEnabled=YES;
    
    UITapGestureRecognizer  *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(topView:)];
    [self.view  addGestureRecognizer:tap];
}

- (void)loadSubViews
{
    //用户名
    UITextField *username = [self loadTextFiledWithIcon:@"icon_phone" placeholder:@"填写手机号"];
    username.frame = CGRectMake(10, 10, kDeviceWidth-20, kUIButtonHeight);
    username.keyboardType = UIKeyboardTypeNumberPad;
    username.tag = 1;
    //密码
    UITextField *password = [self loadTextFiledWithIcon:@"password" placeholder:@"请新输入密码"];
    password.frame = CGRectMake(username.left, username.bottom+15, username.width, username.height);
    password.secureTextEntry=YES;
    password.tag = 2;
    //右侧眼睛
    UIButton  *showPass=[UIButton buttonWithType:UIButtonTypeCustom];
    showPass.backgroundColor=[UIColor  clearColor];
    showPass.frame=CGRectMake(0, 0, password.height, password.height/2.0);
    showPass.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [showPass setImage:[UIImage imageNamed:@"icon_password_eye"] forState:UIControlStateNormal];
    [showPass addTarget:self action:@selector(secureButtonAction) forControlEvents:UIControlEventTouchDown|UIControlEventTouchUpOutside|UIControlEventTouchUpInside];
    password.rightView = showPass;
    password.rightViewMode = UITextFieldViewModeAlways;
    
    
    //验证码
    UITextField *verify = [[UITextField alloc] initWithFrame:CGRectMake(password.left, password.bottom+15, password.width*2/3, password.height)];
    verify.backgroundColor = [UIColor whiteColor];
    verify.layer.borderWidth = 1;
    verify.layer.cornerRadius = 5;
    verify.layer.borderColor = XMColor(236, 236, 236).CGColor;
    verify.tag = 3;
    verify.placeholder = @"验证码";
    verify.delegate = self;
    [_contentView addSubview:verify];
    verify.keyboardType = UIKeyboardTypeNumberPad;
    
    UIView *left = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
    verify.leftView = left;
    verify.leftViewMode = UITextFieldViewModeAlways;
    
    //获取验证码
    time = 60;
    UIButton *verifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [verifyButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [verifyButton setTitle:[NSString stringWithFormat:@"%i秒",time] forState:UIControlStateDisabled];
    [verifyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    verifyButton.frame = CGRectMake(verify.right+5, verify.top, password.width - verify.width - 5, verify.height);
    verifyButton.tag = 4;
    verifyButton.backgroundColor = XMButtonBg;
    verifyButton.layer.cornerRadius = 5;
    verifyButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [verifyButton addTarget:self action:@selector(verifyButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:verifyButton];
    
    //确定重置
    UIButton *login = [UIButton buttonWithType:UIButtonTypeCustom];
    login.backgroundColor = [UIColor darkGrayColor];
    login.frame = CGRectMake(username.left, username.bottom+140, username.width, kUIButtonHeight);
    [login setTitle:@"确定" forState:UIControlStateNormal];
    [login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    login.backgroundColor = XMButtonBg;
    login.layer.cornerRadius = 5;
    login.tag = 100;
    [login addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:login];
}

#pragma mark - 文本框
- (UITextField *)loadTextFiledWithIcon:(NSString *)icon placeholder:(NSString *)placeholder
{
    UITextField* textField = [[UITextField alloc] init];
    textField.backgroundColor = [UIColor whiteColor];
    textField.layer.borderWidth = 1;
    textField.layer.cornerRadius = 5;
    textField.layer.borderColor = XMColor(236, 236, 236).CGColor;
    textField.placeholder = placeholder;
    [_contentView addSubview:textField];
    textField.delegate = self;
    
    UIImageView *left = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 55*2/3.0, 55)];
    [left setImage:[UIImage imageNamed:icon]];
    left.contentMode = UIViewContentModeScaleAspectFit;
    textField.leftView = left;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    return textField;
}
#pragma mark -显示隐藏密码
-(void)secureButtonAction{
    UITextField *password = (UITextField *)[self.view viewWithTag:2];
    password.secureTextEntry = !password.secureTextEntry;
}
#pragma mark - 点击事件(获取验证码)
- (void)verifyButtonClick
{
    UITextField *phoneLabel = (UITextField *)[_contentView viewWithTag:1];
    NSString *regex = @"^1[0-9]{10}$";
    NSPredicate *p = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![p evaluateWithObject:phoneLabel.text]) {
        UIAlertView *alert4 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入11位手机号码" delegate:nil cancelButtonTitle:@"重新输入" otherButtonTitles:nil, nil];
        [alert4 show];
    }else{
        NSString  *mobile = phoneLabel.text;
        UIButton *verifyButton = (UIButton *)[_contentView viewWithTag:4];
        NSDictionary  *parms = @{@"mobile":mobile};
        [XMHttpTool  postWithURL:@"Verifycode/getForgotVerifyCode" params:parms success:^(id json) {
            XMLog(@"json-->%@",json);
            
            if ([json[@"status"] intValue] == 1) {
                
                [XMDealTool  sharedXMDealTool].userid=json[@"userid"];
                
                verifyButton.enabled = NO;
                testTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(testTimerRun) userInfo:nil repeats:YES];
                [[NSRunLoop mainRunLoop] addTimer:testTimer forMode:NSDefaultRunLoopMode];
            }
            else{
                UIAlertView *alert5 = [[UIAlertView alloc] initWithTitle:@"提示" message:json[@"message"] delegate:nil cancelButtonTitle:@"重新登录" otherButtonTitles:nil, nil];
                [alert5 show];
            }
        } failure:^(NSError *error) {
            
            XMLog(@"%@",error);
            
        }];
        
        
    }
    
}
#pragma mark - 登陆
- (void)loginButtonClick
{
    UITextField *verifyLabel = (UITextField *)[_contentView viewWithTag:3];
    if ([verifyLabel.text isEqualToString:@""]) {
        UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入验证码" delegate:nil cancelButtonTitle:@"重新输入" otherButtonTitles:nil, nil];
        [alert1 show];
    }
    else{
        UITextField *phoneLabel = (UITextField *)[_contentView viewWithTag:1];
        UITextField *passwordLabel = (UITextField *)[_contentView viewWithTag:2];
        if ([self verifyWithPhone:phoneLabel.text secure:passwordLabel.text]){
            NSString  *mobile = phoneLabel.text;
            NSString  *password = passwordLabel.text;
            NSString  *verify = verifyLabel.text;
            
            XMLog(@"params-->%@",@{@"mobile":mobile,@"password":password,@"verify":verify});
            [[XMDealTool sharedXMDealTool] resetPasswordWithParams:@{@"mobile":mobile,@"password":password,@"verify":verify} success:^(NSDictionary *deal) {
                
                XMLog(@"json-->%@",deal);
                
                if ([deal[@"status"] intValue]==1) {
                    [MBProgressHUD showSuccess:deal[@"message"]];
                    [XMDealTool sharedXMDealTool].userid=deal[@"userid"];
                    [XMDealTool sharedXMDealTool].password=deal[@"password"];
                    [XMDealTool sharedXMDealTool].phone = mobile;
                    //记住登陆状态
                    [self saveUseridAndPassword];
//                        [self setUserAliasWithUserid:deal[@"userid"]];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessNote object:nil];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
                else{
                    NSString *str = deal[@"message"];
                    XMLog(@"-------------%@",str);
                    [MBProgressHUD showError:str];
//                    UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"提示" message:deal[@"message"] delegate:nil cancelButtonTitle:@"重新登录" otherButtonTitles:nil, nil];
//                    [alert1 show];
                }
            }];
        }
    }
}
#pragma mark - 验证手机号和密码的格式
- (BOOL)verifyWithPhone:(NSString *)phone secure:(NSString *)secure{
    //手机号
    NSString *regex = @"^1[0-9]{10}$";
    NSPredicate *p = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![p evaluateWithObject:phone]) {
        UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入11位手机号码" delegate:nil cancelButtonTitle:@"继续" otherButtonTitles:nil, nil];
        [alert1 show];
        return NO;
    }
    //密码
    NSString *regex2 = @"^[0-9a-zA-Z]{6,15}$";
    NSPredicate *p2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
    if (![p2 evaluateWithObject:secure]) {
        UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入6~15位由数字或字母组成的密码" delegate:nil cancelButtonTitle:@"继续" otherButtonTitles:nil, nil];
        [alert1 show];
        return NO;
    }
    return YES;
}
#pragma mark 保存用户名和密码
- (void)saveUseridAndPassword
{
    NSString *userid = [XMDealTool sharedXMDealTool].userid;
    NSString *password = [XMDealTool sharedXMDealTool].password;
    NSString *phone = [XMDealTool sharedXMDealTool].phone;
    
    [UserDefaults setObject:phone forKey:@"phone"];
    [UserDefaults setObject:userid forKey:@"userid"];
    [UserDefaults setObject:password forKey:@"password"];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    //    [UIView animateWithDuration:0.3 animations:^{
    //        if (textField.tag==3) {
    //            _contentView.contentOffset=CGPointMake(0, password.top-username.top-65);
    //        }else if (textField.tag==4){
    //
    //            _contentView.contentOffset=CGPointMake(0, verify.top-password.top-15);
    //
    //        }
    //
    //    }];
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    _contentView.contentOffset = CGPointMake(0, 0);
    
    //    [UIView animateWithDuration:0.3 animations:^{
    //        if (textField.tag>1) {
    //            _contentView.contentOffset=CGPointMake(0, -70);
    //        }    }];
    
    //}
    
}
#pragma mark - 刷新计时器
- (void)testTimerRun
{
    UIButton  *verifyButton = (UIButton *)[_contentView viewWithTag:4];
    if (--time) {
        [verifyButton setTitle:[NSString stringWithFormat:@"%i秒",time] forState:UIControlStateDisabled];
    }else{
        time = 60;
        verifyButton.enabled = YES;
        [verifyButton setTitle:[NSString stringWithFormat:@"%i秒",time] forState:UIControlStateDisabled];
        [testTimer invalidate];
        testTimer = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)topView:(UITapGestureRecognizer *)tap{
    //
    _contentView.contentOffset = CGPointMake(0, 0);
    // 发送resignFirstResponder.
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder)
                                               to:nil
                                             from:nil
                                         forEvent:nil];
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
