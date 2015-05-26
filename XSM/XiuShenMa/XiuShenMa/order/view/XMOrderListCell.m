//
//  XMOrderListCell.m
//  XiuShenMa
//
//  Created by Apple on 15/1/23.
//  Copyright (c) 2015年 xiushenma. All rights reserved.
//

#import "XMOrderListCell.h"
#import "UIColor+XM.h"
@interface XMOrderListCell ()

@property (nonatomic, strong) UIImageView *orderImageView;
@property (nonatomic, strong) UILabel     *shopNameLabel;
@property (nonatomic, strong) UILabel     *callTimeLabel;
@property (nonatomic, strong) UILabel     *serverLabel;
@property (nonatomic, strong) UIButton    *ratingButton;
@property (nonatomic, strong) UILabel     *stateLabel;

@end

@implementation XMOrderListCell

//+ (instancetype)initWithTableView:(UITableView *)tableView andIdentifier:(NSString *)identifier
//{
//    XMOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if (cell==nil) {
//        cell = [cell initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//    }
//
//    return cell;
//}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initContentView];
    }
    return self;
}

#pragma mark 加载子视图
- (void)initContentView {
    self.orderImageView    = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 70, 70)];
    self.shopNameLabel     = [[UILabel alloc] initWithFrame:CGRectMake(self.orderImageView.left, self.orderImageView.top, kDeviceWidth-185, 16)];
    self.callTimeLabel     = [[UILabel alloc] initWithFrame:CGRectMake(self.shopNameLabel.left, (self.frame.size.height-14)/2.0f, self.shopNameLabel.width, 14)];
    self.serverLabel       = [[UILabel alloc] initWithFrame:CGRectMake(self.callTimeLabel.left, self.orderImageView.bottom-17, 34, 17)];
    self.ratingButton      = [UIButton buttonWithType:UIButtonTypeCustom];
    self.frame = CGRectMake(kDeviceWidth-80, (self.frame.size.height-30)/2.0f, 70, 30);
    self.stateLabel        = [[UILabel alloc] initWithFrame:self.ratingButton.frame];
    
    self.orderImageView.layer.borderWidth = 1;
    self.orderImageView.layer.borderColor = kBorderColor.CGColor;
    
    [self.ratingButton setTitle:@"去评价" forState:UIControlStateNormal];
    [self.ratingButton setTitleColor:[UIColor colorWithHexString:@"#f99a84"] forState:UIControlStateNormal];
    self.ratingButton.layer.borderWidth = 1;
    self.ratingButton.layer.cornerRadius = 5;
    self.ratingButton.layer.borderColor = [UIColor colorWithHexString:@"#f99a84"].CGColor;
    
    self.shopNameLabel.font = [UIFont systemFontOfSize:16];
    self.callTimeLabel.font = [UIFont systemFontOfSize:14];
    self.serverLabel.font   = [UIFont boldSystemFontOfSize:12];
    self.ratingButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.stateLabel.font    = [UIFont systemFontOfSize:15];
    
    self.serverLabel.textAlignment = NSTextAlignmentCenter;
    self.stateLabel.textAlignment = NSTextAlignmentRight;
    
    self.shopNameLabel.textColor = kTextFontColor333;
    self.callTimeLabel.textColor = [UIColor colorWithHexString:@"#888888"];
    self.serverLabel.textColor = [UIColor whiteColor];
    self.stateLabel.textColor = [UIColor colorWithHexString:@"#888888"];
    
    [self addSubview:self.orderImageView];
    [self addSubview:self.shopNameLabel];
    [self addSubview:self.callTimeLabel];
    [self addSubview:self.serverLabel];
    [self addSubview:self.ratingButton];
    [self addSubview:self.stateLabel];
}

- (void)setOrderDetail:(NSDictionary *)orderDetail
{
    XMLog(@"orderDetail--->%@",orderDetail);
    self.orderDetail = orderDetail;
    
    [self.orderImageView setImageWithURL:[NSURL URLWithString:orderDetail[@"maintainphoto"]] placeholderImage:[UIImage imageNamed:@"repairHeadView"]];
    self.shopNameLabel.text = orderDetail[@"shop"];
    self.callTimeLabel.text = orderDetail[@"createtime"];
    if ([orderDetail[@"servicecategory_id"] integerValue] == 1) {
        self.serverLabel.text = @"上门";
    }else if ([orderDetail[@"servicecategory_id"] integerValue] == 2){
        self.serverLabel.text = @"寄修";
    }else{
        self.serverLabel.text = @"进店";
    }
    if ([orderDetail[@"title"] isEqualToString:@"去评价"]) {
        self.ratingButton.hidden = NO;
        self.stateLabel.hidden = YES;
    }else{
        self.ratingButton.hidden = YES;
        self.stateLabel.hidden = NO;
        if ([orderDetail[@"title"] isEqualToString:@"订单完成"] || [orderDetail[@"title"] isEqualToString:@"已取消"]) {
            self.stateLabel.textColor = [UIColor colorWithHexString:@"#888888"];
        }else{
            self.stateLabel.textColor = [UIColor colorWithHexString:@"#f99a84"];
        }
    }
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
