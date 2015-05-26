//
//  PaintActiveViewCell.h
//  超健康
//
//  Created by imac on 14/12/15.
//  Copyright (c) 2014年 ChaoMeiman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpertActive.h"

@protocol PaintActiveViewCellDelegrate <NSObject>

-(void)touchImage:(NSString *)url;

@end


@interface PaintActiveViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *sep_day;
@property (strong, nonatomic) IBOutlet UILabel *sep_month;
@property (strong, nonatomic) IBOutlet UILabel *sep_content;
@property (strong, nonatomic) IBOutlet UIImageView *image1;
@property (strong, nonatomic) IBOutlet UIImageView *image2;
@property (strong, nonatomic) IBOutlet UIImageView *image3;
@property (strong, nonatomic) IBOutlet UIImageView *image4;
@property (strong, nonatomic) IBOutlet UIImageView *image5;
@property (strong, nonatomic) IBOutlet UIImageView *image6;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *textLayout;

@property(nonatomic,retain)ExpertActive *act;
@property(nonatomic,retain)id<PaintActiveViewCellDelegrate>delegrate;
@end
