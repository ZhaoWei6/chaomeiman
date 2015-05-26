//
//  feedback ViewController.m
//  Chaomeiman 专家端
//
//  Created by imac on 14-12-15.
//  Copyright (c) 2014年 imac. All rights reserved.
//

#import "FeedbackViewController.h"
#import "AFNetworking.h"
@interface FeedbackViewController ()<UITextViewDelegate>{
    UITextView *text;
}

@end

@implementation FeedbackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=@"反馈";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self addLeftButtonReturn:@selector(dismiss)];
    
    UIView  *view=[[UIView alloc]initWithFrame:CGRectMake(5, 70, kDeviceWidth-10, kDeviceHeight/2-50)];
    view.layer.cornerRadius=4;
    view.layer.borderWidth=1;
    view.layer.borderColor=[UIColor lightGrayColor].CGColor;
    [self.view addSubview:view];
    
    text=[[UITextView alloc]initWithFrame:CGRectMake(10, 75, kDeviceWidth-20, kDeviceHeight/2-110)];
    text.text=@"请输入您对本产品的意见，我们会及时改正缺点，争取做的更好！";
    text.delegate=self;
    text.autoresizingMask=UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:text];
    
    [self addViewInButtonInHigh:@"feedBack" HighLight:@"feedBackSelect" rect:CGRectMake(text.left, text.bottom+80, kDeviceWidth-((text.left)*2), 50) with:@selector(surePublic)];
    
}

-(void)dismiss{
    [self.navigationController popViewControllerAnimated:YES];
}

//取消第一响应
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text1 {
    if ([text1 isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    textView.text=@"";
}

//--------------------SQL,后台---------------------
//确认反馈
-(void)surePublic{
    NSUserDefaults *users=[NSUserDefaults standardUserDefaults];
    [users setObject:text.text forKey:kFeedBack];
    [users synchronize];
    
    MyLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:kFeedBack]);
    MyLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:E_id]);
    
    //-------－－－－－－－AFN网络请求数据-------------
    [[LoginUser sharedLoginUser]loadurl:GetVerification(@"client", @"setComplaint") with:@{@"complaint_info":text.text,@"e_id":[[NSUserDefaults standardUserDefaults]objectForKey:E_id]} BlockWithSuccess:^(id responseObject) {
        MyLog(@"------%@responseObject",responseObject);
        if ([responseObject[@"success_code"] intValue]==200) {
            NSString *data=[responseObject objectForKey:@"success_message"];
            MyLog(@"%@----data",data);
        }
    } Failure:^(NSError *mes) {
        MyLog(@"%@error",mes);
    }];

    [self.navigationController popViewControllerAnimated:YES];
}

@end
