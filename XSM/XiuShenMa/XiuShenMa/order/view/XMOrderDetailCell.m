//
//  XMOrderDetailCell.m
//  XiuShemMa
//
//  Created by Apple on 14-10-11.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMOrderDetailCell.h"
#import "XMOrderDetail.h"
#import "UIColor+XM.h"
@interface XMOrderDetailCell ()
//{
//    UIImageView *imageView;//图
//    QHLabel     *descLabel;//店铺名
//    QHLabel     *priceLabel;//价格
//    UIButton    *leftButton;//左侧按钮
//    UIButton    *rightButton;//右侧按钮
//    UIView      *contentView;//容器
//    
////    NSArray     *_states1;//订单状态
////    NSArray     *_states2;
//}
@property (nonatomic, strong) UIImageView *orderImageView;
@property (nonatomic, strong) UILabel     *shopNameLabel;
@property (nonatomic, strong) UILabel     *callTimeLabel;
@property (nonatomic, strong) UILabel     *serverLabel;
@property (nonatomic, strong) UIButton    *ratingButton;
@property (nonatomic, strong) UILabel     *stateLabel;
@end

@implementation XMOrderDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadSubView];
//        _states1 = @[@"订单确认中",@"修神收货中",@"已收货，检测中",@"维修中",@"已完成",@"已取消"];
//        _states2 = @[@[@"已确认",@"检测完成",@"维修完成"],@[@"去快递",@"查看报告",@"查看物流"]];
    }
    return self;
}

- (void)loadSubView
{
    self.orderImageView    = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.shopNameLabel     = [[UILabel alloc] initWithFrame:CGRectZero];
    self.callTimeLabel     = [[UILabel alloc] initWithFrame:CGRectZero];
    self.serverLabel       = [[UILabel alloc] initWithFrame:CGRectZero];
    self.ratingButton      = [UIButton buttonWithType:UIButtonTypeCustom];
    self.frame = CGRectZero;
    self.stateLabel        = [[UILabel alloc] initWithFrame:CGRectZero];
    
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
    
    self.serverLabel.layer.cornerRadius = 3;
    self.serverLabel.layer.masksToBounds = YES;
    
    [self.contentView addSubview:self.orderImageView];
    [self.contentView addSubview:self.shopNameLabel];
    [self.contentView addSubview:self.callTimeLabel];
    [self.contentView addSubview:self.serverLabel];
    [self.contentView addSubview:self.ratingButton];
    [self.contentView addSubview:self.stateLabel];
    
    [self.ratingButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setOrderDetail:(NSDictionary *)orderDetail
{
    _orderDetail = orderDetail;
    
    [self.orderImageView setImageWithURL:[NSURL URLWithString:orderDetail[@"photo"]] placeholderImage:[UIImage imageNamed:@"repairHeadView"]];
    self.shopNameLabel.text = orderDetail[@"shop"];
    self.callTimeLabel.text = orderDetail[@"createtime"];
    if ([orderDetail[@"servicecategory_id"] integerValue] == 1) {
        self.serverLabel.text = @"上门";
        self.serverLabel.backgroundColor = [UIColor colorWithHexString:@"#73DDF7"];
    }else if ([orderDetail[@"servicecategory_id"] integerValue] == 2){
        self.serverLabel.text = @"寄修";
        self.serverLabel.backgroundColor = [UIColor colorWithHexString:@"#79E8B5"];
    }else{
        self.serverLabel.text = @"进店";
        self.serverLabel.backgroundColor = [UIColor colorWithHexString:@"#F99A84"];
    }
    if ([orderDetail[@"title"] isEqualToString:@"去评价"]) {
        self.ratingButton.hidden = NO;
        self.stateLabel.hidden = YES;
    }else{
        self.ratingButton.hidden = YES;
        self.stateLabel.hidden = NO;
        self.stateLabel.text = orderDetail[@"title"];
        if ([orderDetail[@"title"] isEqualToString:@"订单完成"] || [orderDetail[@"title"] isEqualToString:@"已取消"]) {
            self.stateLabel.textColor = [UIColor colorWithHexString:@"#888888"];
        }else{
            self.stateLabel.textColor = [UIColor colorWithHexString:@"#f99a84"];
        }
    }
    
    XMLog(@"状态------》%@",orderDetail[@"title"]);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //设置各控件frame
    _orderImageView.frame = CGRectMake(15, 15, 70, 70);
    _shopNameLabel.frame = CGRectMake(_orderImageView.right+10, _orderImageView.top, kDeviceWidth-185, 16);
    _callTimeLabel.frame = CGRectMake(_shopNameLabel.left, (self.frame.size.height-14)/2.0f, _shopNameLabel.width, 14);
    _serverLabel.frame = CGRectMake(_callTimeLabel.left, _orderImageView.bottom-17, 34, 17);
    _ratingButton.frame = CGRectMake(kDeviceWidth-80, (self.frame.size.height-30)/2.0f, 70, 30);
    _stateLabel.frame = CGRectMake(kDeviceWidth-80, (self.frame.size.height-30)/2.0f, 70, 30);
    
    [self.contentView makeInsetShadowWithRadius:1 Color:[UIColor colorWithHexString:@"cccccc"] Directions:@[@"top",@"bottom"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)buttonClick:(UIButton *)button
{
    XMLog(@"点击了评价按钮");
    if ([_delegate respondsToSelector:@selector(clickButton:orderid:isIntoShop:)]) {
        BOOL flag = [_orderDetail[@"servicecategory_id"] intValue]==3 ?YES:NO;
        [_delegate clickButton:button.titleLabel.text orderid:_orderDetail[@"id"] isIntoShop:flag];
    }
}

@end
