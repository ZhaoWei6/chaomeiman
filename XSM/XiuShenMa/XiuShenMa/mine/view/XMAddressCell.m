//
//  XMAddressCell.m
//  XiuShemMa
//
//  Created by Apple on 14/10/24.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMAddressCell.h"
#import "XMContacts.h"
@interface XMAddressCell ()
{
    UIButton *checkBtn;
    UIButton *editBtn;
    
    UILabel *nameLabel;
    UILabel *sexLabel;
    UILabel *phoneLabel;
    UILabel *addressLabel;
    
    UIView  *bottomView;
}

@end

@implementation XMAddressCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadSubViews];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        checkBtn.enabled = NO;
    }else{
        checkBtn.enabled = YES;
    }
}

- (void)loadSubViews
{
    checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [checkBtn setImage:[UIImage imageNamed:@"icon_circle"] forState:UIControlStateNormal];
    [checkBtn setImage:[UIImage imageNamed:@"icon_chooce"] forState:UIControlStateDisabled];
    [checkBtn addTarget:self action:@selector(didSelectContacts:) forControlEvents:UIControlEventTouchUpInside];
    checkBtn.hidden = _isAllowHidden;
    checkBtn.imageView.contentMode = UIViewContentModeCenter;
//    checkBtn.backgroundColor = [UIColor grayColor];
    [self addSubview:checkBtn];
    
    editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [editBtn setImage:[UIImage resizedImage:@"icon_edit"] forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(editContacts) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:editBtn];
//    editBtn.backgroundColor = [UIColor redColor];
    editBtn.contentMode = UIViewContentModeScaleAspectFit;
    
    nameLabel = [[UILabel alloc] init];
    [self addSubview:nameLabel];
    
    sexLabel = [[UILabel alloc] init];
    [self addSubview:sexLabel];
    
    phoneLabel = [[UILabel alloc] init];
    [self addSubview:phoneLabel];
    
    addressLabel = [[UILabel alloc] init];
    [self addSubview:addressLabel];
    
    bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = kBorderColor;
    [self addSubview:bottomView];
}

- (void)setIsAllowHidden:(BOOL)isAllowHidden
{
    _isAllowHidden = isAllowHidden;
    
    checkBtn.hidden = _isAllowHidden;
}

- (void)setContacts:(XMContacts *)contacts
{
    _contacts = contacts;
    
    nameLabel.text = _contacts.nickname;
    sexLabel.text = [_contacts.sex isEqualToString:@"1"] ?@"先生":@"女士";
    phoneLabel.text = _contacts.telephone;
    addressLabel.text = [NSString stringWithFormat:@"%@%@",_contacts.area,_contacts.address];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //
    if (_isAllowHidden) {
        nameLabel.frame = CGRectMake(10, 10, 80, 30);
        //设置姓名标签长度自适应
        nameLabel.width = [nameLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, nameLabel.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:nameLabel.font} context:nil].size.width;
        
        sexLabel.frame = CGRectMake(nameLabel.right+10, nameLabel.top, 60, nameLabel.height);
        phoneLabel.frame = CGRectMake(sexLabel.right-10, nameLabel.top, 120, nameLabel.height);
        addressLabel.frame = CGRectMake(nameLabel.left, 40, kDeviceWidth - 40-20, 30);
    }else{
        checkBtn.frame = CGRectMake(10, self.height/2 - 20, 40, 40);
        
        nameLabel.frame = CGRectMake(checkBtn.right+10, 10, 80, 30);
        //设置姓名标签长度自适应
        nameLabel.width = [nameLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, nameLabel.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:nameLabel.font} context:nil].size.width;
        
        sexLabel.frame = CGRectMake(nameLabel.right+10, nameLabel.top, 60, nameLabel.height);
        phoneLabel.frame = CGRectMake(sexLabel.right-10, nameLabel.top, 120, nameLabel.height);
        addressLabel.frame = CGRectMake(nameLabel.left, 40, kDeviceWidth - checkBtn.width - 40-20, 30);
    }
    editBtn.frame = CGRectMake(kDeviceWidth - 50, self.height/2 - 20, 40, 40);
    bottomView.frame = CGRectMake(0, 89, kDeviceWidth, 1);
    
}

- (void)editContacts
{
    if ([self.delegate respondsToSelector:@selector(editContactsWithContacts:)]) {
        [self.delegate editContactsWithContacts:_contacts];
    }
}


- (void)didSelectContacts:(UIButton *)sender
{
    XMLog(@"点击了选择按钮");
//    _selectButton.enabled = YES;
//    sender.enabled = NO;
//    _selectButton = sender;
    
    if ([self.delegate respondsToSelector:@selector(selectCell:andContact:)]) {
        [self.delegate selectCell:self andContact:self.contacts];
    }
}






@end
