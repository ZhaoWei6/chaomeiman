//
//  XMAddressCell.h
//  XiuShemMa
//
//  Created by Apple on 14/10/24.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XMContacts,XMAddressCell;

@protocol XMAddressCellDelegate <NSObject>

- (void)editContactsWithContacts:(XMContacts *)con;
@optional
- (void)selectCell:(XMAddressCell *)sender andContact:(XMContacts *)contact;

@end

@interface XMAddressCell : UITableViewCell

@property (nonatomic , retain) XMContacts *contacts;
@property (nonatomic , assign) BOOL isAllowHidden;
@property (nonatomic , assign) id<XMAddressCellDelegate> delegate;

@end
