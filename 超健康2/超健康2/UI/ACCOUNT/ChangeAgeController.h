//
//  ChangeAgeController.h
//  Chaomeiman 专家端
//
//  Created by imac on 15-1-9.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol changeAgeDelegate <NSObject>
@required
-(void)changeAge:(NSString *)age;
@end
@interface ChangeAgeController : BaseController
@property(nonatomic,assign)id<changeAgeDelegate>delegate;
@property(nonatomic,retain)NSString *ID;
@end
