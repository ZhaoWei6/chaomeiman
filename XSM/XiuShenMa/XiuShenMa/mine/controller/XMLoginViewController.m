//
//  XMLoginViewController.m
//  XiuShemMa
//
//  Created by Apple on 14-10-8.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMLoginViewController.h"
#import "XMMineViewController.h"
#import "XMResetController.h"

#import "XMDealTool.h"
#import "XMHttpTool.h"
#import "XMContactsTool.h"
#import "APService.h"

#import "XMPlaceHolderTextView.h"
#import "XMKeyboardAvoidingScrollView.h"
#import "UIScrollView+Touch.h"

#import "UIColor+XM.h"
//#import "UIView+Shadow.h"
#import "QHTopMenu.h"

#define TextFiledHeight 44
#define NUMBERS @"0123456789\n"

@interface XMLoginViewController ()<UITextFieldDelegate,QHTopMenuItemClickDelegete>
{
    UITextField *phoneNumber;//手机号码输入框
    UITextField *numberTextFiled;//验证码输入框
    UITextField  *secureFiled;//密码输入框
    
    UIButton *verifyButton;//获取验证码
    
    UIScrollView  *contentView;//放置登录或注册页面
    
    int time;//用于记录按钮上显示的秒数
    NSTimer *testTimer;//用于刷新按钮上显示的数字
    
    NSString *verifyString;//验证码
    
    UITextField *phoneNumber1;//手机号码输入框
    UITextField  *secureFiled1;//密码输入框
//      登录 、注册
    UIButton  *loginButton;
    UIButton  *signButton;
}
// 密码是否隐藏
@property(nonatomic,assign)BOOL isagin;
// 下划线是否隐藏
@property(nonatomic,assign)BOOL isline;

@end

@implementation XMLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = XMGlobalBg;
    
    [self loginSubView];
    
    if (self.isModal) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(backToLastController)];
    }
}
#pragma mark -
#pragma mark 登陆/注册  选项菜单
-(void)loginSubView{
    QHTopMenu *topMenu = [QHTopMenu initQHTopMenuWithTitles:@[@"登录",@"注册"] frame:CGRectMake(0, 64, kDeviceWidth, 44) delegate:self];
    [self.view addSubview:topMenu];
    /*
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(10, 64+10, kDeviceWidth-20, kUIButtonHeight)];
    topView.layer.cornerRadius = 5;
    topView.backgroundColor = XMButtonBg;
    [self.view addSubview:topView];
//    登录
    loginButton=[[UIButton alloc]initWithFrame:CGRectMake(10, 10+64, (kDeviceWidth-20)/2, kUIButtonHeight)];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    loginButton.backgroundColor=[UIColor clearColor];
    [loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [loginButton  addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:loginButton];
//    注册
    signButton=[[UIButton alloc]initWithFrame:CGRectMake(loginButton.right, 10+64, loginButton.width, kUIButtonHeight)];
    [signButton setTitle:@"注册" forState:UIControlStateNormal];
    [signButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    signButton.backgroundColor=[UIColor clearColor];
    [signButton  addTarget:self action:@selector(signAction) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:signButton];
    
    //设置边框
    loginButton.layer.cornerRadius = 5;
    loginButton.layer.borderWidth = 1;
    loginButton.layer.borderColor = XMButtonBg.CGColor;
    signButton.layer.cornerRadius = 5;
    signButton.layer.borderWidth = 1;
    signButton.layer.borderColor = XMButtonBg.CGColor;
    
    //设置背景色
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [signButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [loginButton setTitleColor:XMButtonBg forState:UIControlStateDisabled];
    [signButton setTitleColor:XMButtonBg forState:UIControlStateDisabled];
    */
}
#pragma mark QHTopMenuItemClickDelegete
- (void)clickItemWithItem:(NSString *)item
{
    if ([item isEqualToString:@"登录"]) {
        [self loginView];
    }else{
        [self loadRegisterView];
    }
}

/*
//登录
-(void)loginAction{
    loginButton.enabled = NO;
    signButton.enabled = YES;
    signButton.backgroundColor = [UIColor clearColor];
    loginButton.backgroundColor = [UIColor whiteColor];
    [self  loginView];
}

//注册
-(void)signAction{
    loginButton.enabled = YES;
    signButton.enabled = NO;
    loginButton.backgroundColor = [UIColor clearColor];
    signButton.backgroundColor = [UIColor whiteColor];
    [self loadRegisterView];
}
*/
#pragma mark  登录主页面
-(void)loginView{
    [contentView removeFromSuperview];
    contentView = nil;
    
    contentView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 108, kDeviceWidth, kDeviceHeight-64)];
    contentView.contentSize=CGSizeMake(kDeviceWidth, kDeviceHeight-60);
    contentView.backgroundColor=XMGlobalBg;
    contentView.showsVerticalScrollIndicator=NO;
    contentView.scrollEnabled=YES;
    [self.view addSubview:contentView];
    self.title = @"登录";
    self.isline=NO;
    //
    
    // 顶部提示
    QHLabel *label = [[QHLabel alloc] initWithFrame:CGRectMake(10, 15, kDeviceWidth-20, 18)];
    label.font = [UIFont systemFontOfSize:15];
    label.backgroundColor = [UIColor clearColor];
    label.textColor=XMButtonBg;
    label.text = @"为了确保服务质量，请先登录";
    [contentView addSubview:label];
    
    //用户名
    phoneNumber1 = [self loadTextFiledWithIcon:@"icon_phone" placeholder:@"填写手机号"];
    phoneNumber1.frame = CGRectMake(label.left, label.bottom+10, kDeviceWidth-20, TextFiledHeight);
    [contentView addSubview:phoneNumber1];
//    phoneNumber1.delegate = self;
    phoneNumber1.keyboardType = UIKeyboardTypeNumberPad;
    
    //密码
    secureFiled1 = [self loadTextFiledWithIcon:@"password" placeholder:@"请输入密码"];
    secureFiled1.frame = CGRectMake(phoneNumber1.left, phoneNumber1.bottom+15, phoneNumber1.width, phoneNumber1.height);
    secureFiled1.secureTextEntry=YES;
    secureFiled1.tag=2;
    [contentView addSubview:secureFiled1];
    //右侧眼睛
    UIButton  *secure1=[UIButton buttonWithType:UIButtonTypeCustom];
    secure1.backgroundColor=[UIColor  clearColor];
    secure1.frame=CGRectMake(0, 0, secureFiled1.height, secureFiled1.height/2.0);
    secure1.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [secure1 setImage:[UIImage imageNamed:@"icon_password_eye"] forState:UIControlStateNormal];
    [secure1 addTarget:self action:@selector(secureButtonAction) forControlEvents:UIControlEventTouchDown|UIControlEventTouchUpOutside|UIControlEventTouchUpInside];
    secureFiled1.rightView = secure1;
    secureFiled1.rightViewMode = UITextFieldViewModeAlways;
    
    
    //   忘记密码
    UIButton  *forget=[[UIButton alloc]initWithFrame:CGRectMake(secureFiled1.right-65, secureFiled1.bottom+15, 65, 15)];
    [forget.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [forget setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forget setTitleColor:XMButtonBg forState:UIControlStateNormal];
    [forget addTarget:self action:@selector(forgetAction) forControlEvents:UIControlEventTouchDown];
    [contentView addSubview:forget];
    
//    forget.width = [forget.titleLabel.text boundingRectWithSize:forget.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:forget.titleLabel.font} context:nil].size.width;
//    forget.frame = CGRectMake(secureFiled1.right-forget.width, secureFiled1.bottom+15, forget.width, forget.height);
    
    //登陆按钮
    UIButton *sign = [UIButton buttonWithType:UIButtonTypeCustom];
    sign.backgroundColor = [UIColor darkGrayColor];
    sign.frame = CGRectMake(phoneNumber1.left, phoneNumber1.bottom+140, phoneNumber1.width, kUILoginHeight);
    [sign setTitle:@"立即登录" forState:UIControlStateNormal];
    [sign setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sign.backgroundColor = XMButtonBg;
    sign.layer.cornerRadius = 5;
    [sign addTarget:self action:@selector(loginButton) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:sign];
    
//    [phoneNumber1 performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.5];
}



#pragma mark  注册主页面
-(void)loadRegisterView
{
    [contentView removeFromSuperview];
    contentView = nil;
    
    contentView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 108, kDeviceWidth, kDeviceHeight-64)];
    
    contentView.contentSize=CGSizeMake(kDeviceWidth, kDeviceHeight-60);
    contentView.backgroundColor=XMGlobalBg;
    contentView.showsVerticalScrollIndicator=NO;

    [self.view addSubview:contentView];
    self.title = @"注册";
    //    self.isline=YES;
    // 顶部提示
    QHLabel *label = [[QHLabel alloc] initWithFrame:CGRectMake(10,15, kDeviceWidth-20, 18)];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = XMButtonBg;
    label.text = @"请注册";
   
    [contentView addSubview:label];
    
    //填写手机号
    phoneNumber = [self loadTextFiledWithIcon:@"icon_phone" placeholder:@"填写手机号"];
    phoneNumber.frame = CGRectMake(label.left, label.bottom+10, label.width, TextFiledHeight);
    phoneNumber.keyboardType = UIKeyboardTypeNumberPad;
    
    //验证码
    numberTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(phoneNumber.left, phoneNumber.bottom+15, label.width*2/3, TextFiledHeight)];
    numberTextFiled.backgroundColor = [UIColor whiteColor];
    numberTextFiled.layer.borderWidth = 1;
    numberTextFiled.layer.cornerRadius = 5;
    numberTextFiled.layer.borderColor = kBorderColor.CGColor;
//    numberTextFiled.layer.borderColor = XMColor(236, 236, 236).CGColor;
    numberTextFiled.tag=4;
    numberTextFiled.placeholder = @"验证码";
    numberTextFiled.delegate = self;
    [contentView addSubview:numberTextFiled];
    numberTextFiled.keyboardType = UIKeyboardTypeNumberPad;
    
    UIView *left = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
    numberTextFiled.leftView = left;
    numberTextFiled.leftViewMode = UITextFieldViewModeAlways;
    //获取验证码
    time = 60;
    verifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [verifyButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [verifyButton setTitle:[NSString stringWithFormat:@"%i秒",time] forState:UIControlStateDisabled];
    [verifyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    verifyButton.frame = CGRectMake(numberTextFiled.right+5, numberTextFiled.top+1, label.width - numberTextFiled.width - 5, numberTextFiled.height-2);
    verifyButton.backgroundColor = XMButtonBg;
    verifyButton.layer.cornerRadius = 5;
    verifyButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [verifyButton addTarget:self action:@selector(verifyButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:verifyButton];
    
    //密码
    secureFiled = [self loadTextFiledWithIcon:@"password" placeholder:@"密码(6~15位数字或字母)"];
    secureFiled.frame = CGRectMake(numberTextFiled.left, numberTextFiled.bottom+15, label.width, TextFiledHeight);
    secureFiled.secureTextEntry=YES;
    secureFiled.tag=6;
    secureFiled.delegate  = self;
    [contentView addSubview:secureFiled];
    
    //显示隐藏密码
    UIButton  *secure=[UIButton buttonWithType:UIButtonTypeCustom];
    secure.backgroundColor=[UIColor  clearColor];
    secure.frame=CGRectMake(0, 0, secureFiled1.height, secureFiled1.height/2.0);
    secure.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [secure setImage:[UIImage imageNamed:@"icon_password_eye"] forState:UIControlStateNormal];
    [secure addTarget:self action:@selector(secureButtonClick) forControlEvents:UIControlEventTouchDown|UIControlEventTouchUpOutside|UIControlEventTouchUpInside];
    secureFiled.rightView = secure;
    secureFiled.rightViewMode = UITextFieldViewModeAlways;
    
    
    //隐私协议
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(secureFiled.left, secureFiled.bottom+20, 159, 12)];
    messageLabel.font = [UIFont systemFontOfSize:12];
    messageLabel.textColor = kTextFontColor666;
    messageLabel.text = @"点击\"立即登录\",即表示您同意";
    [contentView addSubview:messageLabel];
    
    UIButton *privacyButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [privacyButton setTitle:@"用户使用协议和隐私政策" forState:UIControlStateNormal];
    privacyButton.titleLabel.font = [UIFont systemFontOfSize:12];
    privacyButton.frame = CGRectMake(messageLabel.right, messageLabel.top, 132, 13);
    //    [privacyButton makeInsetShadowWithRadius:1 Color:[UIColor blueColor] Directions:@[@"bottom"]];
    [privacyButton addTarget:self action:@selector(clickPrivacyButton:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:privacyButton];
    
    //登录
    UIButton *login = [UIButton buttonWithType:UIButtonTypeCustom];
    login.backgroundColor = XMButtonBg;
    login.frame = CGRectMake(numberTextFiled.left, privacyButton.bottom+10, label.width,kUILoginHeight);
    [login setTitle:@"立即登录" forState:UIControlStateNormal];
    [login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    login.layer.cornerRadius = 5;
    [login addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:login];
    
    
    
}

- (void)clickPrivacyButton:(UIButton *)sender
{
    XMBaseViewController *privyVC = [[XMBaseViewController alloc] init];
    
    privyVC.title = @"用户使用协议和隐私政策";
    privyVC.view.backgroundColor = XMGlobalBg;
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, kDeviceWidth, kDeviceHeight-64)];
    
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"user_agreement" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [webView loadRequest:request];
    
    [privyVC.view addSubview:webView];
    
    [self.navigationController pushViewController:privyVC animated:YES];
}

#pragma mark UITextFiled的Delegate方法
/*
//判断输入的是否为数字
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *cs;
    if(textField == phoneNumber)
    {
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        if(!basicTest)
        {
            UIAlertView* alert1 = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"请输入数字"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            phoneNumber.enabled = NO;
            [alert1 show];
            return NO;
        }
    }
    //其他的类型不需要检测，直接写入
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
     [secureFiled resignFirstResponder];
//    判断是否是注册
    if (self.isline==YES){
        if (textField == phoneNumber) {
                  
         [self verifyButtonClick];
                  
        } else{
              
        [self loginButtonClick];
              
       }
        
    }else{
        if (textField==secureFiled1) {
            [secureFiled1 resignFirstResponder];
        }else{
            [self loginButton];
        }
    
    }
    return YES;
}
*/
#pragma mark - 提示框delegate方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    phoneNumber.enabled = YES;
    
}

#pragma mark - 点击事件(获取验证码)
- (void)verifyButtonClick
{
    [phoneNumber resignFirstResponder];
    verifyButton.userInteractionEnabled = NO;
    
    NSString *regex = @"^1[0-9]{10}$";
    NSPredicate *p = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![p evaluateWithObject:phoneNumber.text]) {
        UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入11位手机号码" delegate:nil cancelButtonTitle:@"重新输入" otherButtonTitles:nil, nil];
        [alert1 show];
        verifyButton.userInteractionEnabled = YES;
    }else{
        NSString  *mobile=phoneNumber.text;
        NSDictionary  *parms=@{@"mobile":mobile};
        
//        verifyButton.enabled = NO;
//        testTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(testTimerRun) userInfo:nil repeats:YES];
//        [[NSRunLoop mainRunLoop] addTimer:testTimer forMode:NSDefaultRunLoopMode];
        [numberTextFiled becomeFirstResponder];

        
        verifyButton.userInteractionEnabled = YES;
        [XMHttpTool  postWithURL:@"Verifycode/getVerifyCode" params:parms success:^(id json) {
            
            if ([json[@"status"] intValue] == 1) {
                
                verifyButton.enabled = NO;
                testTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(testTimerRun) userInfo:nil repeats:YES];
                [[NSRunLoop mainRunLoop] addTimer:testTimer forMode:NSDefaultRunLoopMode];
                
                [XMDealTool  sharedXMDealTool].userid=json[@"userid"];
                
                
            }
            else{
                
                UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"提示" message:json[@"message"] delegate:nil cancelButtonTitle:@"重新登录" otherButtonTitles:nil, nil];
                [alert2 show];
                
//                verifyButton.userInteractionEnabled = YES;
            }
            
        } failure:^(NSError *error) {
            
            XMLog(@"%@",error);
            
        }];
        
        
        
       
    }
    
}
#pragma mark - 登录
//注册按钮点击事件
- (void)loginButtonClick
{
    [self resignResponder];
    
    NSString *message = @"";
 
    
    if ([numberTextFiled.text isEqualToString:@""]) {
        message = @"请输入验证码";
    }
    else{
        if ([self verifyWithPhone:phoneNumber.text secure:secureFiled.text]){
            
            NSString  *mobile=phoneNumber.text;
            NSString  *password=secureFiled.text;
            NSString  *verify=numberTextFiled.text;
            
            [[XMContactsTool sharedXMContactsTool]
             dealWitParams:@{@"mobile":mobile,
                             @"password":password,
                             @"verify":verify}
             Success:^(NSDictionary *deal) {
                 //提示用户
                 [MBProgressHUD showSuccess:deal[@"message"]];
                 if ([deal[@"status"] intValue]==1) {
//                     [XMContactsTool sharedXMContactsTool].mobile = mobile;
//                     [XMContactsTool sharedXMContactsTool].userid=deal[@"userid"];
//                     [XMContactsTool sharedXMContactsTool].password=deal[@"password"];
                     
                     
                     [XMDealTool sharedXMDealTool].userid = deal[@"userid"];
                     [XMDealTool sharedXMDealTool].password = deal[@"password"];
                     
                     flag = YES;
                     phone_Number = phoneNumber.text;
                     //为用户设置别名
                     [self setUserAliasWithUserid:deal[@"userid"]];
                     [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessNote object:nil];
                     
                     if (self.isModal) {
                         [self dismissViewControllerAnimated:YES completion:nil];
                     }else{
                         [self.navigationController popViewControllerAnimated:YES];
                     }
                 }
//                 else{
//                     //注册失败
//                     NSString *str = deal[@"message"];
//                     XMLog(@"-------------%@",str);
//                     UIAlertView *alert3 = [[UIAlertView alloc] initWithTitle:@"提示" message:deal[@"message"] delegate:nil cancelButtonTitle:@"重新登录" otherButtonTitles:nil, nil];
//                     [alert3 show];
//                 }
             }];
            
        }
    }

    if (![message isEqualToString:@""]) {
        UIAlertView *alert4 = [[UIAlertView alloc] initWithTitle:@"警告" message:message delegate:nil cancelButtonTitle:@"重新输入" otherButtonTitles:nil, nil];
        [alert4 show];
    }
}

//登录按钮点击事件
-(void)loginButton{
    [self resignResponder];
    //手机号码格式
    if ([self verifyWithPhone:phoneNumber1.text secure:secureFiled1.text]) {
        //提示用户正在登录
        [MBProgressHUD showMessage:@"正在登陆..."];
        
        NSString *mobile = phoneNumber1.text;
        NSString *password = secureFiled1.text;
        NSDictionary *parms = @{@"mobile":mobile,@"password":password};
        [XMHttpTool postWithURL:@"login/index" params:parms success:^(id json) {
            //
            [MBProgressHUD hideHUD];
            if ([json[@"status"] intValue] == 1) {
                [MBProgressHUD showSuccess:json[@"message"]];
                
                flag = YES;
                phone_Number = phoneNumber1.text;
                
                [XMDealTool sharedXMDealTool].userid = json[@"userid"];
                [XMDealTool sharedXMDealTool].password = json[@"password"];
                
                //
                [self setUserAliasWithUserid:json[@"userid"]];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessNote object:nil];
                if (self.isModal) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }else{
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }else{
                [MBProgressHUD showError:json[@"message"]];
//                UIAlertView *alert5 = [[UIAlertView alloc] initWithTitle:@"提示" message:json[@"message"] delegate:nil cancelButtonTitle:@"重新登录" otherButtonTitles:nil, nil];
//                [alert5 show];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUD];
//            [MBProgressHUD ];
            XMLog(@"%@",error);
        }];
        //隐藏提示
//        [self removeNotice];
    }else{
        UIAlertView *alert6 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"输入格式不正确" delegate:nil cancelButtonTitle:@"重新输入" otherButtonTitles:nil, nil];
        [alert6 show];
    }
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



#pragma mark - 移除提示信息
//- (void)removeNotice
//{
//    [showNotice hideNoticeAnimated:NO];
//}
//刷新计时器
- (void)testTimerRun
{
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

// 用户点击返回按钮
//- (void)backButtonClick
//{
//    [self dismissViewControllerAnimated:YES completion:^{}];
//}

//显示隐藏密码
- (void)secureButtonClick{
    if (self.isagin) {
        secureFiled.secureTextEntry=YES;
        self.isagin=NO;
    }else{
       secureFiled.secureTextEntry=NO;
       self.isagin=YES;
    }
}

//登录密码按钮
- (void)secureButtonAction{
    
    if (self.isagin) {
        secureFiled1.secureTextEntry=YES;
        self.isagin=NO;
    }else{
        secureFiled1.secureTextEntry=NO;
        self.isagin=YES;
    }
}

//忘记密码
- (void)forgetAction{
    XMResetController *resetView=[[XMResetController alloc]init];
//    UINavigationController *resetNav=[[UINavigationController alloc]initWithRootViewController:resetView];
//    [resetNav setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
//    [resetNav.navigationBar setBarStyle:UIBarStyleBlack];
//    [self presentViewController:resetNav animated:YES completion:^{
//        
//    }];
 
    
    [self.navigationController pushViewController:resetView animated:YES];
}

#pragma mark - 文本框
- (UITextField *)loadTextFiledWithIcon:(NSString *)icon placeholder:(NSString *)placeholder
{
    UITextField* textField = [[UITextField alloc] init];
    textField.backgroundColor = [UIColor whiteColor];
    textField.layer.borderWidth = 1;
    textField.layer.cornerRadius = 5;
    textField.layer.borderColor = kBorderColor.CGColor;
//    textField.layer.borderColor = XMColor(236, 236, 236).CGColor;
    textField.placeholder = placeholder;
    [contentView addSubview:textField];
    textField.delegate = self;
    
    UIImageView *left = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 55*2/3.0, 55)];
    [left setImage:[UIImage resizedImage:icon]];
    left.contentMode = UIViewContentModeScaleAspectFit;
    textField.leftView = left;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    return textField;
}
//验证手机号和密码的格式
- (BOOL)verifyWithPhone:(NSString *)phone secure:(NSString *)secure{
    NSString *regex = @"^(13|15|17|18|14)[0-9]{9}$";
    NSPredicate *p = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![p evaluateWithObject:phone])
    {
        UIAlertView *alert7 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入11位手机号码" delegate:nil cancelButtonTitle:@"继续" otherButtonTitles:nil, nil];
        [alert7 show];
        return NO;
    }
    NSString *regex2 = @"^[0-9a-zA-Z]{6,15}$";
    NSPredicate *p2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
    if (![p2 evaluateWithObject:secure]) {
        UIAlertView *alert8 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入6~15位由数字和字母组成的密码" delegate:nil cancelButtonTitle:@"继续" otherButtonTitles:nil, nil];
        [alert8 show];
        return NO;
    }
    return YES;
}

- (void)saveUseridAndPassword
{
    NSString *phone = @"";
    if (phoneNumber) {
        phone = phoneNumber.text;
    }else{
        phone = phoneNumber1.text;
    }
    NSString *userid = [XMDealTool sharedXMDealTool].userid;
    NSString *password = [XMDealTool sharedXMDealTool].password;
    
    [[NSUserDefaults standardUserDefaults] setObject:phone forKey:@"phone"];
    [[NSUserDefaults standardUserDefaults] setObject:userid forKey:@"userid"];
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"password"];
}

- (void)topView:(UITapGestureRecognizer *)tap
{
    [self resignResponder];
}

#pragma mark -
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^{
        if (textField.tag > 1 && textField.tag<3) {
            contentView.contentOffset = CGPointMake(0, secureFiled1.top-phoneNumber1.top);
        }else if(textField.tag>3 && textField.tag<5){
            
            contentView.contentOffset=CGPointMake(0, numberTextFiled.top-phoneNumber.top);
            
        }else if (textField.tag>5){
        
            contentView.contentOffset=CGPointMake(0, secureFiled.top-phoneNumber.top);
        }
        
    }];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^{
        if (textField.tag > 1) {
            contentView.contentOffset = CGPointMake(0, 0);
        }
    }];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [self resignResponder];
    //
    [MBProgressHUD hideHUD];
    
    [super viewWillDisappear:animated];
}

#pragma mark - 取消第一响应者
- (void)resignResponder
{
    //
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder)
                                               to:nil
                                             from:nil
                                         forEvent:nil];
}

- (void)backToLastController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
