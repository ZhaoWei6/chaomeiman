//
//  JHRepairmanCell.m
//  XSM_XS
//
//  Created by Andy on 15/1/12.
//  Copyright (c) 2015年 xiushenma. All rights reserved.
//

#define JHBlueColor [UIColor colorWithRed:115/255.0 green:221/255.0 blue:247/255.0 alpha:1]
#define JHRedColor [UIColor colorWithRed:249/255.0 green:154/255.0 blue:132/255.0 alpha:1]
#define JHGreenColor [UIColor colorWithRed:121/255.0 green:232/255.0 blue:181/255.0 alpha:1]

#import "JHRepairmanCell.h"
#import "XMRepairman.h"
#import "UIImageView+WebCache.h"

@interface JHRepairmanCell()
@property (weak, nonatomic) IBOutlet UIImageView *shopIcon;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UIImageView *shopStarCount;
@property (weak, nonatomic) IBOutlet UILabel *repairedCount;
@property (weak, nonatomic) IBOutlet UILabel *shopDistance;
@property (weak, nonatomic) IBOutlet UILabel *shopRepairman;


@end

@implementation JHRepairmanCell

+ (instancetype)repairmanCellWithTableView:(UITableView *)tableView
{
    static NSString *ID =@"JHRepairmanCell";
    
    JHRepairmanCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JHRepairmanCell" owner:nil options:nil] lastObject];
    }
    
    return cell;
}

- (void)setRepairman:(XMRepairman *)repairman
{
    _repairman = repairman;
    
    // 店铺名称
    _shopName.text = repairman.shop;
    
    // 店铺距离
    if (repairman.distance < 500) {
        _shopDistance.text = @"<500m";
    }else{
        CGFloat distance = _repairman.distance/1000;
        if (distance < 1) {
            distance += 1;
        }
        if (distance < 10){
            
            _shopDistance.text = [NSString stringWithFormat:@"<%.1fkm",distance];
            
        }else if (distance < 1000){
            
            _shopDistance.text = [NSString stringWithFormat:@"<%.0fkm",distance];
            
        }else{
            
            _shopDistance.text = [NSString stringWithFormat:@"%.1fWM",distance/10000];
            
        }
    }
    
    // 店铺封面
    [_shopIcon setImageWithURL:[NSURL URLWithString:repairman.photo] placeholderImage:[UIImage imageNamed:@"zhanwei_03"]];
    
    //修身名称
    _shopRepairman.text = repairman.nickname;
    
    // 已修手机数
    _repairedCount.text = [NSString stringWithFormat:@"已修:%li部",(long)repairman.maintaincount];
    
    NSString *starName = [NSString stringWithFormat:@"rating_%d", (int)repairman.evaluate];
    [_shopStarCount setImage:[UIImage imageNamed:starName]];
    
    // 服务品类
    NSArray *array = repairman.servicelist;
    NSArray *servicearray = @[@"上门", @"寄修", @"进店"];
    NSArray *colorarray = @[JHBlueColor, JHGreenColor, JHRedColor];
    
    CGFloat label_y = 101;
    CGFloat label_w = 31;
    CGFloat label_h = 15;
    CGFloat intervel = 4;
    
    for (int index = 0; index < array.count; ++index) {
        
        CGFloat label_x = 96 + (label_w + intervel) * index;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(label_x, label_y, label_w, label_h)];
        int number = [array[index] intValue];
        [label setTextColor:[UIColor whiteColor]];
        [label setFont:[UIFont boldSystemFontOfSize:12]];
//        [label setShadowColor:[UIColor whiteColor]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setText:servicearray[number - 1]];
        [label setBackgroundColor:colorarray[number - 1]];
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = 3;
        [self addSubview:label];
        
    }
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
