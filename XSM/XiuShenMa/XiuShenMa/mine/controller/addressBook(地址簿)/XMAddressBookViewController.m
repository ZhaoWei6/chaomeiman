
//
//  XMAddressBookViewController.m
//  XiuShemMa
//
//  Created by Apple on 14/10/24.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMAddressBookViewController.h"
#import "XMAddressCell.h"
#import "XMAddAddressCell.h"

#import "XMAddAddressViewController.h"
#import "XMContactsTool.h"
#import "XMContacts.h"

#import "XMHttpTool.h"
#import "XMDealTool.h"
#import "NSObject+Value.h"
@interface XMAddressBookViewController ()<UITableViewDataSource,UITableViewDelegate,XMAddressCellDelegate>
{
    UITableView *_tableView;
    NSMutableArray *contacts;
    
    NSInteger cellCount;
    XMContacts *currentContacts;
}
@end

@implementation XMAddressBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    kNAVITAIONBACKBUTTON
    [self loadSubViews];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"新增" style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonClick)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"AddAddressSuccess" object:nil];
    [self requestData];
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [self requestData];
//}

- (void)loadSubViews
{
    self.view.backgroundColor = XMGlobalBg;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kDeviceWidth, kDeviceHeight-64) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 90;
    _tableView.backgroundColor = XMGlobalBg;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)requestData
{
    NSString *userid = [UserDefaults objectForKey:@"userid"];
    NSString *password = [UserDefaults objectForKey:@"password"];
    [XMHttpTool postWithURL:@"user/address" params:@{@"userid":userid,@"password":password} success:^(id json) {
        XMLog(@"json ------------- %@",json);
        NSArray *array = json[@"datalist"];
        NSMutableArray *deals = [NSMutableArray array];
        
        if ([array isKindOfClass:[NSArray class]] && array.count) {
            for (NSDictionary *dict in array) {
                XMContacts *d = [[XMContacts alloc] init];
                [d setValues:dict];
                [deals addObject:d];
            }
            contacts = deals;
            [self removeContentNone];
            [self refresh];
        }else{
            _tableView.hidden = YES;
            [self removeContentNone];
            [self initContentNone];
            //判断是否为第一次启动程序
            [self checkApplicationISfirstLaunch];
        }
    } failure:^(NSError *error) {
        XMLog(@"失败%@",error);
        [MBProgressHUD showError:@"网络异常"];
    }];
}

- (void)refresh
{
    if (_isAllowEdit) {
        cellCount = contacts.count;
    }else{
        cellCount = contacts.count+1;
    }
    
    XMLog(@"%i",cellCount);
    _tableView.hidden = NO;
    [_tableView reloadData];
//    [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
//    if (cellCount>1) {
//        XMAddressCell *cell = (XMAddressCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//        currentContacts = cell.contacts;
//    }
}
- (void)checkApplicationISfirstLaunch
{
    if ([UserDefaults boolForKey:@"firstLaunch"]) {
        UIImageView *cover;
        if (kDeviceWidth == 375) {
            cover = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"addressFistLaunch1"]];
        }else{
            cover = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"addressFistLaunch"]];
        }
        cover.contentMode = UIViewContentModeScaleAspectFill;
        if (kDeviceHeight == 480) {
            cover.frame = CGRectMake(0, 0, 320, 568);
        }else{
            cover.frame = self.view.bounds;
        }
        [cover setUserInteractionEnabled:YES];
        [cover addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideCover:)]];
        [self.view.window addSubview:cover];
        
        [UserDefaults setBool:NO forKey:@"firstLaunch"];
    }

}
- (void)hideCover:(UITapGestureRecognizer *)sender
{
    CGPoint p = [sender locationInView:[sender view]];
    [[sender view] removeFromSuperview];
    
    if (p.x>kDeviceWidth-60 && p.y>20.0f && p.y<=64.0f) {
        [self rightButtonClick];
    }
    XMLog(@"p--->%f-----%f",p.x,p.y);
}

- (void)initContentNone
{
//    UIImageView *imageView = [[UIImageView alloc] init];
//    [imageView setImage:[UIImage imageNamed:@"logo"]];
//    imageView.frame = CGRectMake((kDeviceWidth-100)/2, 84, 100, 100);
//    imageView.contentMode = UIViewContentModeScaleAspectFit;
//    [self.view addSubview:imageView];
    
    QHLabel *lable = [[QHLabel alloc] initWithFrame:CGRectMake(0, kDeviceHeight/2-10, kDeviceWidth, 20)];
    lable.text = @"您还未添加联系人";
    lable.textAlignment = NSTextAlignmentCenter;
    lable.textColor = kTextFontColor666;
    [self.view addSubview:lable];
    
//    imageView.tag = 1001;
    lable.tag = 1002;
}
- (void)removeContentNone
{
//    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:1001];
    QHLabel *label = (QHLabel *)[self.view viewWithTag:1002];
//    [imageView removeFromSuperview];
    [label removeFromSuperview];
    
//    imageView = nil;
    label = nil;
}
#pragma mark -
#pragma mark UITableViewDataSource
#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return cellCount;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == contacts.count) {
        static NSString *cellID = @"cellAdd";
        XMAddAddressCell *cellAdd = [[XMAddAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cellAdd.selectionStyle = UITableViewCellSelectionStyleNone;
        cellAdd.backgroundColor = XMGlobalBg;
        return cellAdd;
    }else{
        static NSString *cellIdentifier = @"cell";
        XMAddressCell *cell =  [[XMAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.delegate = self;
        cell.isAllowHidden = self.isAllowEdit;
        cell.contacts = contacts[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != contacts.count) {
        XMAddressCell *cell = (XMAddressCell *)[_tableView cellForRowAtIndexPath:[_tableView indexPathForSelectedRow]];
        
        currentContacts = cell.contacts;
    }else{
        if (currentContacts==nil) {
            UIAlertView  *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"未选择任何联系人" delegate:self cancelButtonTitle:@"重新选择" otherButtonTitles:nil, nil];
            [alertView show];
        }else{
            [XMContactsTool sharedXMContactsTool].currentContacts = currentContacts;
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


// 设置单元格编辑的样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

//添加删除单元格
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:contacts];
        XMContacts *contact = array[indexPath.row];
        [[XMDealTool sharedXMDealTool] deleteContactWithContact:contact.ID success:^(NSString *deal) {
            //删除成功
            [MBProgressHUD showSuccess:deal];
            [self requestData];
        } failure:^(NSString *deal) {
            //删除失败
            [MBProgressHUD showError:deal];
        }];
    }
}

#pragma mark -
- (void)rightButtonClick
{
    XMAddAddressViewController *addAddress = [[XMAddAddressViewController alloc] init];
    addAddress.title = @"新增地址";
    [self.navigationController pushViewController:addAddress animated:YES];
}

- (void)editContactsWithContacts:(XMContacts *)con
{
    XMAddAddressViewController *addAddress = [[XMAddAddressViewController alloc] init];
    addAddress.title = @"修改联系人信息";
    addAddress.contacts = con;
    [self.navigationController pushViewController:addAddress animated:YES];
}
- (void)selectCell:(XMAddressCell *)sender andContact:(XMContacts *)contact
{
//    XMAddressCell *cell = (XMAddressCell *)[sender superview];
//    [cell becomeFirstResponder];
    XMLog(@"contact---->%@-------->indexpath----->%@",contact,[_tableView indexPathForCell:sender]);
    currentContacts = contact;
//    [cell setSelected:YES animated:YES];
//    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
    [_tableView selectRowAtIndexPath:[_tableView indexPathForCell:sender] animated:YES scrollPosition:UITableViewScrollPositionNone];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
