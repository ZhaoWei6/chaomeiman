//
//  WeDetailImageViewController.h
//  We_Doc
//
//  Created by ejren on 14-10-14.
//  Copyright (c) 2014年 ___PKU___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeDetailImageViewController : UIViewController<UIScrollViewDelegate>
{
    UIImageView  *_imgView;
}
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) NSString *message;

@end
