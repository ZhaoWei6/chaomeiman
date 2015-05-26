//
//  ShowNotice.m
//  天天网
//
//  Created by zhaoweibing on 14-4-25.
//  Copyright (c) 2014年 Ios. All rights reserved.
//

#import "ShowNotice.h"

@interface ShowNotice ()

@property (nonatomic, retain) UIImageView *viewBg;//黑色半透明背景色
@property (nonatomic, retain) UILabel *labelMsg;//提示文本
@property (nonatomic, retain) UIActivityIndicatorView *activityView;//指示器


@end

@implementation ShowNotice

- (id)init
{
    return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, 64, kDeviceWidth, kDeviceHeight-64-49);
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
        
        //黑色透明背景
        self.viewBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120, 100)];
//        _viewBg.image=[UIImage imageNamed:@"02"];
        _viewBg.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7f];
        _viewBg.center = CGPointMake(self.width/2, self.height/2);
        _viewBg.layer.masksToBounds = YES;
        _viewBg.layer.cornerRadius = 8;
       _viewBg.layer.shadowColor = [UIColor blackColor].CGColor;
        _viewBg.layer.opacity = 0.85f;
        [self addSubview:_viewBg];
        
        //指示器
        self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityView.backgroundColor = [UIColor clearColor];
        [self addSubview:_activityView];
        _activityView.center = CGPointMake(self.width/2, 30+_viewBg.top);
        
        //文本 提示信息
        self.labelMsg = [[UILabel alloc] initWithFrame:CGRectMake(_viewBg.left, _viewBg.height+_viewBg.top-35, _viewBg.width, 21)];
        _labelMsg.backgroundColor = [UIColor clearColor];
        _labelMsg.textAlignment = NSTextAlignmentCenter;
        _labelMsg.textColor = [UIColor whiteColor];
        _labelMsg.font = [UIFont systemFontOfSize:15];
        [self addSubview:_labelMsg];
        
    }
    return self;
}

+ (ShowNotice *)showNoticeTo:(UIView *)view msg:(NSString *)msg animated:(BOOL)animated
{
    ShowNotice *notice = [[ShowNotice alloc] init];
    notice.labelMsg.text = msg;
    
    [notice.activityView startAnimating];
    [view addSubview:notice];
//    notice.center = [UIApplication sharedApplication].keyWindow.center;
   
    if (animated) {
        notice.alpha = 0;
        [UIView animateWithDuration:0.2f animations:^{
            notice.alpha = 1;
        }];
    }
    
    return notice;
}

- (void)hideNoticeAnimated:(BOOL)animated
{
    if (animated == NO) {
        [self.activityView startAnimating];
        [self removeFromSuperview];
        return ;
    }
    
    [UIView animateWithDuration:0.5f animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self.activityView startAnimating];
        [self removeFromSuperview];
    }];
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
