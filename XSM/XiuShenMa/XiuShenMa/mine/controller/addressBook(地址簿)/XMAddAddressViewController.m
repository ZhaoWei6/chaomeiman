//
//  XMAddAddressViewController.m
//  XiuShemMa
//
//  Created by Apple on 14/10/27.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMAddAddressViewController.h"
#import "UIImage+XM.h"
#import "XMContactsTool.h"
#import "XMContacts.h"
#import "XMDealTool.h"

#import "XMPlaceHolderTextView.h"
#import "XMKeyboardAvoidingScrollView.h"
#import "UIScrollView+Touch.h"
@interface XMAddAddressViewController ()<UITextFieldDelegate>
{
    UIScrollView *contentView;
    
    UITextField *nameTextField;
    UITextField *address1;
    UITextField *address2;
    UITextField *mobileTextfield;
    
//    CGFloat      h;
    CGFloat keyboardHeight;
}
@end

@implementation XMAddAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    kNAVITAIONBACKBUTTON
    
//    UIControl *Control = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
//    [Control addTarget:self action:@selector(View_TouchDown:) forControlEvents:UIControlEventTouchDown];
//    self.view = Control;
    self.view.backgroundColor = XMGlobalBg;
    contentView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    contentView.backgroundColor = XMGlobalBg;
    [self.view addSubview:contentView];
    
    [self loadSubViews];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveContacts:)];
}
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    h=0;
//}
//加载子视图
- (void)loadSubViews
{
    self.view.backgroundColor = XMGlobalBg;
    //联系人
    QHLabel *peopleLabel =  [[QHLabel alloc] init];
    peopleLabel.text = @"联系人";
    peopleLabel.textColor = kTextFontColor333;
    [contentView addSubview:peopleLabel];
    
    nameTextField = [self loadTextFiledWithIcon:@"icon_my_logo" placeholder:@"填写姓名" index:1];
    [contentView addSubview:nameTextField];
    //性别
    QHLabel *sexLabel =  [[QHLabel alloc] init];
    sexLabel.text = @"性别";
    sexLabel.textColor = kTextFontColor333;
    [contentView addSubview:sexLabel];
    
    UIButton *btnMan = [UIButton buttonWithType:UIButtonTypeCustom];
    btnMan.tag = 1001;
    [btnMan setTitle:@"先生" forState:UIControlStateNormal];
    [btnMan setTitleColor:kTextFontColor333 forState:UIControlStateNormal];
    btnMan.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [btnMan setImage:[UIImage resizedImage:@"icon_circle"] forState:UIControlStateNormal];
    [btnMan setImage:[UIImage resizedImage:@"icon_chooce"] forState:UIControlStateDisabled];
    [contentView addSubview:btnMan];
    
    UIButton *btnWoman = [UIButton buttonWithType:UIButtonTypeCustom];
    btnWoman.tag = 1002;
    [btnWoman setTitle:@"女士" forState:UIControlStateNormal];
    [btnWoman setTitleColor:kTextFontColor333 forState:UIControlStateNormal];
    btnWoman.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [btnWoman setImage:[UIImage resizedImage:@"icon_circle"] forState:UIControlStateNormal];
    [btnWoman setImage:[UIImage resizedImage:@"icon_chooce"] forState:UIControlStateDisabled];
    [contentView addSubview:btnWoman];
    
    [btnMan addTarget:self action:@selector(sexChange:) forControlEvents:UIControlEventTouchUpInside];
    [btnWoman addTarget:self action:@selector(sexChange:) forControlEvents:UIControlEventTouchUpInside];
    
    //地址
    QHLabel *addressLabel =  [[QHLabel alloc] init];
    addressLabel.text = @"地址";
    addressLabel.textColor = kTextFontColor333;
    [contentView addSubview:addressLabel];
    
    address1 = [self loadTextFiledWithIcon:@"icon_add" placeholder:@"北京市海淀区" index:2];
    [contentView addSubview:address1];
    
    address2 = [self loadTextFiledWithIcon:@"edit1" placeholder:@"上地三街中黎科技园" index:3];
    [contentView addSubview:address2];
    
    //联系方式
    QHLabel *mobileLabel = [[QHLabel alloc] init];
    mobileLabel.text = @"联系方式";
    mobileLabel.textColor = kTextFontColor333;
    [contentView addSubview:mobileLabel];
    
    mobileTextfield = [self loadTextFiledWithIcon:@"icon_my_logo" placeholder:@"填写手机号" index:4];
    [contentView addSubview:mobileTextfield];
    
    //设置控件的frame
    peopleLabel.frame = CGRectMake(10, 10+64, kDeviceWidth - 20, 30);
    nameTextField.frame = CGRectMake(peopleLabel.left+20, peopleLabel.bottom, kDeviceWidth - 60, 40);
    sexLabel.frame = CGRectMake(peopleLabel.left, nameTextField.bottom+10, peopleLabel.width, 30);
    btnMan.frame = CGRectMake(nameTextField.left, sexLabel.bottom+10, nameTextField.width/2, 24);
    btnWoman.frame = CGRectMake(btnMan.right, btnMan.top, btnMan.width, btnMan.height);
    addressLabel.frame = CGRectMake(peopleLabel.left, sexLabel.bottom+50, peopleLabel.width, peopleLabel.height);
    address1.frame = CGRectMake(nameTextField.left, addressLabel.bottom+10, nameTextField.width, nameTextField.height);
    address2.frame = CGRectMake(address1.left, address1.bottom+10, address1.width, address1.height);
    mobileLabel.frame = CGRectMake(peopleLabel.left, address2.bottom+10, peopleLabel.width, peopleLabel.height);
    mobileTextfield.frame = CGRectMake(address2.left, mobileLabel.bottom+10, address2.width, address2.height);
    
    contentView.contentSize = CGSizeMake(0, kDeviceHeight-64);
    //
    [self sexChange:btnMan];
    
//    XMLog(@"%@",_contacts.nickname);
    if (_contacts) {
        nameTextField.text = _contacts.nickname;
        if ([_contacts.sex isEqualToString:@"1"]) {
            [self sexChange:btnMan];
        }else{
            [self sexChange:btnWoman];
        }
        mobileTextfield.text = _contacts.telephone;
        address1.text = _contacts.area;
        address2.text = _contacts.address;
    }else{
        XMLog(@"地址%@%@",[XMDealTool sharedXMDealTool].area,[XMDealTool sharedXMDealTool].address);
        address1.text = [XMDealTool sharedXMDealTool].area;
        
        address2.text = [XMDealTool sharedXMDealTool].address;
    }
}

//加载文本框
- (UITextField *)loadTextFiledWithIcon:(NSString *)icon placeholder:(NSString *)placeholder index:(NSInteger)index
{
    UITextField *textField = [[UITextField alloc] init];
    textField.tag = index;
    textField.backgroundColor = [UIColor whiteColor];
    textField.layer.borderWidth = 1;
    textField.layer.cornerRadius = 5;
    textField.layer.borderColor = XMColor(236, 236, 236).CGColor;
    textField.placeholder = placeholder;
    textField.delegate = self;
    //
    UIImageView *left = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [left setImage:[UIImage resizedImage:icon]];
    left.contentMode = UIViewContentModeScaleAspectFit;
    textField.leftView = left;
    textField.leftViewMode = UITextFieldViewModeAlways;
    //
    textField.layer.borderWidth = 1;
    textField.layer.cornerRadius = 5;
    
    textField.placeholder = placeholder;
    
    return textField;
}

- (void)sexChange:(UIButton *)button
{
    if (button.tag == 1001) {
        button.enabled = NO;
        UIButton *btn = (UIButton *)[self.view viewWithTag:1002];
        btn.enabled = YES;
    }else{
        button.enabled = NO;
        UIButton *btn = (UIButton *)[self.view viewWithTag:1001];
        btn.enabled = YES;
    }
}
#pragma mark - 保存联系人
- (void)saveContacts:(UIBarButtonItem *)sender
{
    sender.enabled = NO;
    //性别
    UIButton *btn = (UIButton *)[self.view viewWithTag:1001];
    NSString *sex = btn.enabled ? @"0": @"1";
    
    if (_contacts) {
        //修改联系人信息
        NSDictionary *parmas = @{@"address_id":_contacts.ID,
                                 @"area":address1.text,
                                 @"address":address2.text,
                                 @"sex":sex,
                                 @"phone":mobileTextfield.text,
                                 @"nickname":nameTextField.text};
        [[XMDealTool sharedXMDealTool] editContactWithContent:parmas success:^(NSString *deal,NSString *index) {
            XMLog(@"修改成功");
            sender.enabled = YES;
//            [self saveSuccess:index];
            [MBProgressHUD showSuccess:@"修改成功"];
            [self performSelector:@selector(backToLaseVC) withObject:nil afterDelay:0.3];
        } failure:^(NSString *deal) {
            XMLog(@"修改失败");
            sender.enabled = YES;
//            [self saveFailure:deal];
            [MBProgressHUD showError:@"修改失败"];
        }];
    }else{
        NSDictionary *parmas = @{@"area":address1.text,
                                 @"address":address2.text,
                                 @"sex":sex,
                                 @"phone":mobileTextfield.text,
                                 @"nickname":nameTextField.text};
        
        [[XMDealTool sharedXMDealTool] addContactWithContent:parmas success:^(NSString *deal,NSString *index) {
            XMLog(@"添加成功");
            sender.enabled = YES;
//            [self saveSuccess:index];
            [MBProgressHUD showSuccess:deal];
            [self performSelector:@selector(backToLaseVC) withObject:nil afterDelay:0.3];
        } failure:^(NSString *deal) {
            XMLog(@"添加失败");
            sender.enabled = YES;
//            [self saveFailure:deal];
            [MBProgressHUD showError:deal];
        }];
    }
}
#pragma mark - 
//#pragma mark 保存成功
- (void)backToLaseVC
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddAddressSuccess" object:nil];
    //返回上一级
    [self.navigationController popViewControllerAnimated:YES];
}
//#pragma mark 保存失败
//- (void)saveFailure:(NSString *)message
//{
//    XMLog(@"%@",message);
//    [self showAlertWithTitle:@"提示" andMessage:message];
//    [self performSelector:@selector(dismissAlert) withObject:nil afterDelay:0.5];
//}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

//- (void)View_TouchDown:(id)sender {
//    // 发送resignFirstResponder.
//    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder)
//                                               to:nil
//                                             from:nil
//                                         forEvent:nil];
//}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [UIView animateWithDuration:0.3 animations:^{
        if (textField.tag > 1) {
            contentView.contentOffset = CGPointMake(0, textField.top-kDeviceHeight/3);
//            h = textField.center.y - self.view.center.y*2/3;
//            CGPoint center = self.view.center;
//            center.y -= h;
//            self.view.center = center;
        }
    }];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^{
        if (textField.tag > 1) {
            contentView.contentOffset = CGPointMake(0, 0);
//            CGPoint center = self.view.center;
//            center.y += h;
//            self.view.center = center;
        }
    }];
}
- (void)keyboardWillShow:(NSNotification *)notification
{
    keyboardHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    XMLog(@"keyboardHeight=%.2f",keyboardHeight);
}

@end
