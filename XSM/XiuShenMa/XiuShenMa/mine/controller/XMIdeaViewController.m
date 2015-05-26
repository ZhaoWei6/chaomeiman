//
//  XMIdeaViewController.m
//  XiuShenMa
//
//  Created by Apple on 14/12/15.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMIdeaViewController.h"
#import "XMPlaceHolderTextView.h"
#import "XMDealTool.h"

@interface XMIdeaViewController ()<UITextViewDelegate>{
    
    UIButton  *button;
    XMPlaceHolderTextView  *textView;

}

@end

@implementation XMIdeaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"用户反馈";

    [self addView];
    
}


-(void)addView{
    textView=[[XMPlaceHolderTextView alloc]initWithFrame:CGRectMake(10, 74, kDeviceWidth-20, kDeviceHeight/3)];
    textView.placeholder=@"请填写您的宝贵意见。";
   textView.layer.masksToBounds = YES;
    textView.font=[UIFont systemFontOfSize:16];
    textView.layer.cornerRadius=5;
    textView.layer.borderWidth=1;
    textView.layer.borderColor = XMColor(236, 236, 236).CGColor;
    [self.view addSubview:textView];
    
    button=[[UIButton alloc]initWithFrame:CGRectMake(10, textView.bottom+30, kDeviceWidth-20, kUILoginHeight)];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [button  addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchDown];
    button.backgroundColor=XMButtonBg;
    button.layer.cornerRadius=5;
    [self.view addSubview:button];


}

-(void)buttonAction{
    
    if(textView.text == nil || textView.text.length == 0){
        
        UIAlertView  *alertView=[[UIAlertView alloc]initWithTitle:@"请填写反馈意见" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:
                                 @"确定", nil];
        
        [alertView  show];
    }else{
        
        /**
         
         用户反馈内容:content
         
         手机系统类型:apptype
         
         客户端类型:clienttype
         
         用户id:userid
         
         密码:password
         
         app版本号:version
         
         */
        NSDictionary *param = @{@"userid" : [UserDefaults objectForKey:@"userid"],
                                @"password" : [UserDefaults objectForKey:@"password"],
                                @"apptype" : @"1",
                                @"clienttype" : @"1",
                                @"content" : textView.text,
                                @"version" : AppVersion
                                };
        
        [[XMDealTool sharedXMDealTool] userFeedbackInfoWithParams:param Success:^(NSDictionary *deal) {
            
            if ([deal[@"status"] isEqual: @1]) {
                
                [MBProgressHUD showSuccess:deal[@"message"]];
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:deal[@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            }
            
        }];
        
        
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==100) {
        [self.navigationController  popViewControllerAnimated:YES];
        
        
    }
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    [self.view  endEditing:YES];

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
