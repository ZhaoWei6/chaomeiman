//
//  XMRatingView.m
//  XiuShemMa
//
//  Created by Apple on 14-10-8.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMRatingView.h"

#define kNormalWidth 20
#define kNormalHeight 20

#define kSmallWidth 15
#define kSmallHeight 15

#define kFullMark 10

#define kNormalFontSize 20
#define kSmallFontSize 12
@implementation XMRatingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
- (void)loadSubViews
{
    // 初始化灰色的星星
    [self initGrayStarView];
    
    // 初始化黄色的星星
    [self initYellowStarView];
}
- (void)initGrayStarView
{
    _grayStarsArray = [[NSMutableArray alloc] initWithCapacity:5];
    for (int index = 0; index < 5; index++) {
        UIImageView *grayStarView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:grayStarView];
        grayStarView.image = [UIImage imageNamed:@"icon_star_uncomment"];
        
        [_grayStarsArray addObject:grayStarView];
    }
}

- (void)initYellowStarView
{
    _baseView = [[UIView alloc] initWithFrame:CGRectZero];
    _baseView.backgroundColor = [UIColor clearColor];
    _baseView.clipsToBounds = YES;//允许裁剪  clip裁剪
    [self addSubview:_baseView];
    
    _yellowStarsArray = [[NSMutableArray alloc] initWithCapacity:5];
    for (int index = 0; index < 5; index++) {
        UIImageView *yellowStarView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_baseView addSubview:yellowStarView];
        yellowStarView.image = [UIImage imageNamed:@"icon_star_comment"];
        
        [_yellowStarsArray addObject:yellowStarView];
    }
}

#pragma mark - Setter Method
- (void)setRatingScore:(CGFloat)ratingScore
{
    _ratingScore = ratingScore;
//    _ratingLabel.text = [NSString stringWithFormat:@"%.1f", _ratingScore];
}


#pragma mark - Layout subviews
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 取出黄色、灰色的星星，改变frame
    int width = 0;
    for (int index = 0; index < 5; index++) {
        UIView *yellowStar = _yellowStarsArray[index];
        UIView *grayStar   = _grayStarsArray[index];
        
        //指定五个黄星星的坐标个大小
        if (self.style == kSmallStyle) {
            yellowStar.frame = CGRectMake(0+width, 0, kSmallWidth, kSmallHeight);
            grayStar.frame = CGRectMake(0+width, 0, kSmallWidth, kSmallHeight);
            width += kSmallWidth;
        }else {
            yellowStar.frame = CGRectMake(0+width, 0, kNormalWidth, kNormalHeight);
            grayStar.frame = CGRectMake(0+width, 0, kNormalWidth, kNormalHeight);
            width += kNormalWidth;
        }
    }
    
    // 初始化baseView的宽度
    float baseViewWidth = 0;
    
    // 根据分数计算baseView的宽度
    baseViewWidth = self.ratingScore*2 / kFullMark * width;
    
    float height = 0;
    if (self.style == kSmallStyle) {
        _baseView.frame = CGRectMake(0, 0, baseViewWidth, kSmallHeight);
        _ratingLabel.font = [UIFont boldSystemFontOfSize:kSmallFontSize];
        height = kSmallHeight;
    }else {
        _baseView.frame = CGRectMake(0, 0, baseViewWidth, kNormalHeight);
        _ratingLabel.font = [UIFont boldSystemFontOfSize:kNormalFontSize];
        height = kNormalHeight;
    }
    
//    // 设置评级Label的frame
//    _ratingLabel.frame = CGRectMake(width, 0, 0, 0);
//    [_ratingLabel sizeToFit];
    
    // 设置视图的frame
    if (_isShopDetail) {
//        self.frame = CGRectMake(self.frame.origin.x-width, self.frame.origin.y+(self.frame.size.height-height)/2.0, width, height);
    }else{
        self.frame = CGRectMake((self.frame.size.width-width)/2, self.frame.origin.y, self.frame.size.width, height);
    }
    
}

@end
