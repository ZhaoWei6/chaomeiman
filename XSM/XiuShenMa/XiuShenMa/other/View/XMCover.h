//
//  TGCover.h
//  团购
//
//  Created by app04 on 14-7-28.
//  Copyright (c) 2014年 app04. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMCover : UIView

+ (id)cover;
+ (id)coverWithTarget:(id)target action:(SEL)action;

- (void)reset;

@end
