//
//  XMAddAddressCell.m
//  XiuShemMa
//
//  Created by Apple on 14/10/27.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMAddAddressCell.h"

@interface XMAddAddressCell ()
{
    UIView *view;
    UILabel *label;
}
@end

@implementation XMAddAddressCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadSubViews];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadSubViews
{
    view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = XMButtonBg;
    view.layer.cornerRadius = 5;
    [self addSubview:view];
    
    label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:15];
    [view addSubview:label];
}

- (void)layoutSubviews
{
    view.frame = CGRectMake(20, (self.height-kUIButtonHeight)/2, self.width - 40, kUIButtonHeight);
    
    label.frame = view.bounds;
    label.text = @"确认";
}

@end
