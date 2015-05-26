//
//  JHNotLoginPushView.h
//  XSM_XS
//
//  Created by Andy on 14-12-5.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JHNotLoginPushView;

@protocol JHNotLoginPushViewDelegate <NSObject>

@optional
- (void)notLoginPushView:(JHNotLoginPushView *)notLoginPushView didselectedWithButtonTag:(NSInteger)tag;


@end

@interface JHNotLoginPushView : UIView

@property(nonatomic, weak) id <JHNotLoginPushViewDelegate> delegate;

+ (instancetype)notLoginPushView;

- (IBAction)buttonClickedToLoginAction;

@end
