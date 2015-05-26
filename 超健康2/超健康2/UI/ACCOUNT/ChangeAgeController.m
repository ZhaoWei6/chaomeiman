//
//  ChangeAgeController.m
//  Chaomeiman 专家端
//
//  Created by imac on 15-1-9.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "ChangeAgeController.h"
#import "InformatiomViewController.h"
#import "AFNetworking.h"
@interface ChangeAgeController ()<UITextFieldDelegate>{
UITextField *age;
}

@end

@implementation ChangeAgeController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=@"修改年龄";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航栏背景"] forBarMetrics:UIBarMetricsDefault];
    }
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self addLeftButtonReturn:@selector(dismiss)];
    [self addRightButtonReturn:@"保存" with:@selector(rightDismiss)];
    
    //    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 85, 40)];
    //    view.backgroundColor=[UIColor colorWithWhite:0.9 alpha:0.9];
    //    view.layer.cornerRadius=5;
    //    //边框宽度
    //    view.layer.borderWidth = 1.0;
    //    //边框颜色
    //    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    ////    //把字变红
    ////    NSString *sumStr = [NSString stringWithFormat:@"总价￥"];
    ////    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:sumStr];
    ////    //取出需要改颜色的range
    ////    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(2, sumStr.length-2)];
    ////    dynamicTitle.attributedText = attr;
    
    age=[[UITextField alloc]initWithFrame:CGRectMake(20, 90, kDeviceWidth-40, kDeviceHeight/12)];
    age.borderStyle=UITextBorderStyleRoundedRect;
    age.delegate=self;
    age.placeholder=@"请输入年龄:";
    [self.view addSubview:age];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [age resignFirstResponder];
}

-(void)rightDismiss{
    MyLog(@"------------------------------saveToSQL-----------------------");
    if ([self.delegate respondsToSelector:@selector(changeAge:)]) {
        [self.delegate changeAge:age.text];
    }
    
#pragma mark  -----------AFHTTPRequest网络请求数据----------
    //-------－－－－－－－AFN网络请求数据-------------
    [[LoginUser sharedLoginUser]loadurl:GetVerification(@"client", @"editExpertInfo") with:@{@"id":_ID,@"expert_age":age.text} BlockWithSuccess:^(id responseObject) {
        MyLog(@"------%@responseObject",responseObject);
        if ([responseObject[@"success_code"] intValue]==200) {
            NSString *data=[responseObject objectForKey:@"success_message"];
            MyLog(@"%@----data",data);
            //存取用户年龄
            [[NSUserDefaults standardUserDefaults]setObject:age.text forKey:kPersonAge];
        }
    } Failure:^(NSError *mes) {
        MyLog(@"%@error",mes);
    }];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dismiss{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
