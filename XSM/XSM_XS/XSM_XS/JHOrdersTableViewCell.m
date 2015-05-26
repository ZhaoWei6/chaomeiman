//
//  JHOrdersTableViewCell.m
//  XSM_XS
//
//  Created by Andy on 14-12-3.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "JHOrdersTableViewCell.h"
#import "XMCommon.h"
#import "XMHttpTool.h"
#import "MBProgressHUD+MJ.h"
#import "UIImageView+WebCache.h"

#import "UIViewExt.h"
#import "XMOrder.h"
@interface JHOrdersTableViewCell (){
    NSString *orderid;//订单编号
}
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *statusButton;

- (IBAction)clickButton:(UIButton *)sender;

@end

@implementation JHOrdersTableViewCell

+ (instancetype)ordersTableViewCellWithTableView:(UITableView *)tableView
{
    static NSString *ID =@"JHOrdersTableViewCell";
    
    JHOrdersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JHOrdersTableViewCell" owner:nil options:nil] lastObject];
    }
    
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setButtontitle:(NSString *)buttontitle
{
    _buttontitle = buttontitle;
    
    [self.statusButton setTitle:buttontitle forState:UIControlStateNormal];
    [self.statusButton setTitle:buttontitle forState:UIControlStateHighlighted];
    
}

- (void)setOrder:(XMOrder *)order
{
    _order = order;
    
    orderid = order.ID;
    self.nameLabel.text = order.mobile;
    self.statusLabel.text = order.title;
    
    self.buttontitle = order.checkstatus;
    
    [self.iconImageView setImageWithURL:[NSURL URLWithString:order.photo] placeholderImage:[UIImage imageNamed:@"repair_icon"]];
}

- (void)layoutSubviews
{
    [self.statusButton.titleLabel setTextAlignment:NSTextAlignmentRight];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
@end
