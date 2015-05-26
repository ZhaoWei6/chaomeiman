//
//  XMAddUserMessageViewController.m
//  XSM_XS
//
//  Created by Apple on 14/12/8.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMAddUserMessageViewController.h"

@interface XMAddUserMessageViewController ()
{
    NSString *sex;
}

@property (strong, nonatomic) IBOutlet UITextField *userName;
@property (strong, nonatomic) IBOutlet UIButton *sexMan;
@property (strong, nonatomic) IBOutlet UIButton *sexWoman;
@property (strong, nonatomic) IBOutlet UITextField *userIDCard;
@property (strong, nonatomic) IBOutlet UITextField *age;

- (IBAction)actionSetSex:(UIButton *)sender;


@end

@implementation XMAddUserMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"补全身份信息";
    //
    [self initNavigationItem];
    //
    [self setSubViews];
    //
    [self actionSetSex:self.sexMan];
}

- (void)initNavigationItem
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(cancle)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
}

- (void)setSubViews
{
    [self setTextFiled:self.userName icon:@"icon_contact" placeholder:@"填写姓名"];
    [self setTextFiled:self.userIDCard icon:@"icon_contact" placeholder:@"填写身份证号"];
    [self setTextFiled:self.age icon:@"icon_detailaddress" placeholder:@"  年"];
    
    self.age.keyboardType = UIKeyboardTypeNumberPad;
    
    [self.sexMan setImage:[UIImage imageNamed:@"icon_circle"] forState:UIControlStateNormal];
    [self.sexMan setImage:[UIImage imageNamed:@"icon_chooce"] forState:UIControlStateDisabled];
    
    [self.sexWoman setImage:[UIImage imageNamed:@"icon_circle"] forState:UIControlStateNormal];
    [self.sexWoman setImage:[UIImage imageNamed:@"icon_chooce"] forState:UIControlStateDisabled];
}

- (IBAction)actionSetSex:(UIButton *)sender {
    self.sexMan.enabled = self.sexMan.tag != sender.tag;
    self.sexWoman.enabled = self.sexWoman.tag != sender.tag;
    sex = [NSString stringWithFormat:@"%i",sender.tag];
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
    
    UIImageView *left = [[UIImageView alloc] initWithFrame:CGRectMake(0, textField.height/4.0, textField.height/2.0+10, textField.height/2.0)];
    [left setImage:[UIImage imageNamed:icon]];
    left.contentMode = UIViewContentModeScaleAspectFit;
    textField.leftView = left;
    textField.leftViewMode = UITextFieldViewModeAlways;
}
#pragma mark - 导航
- (void)cancle
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)save
{
    NSString *userid = [XMDealTool sharedXMDealTool].userid;
    NSString *password = [XMDealTool sharedXMDealTool].password;
    NSString *nickName = self.userName.text;
    NSMutableDictionary *params  = [NSMutableDictionary dictionary];
    [params setObject:userid forKey:@"userid"];
    [params setObject:nickName forKey:@"nickname"];
    [params setObject:sex forKey:@"sex"];
    [params setObject:self.age.text forKey:@"maintainage"];
    [params setObject:self.userIDCard.text forKey:@"cid"];
    [params setObject:password forKey:@"password"];
    XMLog(@"%@ params = %@",nickName,params);
    [XMHttpTool postWithURL:@"Maintainer/approve" params:params success:^(id json) {
        XMLog(@"%@",json);
        if ([json[@"status"] integerValue] == 1) {
            XMLog(@"保存成功");
            [XMDealTool sharedXMDealTool].approve = @"4";
            [UserDefaults setObject:@"4" forKey:@"approve"];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } failure:^(NSError *error) {
        XMLog(@"%@",error);
    }];
}
- (IBAction)View_TouchDown:(id)sender {
    // 发送resignFirstResponder.
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder)
                                               to:nil
                                             from:nil
                                         forEvent:nil];
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
