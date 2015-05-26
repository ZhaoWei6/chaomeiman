//
//  XMHomeHeadView.m
//  XiuShemMa
//
//  Created by Apple on 14-10-5.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMHomeHeadView.h"

#import "NSTimer+Addition.h"

@interface XMHomeHeadView ()<UIScrollViewDelegate>
{
    QHLabel *detailLable;
}
@property (nonatomic , assign) NSInteger currentPageIndex;//当前页数
@property (nonatomic , assign) NSInteger totalPageCount;//总页数
@property (nonatomic , strong) NSMutableArray *contentViews;//用于存放滑动视图中的图片
@property (nonatomic , strong) UIScrollView *scrollView;//

@property (nonatomic , strong) NSTimer *animationTimer;//
@property (nonatomic , assign) NSTimeInterval animationDuration;//动画持续时间

@property (nonatomic , strong) UIPageControl *pageControl;//

@end

@implementation XMHomeHeadView

- (void)setTotalPagesCount:(NSInteger (^)(void))totalPagesCount
{
    _totalPageCount = totalPagesCount();
    if (_totalPageCount > 0) {
        [self configContentViews];
        [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
    }
}

- (id)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration
{
    self = [self initWithFrame:frame];
    if (animationDuration > 0.0) {
        self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:(self.animationDuration = animationDuration)
                                                               target:self
                                                             selector:@selector(animationTimerDidFired:)
                                                             userInfo:nil
                                                              repeats:YES];
        [self.animationTimer pauseTimer];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.contentMode = UIViewContentModeCenter;
        self.scrollView.contentSize = CGSizeMake(kPhotoNumber * CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
        self.scrollView.delegate = self;
        self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame), 0);
        self.scrollView.pagingEnabled = YES;
        [self addSubview:self.scrollView];
        self.currentPageIndex = 0;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        
        //底部title和_pageControl
        UIView *bottom = [[UIView alloc] init];
        bottom.backgroundColor = [UIColor clearColor];
//        bottom.alpha = 0.5;
        [self addSubview:bottom];
        
        bottom.translatesAutoresizingMaskIntoConstraints = NO;
        [UIView setView:bottom attr:NSLayoutAttributeLeft sAttr:NSLayoutAttributeLeft constant:0];
        [UIView setView:bottom attr:NSLayoutAttributeRight sAttr:NSLayoutAttributeRight constant:0];
        [UIView setView:bottom attr:NSLayoutAttributeTop sAttr:NSLayoutAttributeTop constant:kHomeHeadViewHeight-20];
        [UIView setView:bottom attr:NSLayoutAttributeBottom sAttr:NSLayoutAttributeBottom constant:0];
//
//        detailLable = [[QHLabel alloc] init];
//        detailLable.backgroundColor = [UIColor clearColor];
//        detailLable.font = [UIFont systemFontOfSize:15];
//        detailLable.textColor = [UIColor whiteColor];
//        detailLable.text = @"第一张图片";
//        [bottom addSubview:detailLable];
//        
//        detailLable.translatesAutoresizingMaskIntoConstraints = NO;
//        [UIView setView:detailLable attr:NSLayoutAttributeLeft sAttr:NSLayoutAttributeLeft constant:10];
////        [self setView:detailLable attr:NSLayoutAttributeRight sAttr:NSLayoutAttributeRight constant:0];
//        [UIView setView:detailLable attr:NSLayoutAttributeTop sAttr:NSLayoutAttributeTop constant:0];
//        [UIView setView:detailLable attr:NSLayoutAttributeBottom sAttr:NSLayoutAttributeBottom constant:0];
//        
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.backgroundColor = [UIColor clearColor];
        _pageControl.numberOfPages = kPhotoNumber;
        _pageControl.tag = 101;
        [bottom addSubview:_pageControl];
        
        _pageControl.translatesAutoresizingMaskIntoConstraints = NO;
        [UIView setView:_pageControl attr:NSLayoutAttributeLeft sAttr:NSLayoutAttributeLeft constant:0];
        [UIView setView:_pageControl attr:NSLayoutAttributeRight sAttr:NSLayoutAttributeRight constant:0];
        [UIView setView:_pageControl attr:NSLayoutAttributeTop sAttr:NSLayoutAttributeTop constant:0];
        [UIView setView:_pageControl attr:NSLayoutAttributeBottom sAttr:NSLayoutAttributeBottom constant:0];
    }
    return self;
}

#pragma mark -
#pragma mark - 私有函数
- (void)configContentViews
{
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self setScrollViewContentDataSource];
    
    NSInteger counter = 0;
    for (UIView *contentView in self.contentViews) {
        contentView.userInteractionEnabled = YES;
        //为图片添加手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapAction:)];
        [contentView addGestureRecognizer:tapGesture];
        CGRect rightRect = contentView.frame;
        rightRect.origin = CGPointMake(CGRectGetWidth(self.scrollView.frame) * (counter ++), 0);
        
        contentView.frame = rightRect;
        [self.scrollView addSubview:contentView];
    }
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
}

/**
 *  设置scrollView的content数据源，即contentViews
 */
- (void)setScrollViewContentDataSource
{
    NSInteger previousPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];
    NSInteger rearPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
    if (self.contentViews == nil) {
        self.contentViews = [@[] mutableCopy];
    }
    [self.contentViews removeAllObjects];
    
    if (self.fetchContentViewAtIndex) {
        [self.contentViews addObject:self.fetchContentViewAtIndex(previousPageIndex)];
        [self.contentViews addObject:self.fetchContentViewAtIndex(_currentPageIndex)];
        [self.contentViews addObject:self.fetchContentViewAtIndex(rearPageIndex)];
    }
}

- (NSInteger)getValidNextPageIndexWithPageIndex:(NSInteger)currentPageIndex;
{
    if(currentPageIndex == -1) {
        return self.totalPageCount - 1;
    } else if (currentPageIndex == self.totalPageCount) {
        return 0;
    } else {
        return currentPageIndex;
    }
}

#pragma mark -
#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.animationTimer pauseTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int contentOffsetX = scrollView.contentOffset.x;
    if(contentOffsetX >= (2 * CGRectGetWidth(scrollView.frame))) {
        self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
        [self configContentViews];
    }
    if(contentOffsetX <= 0) {
        self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];
        [self configContentViews];
    }
    _pageControl.currentPage = _currentPageIndex;
    detailLable.text = _titles[_currentPageIndex];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [scrollView setContentOffset:CGPointMake(CGRectGetWidth(scrollView.frame), 0) animated:YES];
}

#pragma mark -
#pragma mark - 响应事件
- (void)animationTimerDidFired:(NSTimer *)timer
{
    CGPoint newOffset = CGPointMake(self.scrollView.contentOffset.x + CGRectGetWidth(self.scrollView.frame), self.scrollView.contentOffset.y);
    [self.scrollView setContentOffset:newOffset animated:YES];
}

- (void)contentViewTapAction:(UITapGestureRecognizer *)tap
{
    if ([self.delegatee respondsToSelector:@selector(contentViewClick:)]) {
        [self.delegatee contentViewClick:self.currentPageIndex];
    }
}


@end
