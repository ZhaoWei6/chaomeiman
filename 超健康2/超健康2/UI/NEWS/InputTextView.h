//
//  InputTextView.h
//  企信通
//
//  Created by apple on 13-12-6.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatVoiceRecorderVC.h"
@interface InputTextView : UIView<VoiceRecorderBaseVCDelegate,UIGestureRecognizerDelegate>
@property (retain, nonatomic)  ChatVoiceRecorderVC      *recorderVC;

@property (retain, nonatomic)   AVAudioPlayer           *player;
@property (copy, nonatomic)     NSString                *originWav;         //原wav文件名
@property (retain, nonatomic)UILabel *originWavLabel;
@end
