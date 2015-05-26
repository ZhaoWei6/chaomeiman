//
//  ChangeNameController.h
//  Chaomeiman 专家端
//
//  Created by imac on 14-12-15.
//  Copyright (c) 2014年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol changeNameDelegate <NSObject>
@required
-(void)changeTitle:(NSString *)title;
@end
@interface ChangeNameController : BaseController

@property(nonatomic,assign)id<changeNameDelegate>delegate;
@property(nonatomic,retain)NSString *ID;
@end
