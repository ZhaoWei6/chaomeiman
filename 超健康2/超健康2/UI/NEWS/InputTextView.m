//
//  InputTextView.m
//  企信通
//
//  Created by apple on 13-12-6.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "InputTextView.h"
#import "EmoteSelectorView.h"

@interface InputTextView() <EmoteSelectorViewDelegate>

// 表情选择视图
@property (strong, nonatomic) EmoteSelectorView *emoteView;

// 输入文本
@property (weak, nonatomic) IBOutlet UITextField *inputText;
// 录音按钮
@property (weak, nonatomic) IBOutlet UIButton *recorderButton;

@property (weak, nonatomic) IBOutlet UIButton *voiceButton;

// 点击声音切换按钮
- (IBAction)clickVoice:(UIButton *)button;
// 点击表情切换按钮
- (IBAction)clickEmote:(UIButton *)button;
// 点击开始声音按钮
- (IBAction)startVoice:(UIButton *)button;
@end

@implementation InputTextView

- (void)awakeFromNib
{
    // 设置录音按钮的背景图片拉伸效果
    UIImage *image = [UIImage imageNamed:@"VoiceBtn_Black"];
    image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
    UIImage *imageHL = [UIImage imageNamed:@"VoiceBtn_BlackHL"];
    imageHL = [imageHL stretchableImageWithLeftCapWidth:imageHL.size.width * 0.5 topCapHeight:imageHL.size.height * 0.5];
    
    [_recorderButton setBackgroundImage:image forState:UIControlStateNormal];
    [_recorderButton setBackgroundImage:imageHL forState:UIControlStateHighlighted];
    
    // 实例化表情选择视图
    _emoteView = [[EmoteSelectorView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
    // 设置代理
    _emoteView.delegate = self;
}

#pragma mark 设置按钮的图像
- (void)setButton:(UIButton *)button imgName:(NSString *)imgName imgHLName:(NSString *)imgHLName
{
    UIImage *image = [UIImage imageNamed:imgName];
    UIImage *imageHL = [UIImage imageNamed:imgHLName];
    
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:imageHL forState:UIControlStateHighlighted];
}

#pragma mark - Actions
#pragma mark 点击声音切换按钮
- (void)clickVoice:(UIButton *)button
{
    // 1 设置按钮的tag
    button.tag = !button.tag;
    
    // 2 显示录音按钮
    _recorderButton.hidden = !button.tag;
    // 3 隐藏输入文本框
    _inputText.hidden = button.tag;
    
    // 4. 判断当前输入状态，如果是文本输入，显示录音按钮，同时关闭键盘
    if (button.tag) {
        // 1) 关闭键盘
        [_inputText resignFirstResponder];
        
        // 2) 切换按钮图标，显示键盘图标
        [self setButton:button imgName:@"ToolViewInputText" imgHLName:@"ToolViewInputTextHL"];
    } else {
        // 打开文本录入
        // 1) 切换按钮图标，显示录音图标
        [self setButton:button imgName:@"ToolViewInputVoice" imgHLName:@"ToolViewInputVoiceHL"];
        
        // 2) 打开键盘
        [_inputText becomeFirstResponder];
    }
}
// 点击表情切换按钮
- (IBAction)startVoice:(UIButton *)button{
    MyLog(@"录音");
    
    //初始化录音vc
    _recorderVC = [[ChatVoiceRecorderVC alloc]init];
    _recorderVC.vrbDelegate = self;
    
    //初始化播放器
    _player = [[AVAudioPlayer alloc]init];
    
    //添加长按手势
    UILongPressGestureRecognizer *longPrees = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(recordBtnLongPressed:)];
    longPrees.delegate = self;
    [_recorderButton addGestureRecognizer:longPrees];

}
#pragma mark 点击表情切换按钮
- (void)clickEmote:(UIButton *)button
{
    // 1. 如果当前正在录音，需要切换到文本状态
    if (!_recorderButton.hidden) {
        [self clickVoice:_voiceButton];
    }
    
    // 2. 判断当前按钮的状态，如果是输入文本，替换输入视图(选择表情)
    // 1) 设置按钮的tag
    button.tag = !button.tag;
    
    // 2) 激活键盘
    [_inputText becomeFirstResponder];
    
    if (button.tag) {
        // 显示表情选择视图
        [_inputText setInputView:_emoteView];
        
        // 切换按钮图标，显示键盘选择图像
        [self setButton:button imgName:@"ToolViewInputText" imgHLName:@"ToolViewInputTextHL"];
    } else {
        // 显示系统默认键盘
        [_inputText setInputView:nil];
        
        // 切换按钮图标，显示表情选择图像
        [self setButton:button imgName:@"ToolViewEmotion" imgHLName:@"ToolViewEmotionHL"];
    }
    
    // 3. 刷新键盘的输入视图
    [_inputText reloadInputViews];
}

#pragma mark - 表情选择视图代理方法
// 拼接表情字符串
- (void)emoteSelectorViewSelectEmoteString:(NSString *)emote
{
    // 拼接现有文本
    // 1. 取出文本
    NSMutableString *strM = [NSMutableString stringWithString:_inputText.text];

    // 2. 拼接字符串
    [strM appendString:emote];
    
    // 3. 设置文本
    _inputText.text = strM;
}

// 删除字符串
- (void)emoteSelectorViewRemoveChar
{
    // 1. 取出文本
    NSString *str = _inputText.text;
    
    // 2. 删除最末尾的字符，并设置文本
    _inputText.text =  [str substringToIndex:(str.length - 1)];
}



#pragma mark - 长按录音
- (void)recordBtnLongPressed:(UILongPressGestureRecognizer*) longPressedRecognizer{
    //长按开始
    if(longPressedRecognizer.state == UIGestureRecognizerStateBegan) {
        //设置文件名
        self.originWav = [VoiceRecorderBaseVC getCurrentTimeString];
        //开始录音
        [_recorderVC beginRecordByFileName:self.originWav];
        
    }//长按结束
    else if(longPressedRecognizer.state == UIGestureRecognizerStateEnded || longPressedRecognizer.state == UIGestureRecognizerStateCancelled){
        MyLog(@"长安街素");
    }
}
#pragma mark - 播放原wav
- (IBAction)playOriginWavBtnPressed:(id)sender {
    if (_originWav.length > 0) {
        _player = [_player initWithContentsOfURL:[NSURL URLWithString:[VoiceRecorderBaseVC getPathByFileName:_originWav ofType:@"wav"]] error:nil];
        [_player play];
    }
}

#pragma mark - VoiceRecorderBaseVC Delegate Methods
//录音完成回调，返回文件路径和文件名
- (void)VoiceRecorderBaseVCRecordFinish:(NSString *)_filePath fileName:(NSString*)_fileName{
    MyLog(@"录音完成，文件路径:%@",_filePath);
    [self setLabelByFilePath:_filePath fileName:_fileName convertTime:0 label:_originWavLabel];
}

#pragma mark - 根据文件设置label
- (void)setLabelByFilePath:(NSString*)_filePath fileName:(NSString*)_fileName convertTime:(NSTimeInterval)_convertTime label:(UILabel*)_label{
    
    NSInteger size = [self getFileSize:_filePath]/1024;
    _label.text = [NSString stringWithFormat:@"文件名：%@\n文件大小：%dkb\n",_fileName,size];
    
    NSRange range = [_filePath rangeOfString:@"wav"];
    if (range.length > 0) {
        AVAudioPlayer *play = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:_filePath] error:nil];
        _label.text = [_label.text stringByAppendingFormat:@"文件时长:%f\n",play.duration];
    }
    
    if (_convertTime > 0)
        _label.text = [_label.text stringByAppendingFormat:@"转换时间：%f",_convertTime];
}

#pragma mark - 获取文件大小
- (NSInteger) getFileSize:(NSString*) path{
    NSFileManager * filemanager = [[NSFileManager alloc]init];
    if([filemanager fileExistsAtPath:path]){
        NSDictionary * attributes = [filemanager attributesOfItemAtPath:path error:nil];
        NSNumber *theFileSize;
        if ( (theFileSize = [attributes objectForKey:NSFileSize]) )
            return  [theFileSize intValue];
        else
            return -1;
    }
    else{
        return -1;
    }
}

@end
