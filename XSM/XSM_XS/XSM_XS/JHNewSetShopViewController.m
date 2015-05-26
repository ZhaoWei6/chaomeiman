//
//  JHNewSetShopViewController.m
//  XSM_XS
//
//  Created by Andy on 14-12-4.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "JHNewSetShopViewController.h"
#import "JHEditShopNameViewController.h"
#import "JHCommonAddressViewController.h"
#import "JHCheckBar.h"
#import "XMDealTool.h"
#import "JHCommonAdress.h"
#import "JHAddGoodsViewController.h"
#import "JHDeleteAdPhotoViewController.h"

// 选择图片相关
#import "CTAssetsPickerController.h"
#import "CTAssetsPageViewController.h"

@interface JHNewSetShopViewController ()<UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, JHEditShopNameViewDelegate, JHCheckBarDelegate, JHCommonAddressViewControllerDelegate, UIActionSheetDelegate, CTAssetsPickerControllerDelegate>{


    UIAlertView  *alertTimer;

}

/** 遮盖 */
@property (nonatomic, weak) UIButton *cover;
@property (nonatomic, assign) NSInteger severID;

@property(nonatomic, strong) NSMutableArray *tempArray;

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *headTitleArray;
@property(nonatomic, strong) NSMutableArray *cellTitleArray;

@property(nonatomic, strong) NSMutableDictionary *shopServerInfo;
@property(nonatomic, strong) JHCheckBar *checkBar;
@property(nonatomic,assign)BOOL  isChooseBoth;


@property(nonatomic,strong) NSMutableDictionary *update;
@property(nonatomic,strong) NSMutableArray *weixiupinlei_id;
@property(nonatomic,strong) NSMutableArray *itemcategory_id;
@property(nonatomic,strong) NSMutableArray *servicecategory_id;

@property(nonatomic,assign) NSInteger clickedCellNumber;

@property (nonatomic, strong) NSMutableArray *goodsArray;
@property(nonatomic,strong) NSMutableArray *adDataArray;
@property(nonatomic,strong) UICollectionView *adCollectionView;

@property (nonatomic, strong) NSArray *adphotos;
@property (nonatomic, copy) NSArray *assets;


@end

@implementation JHNewSetShopViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.headTitleArray == nil) {
        [self requestPagesInfo];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addGoodImage:) name:@"ADDGOODSIMAGE" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteAdImage:) name:@"DELETEADPHOTO" object:nil];
    // 初始化导航栏
    [self setupNavBar];
    
    // 初始化UITableView
    [self setupNewSetShopTableView];
    
       
}

- (void)deleteAdImage:(NSNotification *)sender
{
    NSNumber *selectedIndexObject = sender.object;
    NSInteger selectedIndex = [selectedIndexObject integerValue];
    [self.adDataArray removeObjectAtIndex:selectedIndex];
    NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:6];
    NSArray *indexArray=[NSArray arrayWithObject:indexPath];
    [self.tableView reloadRowsAtIndexPaths:indexArray withRowAnimation: UITableViewRowAnimationAutomatic];
}

- (void)addGoodImage:(NSNotification *)sender
{
    UIImage *image = sender.object;
    [self.goodsArray insertObject:image atIndex:0];
    NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:7];
    NSArray *indexArray=[NSArray arrayWithObject:indexPath];
    [self.tableView reloadRowsAtIndexPaths:indexArray withRowAnimation: UITableViewRowAnimationAutomatic];
}

- (void)requestPagesInfo
{
    self.severID = -1;
    self.clickedCellNumber = 0;
    [self.adDataArray addObject:[UIImage imageNamed:@"addSkill"]];
    [self.goodsArray addObject:[UIImage imageNamed:@"addSkill"]];
    
    self.headTitleArray = @[@"店铺名称",@"店铺联系方式", @"业务范围", @"维修品类", @"主修品牌", @"服务类型", @"店首广告栏", @"额外的产品和服务"];
    NSArray *cellTitleArray = @[@"4-30字,字母或汉字", @"添加店铺联系方式", @"选择业务范围", @"选择维修品类", @"选择主修品牌", @"选择服务类型", @"", @""];
    self.cellTitleArray = [NSMutableArray arrayWithArray:cellTitleArray];
    
    NSDictionary *param = @{@"userid" : [UserDefaults objectForKey:@"userid"],
                            @"password" : [UserDefaults objectForKey:@"password"]};
    [[XMDealTool sharedXMDealTool] getSettingShopPageInfoWithParams:param Success:^(NSDictionary *deal) {
        
        if ([deal[@"status"] isEqual: @1]) {
            
            self.shopServerInfo = [NSMutableDictionary dictionaryWithDictionary:deal];
            
        }else{
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:deal[@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }

        
    }];
}

- (NSMutableArray *)cellTitleArray
{
    if (_cellTitleArray == nil) {
        _cellTitleArray = [NSMutableArray array];
    }
    return _cellTitleArray;
}

- (NSMutableArray *)tempArray
{
    if (_tempArray == nil) {
        _tempArray = [NSMutableArray array];
    }
    return _tempArray;
}

- (NSMutableDictionary *)update
{
    if (_update == nil) {
        _update = [NSMutableDictionary dictionary];
    }
    return _update;
}

- (NSMutableArray *)weixiupinlei_id
{
    if (_weixiupinlei_id == nil) {
        _weixiupinlei_id = [NSMutableArray array];
    }
    return _weixiupinlei_id;
}

- (NSMutableArray *)itemcategory_id
{
    if (_itemcategory_id == nil) {
        _itemcategory_id = [NSMutableArray array];
    }
    return _itemcategory_id;
}

- (NSMutableArray *)servicecategory_id
{
    if (_servicecategory_id == nil) {
        _servicecategory_id = [NSMutableArray array];
    }
    return _servicecategory_id;
}

- (NSMutableArray *)adDataArray
{
    if (_adDataArray == nil) {
        _adDataArray = [NSMutableArray array];
    }
    return _adDataArray;
}

- (NSMutableArray *)goodsArray
{
    if (_goodsArray == nil) {
        _goodsArray = [NSMutableArray array];
    }
    return _goodsArray;
}

#pragma mark - ------------------初始化TableView--------------------
- (void)setupNewSetShopTableView
{
    CGFloat tableView_y = 0;
    CGRect tableView_frame = CGRectMake(0, tableView_y, kDeviceWidth, kDeviceHeight - tableView_y);
    UITableView *tableView = [[UITableView alloc] initWithFrame:tableView_frame style:UITableViewStyleGrouped];
    [tableView setBackgroundColor:XMGlobalBg];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
//    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    [self.view addSubview:tableView];

   UIView   *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 100)];
    tableView.tableFooterView=view;
    
    
    
    UIButton  *button=[[UIButton alloc]initWithFrame:CGRectMake(10, 50 ,kDeviceWidth-20, kUILoginHeight)];
    [button setExclusiveTouch:YES];
    
    [button setTitle:@"开店喽！" forState:UIControlStateNormal];
    button.backgroundColor=XMButtonBg;
    [button addTarget:self action:@selector(buttonActionWithButton:) forControlEvents:UIControlEventTouchDown];
    button.layer.cornerRadius=5;
    [view addSubview:button];

}

-(void)buttonActionWithButton:(UIButton *)button
{
    button.enabled = NO;
    
    NSString *onestr = self.cellTitleArray[5];
    
    if ([onestr isEqualToString:@"选择服务类型"]) {
        button.enabled = YES;
        [self showAlertViewWithMessage:@"请完整填写信息"];
    }else{
        NSDictionary *param = @{@"userid" : [UserDefaults objectForKey:@"userid"],
                                @"password" : [UserDefaults objectForKey:@"password"],
                                @"maintaincategory_id" : self.update[@"categorylist"],
                                @"weixiupinlei_id" : [self.weixiupinlei_id componentsJoinedByString:@","],
                                @"itemcategory_id" : [self.itemcategory_id componentsJoinedByString:@","],
                                @"servicecategory_id" : [self.servicecategory_id componentsJoinedByString:@","],
                                @"address_id" : self.update[@"address_id"]};
        
        NSLog(@"---------------%@", param);
        
        [[XMDealTool sharedXMDealTool]setupShopWithParams:param Success:^(NSDictionary *deal) {
            if ([deal[@"status"] isEqual: @1]) {
                
                alertTimer=[[UIAlertView alloc]initWithTitle:@"开店成功" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
                
                [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(disAlert:) userInfo:nil repeats:YES];
                button.enabled = YES;
                
                [alertTimer show];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"SettingShopSuecess" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
                
                
            }
        }];

        
    }
}

-(void)disAlert:(NSTimer *)timer{
  
    [alertTimer dismissWithClickedButtonIndex:0 animated:YES];
}


#pragma mark - ------------------初始化TableView代理方法--------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.headTitleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section <6) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.section == 6){ // 店首广告栏
        
        UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc]init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        UICollectionView *adCollectionView  =[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100) collectionViewLayout:flowLayout];
        self.adCollectionView = adCollectionView;
        adCollectionView.tag = 1;
        [adCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collection"];
        [adCollectionView setBackgroundColor:[UIColor whiteColor]];
        adCollectionView.delegate = self;
        adCollectionView.dataSource = self;
        
        [cell addSubview:adCollectionView];
    }else if (indexPath.section == 7){
        
        static CGFloat button_w = 65;
        static CGFloat button_h = 80;
        static CGFloat button_y = 15;
        
        CGFloat intervl = 20;
        
        for (int index = 0; index < self.goodsArray.count; ++ index) {
            
            UIImage *image = self.goodsArray[index];
            CGFloat button_x = intervl +(button_w + intervl) * index;
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = index + 1;
            button.userInteractionEnabled = NO;
            if (button.tag == self.goodsArray.count) {
                
                button.userInteractionEnabled = YES;
                
            }
            [button setFrame:CGRectMake(button_x, button_y, button_w, button_h)];
            [button setBackgroundImage:image forState:UIControlStateNormal];
            [button setBackgroundImage:image forState:UIControlStateHighlighted];
            [button addTarget:self action:@selector(buttonClickToAddGoods) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:button];
            
        }
        
    
    }

    cell.textLabel.text = self.cellTitleArray[indexPath.section];
    [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
    [cell.textLabel setTextColor:kTextFontColor333];
    return cell;
}

- (void)buttonClickToAddGoods
{
    NSString *onestr = self.cellTitleArray[0];
    if ([onestr isEqualToString:@"4-30字,字母或汉字"]) {
        
        [self showAlertViewWithMessage:@"请填写店铺名称！"];
    }else{
        
        JHAddGoodsViewController *addGoodsViewController = [[JHAddGoodsViewController alloc] init];
        [self.navigationController pushViewController:addGoodsViewController animated:YES];
        
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 22)];
    label.text = [NSString stringWithFormat:@"   %@", self.headTitleArray[section]];
    [label setFont:[UIFont systemFontOfSize:15]];
    [label setTextColor:XMButtonBg];
    
    return label;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) { // 添加店铺名称
        
        JHEditShopNameViewController *editShopNameViewController = [[JHEditShopNameViewController alloc] init];
        editShopNameViewController.delegate = self;
        [self.navigationController pushViewController:editShopNameViewController animated:YES];
        
    }else if (indexPath.section == 1){ // 添加店铺联系方式
        NSString *onestr = self.cellTitleArray[indexPath.section - 1];
        if ([onestr isEqualToString:@"4-30字,字母或汉字"]) {
            
            [self showAlertViewWithMessage:@"请填写店铺名称！"];
        }else{
        
            JHCommonAddressViewController *addressViewController = [[JHCommonAddressViewController alloc] init];
            addressViewController.isDisplay = NO;
            addressViewController.delegate = self;
            [self.navigationController pushViewController:addressViewController animated:YES];
            
        }
        
        
    }else if (indexPath.section == 2){ // 业务范围
        
        NSString *onestr = self.cellTitleArray[indexPath.section - 1];
        if ([onestr isEqualToString:@"添加店铺联系方式"]) {
            
            [self showAlertViewWithMessage:@"请填写店铺联系方式！"];
        }else{

            
        NSArray *array = self.shopServerInfo[@"categorylist"];
        JHCheckBar *checkBar = [[JHCheckBar alloc] initWithArray:array andTitle:self.headTitleArray[indexPath.section] andFrame:CGRectMake((kDeviceWidth - 190) * 0.5, 150, 190, 250) andButtonType:kSingleButton];
//        checkBar.buttonStyle = kSingleButton;
        checkBar.index = indexPath.section;
        self.checkBar = checkBar;
        checkBar.delegate = self;
        [self showCoderWithView:checkBar];
            
        }
        
    }else if (indexPath.section == 3){ // 维修品类
        
        self.clickedCellNumber = indexPath.section;
        
        NSString *onestr = self.cellTitleArray[indexPath.section - 1];
        if ([onestr isEqualToString:@"选择业务范围"]) {   
            
            [self showAlertViewWithMessage:@"请选择业务范围"];
        }else{
        NSArray *temp_array = self.shopServerInfo[@"categorylist"];
        NSDictionary *dict = temp_array[self.severID - 1];
        NSArray *sun_array = dict[@"sun"];
        
        JHCheckBar *checkBar = [[JHCheckBar alloc] initWithArray:sun_array andTitle:self.headTitleArray[indexPath.section] andFrame:CGRectMake((kDeviceWidth - 190) * 0.5, 150, 190, 250) andButtonType:kCheckButton];
//        checkBar.buttonStyle = kCheckButton;
        checkBar.index = indexPath.section;
        self.checkBar = checkBar;
        checkBar.delegate = self;
        [self showCoderWithView:checkBar];
            
        }
        
    }else if (indexPath.section == 4){  //维修类型
        self.clickedCellNumber = indexPath.section;
        
        NSString *onestr = self.cellTitleArray[indexPath.section - 1];
        if ([onestr isEqualToString:@"选择维修品类"]) {
            
            [self showAlertViewWithMessage:@"请选择维修品类"];
        }else{
            NSArray *temp_array = self.shopServerInfo[@"brand"];
            NSArray *sun_array;
            if (self.severID - 1 == 0) {
                NSDictionary *dict = temp_array[self.severID - 1];
                sun_array = dict[@"sun"];
            }else{
                
                sun_array = nil;
            }
            JHCheckBar *checkBar = [[JHCheckBar alloc] initWithArray:sun_array andTitle:self.headTitleArray[indexPath.section] andFrame:CGRectMake((kDeviceWidth - 190) * 0.5, 150, 190, 250) andButtonType:kCheckButton];
//            checkBar.buttonStyle = kCheckButton;
            checkBar.index = indexPath.section;
            self.checkBar = checkBar;
            checkBar.delegate = self;
            [self showCoderWithView:checkBar];
            
        }
     
        
    }else if (indexPath.section == 5){  // 服务类型
        self.clickedCellNumber = indexPath.section;
        
        NSString *onestr = self.cellTitleArray[indexPath.section - 1];
        if ([onestr isEqualToString:@"选择主修品牌"]) {
            
            [self showAlertViewWithMessage:@"请选择主修品牌"];
        }else{

            NSArray *array = self.shopServerInfo[@"service"];
            JHCheckBar *checkBar = [[JHCheckBar alloc] initWithArray:array andTitle:self.headTitleArray[indexPath.section] andFrame:CGRectMake((kDeviceWidth - 190) * 0.5, 150, 190, 250) andButtonType:kCheckButton];
//            checkBar.buttonStyle = kCheckButton;
            checkBar.index = indexPath.section;
            self.checkBar = checkBar;
            checkBar.delegate = self;
            [self showCoderWithView:checkBar];
            
        }
        
    }else if (indexPath.section == 6){  // 店首广告栏

        
    }else if (indexPath.section == 7){  // 我的宝贝
        
        
    }else{
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 21;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < 6) {
        return 44;
    }else{
        return 100;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

#pragma mark - 
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    if (self.adDataArray.count > 9) {
        return 9;
    }else{
        return self.adDataArray.count;
    }
    
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
        
    static NSString *ID = @"collection";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UICollectionViewCell alloc] init];
    }
    
    if (indexPath.row <= 8) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 65, 78)];
        imageView.userInteractionEnabled = NO;
        id asset = self.adDataArray[indexPath.row];
        
        if ([asset isKindOfClass:[ALAsset class]]) {
            [imageView setImage:[UIImage imageWithCGImage:[asset thumbnail]]];
        }else{
            if ([asset isKindOfClass:[NSDictionary class]]) {
                
                imageView.userInteractionEnabled = YES;
                imageView.tag = indexPath.row;
                [imageView setImageWithURL:[NSURL URLWithString:asset[@"photo"]] placeholderImage:[UIImage imageNamed:@"skill_photo"]];
                UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewClickToShowAdImage:)];
                [imageView addGestureRecognizer:singleTap];
                
            }else{
                [imageView setImage:asset];
            }
        }
        
        [cell addSubview:imageView];
        
        return cell;
    }else{
        return cell;
    }
    
    
    
}

//设置元素的的大小框
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets top = {15,20,20,5};
    return top;
}

//设置顶部的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size={0,0};
    return size;
}

//设置元素大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(80,80);
}

//点击元素触发事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
        
    if (self.adDataArray.count -1  == indexPath.row) {
        
        [self updateUserPhoto];
        
        if (indexPath.row == 8) {
            [self.adDataArray removeLastObject];
        }
        
    }

    
}

#pragma mark - 添加图片
- (void)updateUserPhoto
{
    NSString *onestr = self.cellTitleArray[0];
    if ([onestr isEqualToString:@"4-30字,字母或汉字"]) {
        
        [self showAlertViewWithMessage:@"请填写店铺名称！"];
    }else{
        
        UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"拍照", @"从相册中选取", nil];
        [choiceSheet showInView:self.view];
        
    }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) { // 拍照
        
        XMLog(@"-------------------拍照--------------");
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
        
    }else if (buttonIndex == 1){    // 从相册中选取
        
        XMLog(@"-------------------从相册中选取--------------");
        [self selectPhotos];
        
    }else if (buttonIndex == 2){    // 取消
        
        XMLog(@"-------------------取消--------------");
        
    }else{
        
        XMLog(@"-------------------other--------------");
        
    }
}

- (void)selectPhotos
{
    
    CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
    picker.assetsFilter         = [ALAssetsFilter allAssets];
    picker.showsCancelButton    = (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad);
    picker.delegate             = self;
    picker.selectedAssets       = [NSMutableArray arrayWithArray:self.assets];
    
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    
    //压缩图片
//    UIImage *theImage = [self imageWithImageSimple:editedImage scaledToSize:CGSizeMake(100.0, 100.0)];
    
    // 设置时间格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
    
    //上传店首广告栏图片
    [self updateWithNewSetShopForAdImage:editedImage imageName:fileName url:@"Addshop/addAd"];
    
//    [MBProgressHUD showMessage:nil];
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
//        [MBProgressHUD hideHUD];
        
//        [self.adDataArray insertObject:editedImage atIndex:0];
//        NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:6];
//        NSArray *indexArray=[NSArray arrayWithObject:indexPath];
//        [self.tableView reloadRowsAtIndexPaths:indexArray withRowAnimation: UITableViewRowAnimationAutomatic];
//        
//        [self.adCollectionView reloadData];
        
        if (self.adDataArray.count >= 4 || self.adDataArray.count >= 7) {
            
            if (self.adDataArray.count > 4 || self.adDataArray.count > 7) {
                [self.adCollectionView setContentOffset:CGPointMake(0, 50 * (self.adDataArray.count/3 + 1)) animated:NO];
            }else{
                [self.adCollectionView setContentOffset:CGPointMake(0, 50 * (self.adDataArray.count/3 + 1)) animated:YES];
            }
            
        }
        
        
    }];
}

#pragma mark - 上传图片--------------------
- (void)updateWithNewSetShopForAdImage:(UIImage *)image imageName:(NSString *)imageName url:(NSString *)url
{
    [MBProgressHUD showMessage:nil];
    NSString *webUrl = [BaseUrl stringByAppendingString:url];
    
    NSString *userid = [XMDealTool sharedXMDealTool].userid;
    NSString *password = [XMDealTool sharedXMDealTool].password;
    NSData *imagedata = UIImageJPEGRepresentation(image, 0.5);
    
    // 1.创建请求管理对象
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    // 2.设置参数
    NSDictionary *parameters = @{@"userid":userid,@"password":password,@"photo":@""};
    XMLog(@"%@",parameters);
    // 3.上传图片
    [mgr POST:webUrl parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [MBProgressHUD hideHUD];
        //
        [formData appendPartWithFileData:imagedata name:imageName fileName:imageName mimeType:@"image/png"];
    } success:^(AFHTTPRequestOperation *operation,id responseObject) {
        
        [MBProgressHUD hideHUD];
        NSLog(@"Success: %@", responseObject);
        if ([responseObject[@"status"] isEqualToNumber:@(1)]) {
            NSMutableDictionary *adImageDictionary = [NSMutableDictionary dictionaryWithDictionary:responseObject];
            [self.adDataArray insertObject:adImageDictionary atIndex:self.adDataArray.count - 1];
            
            NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:6];
            NSArray *indexArray=[NSArray arrayWithObject:indexPath];
            [self.tableView reloadRowsAtIndexPaths:indexArray withRowAnimation: UITableViewRowAnimationAutomatic];
            [self.adCollectionView reloadData];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
        [MBProgressHUD hideHUD];
        XMLog(@"Error: %@", error);
    }];
    
}


- (void)setupNavBar
{
    [self.navigationItem setTitle:@"新建店铺"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"开店须知" style:UIBarButtonItemStyleDone target:self action:@selector(needKnowWithSetShop)];
}

- (void)needKnowWithSetShop
{
    XMBaseViewController *privyVC = [[XMBaseViewController alloc] init];
    
    privyVC.title = @"开店须知";
    privyVC.view.backgroundColor = XMGlobalBg;
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"shop" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [webView loadRequest:request];
    
    [privyVC.view addSubview:webView];
    
    [self.navigationController pushViewController:privyVC animated:YES];
}

#pragma mark - --------------------其他方法入口--------------------
- (void)showCoderWithView:(JHCheckBar *)checkBar
{
    // 1.添加阴影
    UIButton *cover = [[UIButton alloc] init];
    cover.frame = self.view.window.bounds;
    cover.backgroundColor = [UIColor blackColor];
    cover.alpha = 0.0;
    [cover addTarget:self action:@selector(hidenCover) forControlEvents:UIControlEventTouchUpInside];
    [self.view.window addSubview:cover];
    self.cover = cover;
    
    // 2.添加图片
    [self.view.window addSubview:checkBar];
    [checkBar setHidden:YES];
    
    
    // 4.执行动画
    [UIView animateWithDuration:0.25 animations:^{
        
        // 4.1.阴影慢慢显示出来
        cover.alpha = 0.5;
        
        // 4.2.显示图片
        [checkBar setHidden:NO];
    }];
}

- (void)hidenCover
{
    // 清空临时数组
    [self.tempArray removeAllObjects];
    
    // 执行动画
    [UIView animateWithDuration:0.25 animations:^{
        // 存放需要执行动画的代码
        self.checkBar.hidden = YES;
        // 阴影慢慢消失
        self.cover.alpha = 0.0;
    } completion:^(BOOL finished) {
        // 动画执行完毕后会自动调用这个block内部的代码
        // 动画执行完毕后,移除遮盖(从内存中移除)
        [self.cover removeFromSuperview];
        [self.checkBar removeFromSuperview];
        self.cover = nil;
        self.checkBar = nil;
    }];
}

- (void)imageViewClickToShowAdImage:(UITapGestureRecognizer *)sender
{
    UIImageView *imageView = (UIImageView *)sender.view;
    NSInteger imageViewTag = imageView.tag;
    
    JHDeleteAdPhotoViewController *deleteAdPhotoViewController = [[JHDeleteAdPhotoViewController alloc] init];
    deleteAdPhotoViewController.adPhotoDictionary = self.adDataArray[imageViewTag];
    deleteAdPhotoViewController.selectedIdex = imageViewTag;
    
    [self.navigationController pushViewController:deleteAdPhotoViewController animated:YES];
    
    
}

#pragma mark - --------------------代理方法--------------------

- (void)editShopNameViewController:(JHEditShopNameViewController *)editShopNameViewController didSaveShopName:(NSString *)shopName
{
    [self.cellTitleArray replaceObjectAtIndex:0 withObject:shopName];
    [self.tableView reloadData];
}

// 关闭按钮代理
- (void)checkBar:(JHCheckBar *)checkBar didClickCloseButton:(UIButton *)button
{
    [self hidenCover];
}

// 确定按钮代理
- (void)checkBar:(JHCheckBar *)checkBar didClickOkButton:(UIButton *)button
{
    [self hidenCover];
}

// 单选按钮代理
- (void)checkBar:(JHCheckBar *)checkBar didClickSingleChooseButton:(UIButton *)button
{
    
    [self.cellTitleArray replaceObjectAtIndex:checkBar.index withObject:button.titleLabel.text];
    self.severID = button.tag;
    [self.update setObject:[NSString stringWithFormat:@"%ld", (long)button.tag] forKey:@"categorylist"];
    [self.tableView reloadData];
    [self hidenCover];
    
}


// 复选按钮代理
- (void)checkBar:(JHCheckBar *)checkBar didClickCheckChooseButton:(UIButton *)button
{
    if (button.selected == YES) {
        [self.tempArray addObject:button.titleLabel.text];
        [self addArrayDataWith:checkBar didClickButton:button];
        NSString *tempString = [self.tempArray componentsJoinedByString:@","];
        [self.cellTitleArray replaceObjectAtIndex:checkBar.index withObject:tempString];
        [self.tableView reloadData];
    }else{
        
        for (NSString *selectedString in self.tempArray) {
            [self deleteArrayDataWith:checkBar didClickButton:button];
            if ([button.titleLabel.text isEqualToString:selectedString]) {
                [self.tempArray removeObject:selectedString];
                NSString *tempString = [self.tempArray componentsJoinedByString:@","];
                [self.cellTitleArray replaceObjectAtIndex:checkBar.index withObject:tempString];
                [self.tableView reloadData];
                break;
            }
        }
    }
    
}

#pragma mark - -----------------添加选中数据-----------------
- (void)addArrayDataWith:(JHCheckBar *)checkBar didClickButton:(UIButton *)button
{
    if (self.clickedCellNumber == 3) {
        
        [self.weixiupinlei_id addObject:@(button.tag)];
        
    }else if (self.clickedCellNumber == 4){
        
        [self.itemcategory_id addObject:@(button.tag)];
        
    }else if (self.clickedCellNumber == 5){
        
        [self.servicecategory_id addObject:@(button.tag)];
        
    }else{
        
    }
}

#pragma mark - -----------------删除选中数据-----------------
- (void)deleteArrayDataWith:(JHCheckBar *)checkBar didClickButton:(UIButton *)button
{
    if (self.clickedCellNumber == 3) {
        
        for (NSNumber *tag in self.weixiupinlei_id) {
            if (button.tag == [tag integerValue]) {
                [self.weixiupinlei_id removeObject:tag];
                break;
            }
        }
        
    }else if (self.clickedCellNumber == 4){
        
        for (NSNumber *tag in self.itemcategory_id) {
            if (button.tag == [tag integerValue]) {
                [self.itemcategory_id removeObject:tag];
                break;
            }
        }
        
    }else if (self.clickedCellNumber == 5){
        
        for (NSNumber *tag in self.servicecategory_id) {
            if (button.tag == [tag integerValue]) {
                [self.servicecategory_id removeObject:tag];
                break;
            }
        }
        
    }else{
        
    }
}

#pragma mark - -----------------选择联系人代理方法-----------------
- (void)commonAddressViewController:(JHCommonAddressViewController *)commonAddressViewController didSaveCommonAddress:(JHCommonAdress *)commonAdress
{

    [self.cellTitleArray replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%@%@", commonAdress.area, commonAdress.address]];
    [self.update setObject:commonAdress.ID forKey:@"address_id"];
    [self.tableView reloadData];
    
}

#pragma mark - -----------------Assets Picker Delegate-----------------

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker isDefaultAssetsGroup:(ALAssetsGroup *)group
{
    return ([[group valueForProperty:ALAssetsGroupPropertyType] integerValue] == ALAssetsGroupSavedPhotos);
}

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
    for (NSInteger index = 0; index < assets.count; ++ index) {
        
        ALAsset *asset = [[ALAsset alloc] init];
        asset = assets[index];;
        UIImage *adImage = [[UIImage alloc] init];
        adImage = [UIImage imageWithCGImage:[asset thumbnail]];
        
        // 设置时间格式
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        
        [self updateWithNewSetShopForAdImage:adImage imageName:fileName url:@"Addshop/addAd"];
    }
}

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldEnableAsset:(ALAsset *)asset
{
    // Enable video clips if they are at least 5s
    if ([[asset valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo])
    {
        NSTimeInterval duration = [[asset valueForProperty:ALAssetPropertyDuration] doubleValue];
        return lround(duration) >= 5;
    }
    else
    {
        return YES;
    }
}

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldSelectAsset:(ALAsset *)asset
{
    if (picker.selectedAssets.count >= 9)
    {
        UIAlertView *alertView =
        [[UIAlertView alloc] initWithTitle:@"提示"
                                   message:@"最多选择9张图片"
                                  delegate:nil
                         cancelButtonTitle:nil
                         otherButtonTitles:@"确定", nil];
        
        [alertView show];
    }
    
    if (!asset.defaultRepresentation)
    {
        UIAlertView *alertView =
        [[UIAlertView alloc] initWithTitle:@"提示"
                                   message:@"您的照片没有下载到您的设备"
                                  delegate:nil
                         cancelButtonTitle:nil
                         otherButtonTitles:@"确定", nil];
        
        [alertView show];
    }
    
    return (picker.selectedAssets.count < 9 && asset.defaultRepresentation != nil);
}




- (void)showAlertViewWithMessage:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    [alertView show];
    
};

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
