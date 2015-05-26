//
//  XMSendViewController.m
//  XiuShemMa
//
//  Created by Apple on 14/10/28.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMSendViewController.h"

@interface XMSendViewController ()

@end

@implementation XMSendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    kNAVITAIONBACKBUTTON
    self.title = @"填写寄修单";
    
    
    [_content removeAllObjects];
    
    _titles = @[@"寄修人信息",@"设备型号",@"故障描述",@"更多需求"];
    NSArray *arr = @[@"选择寄修人",@"选择需要维修的设备型号",@"选择您设备的故障类型",@"如贴膜服务、清灰服务等"];
    _content = [NSMutableArray arrayWithArray:arr];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if (indexPath.section == 0 || indexPath.section == 3) {
        [cell.textLabel setNumberOfLines:0];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.section == 0 && [XMContactsTool sharedXMContactsTool].currentContacts != nil) {
        XMContacts *contacts = [XMContactsTool sharedXMContactsTool].currentContacts;
        _content[0] = contacts;
        QHLabel *name = [[QHLabel alloc] initWithFrame:CGRectMake(20, 10, 100, 30)];
        name.font = [UIFont boldSystemFontOfSize:16];
        name.text = [NSString stringWithFormat:@"%@  %@",contacts.nickname,contacts.sex];
        [cell.contentView addSubview:name];
        
        QHLabel *mobile = [[QHLabel alloc] initWithFrame:CGRectMake(name.right, name.top, kDeviceWidth - name.width - 60, name.height)];
        mobile.textAlignment = NSTextAlignmentRight;
        mobile.text = contacts.telephone;
        [cell.contentView addSubview:mobile];
        
        QHLabel *address = [[QHLabel alloc] initWithFrame:CGRectMake(name.left, 40, kDeviceWidth - 60, 30)];
        address.text = [NSString stringWithFormat:@"%@%@",contacts.area,contacts.address];
        [cell.contentView addSubview:address];
//        cell.backgroundColor = XMColor(192, 192, 192);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
//    cell.backgroundColor = XMColor(192, 192, 192);
    
    
    XMLog(@"%@",_content[indexPath.section]);
    cell.textLabel.text = _content[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 80;
    }
    else if (indexPath.section == 3){
        return 120;
    }
    else{
        return 60;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (picker != nil) {
        [picker removeFromSuperview];
        picker = nil;
    }
    
    picker = [[XMPickerView alloc] init];
    picker.frame = CGRectMake(0, kDeviceHeight - 320 + 64, kDeviceWidth, 320);
    if (indexPath.section == 0) {
        //   联系人信息
        XMAddressBookViewController *addressBook = [[XMAddressBookViewController alloc] init];
        addressBook.isAllowEdit = NO;
        addressBook.title = @"寄修人信息";
        [self.navigationController pushViewController:addressBook animated:YES];
    }else if (indexPath.section == 1){
        picker.pickerViewStyle = kPickerViewStyleModel;
        picker.titleStr = @"设备型号";
        picker.delegate = self;
        [self.view addSubview:picker];
    }else if (indexPath.section == 2){
        picker.pickerViewStyle = kPickerViewStyleDesc;
        picker.titleStr = @"故障描述";
        picker.delegate = self;
        [self.view addSubview:picker];
    }else if (indexPath.section == 3){
        [self.navigationController pushViewController:[[XMMoreServicesController alloc] init] animated:YES];
    }
}

#pragma mark - 提交订单
- (void)submitButtonClick
{
    for (id str in _content) {
        if ([str isKindOfClass:[NSString class]]) {
            if ([str rangeOfString:@"选择"].location != NSNotFound || [str rangeOfString:@"补全"].location != NSNotFound) {
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
    
    NSString *more = [_content[3] isEqualToString:@"如贴膜服务、清灰服务等"] ? @"无":_content[3];
    XMContacts *contacts = _content[0];
    NSDictionary *dic = @{
                          @"name":contacts.nickname,
                          @"sex":contacts.sex,
                          @"number":contacts.telephone,
                          @"orderDate":orderDate,
                          @"address1":contacts.area,
                          @"address2":contacts.address,
                          @"price":@99,
                          @"model":_content[1],
                          @"desc":_content[2],
                          @"moreServices":more,
                          @"store":@"[专注iPhone维修8年]疯狂维修站"
                          };
    XMPrepareSubmitController *prepareVC = [[XMPrepareSubmitController alloc] init];
    prepareVC.title = @"提交寄修单";
    prepareVC.orderDic = dic;
    prepareVC.isVisit = NO;
    [self.navigationController pushViewController:prepareVC animated:YES];
}


@end
