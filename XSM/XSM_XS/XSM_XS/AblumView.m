//
//  AblumView.m
//  Movie
//
//  Created by man on 14-6-28.
//  Copyright (c) 2014年 www.skedu.com.cn北京尚德致远科技有限公司. All rights reserved.
//

#import "AblumView.h"
#import "UIViewExt.h"
#import "UIImageView+WebCache.h"
@implementation AblumView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _ablumScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _ablumScrollView.minimumZoomScale = 1;
        _ablumScrollView.maximumZoomScale = 2.5;
        _ablumScrollView.showsHorizontalScrollIndicator = NO;
        _ablumScrollView.showsVerticalScrollIndicator = NO;
        _ablumScrollView.scrollsToTop = NO;
        _ablumScrollView.delegate = self;
        _ablumScrollView.backgroundColor = [UIColor blackColor];
        [self addSubview:_ablumScrollView];
        
        _imgView = [[UIImageView alloc] initWithFrame:_ablumScrollView.frame];
//        _imgView.image = [UIImage imageWithName:_imageName];
        _imgView.userInteractionEnabled = YES;
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        [_ablumScrollView addSubview:_imgView];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomOutOrIn:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)];
        [self addGestureRecognizer:singleTap];
        
        // 双击时忽略掉单击事件
        [singleTap requireGestureRecognizerToFail:doubleTap];
    }
    return self;
}

#pragma mark - Public Method
- (void)downloadImage
{
    if (_imgView.image == nil) {
        // 把图片异步请求下来
        [_imgView setImageWithURL:[NSURL URLWithString:_imageName]];
    }
}

#pragma mark - ScrollView Delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView//按住option键缩放
{
    return _imgView;
}

#pragma mark - target Method
- (void)zoomOutOrIn:(UITapGestureRecognizer *)tap//双击缩放
{
    // 获取到用户点击位置
    CGPoint point = [tap locationInView:_imgView];
    
    // NSLog(@"%@", NSStringFromCGPoint(point));
    
    if (_ablumScrollView.zoomScale == 1) {
        
        [_ablumScrollView zoomToRect:CGRectMake(point.x-40, point.y-40, 80, 80) animated:YES];
        
    }else {
        [_ablumScrollView setZoomScale:1 animated:YES];
    }
}

- (void)imageClick:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(back)]) {
        [self.delegate back];
    }
}

@end
