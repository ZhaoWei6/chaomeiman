//
//  XMSkillImageView.h
//  XSM_XS
//
//  Created by Apple on 14/12/9.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XMSkillImageViewDelegate <NSObject>

- (void)deleteSkillImageView:(NSString *)skillImageID url:(NSString *)url;

@end

@interface XMSkillImageView : UIImageView

@property (nonatomic , copy) NSString *skillImageID;//图片ID
@property (nonatomic , copy) NSString *skillImageUrl;//图片Url

@property (nonatomic , assign) id<XMSkillImageViewDelegate> delegate;

@end
