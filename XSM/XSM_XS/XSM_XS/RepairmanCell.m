//
//  RepairmanCell.m
//  XSM_XS
//
//  Created by Apple on 14/11/27.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "RepairmanCell.h"
#import "XMRepairman.h"
#import "XMRatingView.h"
#import "UIImageView+WebCache.h"
@implementation RepairmanCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRepairman:(XMRepairman *)repairman
{
    _repairman = repairman;
    
    _shopName.text = repairman.shop;
//    _distanceLabel.text = [NSString stringWithFormat:@"%.0fm",repairman.distance];
    if (repairman.distance < 500) {
        _distanceLabel.text = @"<500m";
    }else{
        CGFloat distance = _repairman.distance/1000;
        if (distance < 1) {
            distance += 1;
        }
        if (distance < 10){
            _distanceLabel.text = [NSString stringWithFormat:@"<%.1fkm",distance];
        }else{
            _distanceLabel.text = [NSString stringWithFormat:@"<%.0fkm",distance];
        }
    }
    
    
    [_photo setImageWithURL:[NSURL URLWithString:repairman.photo] placeholderImage:[UIImage imageNamed:@"picture01"]];
    
    _nameLabel.text = repairman.nickname;
    
    if (![repairman.desc isEqualToString:@""]) {
        _specialLabel.text = [NSString stringWithFormat:@"擅长:%@",repairman.desc];
    }else{
        _specialLabel.text = [NSString stringWithFormat:@"擅长:无"];
    }
    
    _numberLabel.text = [NSString stringWithFormat:@"已修:%li部",(long)repairman.maintaincount];
    
    for (UIView *view in _ratingView.subviews) {
        [view removeFromSuperview];
    }
    [_ratingView loadSubViews];
    if (_ratingView.ratingScore != repairman.evaluate) {
        _ratingView.ratingScore = repairman.evaluate;
    }
}

- (void)layoutSubviews
{
    _photo.layer.cornerRadius = 25;
    _ratingView.style = kSmallStyle;
//    [super layoutSubviews];
}

@end
