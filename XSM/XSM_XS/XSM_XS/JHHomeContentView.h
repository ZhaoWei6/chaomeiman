//
//  JHHomeContentView.h
//  XSM_XS
//
//  Created by Andy on 15/1/15.
//  Copyright (c) 2015年 xiushenma. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JHHomeContentView;

@protocol JHHomeContentViewDelegate <NSObject>

@optional
- (void)homeContentView:(JHHomeContentView *)homeContentView didSaveInfo:(NSInteger)info;

@end

@interface JHHomeContentView : UIView

@property (nonatomic, strong) NSArray *bannerArray;

@property(nonatomic,weak) id<JHHomeContentViewDelegate> delegate;

+ (instancetype)homeContentViewWithArray:(NSArray *)array;
- (instancetype)initWithArray:(NSArray *)array;
@end
