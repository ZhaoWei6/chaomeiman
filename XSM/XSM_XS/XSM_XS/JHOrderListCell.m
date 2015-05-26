//
//  JHOrderListCell.m
//  XSM_XS
//
//  Created by Andy on 15/1/22.
//  Copyright (c) 2015年 xiushenma. All rights reserved.
//

#import "JHOrderListCell.h"
#import "XMCommon.h"
#import "XMHttpTool.h"
#import "MBProgressHUD+MJ.h"
#import "UIImageView+WebCache.h"

#import "UIViewExt.h"
#import "XMOrder.h"
#import "UIColor+XM.h"

@interface JHOrderListCell(){
    NSString *orderid;//订单编号
}

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *phoneNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *badInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;

@property (weak, nonatomic) IBOutlet UIButton *orderStatus;

@end

@implementation JHOrderListCell

+ (instancetype)ordersListCellWithTableView:(UITableView *)tableView
{
    static NSString *ID =@"JHOrderListCell";
    
    JHOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JHOrderListCell" owner:nil options:nil] lastObject];
    }
    
    return cell;
}

- (void)setOrder:(XMOrder *)order
{
    _order = order;
    orderid = order.ID;
    
    // 设置状态按钮
    [self.orderStatus setTitle:order.title forState:UIControlStateNormal];
    
    if ([order.title isEqualToString:@"接单"] || [order.title isEqualToString:@"出发"] || [order.title isEqualToString:@"联系客户"]) {
        
        self.orderStatus.layer.borderWidth = 1;
        self.orderStatus.layer.cornerRadius = 5;
        [self.orderStatus.titleLabel setTextAlignment:NSTextAlignmentCenter];
        self.orderStatus.layer.borderColor = [UIColor colorWithHexString:@"#f99a84"].CGColor;
        [self.orderStatus setTitleColor:[UIColor colorWithHexString:@"#f99a84"] forState:UIControlStateNormal];
        
    }else if ([order.title isEqualToString:@"待评价"]){
        
        self.orderStatus.layer.borderWidth = 0;
        self.orderStatus.layer.cornerRadius = 0;
        [self.orderStatus.titleLabel setTextAlignment:NSTextAlignmentRight];
        self.orderStatus.layer.borderColor = [UIColor whiteColor].CGColor;
        [self.orderStatus setTitleColor:[UIColor colorWithHexString:@"#f99a84"] forState:UIControlStateNormal];
        
    }else {
        
        self.orderStatus.layer.borderWidth = 0;
        self.orderStatus.layer.cornerRadius = 0;
        [self.orderStatus.titleLabel setTextAlignment:NSTextAlignmentRight];
        self.orderStatus.layer.borderColor = [UIColor whiteColor].CGColor;
        [self.orderStatus setTitleColor:[UIColor colorWithHexString:@"#888888"] forState:UIControlStateNormal];
        
    }
    
    
    
    
    // 头像
    [self.iconImageView setImageWithURL:[NSURL URLWithString:order.photo] placeholderImage:[UIImage imageNamed:@"repair_icon"]];
    
    // 故障机名称
    [self.phoneNameLabel setText:order.attr];
    
    // 故障描述
    [self.badInfoLabel setText:order.fault];
    
    // 下单时间
    [self.orderTimeLabel setText:order.createtime];
    
    
    
}

- (IBAction)clickButton:(UIButton *)sender {
    
    NSString *order_id = orderid;
    NSString *userid = [UserDefaults objectForKey:@"userid"];
    NSString *password = [UserDefaults objectForKey:@"password"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:order_id forKey:@"order_id"];
    [params setObject:userid forKey:@"userid"];
    [params setObject:password forKey:@"password"];
    
    NSString *webUrl = @"";
    
    NSString *title = sender.titleLabel.text;
    if ([title isEqualToString:@"接单"]) {
        webUrl = @"order/confirm";
    }
    else if ([title isEqualToString:@"出发"]){
        webUrl = @"order/setout";
    }
    else if ([title isEqualToString:@"联系客户"]){
        webUrl = @"order/call";
        
        NSString *mobile = _order.mobile;
        //打电话
        UIWebView*callWebview =[[UIWebView alloc] init];
        
        NSString *telUrl = [NSString stringWithFormat:@"tel:%@",mobile];
        
        NSURL *telURL =[NSURL URLWithString:telUrl];//
        
        [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
        
        //添加到view上
        [self addSubview:callWebview];
        
    }else{
        
        return;
        
    }
    
    [XMHttpTool postWithURL:webUrl params:params success:^(id json) {
        XMLog(@"json-->%@",json);
        [MBProgressHUD showSuccess:json[@"message"]];
        //        if ([json[@"status"] integerValue] == 1) {
        //            [[button superview] setHidden:YES];
        //        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHORDERLIST" object:nil];
    } failure:^(NSError *error) {
        XMLog(@"error-->%@",error);
        [MBProgressHUD showError:@"网络异常"];
        //        [MBProgressHUD hideHUD];
    }];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
