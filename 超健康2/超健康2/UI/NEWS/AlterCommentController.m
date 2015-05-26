//
//  AlterCommentController.m
//  Chaomeiman 专家端
//
//  Created by imac on 14-12-12.
//  Copyright (c) 2014年 imac. All rights reserved.
//

#import "AlterCommentController.h"
@interface AlterCommentController ()<UITextFieldDelegate>{
    UITextField *name;
}

@end

@implementation AlterCommentController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=@"备注名称";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self addLeftButtonReturn:@selector(dismiss)];
    [self addRightButtonReturn:@"保存" with:@selector(rightDismiss)];
    
    name=[[UITextField alloc]initWithFrame:CGRectMake(20, 84, kDeviceWidth-40, kDeviceHeight/12)];
    name.borderStyle=UITextBorderStyleRoundedRect;
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
    [[LoginUser sharedLoginUser]setChangeName:name.text];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dismiss{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
