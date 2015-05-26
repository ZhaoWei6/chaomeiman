//
//  XMTextField.m
//  XiuShemMa
//
//  Created by Apple on 14-10-8.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMTextField.h"

@interface XMTextField ()
{
    UIImageView *left;
}
@end
@implementation XMTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        left = [[UIImageView alloc] initWithFrame:CGRectZero];
        left.contentMode = UIViewContentModeScaleAspectFit;
        self.leftView = left;
        self.leftViewMode = UITextFieldViewModeAlways;
        //
//      self.backgroundColor = [UIColor lightGrayColor];
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 5;
    }
    return self;
}

- (void)layoutSubviews
{
    left.frame = CGRectMake(0, 5, 30, 30);
    [left setImage:[UIImage imageNamed:_iconName]];
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectMake(5, 7, bounds.size.width-10, bounds.size.height-14);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectMake(5, 7, bounds.size.width-10, bounds.size.height-14);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
