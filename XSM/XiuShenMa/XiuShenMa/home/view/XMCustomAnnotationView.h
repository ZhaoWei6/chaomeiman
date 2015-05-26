//
//  CallOutAnnotationVifew.h
//  IYLM
//
//  Created by Jian-Ye on 12-11-8.
//  Copyright (c) 2012年 Jian-Ye. All rights reserved.
#import <MAMapKit/MAMapKit.h>

@interface XMCustomAnnotationView : MAAnnotationView

@property (nonatomic,retain)UIView *contentView;

@property (nonatomic, copy)NSString *maintainer_id;

@end
