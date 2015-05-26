//
//  JHOrderStatusTableViewCell.m
//  XSM_XS
//
//  Created by Andy on 14-12-4.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "JHOrderStatusTableViewCell.h"
#import "UIViewExt.h"

@interface JHOrderStatusTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *cellTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cellIconView;
@property (weak, nonatomic) IBOutlet UIView *cellTopDivider;
@property (weak, nonatomic) IBOutlet UIView *cellBottomDivider;
@property(nonatomic, strong) NSDictionary *iconDict;

@end

@implementation JHOrderStatusTableViewCell

+ (instancetype)orderStatusTableViewCellWithTableView:(UITableView *)tableView
{
    static NSString *ID =@"JHOrderStatusTableViewCell";
    
    JHOrderStatusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JHOrderStatusTableViewCell" owner:nil options:nil] lastObject];
    }
    
    return cell;
}

- (void)setupIconImageInfo
{
    self.iconDict = @{@"10" : @"icon_order_unchecked",
                      @"11" : @"icon_order",
                      @"20" : @"icon_order_over_unchecked",
                      @"21" : @"icon_order_over",
                      @"30" : @"icon_on_road_unchecked",
                      @"31" : @"icon_on_road",
                      @"40" : @"icon_call_unchecked",
                      @"41" : @"icon_call",
                      @"50" : @"icon_judge_unchecked",
                      @"51" : @"icon_judge",};
}


- (void)setDictionary:(NSDictionary *)dictionary
{
    _dictionary = dictionary;
    [self setupIconImageInfo];
    
    self.cellTimeLabel.text = dictionary[@"createtime"];
    
    NSString *title,*status;
    if ([dictionary[@"orderstatus"] isEqualToString:@"0"]) {
        self.cellTopDivider.hidden = YES;
        self.cellIconView.image = [UIImage imageNamed:self.iconDict[@"11"]];
        
        title = @"用户提交订单";
        status = @"等待接单";
    }else if ([dictionary[@"orderstatus"] isEqualToString:@"1"]){
        self.cellIconView.image = [UIImage imageNamed:self.iconDict[@"21"]];
        
        title = @"确认接单";
        status = @"修神已确认接单";
    }else if ([dictionary[@"orderstatus"] isEqualToString:@"2"]){
        self.cellIconView.image = [UIImage imageNamed:self.iconDict[@"31"]];
        
        title = @"变身修神";
        status = @"在路上狂奔中";
    }else if ([dictionary[@"orderstatus"] isEqualToString:@"3"]){
        self.cellIconView.image = [UIImage imageNamed:self.iconDict[@"41"]];
        
        title = @"到达接头地点";
        status = @"联系客户";
    }else if ([dictionary[@"orderstatus"] isEqualToString:@"4"]){
        self.cellBottomDivider.hidden = YES;
        
        self.cellIconView.image = [UIImage imageNamed:self.iconDict[@"51"]];
        
        title = @"等待用户评价";
        status = @"提醒用户评价";
    }
    
    if ([dictionary[@"orderstatus"] isEqualToString:@"-1"]){
        self.cellIconView.image = [UIImage imageNamed:self.iconDict[@"51"]];
        
        title = @"订单已取消";
        self.cellStatusLabel.hidden = YES;
        self.cellBottomDivider.hidden = YES;
    }
    
    self.cellTitleLabel.text = title;
    self.cellStatusLabel.text = status;
    // 设置IconView
//    [self settingIconViewWith:dictionary];
    
    // 设直线条
//    [self settingDividerWith:dictionary];
}

- (void)setDefaultDictionary:(NSDictionary *)defaultDictionary
{
    _defaultDictionary = defaultDictionary;
    [self setupIconImageInfo];
    
    self.cellTimeLabel.hidden = YES;
    self.cellStatusLabel.hidden = YES;
    
    [self.cellBottomDivider setBackgroundColor:[UIColor lightGrayColor]];
    [self.cellTopDivider setBackgroundColor:[UIColor lightGrayColor]];
    
    NSString *title;
    if ([defaultDictionary[@"orderstatus"] isEqualToString:@"0"]) {
        self.cellTopDivider.hidden = YES;
        self.cellIconView.image = [UIImage imageNamed:self.iconDict[@"10"]];
        
        title = @"用户提交订单";
    }else if ([defaultDictionary[@"orderstatus"] isEqualToString:@"1"]){
        self.cellIconView.image = [UIImage imageNamed:self.iconDict[@"20"]];
        
        title = @"确认接单";
    }else if ([defaultDictionary[@"orderstatus"] isEqualToString:@"2"]){
        self.cellIconView.image = [UIImage imageNamed:self.iconDict[@"30"]];
        
        title = @"变身修神";
    }else if ([defaultDictionary[@"orderstatus"] isEqualToString:@"3"]){
        self.cellIconView.image = [UIImage imageNamed:self.iconDict[@"40"]];
        
        title = @"到达接头地点";
    }else if ([defaultDictionary[@"orderstatus"] isEqualToString:@"4"]){
        self.cellBottomDivider.hidden = YES;
        
        self.cellIconView.image = [UIImage imageNamed:self.iconDict[@"50"]];
        
        title = @"等待用户评价";
    }
    
    self.cellTitleLabel.text = title;
}



- (void)settingDividerWith:(NSDictionary *)dictionary
{
    if ([dictionary[@"icon"] isEqualToString:@"20"] ||
        [dictionary[@"icon"] isEqualToString:@"30"] ||
        [dictionary[@"icon"] isEqualToString:@"40"] ||
        [dictionary[@"icon"] isEqualToString:@"50"])
    {
        [self.cellBottomDivider setBackgroundColor:[UIColor lightGrayColor]];
        [self.cellTopDivider setBackgroundColor:[UIColor lightGrayColor]];
    
        [self.cellTimeLabel setHidden:YES];
        
        [self.cellStatusLabel setHidden:YES];
        
        
    }
}

- (void)layoutSubviews
{
    if (self.cellStatusLabel.hidden)
    {
        
        [self.cellTitleLabel setFrame:CGRectMake(91, 30, 150, 21)];
        [self.cellTitleLabel setTextColor:[UIColor lightGrayColor]];
        
    }
}
- (void)settingIconViewWith:(NSDictionary *)dictionary
{
    if ([dictionary[@"icon"] isEqualToString:@"10"]) {
        
        self.cellIconView.image = [UIImage imageNamed:self.iconDict[@"10"]];
        
    }else if ([dictionary[@"icon"] isEqualToString:@"11"]){
        
        self.cellIconView.image = [UIImage imageNamed:self.iconDict[@"11"]];
        
    }else if ([dictionary[@"icon"] isEqualToString:@"20"]){
        
        self.cellIconView.image = [UIImage imageNamed:self.iconDict[@"20"]];
        
    }else if ([dictionary[@"icon"] isEqualToString:@"21"]){
        
        self.cellIconView.image = [UIImage imageNamed:self.iconDict[@"21"]];
        
    }else if ([dictionary[@"icon"] isEqualToString:@"30"]){
        
        self.cellIconView.image = [UIImage imageNamed:self.iconDict[@"30"]];
        
    }else if ([dictionary[@"icon"] isEqualToString:@"31"]){
        
        self.cellIconView.image = [UIImage imageNamed:self.iconDict[@"31"]];
        
    }else if ([dictionary[@"icon"] isEqualToString:@"40"]){
        
        self.cellIconView.image = [UIImage imageNamed:self.iconDict[@"40"]];
        
    }else if ([dictionary[@"icon"] isEqualToString:@"41"]){
        
        self.cellIconView.image = [UIImage imageNamed:self.iconDict[@"41"]];
        
    }else if ([dictionary[@"icon"] isEqualToString:@"50"]){
        
        self.cellIconView.image = [UIImage imageNamed:self.iconDict[@"50"]];
        
    }else{
        
        self.cellIconView.image = [UIImage imageNamed:self.iconDict[@"51"]];
        
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
