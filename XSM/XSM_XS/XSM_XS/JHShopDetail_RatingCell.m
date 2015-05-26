//
//  JHShopDetail_RatingCell.m
//  XSM_XS
//
//  Created by Andy on 14-12-12.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "JHShopDetail_RatingCell.h"
#import "JHShopDetail.h"
@interface JHShopDetail_RatingCell ()

@property (weak, nonatomic) IBOutlet UILabel *collectionNumberLabel;

@end

@implementation JHShopDetail_RatingCell

- (void)setShopDetail:(JHShopDetail *)shopDetail
{
    _shopDetail = shopDetail;
    
    self.collectionNumberLabel.text = [NSString stringWithFormat:@"(%@)", _shopDetail.collectionnumber];
}

+ (instancetype)shopDetail_RatingCellWithTableView:(UITableView *)tableView
{
    static NSString *ID =@"JHShopDetail_RatingCell";
    
    JHShopDetail_RatingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JHShopDetail_RatingCell" owner:nil options:nil] lastObject];
    }
    
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
