//
//  ChatMessageCell.h
//  企信通
//
//  Created by apple on 13-12-4.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ChatMessageDelegrate <NSObject>
-(void)touchImage:(NSString *)url;
@end

@interface ChatMessageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageWeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imageWightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imageHeightConstraint;
@property (strong, nonatomic) IBOutlet UIImageView *imageMessage;


@property(nonatomic,retain)NSString *imageUrl;

@property(nonatomic,retain)id<ChatMessageDelegrate>delegrate;

- (void)setMessage:(NSString *)message isOutgoing:(BOOL)isOutgoing;

- (void)setImage:(UIImage *)image Url:(NSString *)message isOutgoing:(BOOL)isOutgoing;
@end
