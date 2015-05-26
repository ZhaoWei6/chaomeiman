//
//  ChangeNameController.m
//  Chaomeiman 专家端
//
//  Created by imac on 14-12-15.
//  Copyright (c) 2014年 imac. All rights reserved.
//

#import "ChangeNameController.h"
#import "InformatiomViewController.h"
#import "AFNetworking.h"
@interface ChangeNameController ()<UITextFieldDelegate>{
    UITextField *name;
}

@end

@implementation ChangeNameController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=@"修改姓名";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航栏背景"] forBarMetrics:UIBarMetricsDefault];
    }
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self addLeftButtonReturn:@selector(dismiss)];
    [self addRightButtonReturn:@"保存" with:@selector(rightDismiss)];
    
    name=[[UITextField alloc]initWithFrame:CGRectMake(20, 90, kDeviceWidth-40, kDeviceHeight/12)];
    name.borderStyle=UITextBorderStyleRoundedRect;
    name.delegate=self;
    name.placeholder=@"请输入姓名:";
    [self.view addSubview:name];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [name resignFirstResponder];
}

-(void)rightDismiss{
    MyLog(@"------------------------------saveToSQL-----------------------");
    if ([self.delegate respondsToSelector:@selector(changeTitle:)]) {
        [self.delegate changeTitle:name.text];
    }
    
#pragma mark  -----------AFHTTPRequest网络请求数据----------
    //-------－－－－－－－AFN网络请求数据-------------
    [[LoginUser sharedLoginUser]loadurl:GetVerification(@"client", @"editExpertInfo") with:@{@"id":_ID,@"expert_name":name.text} BlockWithSuccess:^(id responseObject) {
        MyLog(@"------%@responseObject",responseObject);
        if ([responseObject[@"success_code"] intValue]==200) {
            NSString *data=[responseObject objectForKey:@"success_message"];
            MyLog(@"%@----data",data);
            //存取用户年龄
            [[NSUserDefaults standardUserDefaults]setObject:name.text forKey:kPersonHeadName];
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
