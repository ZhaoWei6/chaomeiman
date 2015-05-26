//
//  JHHomeContentView.m
//  XSM_XS
//
//  Created by Andy on 15/1/15.
//  Copyright (c) 2015年 xiushenma. All rights reserved.
//

#import "JHHomeContentView.h"
#import "XMHomeHeadView.h"
#import "XMBanner.h"

#import "XMCommon.h"
#import "UIImageView+WebCache.h"

@interface JHHomeContentView()<XMHomeHeadViewDelegate>

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttones;

//@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *button;

@property (weak, nonatomic) IBOutlet UIView *adScrollView;



- (IBAction)buttonClickedToRepairmanList:(UIButton *)sender;

@end

@implementation JHHomeContentView

+ (instancetype)homeContentViewWithArray:(NSArray *)array
{
    return [[self alloc] initWithArray:array];
}

- (instancetype)initWithArray:(NSArray *)array
{
    self = [[JHHomeContentView alloc] init];
    
    self = [[[NSBundle mainBundle] loadNibNamed:@"JHHomeContentView" owner:nil options:nil] lastObject];
    
    for (UIButton *subButton in self.buttones) {
        [subButton setExclusiveTouch:YES];
    }
    
    return self;
}

- (void)setBannerArray:(NSArray *)bannerArray
{
    _bannerArray = bannerArray;
    [self loadHeadView];
}

#pragma mark 加载轮播
- (void)loadHeadView
{
    // 设置轮播内容区的图片
    NSMutableArray *viewsArray = [@[] mutableCopy];
    NSMutableArray *titlesArray = [@[] mutableCopy];
    
    for (int i = 0; i < kPhotoNumber; ++i) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, self.adScrollView.frame.size.height)];
        imageView.contentMode = UIViewContentModeScaleToFill;
        XMBanner *ban = _bannerArray[i];
        [imageView setImageWithURL:[NSURL URLWithString:ban.banner] placeholderImage:[UIImage imageNamed:@"01"]];
        [viewsArray addObject:imageView];
        [titlesArray addObject:ban.descripe];
    }
    
    // 实例化轮播对象(初始化frame与轮播间隔)
    XMHomeHeadView *head = [[XMHomeHeadView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, self.adScrollView.frame.size.height) animationDuration:4];
    
    // 设置轮播的当前页
    head.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
        return viewsArray[pageIndex];
    };
    
    // 设置轮播总页数
    head.totalPagesCount = ^NSInteger(void){
        return kPhotoNumber;
    };
    // 设置代理
    head.delegatee = self;
    [self.adScrollView addSubview:head];
}

/**
 *  10001:三星
 *  10002:华为
 *  10003:联想
 *  10004:魅族
 *  10005:苹果
 *  10006:小米
 *  10007:微软
 *  10008:中兴
 *  10009:HTC
 *  10010:其他
 *  10011:手机回收
 *  10012:修锁
 */
- (IBAction)buttonClickedToRepairmanList:(UIButton *)sender {
    
    NSLog(@"--------事件ID：%ld------", (long)sender.tag);
    
    if ([self.delegate respondsToSelector:@selector(homeContentView:didSaveInfo:)]) {
        [self.delegate homeContentView:self didSaveInfo:sender.tag];
    }
}
@end
