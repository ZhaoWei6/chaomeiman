//
//  XMUserResponseViewController.m
//  XSM_XS
//
//  Created by Apple on 14/12/8.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMUserResponseViewController.h"
#import "UIScrollView+Touch.h"
#import "XMLoginViewController.h"
@interface XMUserResponseViewController ()<UIAlertViewDelegate>

@end

@implementation XMUserResponseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"用户反馈";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.textView.placeholder = @"请填写您的宝贵意见。";
    self.textView.font = [UIFont systemFontOfSize:16];
    
    self.textView.layer.cornerRadius = 5;
    self.submitButton.layer.cornerRadius = 5;
}

- (IBAction)actionSubmit:(UIButton *)sender {
    if(self.textView.text == nil || self.textView.text.length == 0){
        
        UIAlertView  *alertView=[[UIAlertView alloc]initWithTitle:@"请填写反馈意见" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:
                                 @"确定", nil];
        
        [alertView  show];
    }else{
        
        NSString *userid = [UserDefaults objectForKey:@"userid"];
        NSString *password = [UserDefaults objectForKey:@"password"];
        
        if (userid && password) {
            
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            
            NSString *content = self.textView.text;
        
            [params setObject:content forKey:@"content"];
            [params setObject:@(1) forKey:@"apptype"];
            [params setObject:@(2) forKey:@"clienttype"];
            [params setObject:userid forKey:@"userid"];
            [params setObject:password forKey:@"password"];
            [params setObject:AppVersion forKey:@"version"];
            
            NSLog(@"%@", params);
            
            [XMHttpTool postWithURL:@"Updatelog/adviced" params:params success:^(id json) {
                XMLog(@"json-->%@",json);
                [MBProgressHUD showSuccess:json[@"message"]];
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSError *error) {
                XMLog(@"失败");
            }];
            
            
        }else{
            
        
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"您未登录，请先登录！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登陆", nil];
            
            [alertView show];
            
            
        }
        
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
            
        XMLoginViewController *loginViewController = [[XMLoginViewController alloc] init];
        [self.navigationController pushViewController:loginViewController animated:YES];
    }
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
