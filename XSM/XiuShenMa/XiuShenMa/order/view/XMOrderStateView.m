//
//  XMOrderStateView.m
//  XiuShemMa
//
//  Created by Apple on 14/10/29.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMOrderStateView.h"

@interface XMOrderStateView ()
{
    NSArray *_images;
    NSArray *_titles;
    NSArray *_details;
}
@end

@implementation XMOrderStateView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _images = @[@"icon_order",@"icon_order_over",@"icon_on_road",@"icon_finish"];
        _titles = @[@"订单提交成功",@"商家已经确认订单",@"在路上狂奔",@"已到，正在联系您"];
        _details = @[@"请耐心等待商家确认",@"等待修神出发",@"等待修神联系",@""];
    }
    return self;
}


- (void)setStateWithDict:(NSDictionary *)dict flag:(BOOL)flag index:(int)index
{
    UIImageView *iconImageView = [[UIImageView alloc] init];
    [self addSubview:iconImageView];
    
    UIView *baseView = [[UIView alloc] init];
    [self addSubview:baseView];
    //
    iconImageView.frame = CGRectMake(0, (self.height-30)/2, 30, 30);
    baseView.frame = CGRectMake(iconImageView.right+10, 0, self.width-iconImageView.width-10, self.height);
    
    UIImageView *background = [[UIImageView alloc] initWithFrame:baseView.bounds];
    [background setImage:[UIImage imageNamed:@"dialog"]];
    [baseView addSubview:background];
    
    if (flag && dict!=nil) {
        NSString *imageName = [_images[index] stringByAppendingString:@"-1"];
        XMLog(@"imageName=  %@",imageName);
        [iconImageView setImage:[UIImage resizedImage:imageName]];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = _titles[index];
        titleLabel.font = [UIFont systemFontOfSize:14];
        [baseView addSubview:titleLabel];
        
        UILabel *detailLabel = [[UILabel alloc] init];
        detailLabel.text = _details[index];
        detailLabel.font = [UIFont systemFontOfSize:14];
        detailLabel.textColor = [UIColor grayColor];
        [baseView addSubview:detailLabel];
        
        UILabel *time = [[UILabel alloc] init];
//        NSRange range = NSMakeRange(10, 6);
//        NSString *createTime = dict[@"createtime"];
//        XMLog(@"%@",createTime);
        time.text = dict[@"createtime"];
        time.font = [UIFont systemFontOfSize:14];
        time.textAlignment = NSTextAlignmentRight;
        [baseView addSubview:time];
        
        titleLabel.frame = CGRectMake(15, 0, baseView.width*2/3-15, 30);
        detailLabel.frame = CGRectMake(titleLabel.left, titleLabel.bottom, titleLabel.width, 30);
        time.frame = CGRectMake(30, self.height/2-30, baseView.width-40, 30);
    }else{
        [iconImageView setImage:[UIImage resizedImage:_images[index]]];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = _titles[index];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = [UIColor grayColor];
        [baseView addSubview:titleLabel];
        
        UILabel *time = [[UILabel alloc] init];
        time.text = dict[@"time"];
        time.font = [UIFont systemFontOfSize:14];
        time.textAlignment = NSTextAlignmentRight;
        [baseView addSubview:time];
        
        
        titleLabel.frame = CGRectMake(15, self.height/2-15, baseView.width*2/3-15, 30);
        time.frame = CGRectMake(titleLabel.right, self.height/2-15, titleLabel.width/2.5, 30);
    }
}


@end
