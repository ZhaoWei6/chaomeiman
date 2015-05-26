//
//  XMBaseOrderViewController.h
//  XiuShemMa
//
//  Created by Apple on 14/10/28.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMBaseViewController.h"
#import "XMMoreServicesController.h"
#import "XMPickerView.h"
#import "XMPrepareSubmitController.h"
#import "XMAddressBookViewController.h"
#import "XMContactsTool.h"
#import "XMContacts.h"
#import "XMDealTool.h"
@interface XMBaseOrderViewController : XMBaseViewController<UITableViewDataSource,UITableViewDelegate,XMPickerViewDelegate>
{
    UITableView *_tableView;
    UIButton *_submitButtom;//提交按钮
    NSArray *_titles;//段标题
    NSMutableArray *_content;//单元格内容
    XMPickerView *picker;
    
    NSString *_item_id;//产品ID
    NSString *_faultcategoryid;//故障ID
    NSString *_attributeid;//属性ID
}

@property (nonatomic , retain) UITableView *tableView;
@property (nonatomic , retain) UIButton *submitButton;
@property (nonatomic , retain) NSArray *titles;
@property (nonatomic , retain) NSMutableArray *content;



@property (nonatomic , copy) NSString *maintainer_id;
@property (nonatomic , copy) NSString *shop;


- (void)showPickerView;

- (void)hidePickerView;


@end
