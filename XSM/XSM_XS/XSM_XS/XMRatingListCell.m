//
//  XMRatingListCell.m
//  XiuShenMa
//
//  Created by Apple on 15/1/5.
//  Copyright (c) 2015年 xiushenma. All rights reserved.
//

#import "XMRatingListCell.h"

#import "XMRatingRepair.h"

#import "UIViewExt.h"
#import "XMCommon.h"
@interface XMRatingListCell ()

@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;
@property (strong, nonatomic) IBOutlet UIImageView *ratingView;
@property (strong, nonatomic) IBOutlet UILabel *ratingContentLabel;
@property (strong, nonatomic) IBOutlet UILabel *ratingTimeLabel;


@end

@implementation XMRatingListCell

- (void)setRepair:(XMRatingRepair *)repair
{
    _repair = repair;
    
    _phoneLabel.text = [NSString stringWithFormat:@"用户：%@",repair.mobile];
    
    NSString *imgName = [NSString stringWithFormat:@"rating_%.0f",repair.score];
    [_ratingView setImage:[UIImage imageNamed:imgName]];
//    _ratingView.ratingScore = repair.score;//
    _ratingTimeLabel.text = repair.evaluatetime;
    _ratingContentLabel.text = ![repair.desc isEqualToString:@""] ?repair.desc:@"无";
    
    _ratingContentLabel.height = [_ratingContentLabel.text boundingRectWithSize:CGSizeMake(_ratingContentLabel.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName:_ratingContentLabel.font} context:nil].size.height;
    _ratingTimeLabel.frame = CGRectMake(_phoneLabel.left, _ratingContentLabel.bottom+10, kDeviceWidth-20, 20);
    
    self.height = _phoneLabel.height+_ratingTimeLabel.height+_ratingContentLabel.height+46;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
