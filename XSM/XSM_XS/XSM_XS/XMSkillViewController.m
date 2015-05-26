//
//  XMSkillViewController.m
//  XSM_XS
//
//  Created by Apple on 14/12/3.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMSkillViewController.h"
#import "UIScrollView+Touch.h"
@interface XMSkillViewController ()

@end

@implementation XMSkillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"编辑精通技能";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.textView.placeholder = @"如擅长主板维修、更换屏幕、电池更换、手机贴膜等。";
    self.textView.font = [UIFont systemFontOfSize:16];
    
    self.textView.layer.cornerRadius = 5;
    self.submitButton.layer.cornerRadius = 5;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showSkills];
}

- (void)showSkills
{
    NSString *userid = [XMDealTool sharedXMDealTool].userid;
    NSString *password = [XMDealTool sharedXMDealTool].password;
    [XMHttpTool postWithURL:@"Maintainer/showskills" params:@{@"userid":userid,@"password":password} success:^(id json) {
        XMLog(@"json-->%@",json);
        if ([json[@"status"] integerValue] == 1) {
            self.textView.text = json[@"description"];
        }else{
            XMLog(@"获取修神自己的精通技能失败-->%@",json[@"description"]);
        }
    } failure:^(NSError *error) {
        XMLog(@"error = %@",error);
    }];
}

- (IBAction)actionSubmit:(UIButton *)sender {
    NSString *description = self.textView.text;
    NSString *userid = [XMDealTool sharedXMDealTool].userid;
    NSString *password = [XMDealTool sharedXMDealTool].password;
    [XMHttpTool postWithURL:@"Maintaineredit/proficientskills" params:@{@"userid":userid,@"password":password,@"description":description} success:^(id json) {
        if ([json[@"status"] integerValue] == 1) {
            XMLog(@"message-->%@",json[@"message"]);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEUSERDATA" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            XMLog(@"获取修神自己的精通技能失败-->%@",json);
            [MBProgressHUD showError:json[@"message"]];
            [self.navigationController popViewControllerAnimated:YES];
        }
        //此处非常屌！！！！
    } failure:^(NSError *error) {
        XMLog(@"error = %@",error);
    }];
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
