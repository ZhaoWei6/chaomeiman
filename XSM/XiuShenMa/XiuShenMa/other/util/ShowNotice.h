//
//  ShowNotice.h
//  天天网
//
//  Created by zhaoweibing on 14-4-25.
//  Copyright (c) 2014年 Ios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowNotice : UIView

+ (ShowNotice *)showNoticeTo:(UIView *)view msg:(NSString *)msg animated:(BOOL)animated;
- (void)hideNoticeAnimated:(BOOL)animated;

@end
