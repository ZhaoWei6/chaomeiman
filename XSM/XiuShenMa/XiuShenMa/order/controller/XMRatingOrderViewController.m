//
//  XMRatingOrderViewController.m
//  XiuShemMa
//
//  Created by Apple on 14/10/24.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMRatingOrderViewController.h"
#import "XMDealTool.h"
#import "XMCover.h"
#import "XMHttpTool.h"

#import "XMPlaceHolderTextView.h"
#import "XMKeyboardAvoidingScrollView.h"
#import "UIScrollView+Touch.h"
@interface XMRatingOrderViewController ()<UIAlertViewDelegate>
{
    QHLabel    *descLabel;
    UIView     *ratingView;
    XMPlaceHolderTextView *ratingDetail;
    UIButton   *submitButton;
   
    NSArray    *descArray;
    NSMutableArray *btnArray;
    
//    XMCover *cover;
    UIView *alert;
    
    NSInteger score;
    NSNumber  *order;
}
@end

@implementation XMRatingOrderViewController

- (void)viewDidLoad
{
    self.title = @"添加评价";
    [super viewDidLoad];
    self.view.backgroundColor = XMGlobalBg;
    
    descArray = @[@"很差",@"差",@"好",@"很好",@"非常好"];
//    [self dismissMessage];
    [self loadSubViews];
    [self loadStart];
    [self addTapGesture];
}
//加载子视图
- (void)loadSubViews
{
    descLabel = [[QHLabel alloc] init];
    descLabel.font = [UIFont systemFontOfSize:16];
    descLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:descLabel];
    
    ratingView = [[UIView alloc] init];
//    ratingDetail.backgroundColor = [UIColor redColor];
    ratingView.contentMode = UIViewContentModeCenter;
    [self.view addSubview:ratingView];
    
    ratingDetail = [[XMPlaceHolderTextView alloc] init];
    ratingDetail.font = [UIFont systemFontOfSize:16];
    ratingDetail.placeholder = @"修的真不错，小哥长得也很帅啊！";
//    ratingDetail.delegate = self;
    ratingDetail.layer.borderWidth = 1;
    ratingDetail.layer.cornerRadius = 5;
    ratingDetail.layer.borderColor = XMColor(233, 233, 233).CGColor;
    [self.view addSubview:ratingDetail];
    ratingDetail.backgroundColor = [UIColor whiteColor];
    
    submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitButton setTitle:@"提交评价" forState:UIControlStateNormal];
    submitButton.titleLabel.font = [UIFont boldSystemFontOfSize:24];
    submitButton.backgroundColor = XMButtonBg;
    submitButton.layer.cornerRadius = 5;
    [submitButton addTarget:self action:@selector(submitButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitButton];
    
    notShop = [UIButton buttonWithType:UIButtonTypeCustom];
    [notShop setTitle:@"并未进店" forState:UIControlStateNormal];
    notShop.titleLabel.font = [UIFont boldSystemFontOfSize:24];
    notShop.backgroundColor = XMButtonBg;
    notShop.layer.cornerRadius = 5;
    [notShop addTarget:self action:@selector(notShopClick) forControlEvents:UIControlEventTouchUpInside];
   notShop.hidden=!_isIntoShop;
    [self.view addSubview:notShop];
    
    
    descLabel.translatesAutoresizingMaskIntoConstraints = NO;
    ratingView.translatesAutoresizingMaskIntoConstraints = NO;
    ratingDetail.translatesAutoresizingMaskIntoConstraints = NO;
    submitButton.translatesAutoresizingMaskIntoConstraints = NO;
    notShop.translatesAutoresizingMaskIntoConstraints = NO;

    
    NSDictionary *dict = NSDictionaryOfVariableBindings(descLabel, ratingView, ratingDetail, submitButton,notShop);
    NSDictionary *metrics = @{@"pad1":@20,@"pad2":@30,@"pad3":@80};
    
    //水平关系
    NSString *vfl0 = @"H:|-pad1-[descLabel]-pad1-|";
    NSString *vfl1 = @"H:|-pad1-[ratingView]-pad1-|";
    NSString *vfl3 = @"H:|-pad1-[ratingDetail]-pad1-|";
    NSString *vfl4 = @"H:|-pad1-[submitButton]-pad1-|";
    NSString *vfl5 = @"H:|-pad1-[notShop]-pad1-|";
    //垂直关系
    NSString *vfl2 = @"V:|-pad3-[descLabel(==ratingView)]-[ratingView]-[ratingDetail]-pad1-[submitButton]-pad2-[notShop]-pad3-|";
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl0 options:0 metrics:metrics views:dict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl1 options:0 metrics:metrics views:dict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl2 options:0 metrics:metrics views:dict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl3 options:0 metrics:metrics views:dict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl4 options:0 metrics:metrics views:dict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl5 options:0 metrics:metrics views:dict]];
    
    
    descLabel.text = @"点击星星打分";
}
//加载评价的星星
- (void)loadStart
{
    btnArray = [NSMutableArray arrayWithCapacity:5];
    
    for (int i=10; i<15; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [button setImage:[UIImage imageNamed:@"icon_start_unchecked"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"icon_start_checked"] forState:UIControlStateSelected];
        [button setImage:[UIImage imageNamed:@"icon_start_checked"] forState:UIControlStateHighlighted];
        [button setImage:[UIImage imageNamed:@"icon_start_checked"] forState:UIControlStateDisabled];
        
        button.tag = i;
        [button addTarget:self action:@selector(starButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [ratingView addSubview:button];
        [btnArray addObject:button];
    }
    
    for (UIButton *btn in btnArray) {
        btn.translatesAutoresizingMaskIntoConstraints = NO;
    }
    UIButton *btn0 = btnArray[0];
    UIButton *btn1 = btnArray[1];
    UIButton *btn2 = btnArray[2];
    UIButton *btn3 = btnArray[3];
    UIButton *btn4 = btnArray[4];
    NSDictionary *dict = NSDictionaryOfVariableBindings(btn0,btn1,btn2,btn3,btn4);
    CGFloat width = (kDeviceWidth-40*5)/2;
    NSDictionary *metrics = @{@"pad1":@(width)};
    
    //水平关系
    NSString *vfl0 = @"H:|-pad1-[btn0(==btn1)]-[btn1(==btn2)]-[btn2(==btn3)]-[btn3(==btn4)]-[btn4]-pad1-|";
    //垂直关系
    NSString *vfl1 = @"V:|-[btn0]-|";
    NSString *vfl2 = @"V:|-[btn1]-|";
    NSString *vfl3 = @"V:|-[btn2]-|";
    NSString *vfl4 = @"V:|-[btn3]-|";
    NSString *vfl5 = @"V:|-[btn4]-|";
    
    
    [ratingView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl0 options:0 metrics:metrics views:dict]];
    [ratingView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl1 options:0 metrics:metrics views:dict]];
    [ratingView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl2 options:0 metrics:metrics views:dict]];
    [ratingView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl3 options:0 metrics:metrics views:dict]];
    [ratingView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl4 options:0 metrics:metrics views:dict]];
    [ratingView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl5 options:0 metrics:metrics views:dict]];
}

//添加手势
- (void)addTapGesture
{
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchScreen:)];
    [self.view addGestureRecognizer:tap];
}

//点击星星
- (void)starButtonClick:(UIButton *)button
{
    for (int i=10; i<15; i++) {
        UIButton *btn = btnArray[i-10];
        btn.enabled = YES;
        if (i>button.tag) {
            btn.highlighted = NO;
        }else{
            btn.highlighted = YES;
        }
    }
    button.enabled = NO;
    
    score = button.tag - 9;
    descLabel.text = descArray[button.tag-10];
}

- (void)touchScreen:(UITapGestureRecognizer *)tap
{
    if (ratingDetail.isEditable) {
        [ratingDetail resignFirstResponder];
    }
}

#pragma mark -
- (void)submitButtonClick
{
    if (ratingDetail.isEditable) {
        [ratingDetail resignFirstResponder];
    }
    if ([descLabel.text isEqualToString:@"点击星星打分"]) {
        UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请给出您的评价" delegate:nil cancelButtonTitle:@"继续" otherButtonTitles:nil, nil];
        [alert1 show];
        return;
    }
    submitButton.enabled = NO;
    NSString *str = ratingDetail.text;
    
    order = _orderID;
    XMLog(@"order=%@",order);
    NSDictionary *dic = @{@"score":@(score),
                          @"order_id":order,
                          @"description":str
                          };
    XMLog(@"%@",dic);
    [[XMDealTool sharedXMDealTool] ratingOrderWithContent:dic success:^(NSString *deal) {
//        [self ratingSuccess];
        [MBProgressHUD showMessage:deal];
        [[NSNotificationCenter defaultCenter] postNotificationName:kOrderChangeNote object:nil];
        [self performSelector:@selector(back) withObject:nil afterDelay:1];
    } failure:^(NSString *deal) {
//        [self ratingFiled];
        [MBProgressHUD showError:deal];
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - 评价结果
//成功
//- (void)ratingSuccess
//{
//    [self showAlertWithTitle:@"提示" andMessage:@"评价成功"];
//    [self performSelector:@selector(dismissAlert) withObject:nil afterDelay:1];
//    [self performSelector:@selector(back) withObject:nil afterDelay:1];
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:kOrderStateChange object:nil];
//}
////失败
//- (void)ratingFiled
//{
//    [self showAlertWithTitle:@"提示" andMessage:@"评价失败"];
//    [self performSelector:@selector(dismissAlert) withObject:nil afterDelay:1];
//}

//- (void)showAlert:(NSString *)message
//{
//    cover = [[XMCover alloc] init];
//    cover.frame = self.view.bounds;
//    [self.view addSubview:cover];
//    
//    
//    alert = [[UIView alloc] init];
//    alert.center = self.view.center;
//    alert.bounds = CGRectMake(0, 0, kDeviceWidth*2/3, 120);
//    alert.layer.cornerRadius = 5;
//    alert.backgroundColor = [UIColor lightGrayColor];
//    [self.view addSubview:alert];
//    
//    QHLabel *label = [[QHLabel alloc] init];
//    label.textColor = [UIColor whiteColor];
//    label.text = message;
//    label.textAlignment = NSTextAlignmentCenter;
//    [alert addSubview:label];
//    
//    XMLog(@"%@",label.text);
//    [self.view bringSubviewToFront:alert];
//    
//    label.translatesAutoresizingMaskIntoConstraints = NO;
//    NSDictionary *dict = NSDictionaryOfVariableBindings(label);
//    NSDictionary *metrics = @{@"pad1":@40};
//    
//    //水平关系
//    NSString *vfl0 = @"H:|-[label]-|";
//    //垂直关系
//    NSString *vfl1 = @"V:|-[label]-|";
//    
//    
//    [alert addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl0 options:0 metrics:metrics views:dict]];
//    [alert addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl1 options:0 metrics:metrics views:dict]];
//}
//
//- (void)removeAlert
//{
//    [alert removeFromSuperview];
//    [cover removeFromSuperview];
//    alert = nil;
//    submitButton.enabled = YES;
//}

- (void)back
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)notShopClick{

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"我们的客服人员会在30分钟内主动联系您，了解本次服务的情况，请您保持手机通讯通畅" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    
    NSString *userid = [XMDealTool sharedXMDealTool].userid;
    NSString *password = [XMDealTool sharedXMDealTool].password;
    
    NSDictionary *params = @{@"userid":userid,
                             @"password":password,
                             @"order_id":_orderID
                             };
    
    [XMHttpTool postWithURL:@"order/Cancelorder" params:params success:^(id json) {
        XMLog(@"成功");
        [self showAlert:json[@"message"]];
        
    } failure:^(NSError *error) {
        XMLog(@"失败%@",error);
    }];

}
- (void)showAlert:(NSString *)message
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kOrderStateChange object:nil];
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [alertView show];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
#pragma mark - 代理
//- (BOOL)textViewShouldEndEditing:(UITextView *)textView
//{
//    return [textView resignFirstResponder];
//}

//- (void)resignKeyBoard:(UITapGestureRecognizer *)sender
//{
//    [ratingView resignFirstResponder];
//    UIView *view = [sender view];
//    [view removeFromSuperview];
//}

//- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
//{
//    if ([textView.text isEqualToString:@"修的真不错，小哥长得也很帅啊！"]) {
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

//@implementation UIButton (XM)
//
//- (void)setHighlighted:(BOOL)highlighted
//{
//    [super setHighlighted:NO];
//}
//- (void)setSelected:(BOOL)selected
//{
//    [super setSelected:selected];
//}
//
//@end
