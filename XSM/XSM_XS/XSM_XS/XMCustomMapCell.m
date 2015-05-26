//
//  XMCustomMapCell.m
//  XiuShemMa
//
//  Created by Apple on 14-10-16.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMCustomMapCell.h"
//#import "XMRatingView.h"
#import "XMMap.h"
#import "XMDealTool.h"
#import "XMCommon.h"
#import "Measurement.h"
#import "UIViewExt.h"
#import "UIImageView+WebCache.h"
#import "XMShopDetailViewController.h"
#import "XMNavigationViewController.h"
@interface XMCustomMapCell ()
{
    UIImageView *imageView;
    UILabel *titleLabel;
    UIImageView *ratingView;
    
}
@end

@implementation XMCustomMapCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadSubViews];
                self.userInteractionEnabled = YES;
        
                [self addGestureRecognizer:[[UIGestureRecognizer alloc] initWithTarget:self action:@selector(clickMapCell:)]];
    }
    return self;
}

- (void)loadSubViews
{
    
    
    UIButton   *button=[[UIButton alloc]init];
    button.frame=CGRectMake(0, 0, 120, 60);
    
//    [button addTarget:self action:@selector(buttonSelector:) forControlEvents:UIControlEventTouchDown];
//    button.backgroundColor=[UIColor clearColor];
//    [self addSubview:button];
    
    
    imageView = [[UIImageView alloc] init];
//    imageView.backgroundColor = [UIColor lightGrayColor];
    
    [self addSubview:imageView];
    
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = kMapCellHeight/3;
    imageView.layer.borderWidth = 1;
    imageView.layer.borderColor=kBorderColor.CGColor;
    titleLabel = [[UILabel alloc] init];
//    titleLabel.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:titleLabel];
    
    ratingView = [[UIImageView alloc] init];
//    detailLabel.backgroundColor = [UIColor lightGrayColor];
    ratingView.contentMode = UIViewContentModeScaleAspectFit;
   [self addSubview:ratingView];
//    ratingView.isShopDetail = YES;
//    ratingView.style = kSmallStyle;
//    ratingView.ratingScore=_map.evaluate;
    
  
    
    
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    imageView.frame = CGRectMake(5, kMapCellHeight/6, kMapCellHeight*2/3, kMapCellHeight*2/3);
    titleLabel.frame = CGRectMake(imageView.right, imageView.top, self.width-imageView.width-10, kMapCellHeight/3);
    ratingView.frame = CGRectMake(titleLabel.left, titleLabel.bottom, titleLabel.width, titleLabel.height);
//    ratingView.frame=CGRectMake(nameLabel.right, nameLabel.bottom, 0, 0);
//    ratingView.center = CGPointMake(titleLabel.center.x+75/2.0, titleLabel.bottom+ratingView.height/2.0);
    
//    ratingView.backgroundColor = [UIColor redColor];
    
//    [imageView setImageWithURL:[NSURL URLWithString:_map.photo]];
    [imageView setImageWithURL:[NSURL URLWithString:_map.photo] placeholderImage:[UIImage imageNamed:@"picture01"]];
    titleLabel.text=_map.nickname;
    titleLabel.textColor = kTextFontColor333;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    NSString *r = [NSString stringWithFormat:@"rating_%.0f",_map.evaluate];
    [ratingView setImage:[UIImage imageNamed:r]];
    
    XMLog(@"评分%f",_map.evaluate);
    XMLog(@"%f,%f,%f,%f",ratingView.left,ratingView.top,ratingView.width,ratingView.height);
}



- (void)clickMapCell:(UITapGestureRecognizer *)sender
{
    if ([_delegate respondsToSelector:@selector(clickMapCellWith:)]) {
        [_delegate clickMapCellWith:_map.maintainer_id];

        
        
    }
}





@end
