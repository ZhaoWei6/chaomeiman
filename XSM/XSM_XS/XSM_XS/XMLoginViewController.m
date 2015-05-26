//
//  XMLoginViewController.m
//  XSM_XS
//
//  Created by Apple on 14/12/1.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMLoginViewController.h"
#import "XMResetViewController.h"
#import "APService.h"
@interface XMLoginViewController ()
{
    int time;//用于记录按钮上显示的秒数
    NSTimer *testTimer;//用于刷新按钮上显示的数字
}
@end

@implementation XMLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.isModal == YES) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(backOriginalController)];
    }
    
    //加载登录主界面
    [self loadLoginView];
    self.seg.frame  = CGRectMake(10, 10, kDeviceWidth-20, 40);
    //
    self.contentView.contentSize = CGSizeMake(0, _contentView.height+1);
    [self.contentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignResponder)]];
}


#pragma mark  登录主页面
-(void)loadLoginView{
    if (_contentView.subviews.count > 0) {
        for (UIView *subView in _contentView.subviews) {
            [subView removeFromSuperview];
        }
    }
    self.title = @"登录";
    //提示信息
    UILabel *message = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, kDeviceWidth-20, 20)];
    message.text = @"为了确保服务质量，请先登录";
    message.textColor = XMButtonBg;
    message.font = [UIFont systemFontOfSize:15];
    [_contentView addSubview:message];
    //用户名
    UITextField *username = [self loadTextFiledWithIcon:@"icon_phone" placeholder:@"填写手机号"];
    username.frame = CGRectMake(message.left, message.bottom+5, message.width, kUIButtonHeight);
    username.tag = 1;
    username.keyboardType = UIKeyboardTypeNumberPad;
    //密码
    UITextField *password = [self loadTextFiledWithIcon:@"password" placeholder:@"请输入密码"];
    password.frame = CGRectMake(username.left, username.bottom+15, username.width, username.height);
    password.secureTextEntry=YES;
    password.tag=2;
    //右侧眼睛
    UIButton  *showPass=[UIButton buttonWithType:UIButtonTypeCustom];
    showPass.backgroundColor=[UIColor  clearColor];
    showPass.frame=CGRectMake(0, 0, password.height, password.height/2.0);
    showPass.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [showPass setImage:[UIImage imageNamed:@"icon_password_eye"] forState:UIControlStateNormal];
    [showPass addTarget:self action:@selector(secureButtonAction:) forControlEvents:UIControlEventTouchDown|UIControlEventTouchUpOutside|UIControlEventTouchUpInside];
    password.rightView = showPass;
    password.rightViewMode = UITextFieldViewModeAlways;
    //忘记密码
    UIButton  *forget=[[UIButton alloc]initWithFrame:CGRectMake(password.right-80, password.bottom, 80, 40)];
    [forget.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [forget setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forget setTitleColor:XMButtonBg forState:UIControlStateNormal];
    [forget addTarget:self action:@selector(forgetAction) forControlEvents:UIControlEventTouchDown];
    [_contentView addSubview:forget];
    //登录按钮
    UIButton *sign = [UIButton buttonWithType:UIButtonTypeCustom];
    sign.backgroundColor = [UIColor darkGrayColor];
    sign.frame = CGRectMake(username.left, username.bottom+140, username.width, kUIButtonHeight);
    [sign setTitle:@"立即登录" forState:UIControlStateNormal];
    [sign setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sign.backgroundColor = XMButtonBg;
    sign.layer.cornerRadius = 5;
    sign.tag = 101;
    [sign addTarget:self action:@selector(loginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:sign];
}



#pragma mark  注册主页面
-(void)loadRegisterView
{
    if (_contentView.subviews.count > 0) {
        for (UIView *subView in _contentView.subviews) {
            [subView removeFromSuperview];
        }
    }
    self.title = @"注册";
    //提示信息
    UILabel *message = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, kDeviceWidth-20, 20)];
    message.text = @"请注册";
    message.textColor = XMButtonBg;
    message.font = [UIFont systemFontOfSize:15];
    [_contentView addSubview:message];
    //用户名
    UITextField *username = [self loadTextFiledWithIcon:@"icon_phone" placeholder:@"填写手机号"];
    username.frame = CGRectMake(message.left, message.bottom+5, message.width, kUIButtonHeight);
    username.keyboardType = UIKeyboardTypeNumberPad;
    username.tag = 1;
    //验证码
    UITextField *verify = [[UITextField alloc] initWithFrame:CGRectMake(username.left, username.bottom+10, username.width*2/3, username.height)];
    verify.backgroundColor = [UIColor whiteColor];
    verify.layer.borderWidth = 1;
    verify.layer.cornerRadius = 5;
    verify.layer.borderColor = XMColor(236, 236, 236).CGColor;
    verify.tag=3;
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
    verifyButton.frame = CGRectMake(verify.right+5, verify.top, message.width - verify.width - 5, verify.height);
    verifyButton.tag = 4;
    verifyButton.backgroundColor = XMButtonBg;
    verifyButton.layer.cornerRadius = 5;
    verifyButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [verifyButton addTarget:self action:@selector(verifyButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:verifyButton];
    //密码
    UITextField *password = [self loadTextFiledWithIcon:@"password" placeholder:@"请输入密码"];
    password.frame = CGRectMake(verify.left, verify.bottom+15, username.width, username.height);
    password.secureTextEntry=YES;
    password.tag=2;
    //右侧眼睛
    UIButton  *showPass=[UIButton buttonWithType:UIButtonTypeCustom];
    showPass.backgroundColor=[UIColor  clearColor];
    showPass.frame=CGRectMake(0, 0, password.height, password.height/2.0);
    showPass.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [showPass setImage:[UIImage imageNamed:@"icon_password_eye"] forState:UIControlStateNormal];
    [showPass addTarget:self action:@selector(secureButtonAction:) forControlEvents:UIControlEventTouchDown|UIControlEventTouchUpOutside|UIControlEventTouchUpInside];
    password.rightView = showPass;
    password.rightViewMode = UITextFieldViewModeAlways;
    
    // 用户隐私协议
    UILabel *privacylabel = [[UILabel alloc] initWithFrame:CGRectMake(username.left, username.bottom+110, 150, 21)];
    [privacylabel setText:@"点击\"立即登录\",即表示同意"];
    [privacylabel setTextColor:kTextFontColor666];
    [privacylabel setFont:[UIFont systemFontOfSize:12]];
    [_contentView addSubview:privacylabel];
    
    UIButton *privacybutton = [[UIButton alloc] initWithFrame:CGRectMake(username.left + 150, username.bottom+110, 120, 21)];
    [privacybutton setTitle:@"用使用协议和隐私政策" forState:UIControlStateNormal];
//    [privacybutton setTitle:@"用使用协议和隐私政策" forState:UIControlStateHighlighted];
    [privacybutton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [privacybutton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [privacybutton addTarget:self action:@selector(buttonClickedToPrivacyInfo) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:privacybutton];
    
    //登录按钮
    UIButton *login = [UIButton buttonWithType:UIButtonTypeCustom];
    login.backgroundColor = [UIColor darkGrayColor];
    login.frame = CGRectMake(username.left, username.bottom+140, username.width, kUIButtonHeight);
    [login setTitle:@"立即登录" forState:UIControlStateNormal];
    [login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    login.backgroundColor = XMButtonBg;
    login.layer.cornerRadius = 5;
    login.tag = 100;
    [login addTarget:self action:@selector(loginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:login];
}

- (void)buttonClickedToPrivacyInfo
{
    XMBaseViewController *privyVC = [[XMBaseViewController alloc] init];
    
    privyVC.title = @"用户使用协议和隐私政策";
    privyVC.view.backgroundColor = XMGlobalBg;
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"user_agreement" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [webView loadRequest:request];
    
    [privyVC.view addSubview:webView];
    
    [self.navigationController pushViewController:privyVC animated:YES];
    
}

#pragma mark - segment的点击事件
- (IBAction)loginOrResgin:(UISegmentedControl *)sender {
    //    XMLog(@"%i",sender.selectedSegmentIndex);
    if (sender.selectedSegmentIndex) {
        [self loadRegisterView];
    }else{
        [self loadLoginView];
    }
}
#pragma mark 显示隐藏密码
- (void)secureButtonAction:(UIButton *)sender
{
    UIView *view = [sender superview];
    UITextField *textField = (UITextField *)[view viewWithTag:2];
    textField.secureTextEntry = !textField.secureTextEntry;
}
#pragma mark 登录
- (void)loginButtonClick:(UIButton *)sender
{
    UIView *content = [sender superview];
    if (sender.tag == 100) {
        //注册
        UITextField *verifyLabel = (UITextField *)[content viewWithTag:3];
        if ([verifyLabel.text isEqualToString:@""]) {
            UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入验证码" delegate:nil cancelButtonTitle:@"重新输入" otherButtonTitles:nil, nil];
            [alert1 show];
        }
        else{
            UITextField *phoneLabel = (UITextField *)[content viewWithTag:1];
            UITextField *passwordLabel = (UITextField *)[content viewWithTag:2];
            if ([self verifyWithPhone:phoneLabel.text secure:passwordLabel.text]){
                NSString  *mobile = phoneLabel.text;
                NSString  *password = passwordLabel.text;
                NSString  *verify = verifyLabel.text;
                
                [[XMDealTool sharedXMDealTool] dealWitParams:@{@"mobile":mobile,@"password":password,@"verify":verify} Success:^(NSDictionary *deal) {
                    if ([deal[@"status"] intValue]==1) {
                        [XMDealTool sharedXMDealTool].userid=deal[@"userid"];
                        [XMDealTool sharedXMDealTool].password=deal[@"password"];
                        [XMDealTool sharedXMDealTool].phone = mobile;
                        [XMDealTool sharedXMDealTool].approve = @"1";
                        //记住登陆状态
                        [self saveUseridAndPassword];
                        [self setUserAliasWithUserid:deal[@"userid"]];
                        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessNote object:nil];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    else{
                        NSString *str = deal[@"message"];
                        XMLog(@"-------------%@",str);
                        UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"提示" message:deal[@"message"] delegate:nil cancelButtonTitle:@"重新登录" otherButtonTitles:nil, nil];
                        [alert1 show];
                    }
                }];
            }
        }
    }
    else{
        //登陆
        UITextField *phoneLabel = (UITextField *)[content viewWithTag:1];
        UITextField *passwordLabel = (UITextField *)[content viewWithTag:2];
        if ([self verifyWithPhone:phoneLabel.text secure:passwordLabel.text]){
            NSString  *mobile = phoneLabel.text;
            NSString  *password = passwordLabel.text;
            
            NSDictionary *parms = @{@"mobile":mobile,@"password":password};
            [XMHttpTool postWithURL:@"login/index" params:parms success:^(id json) {
                //
                XMLog(@"登陆json-->%@",json);
                //
                if ([json[@"status"] intValue] == 1) {
                    [XMDealTool sharedXMDealTool].userid = json[@"userid"];
                    [XMDealTool sharedXMDealTool].password = json[@"password"];
                    [XMDealTool sharedXMDealTool].phone = mobile;
                    [XMDealTool sharedXMDealTool].approve = json[@"approve"];
                    XMLog(@"approve:%@",[XMDealTool sharedXMDealTool].approve);
                    //记住登陆状态
                    [self saveUseridAndPassword];
                    //出栈
                    if (self.isModal == NO) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }else{
                        [self dismissViewControllerAnimated:YES completion:^{}];
                    }
                    //                    [self setUserAliasWithUserid:json[@"userid"]];
                    //发送通知--登陆成功
                    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessNote object:nil];
                }else{
                    UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"提示" message:json[@"message"] delegate:nil cancelButtonTitle:@"重新登录" otherButtonTitles:nil, nil];
                    [alert1 show];
                }
            } failure:^(NSError *error) {
                
                XMLog(@"%@",error);
            }];
        }
    }
}
//验证手机号和密码的格式
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
        UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入6~15位由数组和字母组成的密码" delegate:nil cancelButtonTitle:@"继续" otherButtonTitles:nil, nil];
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
    NSString *approve = [XMDealTool sharedXMDealTool].approve;
    
    [UserDefaults setObject:phone forKey:@"phone"];
    [UserDefaults setObject:userid forKey:@"userid"];
    [UserDefaults setObject:password forKey:@"password"];
    [UserDefaults setObject:approve forKey:@"approve"];
    
    XMLog(@"%@",[UserDefaults objectForKey:@"approve"]);
}
#pragma mark - 为用户设置别名
- (void)setUserAliasWithUserid:(NSString *)userid
{
    [self saveUseridAndPassword];
    [APService setAlias:userid callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
}

- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}
#pragma mark 忘记密码
- (void)forgetAction
{
    [self.navigationController pushViewController:[[XMResetViewController alloc] init] animated:YES];
}
#pragma mark 获取验证码
- (void)verifyButtonClick
{
    UITextField *phoneText = (UITextField *)[_contentView viewWithTag:1];
    NSString *regex = @"^(13|15|17|18|14)[0-9]{9}$";
    NSPredicate *p = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![p evaluateWithObject:phoneText.text]) {
        UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入11位手机号码" delegate:nil cancelButtonTitle:@"重新输入" otherButtonTitles:nil, nil];
        [alert1 show];
    }else{
        NSString  *mobile=phoneText.text;
        UIButton  *verifyButton = (UIButton *)[_contentView viewWithTag:4];
        verifyButton.enabled = NO;
        testTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(testTimerRun) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:testTimer forMode:NSDefaultRunLoopMode];
        NSDictionary  *parms=@{@"mobile":mobile};
        [XMHttpTool  postWithURL:@"Verifycode/getVerifyCode" params:parms success:^(id json) {
            if ([json[@"status"] intValue] == 1) {
            }
            else{
                UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"提示" message:json[@"message"] delegate:nil cancelButtonTitle:@"重新登录" otherButtonTitles:nil, nil];
                [alert2 show];
            }
        } failure:^(NSError *error) {
            XMLog(@"%@",error);
        }];
    }
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
#pragma mark - 返回
- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)backOriginalController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)View_TouchDown:(id)sender {
    // 发送resignFirstResponder.
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder)
                                               to:nil
                                             from:nil
                                         forEvent:nil];
}
- (void)resignResponder
{
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
