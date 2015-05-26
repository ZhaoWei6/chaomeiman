//
//  XMExpressViewController.m
//  XiuShemMa
//
//  Created by Apple on 14/10/29.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMExpressViewController.h"

@interface XMExpressViewController ()<UITextFieldDelegate>
{
    UITextField *expressCompany;//快递公司名称
    UITextField *expressNumber;//快递单号
}
@end

@implementation XMExpressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    kNAVITAIONBACKBUTTON
    self.title = @"添加快递信息";
    
    [self loadSubViews];
}

- (void)loadSubViews
{
    self.view.backgroundColor = XMGlobalBg;
    
    expressCompany = [self loadTextFiledWithPlaceholder:@"快递公司名称" index:1];
    expressNumber = [self loadTextFiledWithPlaceholder:@"快递单号" index:2];
    [self.view addSubview:expressCompany];
    [self.view addSubview:expressNumber];
    
    expressCompany.frame = CGRectMake(30, 64+50, kDeviceWidth-60, 40);
    expressNumber.frame = CGRectMake(expressCompany.left, expressCompany.bottom+20, expressCompany.width, expressCompany.height);
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setTitle:@"确认添加" forState:UIControlStateNormal];
    addButton.frame = CGRectMake(20, expressNumber.bottom+30, kDeviceWidth-40, kUIButtonHeight);
    addButton.backgroundColor =XMButtonBg;
    addButton.layer.cornerRadius=5;
    addButton.layer.borderWidth=0;
    [addButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addButton];

}

//加载文本框
- (UITextField *)loadTextFiledWithPlaceholder:(NSString *)placeholder index:(NSInteger)index
{
    UITextField *textField = [[UITextField alloc] init];
    textField.tag = index;
    textField.delegate = self;
    //
    UIImageView *left = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
    textField.leftView = left;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.backgroundColor=[UIColor whiteColor];
    //
    textField.layer.borderWidth = 1;
    textField.layer.cornerRadius = 5;
    textField.layer.borderColor=(__bridge CGColorRef)([UIColor lightGrayColor]);
    
    textField.placeholder = placeholder;
    
    return textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == expressCompany) {
        return [expressNumber becomeFirstResponder];
    }
    return [textField resignFirstResponder];
}

- (void)buttonClick
{
    XMLog(@"快递公司：%@   快递单号%@",expressCompany.text,expressNumber.text);
}

@end
