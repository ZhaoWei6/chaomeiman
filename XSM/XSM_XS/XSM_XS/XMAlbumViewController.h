//
//  XMAlbumViewController.h
//  XiuShemMa
//
//  Created by Apple on 14-10-9.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMBaseViewController.h"
#import "AblumView.h"
@interface XMAlbumViewController : XMBaseViewController<AblumViewDelegate, UIScrollViewDelegate>
{
@private
    UIScrollView   *_contentScrollView;//滑动视图-->相册视图
}

@property (nonatomic , retain) NSArray *array;
@property (nonatomic , assign) NSInteger index;

@end
