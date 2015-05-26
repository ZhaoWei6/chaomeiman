//
//  JHCommonAddressTableViewCell.m
//  XSM_XS
//
//  Created by Andy on 14-12-11.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "JHCommonAddressTableViewCell.h"
@interface JHCommonAddressTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation JHCommonAddressTableViewCell

+ (instancetype)commonAddressTableViewCellWithTableView:(UITableView *)tableView 
{
    static NSString *ID =@"JHCommonAddressTableViewCell";
    
    JHCommonAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JHCommonAddressTableViewCell" owner:nil options:nil] lastObject];
    }
    
    return cell;
}
- (IBAction)buttonClickedToEditing:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(commonAddressCell:didSelectEditButton:)])
    {
        [self.delegate commonAddressCell:self didSelectEditButton:sender];
        
    }
    
}

- (void)setCommonAdress:(JHCommonAdress *)commonAdress
{
    _commonAdress = commonAdress;
    
    NSString *sex = [_commonAdress.sex isEqualToString:@"1"] ? @"先生" : @"女士";
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@ %@", _commonAdress.nickname, sex, _commonAdress.telephone];
    
    self.addressLabel.text = [NSString stringWithFormat:@"%@%@", _commonAdress.area, _commonAdress.address];
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
