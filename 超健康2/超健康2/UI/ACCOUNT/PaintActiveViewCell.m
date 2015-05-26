//
//  PaintActiveViewCell.m
//  超健康
//
//  Created by imac on 14/12/15.
//  Copyright (c) 2014年 ChaoMeiman. All rights reserved.
//

#import "PaintActiveViewCell.h"
#import "UIImageView+WebCache.h"
@implementation PaintActiveViewCell

- (void)awakeFromNib {

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setAct:(ExpertActive *)act
{
    if (_act!=act) {
        NSArray *arr=@[_image1,_image2,_image3,_image4,_image5,_image6];
        _act=act;
        _sep_day.text=act.day;
        _sep_month.text=act.month;
        _sep_content.text=act.AcContent;
        
        for (int i=0; i<6; i++) {
            UIImageView *ima=arr[i];
            ima.userInteractionEnabled=YES;
            if (i<act.imageArr.count) {
                ima.hidden=NO;
                [ima setImageWithURL:[NSURL URLWithString:act.imageArr[i]] placeholderImage:nil options:SDWebImageLowPriority | SDWebImageRetryFailed];
                UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImage:)];
                [ima addGestureRecognizer:tap];
            }
            else
            {
                ima.hidden=YES;
            }
        }
//        if (act.imageArr.count>3) {
//            _textLayout.constant=100;
//        }else if (act.imageArr.count>0){
//            _textLayout.constant=48;
//        }else
//            _textLayout.constant=0;
        [self layoutIfNeeded];
    }
   
}


-(void)clickImage:(UITapGestureRecognizer *)tap
{
    long int i=tap.view.tag;
    MyLog(@"%ld",i);
    if ([self.delegrate respondsToSelector:@selector(touchImage:)]) {
        [self.delegrate touchImage:_act.imageArr[i-1]];
    }
}
@end
