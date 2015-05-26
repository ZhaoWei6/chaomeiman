//
//  JHCheckBar.h
//  XSM_XS
//
//  Created by Andy on 14-12-8.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum kButtonType {
    
    kSingleButton  = 0,
    kCheckButton  = 1,
    
}kButtonType;

@class JHCheckBar;

@protocol JHCheckBarDelegate <NSObject>

@optional
/** JHCheckBar代理：点击关闭按钮 */
- (void)checkBar:(JHCheckBar *)checkBar didClickCloseButton:(UIButton *)button;

/** JHCheckBar代理：点击确认按钮 */
- (void)checkBar:(JHCheckBar *)checkBar didClickOkButton:(UIButton *)button;

- (void)checkBar:(JHCheckBar *)checkBar didClickSingleChooseButton:(UIButton *)button;

- (void)checkBar:(JHCheckBar *)checkBar didClickCheckChooseButton:(UIButton *)button;
@end

@interface JHCheckBar : UIView
// 按钮类型
@property(nonatomic, assign) NSInteger index;

// 按钮类型
@property(nonatomic, assign) kButtonType buttonStyle;
@property(nonatomic, weak) id <JHCheckBarDelegate> delegate;


/**
 *  根据ID创建复选框
 *
 *  @param ID ID
 *
 *  @return 10001:业务范围，10002：维修品类，10003：主修品牌，10004：服务类型
 */

//+ (instancetype)checkBarWithArray:(NSArray *)array andTitle:(NSString *)barTitle andFrame:(CGRect)frame;
+ (instancetype)checkBarWithArray:(NSArray *)array andTitle:(NSString *)barTitle andFrame:(CGRect)frame andButtonType:(kButtonType)buttonType;
//- (instancetype)initWithArray:(NSArray *)array andTitle:(NSString *)barTitle andFrame:(CGRect)frame;
- (instancetype)initWithArray:(NSArray *)array andTitle:(NSString *)barTitle andFrame:(CGRect)frame andButtonType:(kButtonType)buttonType;

@end
