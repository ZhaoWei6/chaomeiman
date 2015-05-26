//
//  XMKeyboardAvoidingScrollView.h
//  XiuShenMa
//
//  Created by Apple on 14/11/25.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMKeyboardAvoidingScrollView : UIScrollView

- (BOOL)focusNextTextField;
- (void)scrollToActiveTextField;


@end
