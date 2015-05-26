//
//  XMGoodsView.m
//  XiuShemMa
//
//  Created by Apple on 14-10-8.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMGoodsView.h"
#import "XMCommon.h"
#import "UIViewExt.h"
#import "UIImageView+WebCache.h"

#pragma mark - ******************************CustomLabel************************************
@interface CustomLabel : UILabel

@end

@implementation CustomLabel

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    // 1.获得上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 2.设置颜色
    [self.textColor setStroke];
    
    // 3.画线
    CGFloat y = rect.size.height * 0.5;
    CGContextMoveToPoint(ctx, 0, y);
    CGFloat endX = rect.size.width;
    CGContextAddLineToPoint(ctx, endX, y);
    
    // 4.渲染
    CGContextStrokePath(ctx);
}

@end
#pragma mark - ******************************XMGoodsView************************************
@implementation XMGoodsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)loadSubViewWithIcon:(NSString *)icon title:(NSString *)title price:(CGFloat)price oldprice:(CGFloat)oldprice
{
    //实例化对象
    UIImageView *imageView = [[UIImageView alloc] init];//图像
    UILabel   *titleLabel = [[UILabel alloc] init];//标题
    UILabel   *priceLable = [[UILabel alloc] init];//现价
    CustomLabel  *priceLabelOld=[[CustomLabel alloc]init];//原价
    
    //内容设定
    [imageView setImageWithURL:[NSURL URLWithString:icon]];
    imageView.backgroundColor = [UIColor lightGrayColor];
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = title;
    
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    priceLable.font = [UIFont systemFontOfSize:12];
    priceLable.text = [NSString stringWithFormat:@"¥%.1f",price];
    priceLable.textColor = XMColor(254, 85, 3);
    priceLabelOld.font = [UIFont systemFontOfSize:9];
    priceLabelOld.text = [NSString stringWithFormat:@" ¥%.1f ",oldprice];
    priceLabelOld.textColor = XMColor(254, 85, 3);
    
    
    //位置设定
    imageView.frame = CGRectMake(0, 0, self.width, self.height*2/3);
    titleLabel.frame = CGRectMake(0, imageView.bottom, self.width, 40);
    titleLabel.numberOfLines=2;
    priceLable.frame = CGRectMake(0, titleLabel.bottom, self.width, self.height/6);
    priceLable.width = [priceLable.text boundingRectWithSize:CGSizeMake(titleLabel.width, priceLable.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:priceLable.font} context:nil].size.width+4;
    
    priceLabelOld.frame=CGRectMake(priceLable.right, priceLable.top, priceLable.width, self.height/6);
    
    priceLabelOld.width = [priceLabelOld.text boundingRectWithSize:CGSizeMake(titleLabel.width, priceLabelOld.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:priceLabelOld.font} context:nil].size.width;
    //加入父视图
    [self addSubview:imageView];
    [self addSubview:titleLabel];
    [self addSubview:priceLable];
    [self addSubview:priceLabelOld];
    
    [imageView setUserInteractionEnabled:YES];
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchImage:)]];
}

- (void)touchImage:(UITapGestureRecognizer *)sender
{
    UIImageView *imageView = (UIImageView *)[sender view];
    if ([self.delegate respondsToSelector:@selector(touchImageViewWithImage:)]) {
        [self.delegate touchImageViewWithImage:imageView.image];
    }
}



@end
