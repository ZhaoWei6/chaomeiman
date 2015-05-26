//
//  XMMineRepairCell.m
//  XiuShenMa
//
//  Created by Apple on 14/11/14.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMMineRepairCell.h"
#import "XMRatingView.h"

#import "UIColor+XM.h"

#define TitleLabelFont 18
#define DetailLabelFont 13
@interface XMMineRepairCell (){

    UILabel *detailLabel;
    UIImageView *imageView;
    UILabel *nameLabel;
  
    XMRatingView *ratingView;
    UILabel *numberLabel;
    UIView *bottom;
    UIView      *serverContentView;
    NSArray     *serverArray;
}

@end


@implementation XMMineRepairCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadSubViews];
        
        serverArray = @[@[@"上门",[UIColor colorWithHexString:@"#73DDF7"]],
                        @[@"寄修",[UIColor colorWithHexString:@"#79E8B5"]],
                        @[@"进店",[UIColor colorWithHexString:@"#F99A84"]]];
        
        
    }
    return self;
}

-(void)loadSubViews{
    
    
    UIView   *contentView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, kDeviceWidth-20, 120)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:contentView];
    
    
    
    
    
    
    //图片
    imageView = [[UIImageView alloc] init];
    
    imageView.image=[UIImage imageNamed:@"picture"];
    [contentView addSubview:imageView];
    //店铺描述
    detailLabel = [[UILabel alloc] init];
    detailLabel.font = kDetailLabelFont;
    //    detailLabel.textColor = XMButtonBg;
    [contentView addSubview:detailLabel];
    //修神信息
    //修神姓名
    nameLabel = [[UILabel alloc] init];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont systemFontOfSize:13];;
    nameLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    [contentView addSubview:nameLabel];
    //评价
    ratingView = [[XMRatingView alloc] init];
    [contentView addSubview:ratingView];
    ratingView.style = kSmallStyle;
    
    //已修数量
    numberLabel = [[UILabel alloc] init];
    numberLabel.textAlignment = NSTextAlignmentRight;
    numberLabel.font = [UIFont systemFontOfSize:15];
    numberLabel.textColor = [UIColor colorWithHexString:@"#888888"];
    [contentView addSubview:numberLabel];
    
    
    bottom = [[UIView alloc] init];
    bottom.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC"];
    [contentView addSubview:bottom];
    
    
    serverContentView = [[UIView      alloc] init];
    [contentView addSubview:serverContentView];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    //位置设定
    //设置frame
    
    
    //    separate.frame=CGRectMake(15/2.0, detailLabel.bottom-1/2.0, kDeviceWidth-20, 1/2.0);
    
    imageView.frame = CGRectMake(13, 13, 127/2.0, 127/2.0);
    detailLabel.frame=CGRectMake(imageView.right+7, imageView.top-10, kDeviceWidth-25, 45);
    ratingView.frame=CGRectMake(imageView.right+85, detailLabel.bottom, 0, 0);
    ratingView.center = CGPointMake(imageView.right+85, detailLabel.bottom-10);
    
    numberLabel.frame=CGRectMake(ratingView.right-25, detailLabel.bottom-10, kDeviceWidth/3, 20);
    nameLabel.frame=CGRectMake(imageView.right-22, ratingView.bottom+20, 205/2.0, 20);
    
    //    specialLabel.frame=CGRectMake(205/2.0, imageView.top, kDeviceWidth-205/2.0-25, 70);
    
    bottom.frame=CGRectMake(imageView.right, nameLabel.bottom+5, kDeviceWidth-imageView.width-40, 0.5);
    serverContentView.frame = CGRectMake(bottom.left, bottom.bottom+9, bottom.width, DetailLabelFont+10);
    
    detailLabel.text = _mineRepair[@"shop"];
    
    
    [imageView setImageWithURL:[NSURL URLWithString:_mineRepair[@"photo"]] placeholderImage:[UIImage imageNamed:@"repairHeadView"]];
    
    nameLabel.text = _mineRepair[@"nickname"];
    
    
    numberLabel.text = [NSString stringWithFormat:@"已修:%@部",_mineRepair[@"maintaincount"]];
    
    ratingView.ratingScore=[_mineRepair[@"evaluate"] floatValue];
    
    ratingView.style = kSmallStyle;
    
    [self initServerView];
    
}

- (void)initServerView
{
    for (UIView *subView in serverContentView.subviews) {
        [subView removeFromSuperview];
    }
    
    for (int i=0; i<[_mineRepair[@"servicelist"] count] ;i++) {
        int index = [_mineRepair[@"servicelist"][i] intValue]-1;
        
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
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
