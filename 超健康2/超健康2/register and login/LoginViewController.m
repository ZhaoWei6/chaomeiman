//
//  LoginViewController.m
//  Chaomeiman 专家端
//
//  Created by imac on 14-12-10.
//  Copyright (c) 2014年 imac. All rights reserved.
//

#import "LoginViewController.h"
#import "ForgetViewController.h"
#import "MainViewController.h"
#import "RegiesterViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"

#import "MobClick.h"
@interface LoginViewController ()
//-------------------写入SQL---------------------
@property (strong, nonatomic) IBOutlet UITextField *password;
//-------------------写入SQL---------------------
- (IBAction)forgetPassword:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *RadioButton;
- (IBAction)changeButton:(id)sender;

//登录
- (IBAction)login:(id)sender;

////注册
//- (IBAction)regist:(id)sender;


@end

@implementation LoginViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"self.view"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"self.view"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _userID.delegate=self;
    _password.delegate=self;
    [_userID becomeFirstResponder];
    _userID.keyboardType=UIKeyboardTypeNumberPad;
    //self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"backGroundColor"]];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_userID resignFirstResponder];
    [_password resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField==_userID) {
        [_userID resignFirstResponder];
        [_password becomeFirstResponder];
    }else
    {
        [_password resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField==_password) {
        //键盘遮住了文本字段，视图整体上移
        CGRect frame = self.view.frame;
        frame.origin.y -=120;
        frame.size.height +=120;
        
        [UIView beginAnimations:@"111" context:nil];
        [UIView setAnimationDuration:0.5];
        self.view.frame = frame;
        [UIView commitAnimations];
    }
}


-(void)textFieldDidEndEditing:(UITextField *)textField{
    [_userID resignFirstResponder];
    if (textField==_password) {
        [_password resignFirstResponder];
        CGRect frame = self.view.frame;
        frame.origin.y +=120;
        frame.size.height -=120;
        [UIView beginAnimations:@"111" context:nil];
        [UIView setAnimationDuration:0.5];
        self.view.frame = frame;
        [UIView commitAnimations];
    }
}

- (IBAction)login:(id)sender {
    
    if ([_userID.text length]==0) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"友情提示" message:@"您没有输入账号,请重新输入账号：" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if ([_password.text length]==0) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"友情提示" message:@"您没有输入密码,请重新输入密码：" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    [MobClick event:@"clickevent" label:_userID.text];
     //登录服务器
    [[LoginUser sharedLoginUser]loadurl:GetVerification(@"client", @"expertLogin") with:@{@"act":_userID.text,@"pwd":[self getSha1String:_password.text]}  BlockWithSuccess:^(NSDictionary * mes) {
        if ([[mes valueForKey:@"success_code"] integerValue]==200){
            NSString *data=[mes objectForKey:@"success_message"];
            MyLog(@"%@----data",data);
            //isLogin 存储 kXmppUserName kXmppPassword
            [[NSUserDefaults standardUserDefaults] setObject:self.userID.text forKey:@"isLogin"];
            
            //存取用户姓名
            [[NSUserDefaults standardUserDefaults]setObject:[[mes objectForKey:@"success_message"]objectForKey:@"expert_name"]forKey:kPersonHeadName];
            //存取用户年龄
            [[NSUserDefaults standardUserDefaults]setObject:[[mes objectForKey:@"success_message"]objectForKey:@"expert_age"]forKey:kPersonAge];
            //存取用户性别
            [[NSUserDefaults standardUserDefaults]setObject:[[mes objectForKey:@"success_message"]objectForKey:@"expert_gender"]forKey:kPersonGender];
            //存取图片
            [[NSUserDefaults standardUserDefaults]setObject:[[mes objectForKey:@"success_message"]objectForKey:@"expert_picture"]forKey:kPersonHeadImage];
            //存取专家语录
            [[NSUserDefaults standardUserDefaults]setObject:[[mes objectForKey:@"success_message"]objectForKey:@"expert_motto"]forKey:kPersonLanguage];
            //存取专家e_id
            [[NSUserDefaults standardUserDefaults]setObject:[[mes objectForKey:@"success_message"]objectForKey:@"id"]forKey:E_id];
            
            [[LoginUser sharedLoginUser] setUserName:self.userID.text];
            [[LoginUser sharedLoginUser] setPassword:[self getSha1String:self.password.text]];
            
            //-------------造AppDelegate对象,连接openfire服务器----------------------
            AppDelegate *applegate=xmppDelegate;
            [applegate connectWithCompletion:nil failed:^{
                MyLog(@"连接openfire服务器");
            }];
            //-----------------------------进入主函数--------------------------------
            MainViewController *main=[[MainViewController alloc]init];
            [self presentViewController:main animated:YES completion:nil];
        }else{
            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"提示" message:@"您的账号或者密码错误！请从新登录。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            
            self.userID.text=@"";
            self.password.text=@"";
            return;
        }
    } Failure:^(NSError *mes) {
        MyLog(@"%@error",mes);
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

//- (IBAction)regist:(id)sender {
//    RegiesterViewController *regist=[[RegiesterViewController alloc]init];
//    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:regist];
//    [self presentViewController:nav animated:YES completion:nil];
//}

- (IBAction)changeButton:(id)sender {
    _RadioButton.selected=!_RadioButton.selected;
    if (_RadioButton.selected) {
        [_RadioButton setImage:[UIImage imageNamed:@"RadioButton-Unselected"] forState:UIControlStateSelected];
        //选中密码
        [[NSUserDefaults standardUserDefaults] setBool:_RadioButton.selected forKey:@"rememberPassword"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }else{
        [_RadioButton setImage:[UIImage imageNamed:@"RadioButton-Selected"] forState:UIControlStateNormal];
    }
}

- (IBAction)forgetPassword:(id)sender {
    ForgetViewController *forget=[[ForgetViewController alloc]init];
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:forget];
    [self presentViewController:nav animated:YES completion:nil];
}

@end
