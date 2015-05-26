//
//  XMCustomMapCell.m
//  XiuShemMa
//
//  Created by Apple on 14-10-16.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMCustomMapCell.h"
#import "XMRatingView.h"
#import "XMMap.h"
#import "XMDealTool.h"
@interface XMCustomMapCell ()
{
    UIImageView *imageView;
    QHLabel *titleLabel;
    XMRatingView *ratingView;
}
@end

@implementation XMCustomMapCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadSubViews];
//        self.userInteractionEnabled = YES;
//        [self addGestureRecognizer:[[UIGestureRecognizer alloc] initWithTarget:self action:@selector(clickMapCell:)]];
    }
    return self;
}

- (void)loadSubViews
{
    imageView = [[UIImageView alloc] init];
//    imageView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:imageView];
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = kMapCellHeight/3;
    imageView.layer.borderWidth = 1;
    
    titleLabel = [[QHLabel alloc] init];
//    titleLabel.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:titleLabel];
    
    ratingView = [[XMRatingView alloc] init];
//    detailLabel.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:ratingView];
    ratingView.style = kSmallStyle;
}

- (void)setMap:(XMMap *)map
{
    _map = map;
    
    [imageView setImageWithURL:[NSURL URLWithString:map.photo] placeholderImage:[UIImage imageNamed:@"picture01"]];
    titleLabel.text = map.nickname;
    titleLabel.textColor = kTextFontColor333;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    ratingView.ratingScore = map.evaluate;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    imageView.frame = CGRectMake(5, kMapCellHeight/6, kMapCellHeight*2/3, kMapCellHeight*2/3);
    titleLabel.frame = CGRectMake(imageView.right, imageView.top, self.width-imageView.width-10, kMapCellHeight/3);
    ratingView.frame = CGRectMake(kMapCellWidth, titleLabel.bottom, 0, 0);
    ratingView.center = CGPointMake(titleLabel.center.x+75/2.0, titleLabel.bottom+ratingView.height/2.0);
}


- (void)clickMapCell:(UITapGestureRecognizer *)sender
{
    if ([_delegate respondsToSelector:@selector(clickMapCellWith:)]) {
        [_delegate clickMapCellWith:_map.maintainer_id];
    }
}

- (void)dealloc
{
    [imageView removeFromSuperview];
    [titleLabel removeFromSuperview];
    [ratingView removeFromSuperview];
    
    imageView = nil;
    titleLabel = nil;
    ratingView = nil;
}

@end
