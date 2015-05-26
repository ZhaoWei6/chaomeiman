//
//  JHOrderDetailForDetailView.m
//  XSM_XS
//
//  Created by 李江辉 on 14-12-3.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "JHOrderDetailForDetailView.h"

@interface JHOrderDetailForDetailView ()

@property (strong, nonatomic) IBOutlet UILabel *mobileLabel;  //下单手机号
@property (strong, nonatomic) IBOutlet UILabel *calltimeLabel;//下单时间
@property (strong, nonatomic) IBOutlet UILabel *addressLabel; //上门地址
@property (strong, nonatomic) IBOutlet UILabel *serverLabel;  //上门时间
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;   //参考报价

@property (strong, nonatomic) IBOutlet UILabel *modelLabel;   //型号
@property (strong, nonatomic) IBOutlet UILabel *descLabel;    //故障
@property (strong, nonatomic) IBOutlet UILabel *moreLabel;    //更多需求

- (IBAction)actionCall:(UIButton *)sender;


@end


@implementation JHOrderDetailForDetailView

+ (instancetype)orderDetailForDetailView
{
    JHOrderDetailForDetailView *orderDetailForDetailView = [[[NSBundle mainBundle] loadNibNamed:@"JHOrderDetailForDetailView" owner:nil options:nil] lastObject];
    return orderDetailForDetailView;
}

- (void)setContentDic:(NSDictionary *)contentDic
{
    _contentDic = contentDic;
    NSLog(@"内容%@",contentDic);
    self.mobileLabel.text = contentDic[@"phone"];
    self.calltimeLabel.text = contentDic[@"createtime"];
    self.addressLabel.text = contentDic[@"address"];
    self.serverLabel.text = contentDic[@"calltime"];
    self.priceLabel.text = @"等待修神提供";
    
    self.addressLabel.frame = [self.addressLabel textRectForBounds:self.addressLabel.frame limitedToNumberOfLines:0];
    
    self.modelLabel.text = contentDic[@"attr"];
    self.descLabel.text = contentDic[@"fault"];
    self.moreLabel.text = contentDic[@"description"];
    
}

#pragma mark - 联系客户
- (IBAction)actionCall:(UIButton *)sender {
    NSString *mobile = self.mobileLabel.text;
    //打电话
    UIWebView*callWebview =[[UIWebView alloc] init];
    
    NSString *telUrl = [NSString stringWithFormat:@"tel:%@",mobile];
    
    NSURL *telURL =[NSURL URLWithString:telUrl];//
    
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    
    //添加到view上
    [self addSubview:callWebview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
