//
//  XMResetController.m
//  XiuShemMa
//
//  Created by Apple on 14/10/22.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMResetController.h"
#import "XMContactsTool.h"
#import "XMHttpTool.h"
#import "XMDealTool.h"
#import "APService.h"
#define TextFiledHeight 44
@interface XMResetController ()<UITextFieldDelegate>{
//手机号码输入框
    UITextField  *phoneNumber;
    
//    新密码输入框
    UITextField  *secureFiled;
//    验证码
    UITextField *numberTextFiled;
//    获取验证码
    UIButton *verifyButton;
    UIScrollView  *contentView;
    
     int time;//用于记录按钮上显示的秒数
     NSTimer *testTimer;//用于刷新按钮上显示的数字
    NSString *verifyString;//验证码

}

#define NUMBERS @"0123456789\n"


// 密码是否隐藏
@property(nonatomic,assign)BOOL isagin;

@end

@implementation XMResetController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"重置密码";
    self.view.backgroundColor = XMGlobalBg;
     kNAVITAIONBACKBUTTON
    kRectEdge
//    [self dismissMessage];
    
    contentView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    
    contentView.contentSize=CGSizeMake(kDeviceWidth, kDeviceHeight+2);
    contentView.backgroundColor=XMGlobalBg;
    contentView.showsVerticalScrollIndicator=NO;
    
    [self.view addSubview:contentView];

    
    //    取消第一响应者
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topView:)];
    [self.view addGestureRecognizer:tap];

    
    [self loadSubView];
   
}

-(void)loadSubView{
    phoneNumber = [self loadTextFiledWithIcon:@"icon_phone" placeholder:@"填写手机号"];
    phoneNumber.frame = CGRectMake(10, 10+64, self.view.width-20, TextFiledHeight);
//    phoneNumber = [[XMTextField alloc] initWithFrame:CGRectMake(10, 10+64, self.view.width-20, 40)];
//    phoneNumber.placeholder = @"填写手机号";
    [contentView addSubview:phoneNumber];
//    phoneNumber.delegate = self;
    phoneNumber.keyboardType = UIKeyboardTypeNumberPad;

    
    UIView  *secureView=[[UIView alloc]initWithFrame:CGRectMake(phoneNumber.left, phoneNumber.bottom+15, phoneNumber.width, 40)];
    secureView.backgroundColor=[UIColor clearColor];
    [contentView addSubview:secureView];
    
    secureFiled = [self loadTextFiledWithIcon:@"password" placeholder:@"输入新密码"];
    secureFiled.frame = CGRectMake(0, 0, phoneNumber.width, TextFiledHeight);
    secureFiled.tag=2;
    secureFiled.secureTextEntry=YES;
    [secureView addSubview:secureFiled];
    
    
    UIButton  *secure=[UIButton buttonWithType:UIButtonTypeCustom];
    secure.backgroundColor=[UIColor  clearColor];
    secure.imageView.contentMode=UIViewContentModeScaleAspectFit;
//    secure.frame=CGRectMake(secureView.width-35, 20-15, 30, 30);
    secure.frame=CGRectMake(0, 0, secureFiled.height, secureFiled.height/2);
    [secure setImage:[UIImage resizedImage:@"icon_password_eye"] forState:UIControlStateNormal];
    [secure addTarget:self action:@selector(secureButtonClick) forControlEvents:UIControlEventTouchDown|UIControlEventTouchUpOutside|UIControlEventTouchUpInside];
    secureFiled.rightView=secure;
    secureFiled.rightViewMode=UITextFieldViewModeAlways;
    [secureView  addSubview:secure];
    
    //验证码
    numberTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(secureView.left, secureView.bottom+15, phoneNumber.width-100, TextFiledHeight)];
    numberTextFiled.backgroundColor = [UIColor whiteColor];
    numberTextFiled.layer.borderWidth = 1;
    numberTextFiled.layer.cornerRadius = 5;
    numberTextFiled.layer.borderColor = kBorderColor.CGColor;
//    numberTextFiled.layer.borderColor = XMColor(236, 236, 236).CGColor;
    numberTextFiled.placeholder = @"验证码";
    numberTextFiled.delegate = self;
    numberTextFiled.tag=5;
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
    verifyButton.frame = CGRectMake(numberTextFiled.right+10, numberTextFiled.top+1, 90, phoneNumber.height-2);
    verifyButton.backgroundColor = XMButtonBg;
    verifyButton.layer.cornerRadius = 5;
    verifyButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [verifyButton addTarget:self action:@selector(verifyButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:verifyButton];

    
    UIButton *login = [UIButton buttonWithType:UIButtonTypeCustom];
    login.backgroundColor = [UIColor darkGrayColor];
    login.frame = CGRectMake(numberTextFiled.left, numberTextFiled.bottom+80, phoneNumber.width, kUILoginHeight);
    [login setTitle:@"确定重置" forState:UIControlStateNormal];
    [login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    login.backgroundColor = XMButtonBg;
    login.layer.cornerRadius = 5;
    [login addTarget:self action:@selector(loginButtonClick1:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:login];
}


#pragma mark UITextFiled的Delegate方法
/*   //判断输入的是否为数字
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
            UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"请输入数字"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            
              [alert1 show];
            phoneNumber.enabled = NO;
          
            return NO;
        }
    }
    //其他的类型不需要检测，直接写入
    return YES;
}*/


-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    [secureFiled resignFirstResponder];
    
    return YES;

}

//验证手机号和密码的格式
- (BOOL)verifyWithPhone:(NSString *)phone secure:(NSString *)secure{
    NSString *regex = @"^(13|15|17|18|14)[0-9]{9}$";
    NSPredicate *p = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![p evaluateWithObject:phone]) {
        UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入11位手机号码" delegate:nil cancelButtonTitle:@"继续" otherButtonTitles:nil, nil];
        [alert2 show];
        return NO;
    }
    NSString *regex2 = @"^[0-9a-zA-Z]{6,15}$";
    NSPredicate *p2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
    if (![p2 evaluateWithObject:secure]) {
        UIAlertView *alert3 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入6~15位由数字或字母组成的密码" delegate:nil cancelButtonTitle:@"继续" otherButtonTitles:nil, nil];
        [alert3 show];
        return NO;
    }
    return YES;
}


#pragma mark - 点击事件(获取验证码)
- (void)verifyButtonClick
{
    verifyButton.userInteractionEnabled = NO;
    [phoneNumber resignFirstResponder];
    
    NSString *regex = @"^(13|15|17|18|14)[0-9]{9}$";
    NSPredicate *p = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![p evaluateWithObject:phoneNumber.text]) {
        
        verifyButton.userInteractionEnabled = YES;
        UIAlertView *alert4 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入11位手机号码" delegate:nil cancelButtonTitle:@"继续" otherButtonTitles:nil, nil];
        [alert4 show];
    }
    
    else{
//        if ([numberTextFiled.text isEqualToString:@""]){
//            
//            UIAlertView *alert5 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入6~15位由数字或字母组成的密码" delegate:nil cancelButtonTitle:@"继续" otherButtonTitles:nil, nil];
//            [alert5 show];
//        }
//        else{
            NSString  *mobile=phoneNumber.text;
            NSDictionary  *parms=@{@"mobile":mobile};
//            verifyButton.enabled = NO;
//            testTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(testTimerRun) userInfo:nil repeats:YES];
//            [[NSRunLoop mainRunLoop] addTimer:testTimer forMode:NSDefaultRunLoopMode];
            [numberTextFiled becomeFirstResponder];
            
            [XMHttpTool  postWithURL:@"Verifycode/getForgotVerifyCode" params:parms success:^(id json) {
                
                verifyButton.userInteractionEnabled = YES;
                
                if ([json[@"status"] intValue] == 1) {
                    
                    verifyButton.enabled = NO;
                    testTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(testTimerRun) userInfo:nil repeats:YES];
                    [[NSRunLoop mainRunLoop] addTimer:testTimer forMode:NSDefaultRunLoopMode];
                    
                    [XMDealTool  sharedXMDealTool].userid=json[@"userid"];
                }
                else{
                    UIAlertView *alert5 = [[UIAlertView alloc] initWithTitle:@"提示" message:json[@"message"] delegate:nil cancelButtonTitle:@"重新登录" otherButtonTitles:nil, nil];
                    [alert5 show];
                    
                }
                
            } failure:^(NSError *error) {
                
                verifyButton.userInteractionEnabled = YES;
                
                XMLog(@"%@",error);
                
            }];
//        }
        
    }
    
}


//重置密码
- (void)loginButtonClick1:(UIButton *)sender
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder)
                                               to:nil
                                             from:nil
                                         forEvent:nil];
    
    NSString *message = @"";
    
    sender.enabled = NO;
    
    if ([numberTextFiled.text isEqualToString:@""]) {
        message = @"请输入验证码";
    }
    else{
        if ([self verifyWithPhone:phoneNumber.text secure:secureFiled.text]){
            
            NSString  *mobile=phoneNumber.text;
            NSString  *password=secureFiled.text;
            NSString   *verify=numberTextFiled.text;
            NSDictionary  *dict=@{@"mobile":mobile,@"password":password,@"verify":verify};
            
            [MBProgressHUD showMessage:@"请稍后..."];
            
            [XMHttpTool postWithURL:@"register/reset" params:dict success:^(id json) {
                [MBProgressHUD hideHUD];
                sender.enabled = YES;
                if ([json[@"status"] intValue]==1) {
                    XMLog(@"json-------->%@",json);
//                    [XMContactsTool sharedXMContactsTool].userid=dict[@"userid"];
//                    [XMContactsTool sharedXMContactsTool].password=dict[@"password"];
                    [XMDealTool sharedXMDealTool].userid = json[@"userid"];
                    [XMDealTool sharedXMDealTool].password = json[@"password"];
                    
                    [self setUserAliasWithUserid:json[@"userid"]];
                    
                    flag = YES;
                    phone_Number = phoneNumber.text;
                    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessNote object:nil];
//                    [self dismissViewControllerAnimated:YES completion:^{}];
                  
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    
                }
                
                else{
                    
                    NSString *str = json[@"message"];
                    XMLog(@"-------------%@",str);
                    UIAlertView *alert6 = [[UIAlertView alloc] initWithTitle:@"提示" message:json[@"message"] delegate:nil cancelButtonTitle:@"重新登录" otherButtonTitles:nil, nil];
                    [alert6 show];
                    
                }
            } failure:^(NSError *error) {
                sender.enabled = YES;
                
                [MBProgressHUD showError:@"网络不给力！"];
                XMLog(@"%@",error);
                
            }];
        }
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
- (void)saveUseridAndPassword
{
    NSString *phone = @"";
    if (phoneNumber) {
        phone = phoneNumber.text;
    }
    NSString *userid = [XMDealTool sharedXMDealTool].userid;
    NSString *password = [XMDealTool sharedXMDealTool].password;
    
    [[NSUserDefaults standardUserDefaults] setObject:phone forKey:@"phone"];
    [[NSUserDefaults standardUserDefaults] setObject:userid forKey:@"userid"];
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"password"];
}

#pragma mark - 提示框delegate方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    phoneNumber.enabled = YES;
    
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
    
    UIImageView *left = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, TextFiledHeight*2/3.0, TextFiledHeight)];
    [left setImage:[UIImage resizedImage:icon]];
    left.contentMode = UIViewContentModeScaleAspectFit;
    textField.leftView = left;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    return textField;

}
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
//密码按钮

-(void)secureButtonClick{
    
    
    if (self.isagin) {
        secureFiled.secureTextEntry=YES;
        self.isagin=NO;
    }else{
        secureFiled.secureTextEntry=NO;
        self.isagin=YES;
    }
    
    
    
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
            contentView.contentOffset = CGPointMake(0, phoneNumber.top-secureFiled.top);
        }else if(textField.tag>3 ){
            
            contentView.contentOffset=CGPointMake(0, numberTextFiled.top-phoneNumber.top);
            
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



- (void)topView:(UITapGestureRecognizer *)tap
{
//    [phoneNumber resignFirstResponder];
//    [numberTextFiled resignFirstResponder];
//    [secureFiled resignFirstResponder];
    
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder)
                                               to:nil
                                             from:nil
                                         forEvent:nil];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
