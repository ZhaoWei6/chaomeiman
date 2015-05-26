//
//  XMProvideHomeServiceController.m
//  XiuShemMa
//
//  Created by Apple on 14/10/20.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMProvideHomeServiceController.h"
//#import "XMMoreServicesController.h"
//#import "XMPickerView.h"
//#import "XMPrepareSubmitController.h"
//#import "XMAddressBookViewController.h"
//#import "XMContactsTool.h"
//#import "XMContacts.h"

@interface XMProvideHomeServiceController ()<UITextFieldDelegate>
{
    NSArray *_item;
    NSArray *_attributecategory;
    NSArray *_faultcategory;
    
    NSInteger _itemcategoryid_;//产品分类id
    NSInteger _faultcategoryid_;//故障分类id
}
@end

@implementation XMProvideHomeServiceController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"预约上门";
    
    _itemcategoryid_ = [XMDealTool sharedXMDealTool].itemcategoryid;   //产品型号
    _faultcategoryid_ = [XMDealTool sharedXMDealTool].faultcategory_id;//故障类型
    
    _titles = @[@"服务时间",@"联系人信息",@"设备型号",@"故障描述",@"更多需求"];//段首标题
  
    NSArray *arr;
    
    if (_itemcategoryid_ == 11) {
        //其他手机维修
        arr = @[@"选择上门时间",@"补全联系人信息",@"填写您的设备型号",@"选择您设备的故障类型",@"如贴膜服务、清灰服务等"];
    }else{
        //已知品牌手机维修
        arr = @[@"选择上门时间",@"补全联系人信息",@"选择需要维修的设备型号",@"选择您设备的故障类型",@"如贴膜服务、清灰服务等"];
    }
    
    _content = [NSMutableArray arrayWithArray:arr];
    
    // 请求picker数据
    [self requestDate];
}

/*
- (void)loadContentView
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    
    _submitButtom = [UIButton buttonWithType:UIButtonTypeCustom];
    _submitButtom.backgroundColor = [UIColor darkGrayColor];
    [_submitButtom setTitle:@"填好了" forState:UIControlStateNormal];
    [_submitButtom setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitButtom addTarget:self action:@selector(submitButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_submitButtom];
    
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [UIView setView:_tableView attr:NSLayoutAttributeLeft sAttr:NSLayoutAttributeLeft constant:0];
    [UIView setView:_tableView attr:NSLayoutAttributeRight sAttr:NSLayoutAttributeRight constant:0];
    [UIView setView:_tableView attr:NSLayoutAttributeTop sAttr:NSLayoutAttributeTop constant:0];
    [UIView setView:_tableView attr:NSLayoutAttributeBottom sAttr:NSLayoutAttributeBottom constant:-50];
    
    _submitButtom.translatesAutoresizingMaskIntoConstraints = NO;
    [UIView setView:_submitButtom attr:NSLayoutAttributeLeft sAttr:NSLayoutAttributeLeft constant:20];
    [UIView setView:_submitButtom attr:NSLayoutAttributeRight sAttr:NSLayoutAttributeRight constant:-20];
    [UIView setView:_submitButtom attr:NSLayoutAttributeTop sAttr:NSLayoutAttributeBottom constant:-45];
    [UIView setView:_submitButtom attr:NSLayoutAttributeBottom sAttr:NSLayoutAttributeBottom constant:-5];
}
*/

- (void)requestDate
{
    XMLog(@"--------%i--------%i---------",_itemcategoryid_,_faultcategoryid_);
    //获取picker要显示的内容
    [[XMDealTool sharedXMDealTool] orderWithMaintainerid:self.maintainer_id
                                          itemcategoryid:_itemcategoryid_
                                         faultcategoryid:_faultcategoryid_
                                                 success:^(NSArray *item, NSArray *attributecategory, NSArray *faultcategory) {
                                                     _item              = item;             //设备型号
                                                     _attributecategory = attributecategory;//颜色
                                                     _faultcategory     = faultcategory;    //故障分类
                                                 }];
}

#pragma mark 表格方法
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 5;
//}
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 1;
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    //服务时间
    if (indexPath.section == 0) {
        UIImageView *alarm = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_alarm"]];
        alarm.center = CGPointMake(kDeviceWidth-30, 30);
        [cell addSubview:alarm];
    }
    //设置联系人信息
    if (indexPath.section == 1 && [XMContactsTool sharedXMContactsTool].currentContacts != nil) {
        XMContacts *contacts = [XMContactsTool sharedXMContactsTool].currentContacts;
        _content[1] = contacts;
        //联系人姓名
        QHLabel *name = [[QHLabel alloc] initWithFrame:CGRectMake(20, 10, 100, 30)];
        name.text = [NSString stringWithFormat:@"%@",contacts.nickname];
        [cell.contentView addSubview:name];
        name.textColor = kTextFontColor666;
        name.width = [contacts.nickname boundingRectWithSize:CGSizeMake(MAXFLOAT, name.height) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16]} context:nil].size.width+10;
        //性别
        QHLabel *sex = [[QHLabel alloc] initWithFrame:CGRectMake(name.right, name.top, 100, name.height)];
        sex.text = [contacts.sex isEqualToString:@"1"]?@"先生":@"女士";
        [cell.contentView addSubview:sex];
        sex.textColor = kTextFontColor666;
        sex.width = [sex.text boundingRectWithSize:CGSizeMake(MAXFLOAT, name.height) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16]} context:nil].size.width+10;
        //手机
        QHLabel *mobile = [[QHLabel alloc] initWithFrame:CGRectMake(sex.right, sex.top, 100, name.height)];
//        mobile.textAlignment = NSTextAlignmentRight;
        mobile.text = contacts.telephone;
        mobile.textColor = kTextFontColor666;
        [cell.contentView addSubview:mobile];
        mobile.width = [mobile.text boundingRectWithSize:CGSizeMake(MAXFLOAT, name.height) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16]} context:nil].size.width+10;
        //地址
        QHLabel *address = [[QHLabel alloc] initWithFrame:CGRectMake(name.left, 40, kDeviceWidth - 60, 30)];
        address.text = [NSString stringWithFormat:@"%@%@",contacts.area,contacts.address];
        [cell.contentView addSubview:address];
        address.textColor = kTextFontColor666;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
//    cell.backgroundColor = XMColor(192, 192, 192);
    if (indexPath.section == 4) {
        cell.textLabel.numberOfLines = 2;
        cell.textLabel.height = [_content[4] boundingRectWithSize:CGSizeMake(cell.textLabel.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:cell.textLabel.font} context:nil].size.height+10;
    }
    cell.textLabel.textColor = kTextFontColor666;
    
    //设备型号
    if (indexPath.section == 2 && _itemcategoryid_ == 11) {
        
        UITextField *deviceModal = [[UITextField alloc] initWithFrame:CGRectMake(20, 20, kDeviceWidth-40, 20)];
        if ([_content[2] isEqualToString:@"填写您的设备型号"]) {
            deviceModal.placeholder = _content[2];
        }else{
            if ([_content[2] length] == 0) {
                deviceModal.placeholder = @"填写您的设备型号";
            }else{
                deviceModal.text = _content[2];
            }
        }
        deviceModal.delegate = self;
        deviceModal.tag = 100;
        [cell addSubview:deviceModal];
    }else{
        cell.textLabel.text = _content[indexPath.section];
    }
    
    //右侧指示器
    if (indexPath.section == 4 || indexPath.section == 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        cell.accessoryType = UITableViewCellSelectionStyleNone;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - textFiledDelegete
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.2 animations:^{
        _tableView.contentOffset = CGPointMake(0, 150);
    }];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _content[2] = textField.text;
    UITableViewCell *cell = (UITableViewCell *)[textField superview];
    [_tableView reloadRowsAtIndexPaths:@[[_tableView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationFade];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    _content[2] = textField.text;
    UITableViewCell *cell = (UITableViewCell *)[textField superview];
    [_tableView reloadRowsAtIndexPaths:@[[_tableView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationFade];
    return [textField resignFirstResponder];
}
#pragma mark - tableDelegate
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return kHeaderViewHeight;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return 80;
    }
//    else if (indexPath.section == 4){
//        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
//        return cell.frame.size.height;
////        return 120;
//    }
    else{
        return 60;
    }
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    QHLabel *titleLabel = [[QHLabel alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kHeaderViewHeight)];
//    titleLabel.backgroundColor = XMColor(214, 214, 214);
//    titleLabel.textColor = [UIColor lightGrayColor];
//    titleLabel.text = [NSString stringWithFormat:@"   %@",_titles[section] ];
//    return titleLabel;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder)
                                               to:nil
                                             from:nil
                                         forEvent:nil];
    if (indexPath.section == 0) {
        [self initPickerView];
        picker.pickerViewStyle = kPickerViewStyleTime;
        picker.titleStr = @"修神上门时间";
        [self showPickerView];
    }else if (indexPath.section == 1){
        //   联系人信息
        XMAddressBookViewController *addressBook = [[XMAddressBookViewController alloc] init];
        addressBook.isAllowEdit = NO;
        addressBook.title = @"常用地址";
        [self.navigationController pushViewController:addressBook animated:YES];
    }else if (indexPath.section == 2){
        if (_itemcategoryid_ == 11) {
            if (picker) {
                [self hidePickerView];
            }
            UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
            UITextField *textFiled = (UITextField *)[cell viewWithTag:100];
            [textFiled becomeFirstResponder];
        }else{
            if (_item) {
                [self initPickerView];
                picker.pickerViewStyle = kPickerViewStyleModel;
                picker.titleStr = @"设备型号";
                
                [self showPickerView];
            }
        }
    }else if (indexPath.section == 3){
        if (_attributecategory) {
            [self initPickerView];
            picker.pickerViewStyle = kPickerViewStyleDesc;
            picker.titleStr = @"故障描述";
            
            [self showPickerView];
        }
    }else if (indexPath.section == 4){
        XMMoreServicesController *moreVC = [[XMMoreServicesController alloc] init];
        if (![_content[indexPath.section] isEqualToString:@"如贴膜服务、清灰服务等"]) {
            moreVC.moreServices = _content[indexPath.section];
        }
        [self.navigationController pushViewController:moreVC animated:YES];
    }
}


- (void)initPickerView
{
    if (picker != nil) {
        [picker removeFromSuperview];
        picker = nil;
    }
    
    picker = [[XMPickerView alloc] init];
    picker.frame = CGRectMake(0, kDeviceHeight - 320 + 64, kDeviceWidth, 320);
    picker.item = _item;
    picker.faultcategory = _faultcategory;
    picker.attributecategory = _attributecategory;
    picker.delegate = self;
    [self.view addSubview:picker];
}

#pragma mark - 提交订单
- (void)submitButtonClick
{
    for (id str in _content) {
        if ([str isKindOfClass:[NSString class]]) {
            if ([str rangeOfString:@"选择"].location != NSNotFound || [str rangeOfString:@"补全"].location != NSNotFound || [str isEqualToString:@""]) {
                UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写完整订单信息" delegate:nil cancelButtonTitle:@"继续" otherButtonTitles:nil, nil];
                [alert1 show];
                return;
            }
        }
    }
    //获取现在时间--下单时间
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit |NSDayCalendarUnit |NSHourCalendarUnit | NSMinuteCalendarUnit |NSSecondCalendarUnit) fromDate:date];
    NSString *orderDate = [NSString stringWithFormat:@"%i-%i-%i  %i:%i",[comps year],[comps month],[comps day],[comps hour],[comps minute]];
    XMLog(@"现在时间：%@",orderDate);
    //上门时间
    NSString *dateService = _content[0];
    NSInteger hour,minute;
    NSString *servicesDate;

    NSNumber *timeSp;
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"yyyyMMddHHmmss"];
    

    char *date_service = (char *)[dateService UTF8String];
    if ([dateService rangeOfString:@"今天"].location != NSNotFound) {
        sscanf(date_service, "今天%d时%02d分",&hour,&minute);

        servicesDate = [NSString stringWithFormat:@"%04i%02i%02i%02i%02i%02i",[comps year],[comps month],[comps day],hour,minute,[comps second]];
        NSDate* inputDate = [inputFormatter dateFromString:servicesDate];
        
        timeSp = [[NSNumber alloc] initWithLong:(long)[inputDate timeIntervalSince1970]];

    }else if ([dateService rangeOfString:@"明天"].location != NSNotFound){
        sscanf(date_service, "明天%d时%02d分",&hour,&minute);

        servicesDate = [NSString stringWithFormat:@"%04i%02i%02i%02i%02i%02i",[comps year],[comps month],[comps day],hour,minute,[comps second]];
        NSDate* inputDate = [inputFormatter dateFromString:servicesDate];
        
        timeSp = [[NSNumber alloc] initWithLong:(long)[inputDate timeIntervalSince1970]+24*60*60];

    }else{
        sscanf(date_service, "后天%d时%02d分",&hour,&minute);

        servicesDate = [NSString stringWithFormat:@"%04i%02i%02i%02i%02i%02i",[comps year],[comps month],[comps day],hour,minute,[comps second]];
        NSDate* inputDate = [inputFormatter dateFromString:servicesDate];
        
        timeSp = [[NSNumber alloc] initWithLong:(long)[inputDate timeIntervalSince1970]+24*60*60*2];

    }
    
    XMLog(@"上门时间：%@  %@",timeSp,servicesDate);
    NSString *more = [_content[4] isEqualToString:@"如贴膜服务、清灰服务等"] ? @"无":_content[4];
    XMContacts *contacts = [XMContactsTool sharedXMContactsTool].currentContacts;
    
    NSString *sex = [contacts.sex isEqualToString:@"1"]?@"先生":@"女士";
    
    int maintaincategory = [XMDealTool sharedXMDealTool].maintaincategoryid;
//    NSDictionary *dic1 = @{@"item_id":_item_id,
//                           @"maintaincategory":@(maintaincategory),
//                           @"faultcategoryid":@(_faultcategoryid),
//                           @"name":contacts.nickname,
//                           @"sex":sex,
//                           @"number":contacts.telephone,
//                           @"area":contacts.area,
//                           @"address":contacts.address,
//                           @"serviceDate":timeSp,
//                           @"price":@99,
//                           @"model":_content[2],
//                           @"desc":_content[3],
//                           @"more":more,
//                           @"maintainer_id":self.maintainer_id,
//                           @"useraddress":contacts.ID,
//                           @"servicecategory_id":@(1),
//                           @"attributecategoryid":_attributecategory[0][@"id"],
//                           @"attributeid":_attributeid,
//                           @"video":@""
//                          };
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    /** 上门时间 */
    [dictionary setObject:timeSp forKey:@"serviceDate"];                  //
    /** 维修分类 */
    [dictionary setObject:@(maintaincategory) forKey:@"maintaincategory"];//
    /** 故障类型 */
    [dictionary setObject:_faultcategoryid forKey:@"faultcategoryid"]; //
    /** 联系人编号 */
    [dictionary setObject:contacts.ID forKey:@"useraddress"];
    /** 姓名 */
    [dictionary setObject:contacts.nickname forKey:@"name"];              //
    /** 性别 */
    [dictionary setObject:sex forKey:@"sex"];                             //
    /** 手机号 */
    [dictionary setObject:contacts.telephone forKey:@"number"];           //
    /** 价格 */
    [dictionary setObject:@99 forKey:@"price"];
    /** 区域 */
    [dictionary setObject:contacts.area forKey:@"area"];                  //
    /** 地址 */
    [dictionary setObject:contacts.address forKey:@"address"];            //
    /** 设备型号 */
    [dictionary setObject:_content[2] forKey:@"model"];
    /** 故障描述 */
    [dictionary setObject:_content[3] forKey:@"desc"];
    /** 修神id */
    [dictionary setObject:self.maintainer_id forKey:@"maintainer_id"];
    /** 服务类型id */
    [dictionary setObject:@(1) forKey:@"servicecategory_id"];
    /** 视频 */
    [dictionary setObject:@"" forKey:@"video"];
    /**  */
    if (_itemcategoryid_ == 11) {
        
    }else{
        /** item_id */
        [dictionary setObject:_item_id forKey:@"item_id"];
        /** attributecategoryid */
        [dictionary setObject:_attributecategory[0][@"id"] forKey:@"attributecategoryid"];
        /** attributeid */
        [dictionary setObject:_attributeid forKey:@"attributeid"];
    }
    /** 更多描述 */
    [dictionary setObject:more forKey:@"more"];
    /**  */
    
    XMPrepareSubmitController *prepareVC = [[XMPrepareSubmitController alloc] init];
    prepareVC.title = @"提交订单";
    
    prepareVC.isOtherMobile = _itemcategoryid_==11 ?YES:NO;
    
    prepareVC.orderDic = dictionary;
    prepareVC.isVisit = YES;
    [self.navigationController pushViewController:prepareVC animated:YES];
}
/*
#pragma mark - XMPickerViewDelegate
- (void)cancleOption
{
    [self removePickerView];
}

- (void)enterOptionWithContent:(NSString *)string
{
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[_tableView indexPathForSelectedRow]];
    cell.textLabel.text = string;
    NSInteger index = [[_tableView indexPathForSelectedRow] section];
    _content[index] = string;
    [self removePickerView];
}

#pragma mark - 移除pickerView
- (void)removePickerView
{
    picker.transform = CGAffineTransformMakeTranslation(0, -320);
    picker.alpha = 1;
    [UIView animateWithDuration:3 animations:^{
        picker.transform = CGAffineTransformIdentity;
        picker.alpha = 0;
    }];
    
    [picker removeFromSuperview];
    picker = nil;
}

#pragma mark - 修改单元格内容
- (void)changeServices
{
    XMMoreServicesController *more = [XMMoreServicesController sharedXMMoreServicesController];
    
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[_tableView indexPathForSelectedRow]];
    cell.textLabel.text = more.moreServices;
    NSInteger index = [[_tableView indexPathForSelectedRow] section];
    _content[index] = more.moreServices;
    
    XMLog(@"%@",more.moreServices);
}

- (void)changeContacts
{
    [_tableView reloadData];
}
*/
- (void)dealloc
{
    [XMContactsTool sharedXMContactsTool].currentContacts = nil;
    _titles = nil;
    [_content removeAllObjects];
    _content = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
