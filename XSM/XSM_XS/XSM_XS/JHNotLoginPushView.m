//
//  JHNotLoginPushView.m
//  XSM_XS
//
//  Created by Andy on 14-12-5.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "JHNotLoginPushView.h"


@implementation JHNotLoginPushView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)notLoginPushView
{
    JHNotLoginPushView *notLoginPushView = [[[NSBundle mainBundle] loadNibNamed:@"JHNotLoginPushView" owner:nil options:nil] lastObject];
    return notLoginPushView;
}

- (IBAction)buttonClickedToLoginAction {
    
    if ([self.delegate respondsToSelector:@selector(notLoginPushView:didselectedWithButtonTag:)]) {
        [self.delegate notLoginPushView:self didselectedWithButtonTag:0];
    }
    
    
}
@end
