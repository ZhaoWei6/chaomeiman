//
//  XMMoreServicesController.m
//  XiuShemMa
//
//  Created by Apple on 14/10/21.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMMoreServicesController.h"
#import "XMPlaceHolderTextView.h"
#import "XMKeyboardAvoidingScrollView.h"
#import "UIScrollView+Touch.h"
@interface XMMoreServicesController ()
{
    XMPlaceHolderTextView *_servicesContent;
}
@end

@implementation XMMoreServicesController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"更多需求";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = XMGlobalBg;
    [self loadSubViews];
}

- (void)loadSubViews
{
    //
    _servicesContent = [[XMPlaceHolderTextView alloc] initWithFrame:CGRectMake(20, 80, kDeviceWidth-40, 100)];
    [self.view addSubview:_servicesContent];
    
    _servicesContent.font = [UIFont systemFontOfSize:16];
    _servicesContent.layer.masksToBounds = YES;
    _servicesContent.backgroundColor = [UIColor whiteColor];
    _servicesContent.layer.borderWidth = 1;
    _servicesContent.layer.cornerRadius = 5;
    _servicesContent.layer.borderColor = XMColor(236, 236, 236).CGColor;
    
    _servicesContent.placeholder = @"如贴膜服务、清灰服务等";
    _servicesContent.placeholderColor = kTextFontColor999;
    
    if (![_moreServices isEqualToString:@""]) {
        _servicesContent.text = _moreServices;
    }
    
    //
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(_servicesContent.left, _servicesContent.bottom+20, _servicesContent.width, kUIButtonHeight);
    submitBtn.backgroundColor = XMButtonBg;
    submitBtn.layer.cornerRadius=5;
    submitBtn.layer.borderWidth=0;
    [submitBtn setTitle:@"确定" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
}

- (void)submitBtnClick
{
    NSString *server = _servicesContent.text;
    if ([server isEqualToString:@""]) {
        server = @"如贴膜服务、清灰服务等";
    }
    [UserDefaults setValue:server forKey:@"server"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kServicesChangeNote object:self];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
//- (void)topView:(UITapGestureRecognizer *)tap
//{
//    [_servicesContent resignFirstResponder];
//}

#pragma mark - 代理
//- (BOOL)textViewShouldEndEditing:(UITextView *)textView
//{
//    return [textView resignFirstResponder];
//}
//
//- (void)resignKeyBoard:(UITapGestureRecognizer *)sender
//{
//    [_servicesContent resignFirstResponder];
//    UIView *view = [sender view];
//    [view removeFromSuperview];
//}
//
//- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
//{
//    if ([textView.text isEqualToString:@"如贴膜服务、清灰服务等"]) {
//        textView.text = @"";
//        textView.textColor = kTextFontColor333;
//    }
//    UIView *cover = [[UIView alloc] initWithFrame:self.view.bounds];
//    cover.backgroundColor = [UIColor blackColor];
//    cover.alpha = 0.1;
//    [self.view addSubview:cover];
//    
//    cover.userInteractionEnabled = YES;
//    [cover addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyBoard:)]];
//    return YES;
//}



@end
