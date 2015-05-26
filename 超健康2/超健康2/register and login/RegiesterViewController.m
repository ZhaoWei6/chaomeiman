//
//  RegiesterViewController.m
//  Chaomeiman 专家端
//
//  Created by imac on 14-12-11.
//  Copyright (c) 2014年 imac. All rights reserved.
//

#import "RegiesterViewController.h"
#import "ProtocalViewController.h"
@interface RegiesterViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
//---------------SQL--------------
@property (strong, nonatomic) IBOutlet UITextField *telePhone;
@property (strong, nonatomic) IBOutlet UITextField *currentSure;
@property (strong, nonatomic) IBOutlet UITextField *passWord;
@property (strong, nonatomic) IBOutlet UITextField *ensurePassword;
//---------------SQL--------------
@property (strong, nonatomic) IBOutlet UIButton *RadioButton;
- (IBAction)changeButton:(id)sender;
//用户协议
- (IBAction)protocal:(id)sender;

//确认注册
- (IBAction)ensureRegister:(id)sender;

@end

@implementation RegiesterViewController

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
    
    [self addLeftButtonReturn:@selector(dismiss)];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth/2, 40)];
    label.textColor=[UIColor blackColor];
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont boldSystemFontOfSize:25];
    label.text=@"找回密码";
    self.navigationItem.titleView=label;
    
    _telePhone.delegate=self;
    _ensurePassword.delegate=self;
    _currentSure.delegate=self;
    _passWord.delegate=self;
    [_telePhone becomeFirstResponder];
}

-(void)dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//单选按钮
- (IBAction)changeButton:(id)sender {
    _RadioButton.selected=!_RadioButton.selected;
    if (_RadioButton.selected) {
        [_RadioButton setImage:[UIImage imageNamed:@"RadioButton-Unselected"] forState:UIControlStateSelected];
        
    }else{
        [_RadioButton setImage:[UIImage imageNamed:@"RadioButton-Selected"] forState:UIControlStateNormal];
    }
}

//协议
- (IBAction)protocal:(id)sender {
    ProtocalViewController *proctocal=[[ProtocalViewController alloc]init];
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:proctocal];
    [self presentViewController:nav animated:YES completion:nil];
}

//确认注册
- (IBAction)ensureRegister:(id)sender {
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:_telePhone.text];
    if (!isMatch) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"友情提示" message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if ([_telePhone.text length]==0) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"友情提示" message:@"您没有输入账号,请重新输入手机号：" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if ([_telePhone.text length]!=11) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"友情提示" message:@"请重新输入正确手机号：" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        _telePhone.text=@"";
        return;
    }
    
    if ([_currentSure.text length]==0) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"友情提示" message:@"您没有输入验证码,请重新输入验证码：" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        _currentSure.text=@"";
        return;
    }
    if ([_passWord.text length]==0) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"友情提示" message:@"您没有输入密码,请重新输入密码：" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
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

    if([_ensurePassword.text length]==0) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"友情提示" message:@"您没有输入确认密码,请重新确认密码：" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        _ensurePassword.text=@"";
        return;
    }

    if(![_ensurePassword.text isEqualToString:_passWord.text]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"友情提示" message:@"两次密码输入不一致，请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [_ensurePassword setText:@""];
    }
    if (_RadioButton.selected) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"友情提示" message:@"您没有接受了协议" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    MyLog(@"确定注册");
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_telePhone resignFirstResponder];
    [_currentSure resignFirstResponder];
    [_passWord resignFirstResponder];
    [_ensurePassword resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField==_telePhone) {
        [_telePhone becomeFirstResponder];
        [_currentSure becomeFirstResponder];
    }else if(textField==_currentSure)
    {
        [_currentSure resignFirstResponder];
        [_passWord becomeFirstResponder];
    }else if (textField==_passWord){
        [_passWord resignFirstResponder];
        [_ensurePassword becomeFirstResponder];
    }else{
        [_ensurePassword resignFirstResponder];
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [_telePhone resignFirstResponder];
    [_currentSure resignFirstResponder];
    [_passWord resignFirstResponder];
    [_ensurePassword resignFirstResponder];
    
}
@end
