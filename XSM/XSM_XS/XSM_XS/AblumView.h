//
//  AblumView.h
//  Movie
//
//  Created by man on 14-6-28.
//  Copyright (c) 2014年 www.skedu.com.cn北京尚德致远科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AblumView;
@protocol AblumViewDelegate <NSObject>

@optional
- (void)back;

@end

@interface AblumView : UIView <UIScrollViewDelegate>
{
    UIImageView  *_imgView;
}

@property (nonatomic, assign) id <AblumViewDelegate> delegate;

@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, retain) UIScrollView *ablumScrollView;

- (void)downloadImage;

@end
