//
//  JHShopDetail_WorkerCell.m
//  XSM_XS
//
//  Created by Andy on 14-12-12.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "JHShopDetail_WorkerCell.h"
#import "JHShopDetail.h"
#import "QHLabel.h"

@interface JHShopDetail_WorkerCell()
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *maintainerNameLabel;
@property (weak, nonatomic) IBOutlet QHLabel *maintainerDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *maintainCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodEvaluateLabel;

@end

@implementation JHShopDetail_WorkerCell

- (void)setShopDetail:(JHShopDetail *)shopDetail
{
    _shopDetail = shopDetail;
    
    self.shopNameLabel.text = [NSString stringWithFormat:@"%@", _shopDetail.shop];
    self.maintainerNameLabel.text = [NSString stringWithFormat:@"%@", _shopDetail.nickname];
    self.maintainerDescriptionLabel.text = [NSString stringWithFormat:@"%@", _shopDetail.desc];
    self.maintainCountLabel.text = [NSString stringWithFormat:@"%@部", _shopDetail.maintaincount];
    self.goodEvaluateLabel.text = [NSString stringWithFormat:@"%0.0f%%", ([_shopDetail.evaluate floatValue]/5) * 100];
    
}


+ (instancetype)shopDetail_WorkerCellWithTableView:(UITableView *)tableView
{
    static NSString *ID =@"JHShopDetail_WorkerCell";
    
    JHShopDetail_WorkerCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JHShopDetail_WorkerCell" owner:nil options:nil] lastObject];
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
