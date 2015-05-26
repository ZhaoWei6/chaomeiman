//
//  XMSkillImageView.m
//  XSM_XS
//
//  Created by Apple on 14/12/9.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMSkillImageView.h"

@implementation XMSkillImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.image = [UIImage imageNamed:@"skill_photo"];
        
        [self setUserInteractionEnabled:YES];
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageView:)]];
    }
    return self;
}

- (void)clickImageView:(UITapGestureRecognizer *)sender
{
    if ([self.delegate respondsToSelector:@selector(deleteSkillImageView:url:)]) {
        [self.delegate deleteSkillImageView:self.skillImageID url:self.skillImageUrl];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
