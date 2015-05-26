//
//  XMCustomMapCell.h
//  XiuShemMa
//
//  Created by Apple on 14-10-16.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMMap.h"




@protocol XMMapCellClickDelegate <NSObject>

- (void)clickMapCellWith:(NSString *)maintainer;

@end

@interface XMCustomMapCell : UIView

//@property (nonatomic , retain)NSDictionary *content;
//@property (nonatomic , copy)NSString *imageURL;
//@property (nonatomic , copy)NSString *title;
//@property (nonatomic , assign)CGFloat detail;


@property (nonatomic , copy ) NSString *maintainer_id;
@property (nonatomic ,retain)XMMap  *map;
@property (nonatomic , assign) id<XMMapCellClickDelegate>delegate;


@end
