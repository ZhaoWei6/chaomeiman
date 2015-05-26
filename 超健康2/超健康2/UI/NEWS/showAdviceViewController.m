//
//  showAdviceViewController.m
//  Chaomeiman 专家端
//
//  Created by imac on 14-12-12.
//  Copyright (c) 2014年 imac. All rights reserved.
//

#import "showAdviceViewController.h"
#import "AdviceViewController.h"
#import "AFNetworking.h"

@interface showAdviceViewController ()<UITextViewDelegate>{
    UITextView *text;
    NSMutableArray *array;
    bool flag;
}

@end

@implementation showAdviceViewController

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
    array=[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:kText]];
    if (array==nil) {
        array=[NSMutableArray array];
    }
    
    flag=[[NSUserDefaults standardUserDefaults]boolForKey:kBool];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self addLeftButtonReturn:@selector(dismiss)];
    UIView  *view=[[UIView alloc]initWithFrame:CGRectMake(5, 75, kDeviceWidth-10, kDeviceHeight/2)];
    view.layer.cornerRadius=4;
    view.layer.borderWidth=1;
    view.layer.borderColor=[UIColor lightGrayColor].CGColor;
    [self.view addSubview:view];
    
    text=[[UITextView alloc]initWithFrame:CGRectMake(10, 80, kDeviceWidth-20, kDeviceHeight/2-10)];
    text.delegate=self;
    text.autoresizingMask=UIViewAutoresizingFlexibleHeight;
    if (flag==YES) {
        text.text=[[[NSUserDefaults standardUserDefaults]objectForKey:kText]objectAtIndex:0];
    }else{
            text.text=@"请为您的用户出具一份权威的建议书:";
    }
    [self.view addSubview:text];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(returnKeyboard) name:UITextViewTextDidEndEditingNotification object:nil];
    
    //确认发布
    [self addViewInButtonInHigh:@"确认发布－.9.png" HighLight:@"确认发布－点击之后的.9.png" rect:CGRectMake(view.left+10, view.bottom+30, kDeviceWidth-((view.left+10)*2), 40) with:@selector(surePublic)];
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
#pragma mark  textView发生改变
//textView发生改变
//- (void)textViewDidChange:(UITextView *)textView{
//    NSString *newData=[[NSUserDefaults standardUserDefaults]objectForKey:kText];
//    NSLog(@"----newData-----%@",newData);
////    if (![newData isEqualToString:textView.text]) {
////        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kText];
////        [[NSUserDefaults standardUserDefaults] synchronize];
////    }
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"textViewChange" object:newData];
////    NSLog(@"%@------textView.text-----",textView.text);
//    
//}
-(void)dismiss{
    [self returnKeyboard];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -----------传入到服务器,用户获得数据------------
//确认发布
-(void)surePublic{
    MyLog(@"确认发布");
    
    [array addObject:text.text];
    
    //存入偏好设置
    NSUserDefaults *defaultDafaults=[NSUserDefaults standardUserDefaults];
    [defaultDafaults setObject:array forKey:kText];
    [defaultDafaults setBool:YES forKey:kBool];//bool
    [defaultDafaults synchronize];
    
    [[LoginUser sharedLoginUser]loadurl:GetVerification(@"client", @"sendAdvice") with:@{
                                                                                         @"expert_id":[[NSUserDefaults standardUserDefaults]objectForKey:E_id],@"member_id":[LoginUser sharedLoginUser].member_id,@"advice_content":text.text} BlockWithSuccess:^(id responseObject) {
                                      if ([responseObject[@"success_code"] intValue]==200) {
                                         NSString *data=[responseObject objectForKey:@"success_message"];
                                         MyLog(@"%@----data",data);
                                        }
                                                                                         } Failure:^(NSError *mes) {                    MyLog(@"%@error",mes);
                                                                    }];
    [self.navigationController.tabBarController setSelectedIndex:1];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if (flag==NO) {
        textView.text=@"";
    }
}

-(void)returnKeyboard{
    [text resignFirstResponder];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [text resignFirstResponder];
}

@end
