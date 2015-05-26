//
//  TGCover.h
//  团购
//
//  Created by app35 on 14-7-28.
//  Copyright (c) 2014年 sk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TGCover : UIView
+ (id)cover;
+ (id)coverWithTarget:(id)target action:(SEL)action;

- (void)reset;
@end
