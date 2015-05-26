//
//  ForgetViewController.m
//  Chaomeiman 专家端
//
//  Created by imac on 14-12-10.
//  Copyright (c) 2014年 imac. All rights reserved.
//

#import "ForgetViewController.h"
#import "ProtocalViewController.h"
#import "AFNetworking.h"
#import <CommonCrypto/CommonDigest.h>
@interface ForgetViewController ()<UITextFieldDelegate>{
    int time;
    NSTimer *testTimer;
}

@property (strong, nonatomic) IBOutlet UITextField *verifyPassword;
@property (strong, nonatomic) IBOutlet UITextField *passWord;
@property (strong, nonatomic) IBOutlet UITextField *verify;
@property (strong, nonatomic) IBOutlet UITextField *telephone;
- (IBAction)sendPassword:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *verifyButton;

@property (strong, nonatomic) IBOutlet UIButton *RadioButton;
- (IBAction)changeButton:(id)sender;

//用户协议
- (IBAction)protocal:(id)sender;


- (IBAction)findPassword:(id)sender;

@end

@implementation ForgetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航栏背景"] forBarMetrics:UIBarMetricsDefault];
    }
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"backGroundColor"]];
    
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"goBack.png"] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0, 0, 40, 40)];
    [button addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *bar=[[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem=bar;
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth/2, 40)];
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont boldSystemFontOfSize:25];
    label.textColor=[UIColor whiteColor];
    label.text=@"找回密码";
    self.navigationItem.titleView=label;
    
    time=60;
    [_verifyButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_verifyButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_verifyButton setTitle:[NSString stringWithFormat:@"重新获取%i",time] forState:UIControlStateDisabled];
    _verifyButton.layer.cornerRadius = 5;
    
    _telephone.delegate=self;
    _telephone.keyboardType=UIKeyboardTypeNumberPad;
    _verify.delegate=self;
    _verifyPassword.delegate=self;
    _passWord.delegate=self;
    [_telephone becomeFirstResponder];
}

-(void)dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)sendPassword:(id)sender {
    if ([_telephone.text length]!=11) {
        return;
    }
    _verifyButton.enabled = NO;
    testTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(testTimerRun) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:testTimer forMode:NSDefaultRunLoopMode];
    
#pragma mark  -----------AFHTTPRequest网络请求数据----------
    [[LoginUser sharedLoginUser]loadurl:GetVerification(@"client", @"getExpertVerificationCode") with:@{@"phone":_telephone.text} BlockWithSuccess:^(NSDictionary *responseObject) {
        if ([[responseObject valueForKey:@"success_code"] integerValue]==100){
            NSString *data=[responseObject objectForKey:@"success_message"];
            MyLog(@"%@----data",data);
        }
    } Failure:^(NSError *mes) {
        MyLog(@"%@error",mes);
    }];
    
}
////刷新计时器
- (void)testTimerRun
{
    if (--time) {
        [_verifyButton setTitle:[NSString stringWithFormat:@"重新获取%i",time] forState:UIControlStateDisabled];
    }else{
        time = 60;
        _verifyButton.enabled = YES;
        [_verifyButton setTitle:[NSString stringWithFormat:@"重新获取%i",time] forState:UIControlStateDisabled];
        [testTimer invalidate];
        testTimer = nil;
    }
}

//－－－－－－－－－－－－协议上传到服务器－－－－－－－－
- (IBAction)protocal:(id)sender {
    ProtocalViewController *proctocal=[[ProtocalViewController alloc]init];
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:proctocal];
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)findPassword:(id)sender {
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:_telephone.text];
    if (!isMatch) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"友情提示" message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if ([_telephone.text length]==0) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"友情提示" message:@"您没有输入账号,请重新输入手机号：" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if ([_telephone.text length]!=11) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"友情提示" message:@"请重新输入正确手机号：" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        _telephone.text=@"";
        return;
    }
    
    if ([_verify.text length]==0) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"友情提示" message:@"您没有输入验证码,请重新输入验证码：" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        _verify.text=@"";
        return;
    }
    if ([_verify.text length]==0) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"友情提示" message:@"您没有输入验证码,请重新输入验证码：" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        _verify.text=@"";
        return;
    }
    if ([_verify.text length]!=6) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"友情提示" message:@"请您输入六位的验证码,请重新输入验证码：" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        _passWord.text=@"";
        return;
    }
    if ([[_passWord text] length] < 6) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"友情提示" message:@"用户密码小于6位!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
        _passWord.text=@"";
    }
    
    if([_verifyPassword.text length]==0) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"友情提示" message:@"您没有输入确认密码,请重新确认密码：" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        _verifyPassword.text=@"";
        return;
    }
    
    if(![_verifyPassword.text isEqualToString:_passWord.text]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"友情提示" message:@"两次密码输入不一致，请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [_verifyPassword setText:@""];
    }
    if (_RadioButton.selected) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"友情提示" message:@"您没有接受了协议" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }

    NSLog(@"确定找回密码");
    
    [self dismissViewControllerAnimated:YES completion:^{
#pragma mark  -----------AFHTTPRequest网络请求数据----------
        //-------－－－－－－－AFN网络请求数据 验证密码-------------
        [[LoginUser sharedLoginUser]loadurl:GetVerification(@"client", @"findExpertPwd") with:@{@"phone":_telephone.text,@"pwd":[self getSha1String: _passWord.text],@"verification":_verify.text} BlockWithSuccess:^(NSDictionary *responseObject) {
            NSLog(@"------%@responseObject",responseObject);
            if ([responseObject[@"success_code"] intValue]==200) {
                NSString *data=[responseObject objectForKey:@"success_message"];
                MyLog(@"%@----data",data);
            }
        } Failure:^(NSError *mes) {
            MyLog(@"%@error",mes);
        }];
    }];
}

#pragma mark -- SHA1加密
- ( NSString *)getSha1String:( NSString *)srcString{
    
    const char *cstr = [srcString cStringUsingEncoding : NSUTF8StringEncoding ];
    NSData *data = [ NSData dataWithBytes :cstr length :srcString. length ];
    uint8_t digest[ CC_SHA1_DIGEST_LENGTH ];
    CC_SHA1 (data. bytes , data. length , digest);
    NSMutableString * result = [ NSMutableString stringWithCapacity : CC_SHA1_DIGEST_LENGTH * 2 ];
    for ( int i = 0 ; i < CC_SHA1_DIGEST_LENGTH ; i++) {
        [result appendFormat : @"%02x" , digest[i]];
    }
    return result;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_telephone resignFirstResponder];
    [_verify resignFirstResponder];
    [_passWord resignFirstResponder];
    [_verifyPassword resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField==_telephone) {
        [_telephone becomeFirstResponder];
        [_verify becomeFirstResponder];
    }else if(textField==_verify)
    {
        [_verify resignFirstResponder];
        [_passWord becomeFirstResponder];
    }else if (textField==_passWord){
        [_passWord resignFirstResponder];
        [_verifyPassword becomeFirstResponder];
    }else{
        [_verifyPassword resignFirstResponder];
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    [_telephone resignFirstResponder];
    [_verify resignFirstResponder];
    [_passWord resignFirstResponder];
    [_verifyPassword resignFirstResponder];
    if (textField==_verifyPassword) {
        [_verifyPassword resignFirstResponder];
        CGRect frame = self.view.frame;
        frame.origin.y +=130;
        frame.size.height -=130;
        [UIView beginAnimations:@"111" context:nil];
        [UIView setAnimationDuration:0.5];
        self.view.frame = frame;
        [UIView commitAnimations];
    }
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField==_verifyPassword) {
        //键盘遮住了文本字段，视图整体上移
        CGRect frame = self.view.frame;
        frame.origin.y -=130;
        frame.size.height +=130;
        
        [UIView beginAnimations:@"111" context:nil];
        [UIView setAnimationDuration:0.5];
        self.view.frame = frame;
        [UIView commitAnimations];
    }
}

- (IBAction)changeButton:(id)sender {
    _RadioButton.selected=!_RadioButton.selected;
    if (_RadioButton.selected) {
        [_RadioButton setImage:[UIImage imageNamed:@"RadioButton-Unselected"] forState:UIControlStateSelected];
        
    }else{
        [_RadioButton setImage:[UIImage imageNamed:@"RadioButton-Selected"] forState:UIControlStateNormal];
    }
}
@end
