//
//  XMRatingView.h
//  XiuShemMa
//
//  Created by Apple on 14-10-8.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum kRatingViewStyle {
    kSmallStyle  = 0,
    kNormalStyle = 1
}kRatingViewStyle;

@interface XMRatingView : UIView

{
@private
    UIView  *_baseView;//存放5个黄星星，可以进行裁剪 显示星级
    UILabel *_ratingLabel;//用来显示分数
    NSMutableArray *_yellowStarsArray;//放5个黄色的星星
    NSMutableArray *_grayStarsArray;//放5个灰色的星星
    CGFloat        _ratingScore;  // 获取Model里的星级分数 保存评比的分数值
}

@property (nonatomic, assign) kRatingViewStyle style;
@property (nonatomic, assign) CGFloat ratingScore;
@property (nonatomic, assign) BOOL isShopDetail;
- (void)loadSubViews;

@end
