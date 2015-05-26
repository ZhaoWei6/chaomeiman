//
//  XMRepairmanCell.m
//  XiuShemMa
//
//  Created by Apple on 14-10-5.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMRepairmanCell.h"
#import "XMRepairman.h"
#import "XMRatingView.h"
#import "UIColor+XM.h"

#define TitleLabelFont 18
#define DetailLabelFont 13

@interface XMRepairmanCell ()
{
//    UIView  *contentView;
//    UILabel *detailLabel;
//    UILabel *distanceLabel;
//    UIView  *separate;
//    UIImageView *imageView;
//    UILabel *nameLabel;
//    UILabel *specialLabel;
//    XMRatingView *ratingView;
//    UILabel *numberLabel;
//    UIView *bottom;
    UIImageView *headImageView;  //修神头像
    UILabel     *shopNameLabel;  //店名
    UIImageView *ratingImageView;//评价星级
    UILabel     *numberLabel;    //修理数量
    UILabel     *distanceLabel;  //距离
    UILabel     *nameLabel;      //修神姓名
    UIView      *lineCenter;
    UIView      *line;
    UIView      *serverContentView;
    NSArray     *serverArray;
}
@end

@implementation XMRepairmanCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        [self loadSubViews];
        [self initContentView];
        
        [self adjustFrom];
        
//        [self initServerView];
//        [UIColor blueColor];
        serverArray = @[@[@"上门",[UIColor colorWithHexString:@"#73DDF7"]],
                        @[@"寄修",[UIColor colorWithHexString:@"#79E8B5"]],
                        @[@"进店",[UIColor colorWithHexString:@"#F99A84"]]];
    }
    return self;
}

- (void)initContentView
{
    headImageView     = [[UIImageView alloc] init];
    shopNameLabel     = [[UILabel     alloc] init];
    ratingImageView   = [[UIImageView alloc] init];
    numberLabel       = [[UILabel     alloc] init];
    distanceLabel     = [[UILabel     alloc] init];
    nameLabel         = [[UILabel     alloc] init];
    line              = [[UIView      alloc] init];
    serverContentView = [[UIView      alloc] init];
    lineCenter        = [[UIView     alloc] init];
    
    headImageView.layer.borderColor = kBorderColor.CGColor;
    headImageView.layer.borderWidth = 0.5;
    
    shopNameLabel.font = [UIFont systemFontOfSize:TitleLabelFont];
    numberLabel.font   = [UIFont systemFontOfSize:DetailLabelFont];
    distanceLabel.font = [UIFont systemFontOfSize:DetailLabelFont];
    nameLabel.font     = [UIFont systemFontOfSize:DetailLabelFont];
    
    numberLabel.textColor      = [UIColor colorWithHexString:@"#888888"];
    distanceLabel.textColor    = [UIColor colorWithHexString:@"#666666"];
    nameLabel.textColor        = [UIColor colorWithHexString:@"#666666"];
    line.backgroundColor       = [UIColor colorWithHexString:@"#EEEEEE"];
    lineCenter.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC"];
    
    [self.contentView addSubview:headImageView];
    [self.contentView addSubview:shopNameLabel];
    [self.contentView addSubview:ratingImageView];
    [self.contentView addSubview:numberLabel];
    [self.contentView addSubview:distanceLabel];
    [self.contentView addSubview:nameLabel];
    [self.contentView addSubview:line];
    [self.contentView addSubview:serverContentView];
    [self.contentView addSubview:lineCenter];
}

- (void)adjustFrom
{
    headImageView.frame = CGRectMake(13, 13, 127/2.0, 127/2.0);
    shopNameLabel.frame = CGRectMake(headImageView.right+9, headImageView.top, kDeviceWidth-30-headImageView.width, TitleLabelFont);
    ratingImageView.frame = CGRectMake(shopNameLabel.left, shopNameLabel.top+(headImageView.height-DetailLabelFont)/2, DetailLabelFont*5+4, DetailLabelFont);
    numberLabel.frame = CGRectMake(ratingImageView.right+7, ratingImageView.top, shopNameLabel.width-ratingImageView.width-5, ratingImageView.height);
    distanceLabel.frame = CGRectMake(shopNameLabel.left, headImageView.bottom-DetailLabelFont, 1000, DetailLabelFont);
    nameLabel.frame = CGRectMake(distanceLabel.right+14, distanceLabel.top, DetailLabelFont*5, DetailLabelFont);
    line.frame = CGRectMake(shopNameLabel.left, headImageView.bottom+13, kDeviceWidth-shopNameLabel.left, 0.5);
    serverContentView.frame = CGRectMake(line.left, line.bottom+9, line.width, DetailLabelFont+2);
    lineCenter.frame = CGRectMake(distanceLabel.right+5, distanceLabel.top, 0.5, distanceLabel.height);
}

- (void)initServerView
{
    for (UIView *subView in serverContentView.subviews) {
        [subView removeFromSuperview];
    }
    
    for (int i=0; i<[_repairman.servicelist count] ;i++) {
        int index = [_repairman.servicelist[i] intValue]-1;
        
        UILabel *serverLabel = [[UILabel alloc] initWithFrame:CGRectMake(0+ (31+4)*i, 0, 31, serverContentView.height)];
        serverLabel.backgroundColor = serverArray[index][1];
        serverLabel.text = serverArray[index][0];
//        serverLabel.text = _repairman.servicelist[i];
        serverLabel.textColor = [UIColor whiteColor];
        serverLabel.textAlignment = NSTextAlignmentCenter;
        serverLabel.font = [UIFont boldSystemFontOfSize:DetailLabelFont-1];
        serverLabel.layer.cornerRadius = 3;
        serverLabel.layer.masksToBounds = YES;
        [serverContentView addSubview:serverLabel];
    }

//    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, line.bottom+24+DetailLabelFont, kDeviceWidth, 0.5)];
//    bottomLine.backgroundColor = [UIColor lightGrayColor];
//    XMLog(@"单元格高度-->%f",bottomLine.top);
//    [self.contentView addSubview:bottomLine];
}

- (void)setRepairman:(XMRepairman *)repairman
{
    _repairman = repairman;
    
    [headImageView setImageWithURL:[NSURL URLWithString:_repairman.photo] placeholderImage:[UIImage imageNamed:@"repairHeadView"]];
    shopNameLabel.text = repairman.shop;
    NSString *ratingName = [NSString stringWithFormat:@"rating_%.0f",repairman.evaluate];
    [ratingImageView setImage:[UIImage imageNamed:ratingName]];
    numberLabel.text = [NSString stringWithFormat:@"已修:%i部",_repairman.maintaincount];
    
    
    //   判断距离
    if (_repairman.distance < 1000) {
        distanceLabel.text = [NSString stringWithFormat:@"%.0fm",_repairman.distance];
    }else{
        CGFloat distance = _repairman.distance/1000;
        if (distance < 1) {
            distance += 1;
        }
        if (distance < 10){
            distanceLabel.text = [NSString stringWithFormat:@"%.1fkm",distance];
        }else{
            distanceLabel.text = [NSString stringWithFormat:@"%.0fkm",distance];
        }
    }
    
    distanceLabel.width = [distanceLabel.text boundingRectWithSize:distanceLabel.frame.size options:NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:distanceLabel.font} context:nil].size.width;
    
    nameLabel.text = repairman.nickname;
    
    nameLabel.frame = CGRectMake(distanceLabel.right+10, distanceLabel.top, DetailLabelFont*5, DetailLabelFont);
    lineCenter.frame = CGRectMake(distanceLabel.right+5, distanceLabel.top, 0.5, distanceLabel.height);
    
    [self initServerView];
//    detailLabel.text = _repairman.shop;
//    
//    [imageView setImageWithURL:[NSURL URLWithString:_repairman.photo] placeholderImage:[UIImage imageNamed:@"picture"]];
//    
//    nameLabel.text = _repairman.nickname;
//    
//    if ([_repairman.desc isEqualToString:@""]){
//        specialLabel.text = @"擅长:无";
//    }else{
//        specialLabel.text = [NSString stringWithFormat:@"擅长:%@",_repairman.desc];
//    }
//    
//    numberLabel.text = [NSString stringWithFormat:@"已修:%i部",_repairman.maintaincount];
//    
//    ratingView.ratingScore = _repairman.evaluate;
//    //   判断距离
//    if (_repairman.distance < 500) {
//        distanceLabel.text = @"<500m";
//    }else{
//        CGFloat distance = _repairman.distance/1000;
//        if (distance < 1) {
//            distance += 1;
//        }
//        if (distance < 10){
//            distanceLabel.text = [NSString stringWithFormat:@"<%.1fkm",distance];
//        }else{
//            distanceLabel.text = [NSString stringWithFormat:@"<%.0fkm",distance];
//        }
//    }
}
/*
- (void)loadSubViews
{
    contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:contentView];
    //店铺描述
    detailLabel = [[UILabel alloc] init];
    detailLabel.font = kRepairTextFont;
    detailLabel.textColor = XMButtonBg;
    [contentView addSubview:detailLabel];
    //距离
    distanceLabel = [[UILabel alloc] init];
    distanceLabel.textAlignment = NSTextAlignmentRight;
    distanceLabel.font = kRepairTextFont;
    distanceLabel.textColor = XMButtonBg;
    [contentView addSubview:distanceLabel];
    //分割线
    separate  = [[UIView alloc] init];
    [contentView addSubview:separate];
    separate.backgroundColor = kBorderColor;
    //图片
    imageView = [[UIImageView alloc] init];
    imageView.layer.cornerRadius=45/2.0;
    imageView.layer.masksToBounds = YES;
    imageView.image=[UIImage imageNamed:@"picture"];
//    imageView.layer.borderWidth=1;
//    imageView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    [contentView addSubview:imageView];
    //修神信息
    //修神姓名
    nameLabel = [[UILabel alloc] init];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = kRepairTextFont1;
    nameLabel.textColor = kTextFontColor999;
    [contentView addSubview:nameLabel];
    //评价
    ratingView = [[XMRatingView alloc] init];
    [contentView addSubview:ratingView];
    ratingView.style = kSmallStyle;
    //修神专长
    specialLabel = [[UILabel alloc] init];
    specialLabel.numberOfLines = 0;
    specialLabel.font = kRepairTextFont;
    specialLabel.textColor = kTextFontColor666;
    [contentView addSubview:specialLabel];
    //已修数量
    numberLabel = [[UILabel alloc] init];
    numberLabel.textAlignment = NSTextAlignmentRight;
    numberLabel.font = [UIFont systemFontOfSize:15];
    numberLabel.textColor = XMColor(89, 122, 155);
    [contentView addSubview:numberLabel];
    
    //
//    bottom = [[UIView alloc] init];
//    bottom.backgroundColor = [UIColor lightGrayColor];
//    [self.contentView addSubview:bottom];
}

- (void)setRepairman:(XMRepairman *)repairman
{
    _repairman = repairman;
    
    //设置内容
    //
    detailLabel.text = _repairman.shop;
    
    [imageView setImageWithURL:[NSURL URLWithString:_repairman.photo] placeholderImage:[UIImage imageNamed:@"picture"]];
    
    nameLabel.text = _repairman.nickname;
    
    if ([_repairman.desc isEqualToString:@""]){
        specialLabel.text = @"擅长:无";
    }else{
        specialLabel.text = [NSString stringWithFormat:@"擅长:%@",_repairman.desc];
    }
    
    numberLabel.text = [NSString stringWithFormat:@"已修:%i部",_repairman.maintaincount];
    
    ratingView.ratingScore = _repairman.evaluate;
    //   判断距离
    if (_repairman.distance < 500) {
        distanceLabel.text = @"<500m";
    }else{
        CGFloat distance = _repairman.distance/1000;
        if (distance < 1) {
            distance += 1;
        }
        if (distance < 10){
            distanceLabel.text = [NSString stringWithFormat:@"<%.1fkm",distance];
        }else{
            distanceLabel.text = [NSString stringWithFormat:@"<%.0fkm",distance];
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //设置frame
    contentView.frame = CGRectMake(10, 0, kDeviceWidth-20, self.height-10);
    contentView.backgroundColor = [UIColor whiteColor];
    //店铺
    detailLabel.frame=CGRectMake(25/2.0, 0, contentView.width-25, 40);
    //距离
    distanceLabel.frame=CGRectMake(contentView.width-100-25/2.0, 0, 100, detailLabel.height);
    //分隔线
    separate.frame=CGRectMake(5, detailLabel.bottom-1/2.0, contentView.width-10, 1/2.0);
    //头像
    imageView.frame = CGRectMake((205-90)/4.0, separate.bottom+10, 45, 45);
    //姓名
    nameLabel.frame=CGRectMake(0, imageView.bottom+5, 205/2.0, 20);
    //评价星级
    ratingView.frame=CGRectMake(nameLabel.right, nameLabel.bottom, 0, 0);
    ratingView.center = CGPointMake(imageView.center.x+75/2.0, nameLabel.bottom+ratingView.height/2.0);
    //修神擅长
    specialLabel.frame=CGRectMake(205/2.0, imageView.top, contentView.width-205/2.0-15, imageView.height+nameLabel.height+ratingView.height);
    //修理数量
    numberLabel.frame=CGRectMake(specialLabel.left, specialLabel.bottom, specialLabel.width, 20);
//    CGPoint center = numberLabel.center;
//    center.y = nameLabel.bottom+ratingView.height/2.0;
//    numberLabel.center = center;
//    bottom.frame=CGRectMake(0, 295/2.0, kDeviceWidth, 0.5);
}
*/
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
