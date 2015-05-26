//
//  ChatMessageCell.m
//  企信通
//
//  Created by apple on 13-12-4.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "ChatMessageCell.h"
#import "UIImageView+WebCache.h"
#import "MMTextAttachment.h"
@interface ChatMessageCell()
{
    UIImage *_receiveImage;
    UIImage *_receiveImageHL;
    UIImage *_senderImage;
    UIImage *_senderImageHL;
}

@end

@implementation ChatMessageCell

- (UIImage *)stretcheImage:(UIImage *)img
{
    return [img stretchableImageWithLeftCapWidth:img.size.width * 0.5 topCapHeight:img.size.height * 0.6];
}

- (void)awakeFromNib
{
    // 实例化表格行背景使用的图像
    _receiveImage = [UIImage imageNamed:@"ReceiverTextNodeBkg"];
    _receiveImageHL = [UIImage imageNamed:@"ReceiverTextNodeBkgHL"];
    _senderImage = [UIImage imageNamed:@"SenderTextNodeBkg"];
    _senderImageHL = [UIImage imageNamed:@"SenderTextNodeBkgHL"];
    
    // 处理图像拉伸（因为iOS 6不支持图像切片）
//    _receiveImage = [_receiveImage stretchableImageWithLeftCapWidth:_receiveImage.size.width * 0.5 topCapHeight:_receiveImage.size.height * 0.6];
    _receiveImage = [self stretcheImage:_receiveImage];
    _receiveImageHL = [self stretcheImage:_receiveImageHL];
    _senderImage = [self stretcheImage:_senderImage];
    _senderImageHL = [self stretcheImage:_senderImageHL];
    
    _imageMessage.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignTap:)];
    [_imageMessage addGestureRecognizer:tap];
}

- (void)setMessage:(NSString *)message isOutgoing:(BOOL)isOutgoing
{
    // 1. 根据isOutgoing判断消息是发送还是接受，依次来设置按钮的背景图片
    if (isOutgoing) {
        [_messageButton setBackgroundImage:_senderImage forState:UIControlStateNormal];
        [_messageButton setBackgroundImage:_senderImageHL forState:UIControlStateHighlighted];
    } else {
        [_messageButton setBackgroundImage:_receiveImage forState:UIControlStateNormal];
        [_messageButton setBackgroundImage:_receiveImageHL forState:UIControlStateHighlighted];
    }
    
//    // 2. 设置按钮文字
//    // 2.1 计算文字占用的区间
//    CGSize size = [message sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(180, 10000.0)];
//    
//    // 2.2 使用文本占用空间设置按钮的约束
//    // 提示：需要考虑到在Stroyboard中设置的间距
//    _messageHeightConstraint.constant = size.height + 30.0;
//    _messageWeightConstraint.constant = size.width + 30.0;
//    
//    // 2.3 设置按钮文字
//    [_messageButton setTitle:message forState:UIControlStateNormal];
//    
//    // 2.4 重新调整布局
//    [self layoutIfNeeded];
    NSString *searchText = message;
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(\\#\\[face/png/f_static_)\\d{3}(.png\\]\\#)" options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *arr=[regex matchesInString:searchText options:0 range:NSMakeRange(0, [searchText length])];
    NSMutableAttributedString * string = [[ NSMutableAttributedString alloc ] initWithString:@""  attributes:nil ] ;
    if (arr.count!=0) {
        for (long int i=0,j=0,e=0; i<=arr.count; i++) {
            NSTextCheckingResult *result1;
            NSTextCheckingResult *result2;
            if (i==0) {
                j=0;
                result2=arr[i];
                e=result2.range.location-j;
            }
            else if(i<arr.count)
            {
                result1=arr[i-1];
                result2=arr[i];
                
                //                NSLog(@"%@\n", [searchText substringWithRange:NSMakeRange(result1.range.location+11, result1.range.length-13)]);
                NSAttributedString *str = [self emoteStringWithIndex:[searchText substringWithRange:NSMakeRange(result1.range.location+11, result1.range.length-13)]];
                [string appendAttributedString:str];
                
                j=result1.range.location+result1.range.length;
                e=result2.range.location-j;
            }
            else
            {
                result1=arr[i-1];
                j=result1.range.location+result1.range.length;
                e=searchText.length-j;
                //                NSLog(@"%@\n", [searchText substringWithRange:NSMakeRange(result1.range.location+11, result1.range.length-13)]);
                
                NSAttributedString *str = [self emoteStringWithIndex:[searchText substringWithRange:NSMakeRange(result1.range.location+11, result1.range.length-13)]];
                [string appendAttributedString:str];
            }
            //            NSLog(@"%@\n", [searchText substringWithRange:NSMakeRange(j,e)]);
            NSMutableAttributedString * str = [[ NSMutableAttributedString alloc ] initWithString:[searchText substringWithRange:NSMakeRange(j,e)]  attributes:nil ];
            [string appendAttributedString:str];
            
        }
        [_messageButton setAttributedTitle:string forState:UIControlStateNormal];
    }
    else
        [_messageButton setTitle:message forState:UIControlStateNormal];
    
    // 2. 设置按钮文字
    // 2.1 计算文字占用的区间
    long int count=arr.count * 22;
    
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0]};
    CGSize size = [[message substringWithRange:NSMakeRange(0,message.length-count)] boundingRectWithSize:CGSizeMake(180, 10000.0) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    //    CGSize size = [message sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(180, 10000.0)];
    
    
    // 2.2 使用文本占用空间设置按钮的约束
    // 提示：需要考虑到在Stroyboard中设置的间距
    _messageHeightConstraint.constant = size.height + 30;
    _messageWeightConstraint.constant = size.width + 30.0;
    
    // 2.3 设置按钮文字
    
    // 2.4 重新调整布局
    [self layoutIfNeeded];

}

-(NSAttributedString *)emoteStringWithIndex:(NSString *)imageName
{
    MMTextAttachment * textAttachment = [[ MMTextAttachment alloc ] initWithData:nil ofType:nil ] ;
    UIImage * smileImage = [ UIImage imageNamed:imageName];  //my emoticon image named a.jpg
    textAttachment.image = smileImage ;
    
    NSAttributedString * textAttachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment];
    return textAttachmentString;
}

//----//
- (void)setImage:(UIImage *)image Url:(NSString *)message isOutgoing:(BOOL)isOutgoing
{
    // 1. 根据isOutgoing判断消息是发送还是接受，依次来设置按钮的背景图片
    if (isOutgoing) {
        [_imageMessage setBackgroundColor:[UIColor colorWithPatternImage:_senderImage]];
    } else {
        [_imageMessage setBackgroundColor:[UIColor colorWithPatternImage:_receiveImage]];
    }
    
    // 2. 设置按钮文字
    // 2.1 计算文字占用的区间
    CGSize imageSize = image.size;
    if (imageSize.width > maxImageWidth) {
        imageSize.height = imageSize.height / imageSize.width * maxImageWidth;
        imageSize.width = maxImageWidth;
    }
    if (imageSize.height > maxImageHeight) {
        imageSize.width = imageSize.width / imageSize.height * maxImageHeight;
        imageSize.height = maxImageHeight;
    }
    // 2.2 使用文本占用空间设置按钮的约束
    // 提示：需要考虑到在Stroyboard中设置的间距
    
    _messageHeightConstraint.constant = imageSize.height + 30;
    _messageWeightConstraint.constant = imageSize.width + 30.0;
    
    _imageHeightConstraint.constant = imageSize.height + 30-20;
    _imageWightConstraint.constant = imageSize.width + 30.0-25;
    NSRange rage=[message rangeOfString:@"</ImageEnd>"];
    if (rage.length) {
        NSMutableString *base=[NSMutableString stringWithString:message];
        //        NSLog(@"base-----%@",base);
        NSRange rang=[base rangeOfString:@"</ImageEnd>"];
        //        NSLog(@"rang-----%lu,%lu",(unsigned long)rang.location,(unsigned long)rang.length);
        [base deleteCharactersInRange:rang];
        //        NSLog(@"baserang-----%@",base);
        _imageUrl=[NSString stringWithFormat:@"%@",base];
        
        // 2.3 设置按钮文字
        [_imageMessage setImageWithURL:[NSURL URLWithString:base] placeholderImage:[UIImage imageNamed:@"头像1.jpg"] options:SDWebImageLowPriority | SDWebImageRetryFailed ];
    }
    
    // 2.4 重新调整布局
    [self layoutIfNeeded];
}


-(void)resignTap:(UITapGestureRecognizer *)tap
{
    NSLog(@"------%@_imageUrl",_imageUrl);
    if ([_delegrate respondsToSelector:@selector(touchImage:)]) {
        [_delegrate touchImage:_imageUrl];
    }
}
@end
