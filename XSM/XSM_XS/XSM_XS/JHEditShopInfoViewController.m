//
//  JHEditShopInfoViewController.m
//  XSM_XS
//
//  Created by Andy on 14-12-15.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "JHEditShopInfoViewController.h"
#import "JHEditShopNameViewController.h"
#import "JHCommonAddressViewController.h"
#import "JHCheckBar.h"
#import "XMDealTool.h"
#import "JHCommonAdress.h"
#import "JHAddGoodsViewController.h"
#import "JHEditShopInfo.h"
#import "JHDeleteAdPhotoViewController.h"


@interface JHEditShopInfoViewController ()<UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate,JHCheckBarDelegate, JHCommonAddressViewControllerDelegate, JHEditShopNameViewDelegate>
{
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

@property(nonatomic,strong) NSMutableArray *business_array;
@property(nonatomic,strong) NSMutableArray *itemcategory_array;
@property(nonatomic,strong) NSMutableArray *servicecategory_array;

@property(nonatomic,assign) BOOL isCellIIIFirst;
@property(nonatomic,assign) BOOL isCellIVFirst;
@property(nonatomic,assign) BOOL isCellVIFirst;

@property(nonatomic,assign) NSInteger clickedCellNumber;

@property (nonatomic, strong) NSMutableArray *goodsArray;
@property(nonatomic,strong) NSMutableArray *adDataArray;
@property(nonatomic,strong) UICollectionView *adCollectionView;
@property (nonatomic, strong) JHEditShopInfo *editShopInfo;

@property (nonatomic, strong) NSMutableArray *businessStringArray;


@property(nonatomic,assign) NSInteger selectGoodNumber;
@property(nonatomic,assign) NSInteger selectAdPhotoNumber;

@end

@implementation JHEditShopInfoViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.isCellIIIFirst = YES;
    self.isCellIVFirst = YES;
    self.isCellVIFirst = YES;
    
    if (self.headTitleArray == nil) {
        [self requestDataForSavedInfo];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addGoodImage:) name:@"ADDGOODSIMAGE" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editGoodImage:) name:@"EDITGOODSIMAGE" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteAdphoto:) name:@"DELETEADPHOTO" object:nil];
    [self setupNavigationItemInfo];
    [self setupEditShopTableView];

}

- (void)editGoodImage:(NSNotification *)sender
{
    UIImage *image = sender.object;
    
    [self.goodsArray replaceObjectAtIndex:self.selectGoodNumber withObject:image];
    
    NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:7];
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

- (void)deleteAdphoto:(NSNotification *)sender
{
    NSNumber *selectedIndexObject = sender.object;
    NSInteger selectedIndex = [selectedIndexObject integerValue];
    [self.adDataArray removeObjectAtIndex:selectedIndex];
    NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:6];
    NSArray *indexArray=[NSArray arrayWithObject:indexPath];
    [self.tableView reloadRowsAtIndexPaths:indexArray withRowAnimation: UITableViewRowAnimationAutomatic];
    
}

- (void)requestDataForSavedInfo
{
    NSDictionary *param = @{@"userid" : [UserDefaults objectForKey:@"userid"],
                            @"password" : [UserDefaults objectForKey:@"password"]};
    [[XMDealTool sharedXMDealTool] showSavedShopInfoWithParams:param Success:^(NSDictionary *deal) {
        
        if ([deal[@"status"] isEqual: @1]) {
            
            JHEditShopInfo *editShopInfo = [JHEditShopInfo editShopInfoWithDict:deal];
            self.editShopInfo = editShopInfo;
            
            
            [self setupPagesInfo];
            [self.tableView reloadData];
            
        }else{
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:deal[@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
        
    }];
}

- (void)setupPagesInfo
{
    self.severID = -1;
    self.clickedCellNumber = 0;
    [self.adDataArray addObject:[UIImage imageNamed:@"addSkill"]];
    [self.goodsArray addObject:[UIImage imageNamed:@"addSkill"]];
    
    // 店铺名称
    NSArray *shopnamearray = self.editShopInfo.shop_name;
    NSDictionary *shopnamedictionary = shopnamearray[0];
    
    // 店铺地址
    NSArray *addressnamearray = self.editShopInfo.address;
    NSDictionary *addressnamedictionary = addressnamearray[0];
    NSString *addressstring = [NSString stringWithFormat:@"%@%@", addressnamedictionary[@"area"], addressnamedictionary[@"address"]];
    [self.update setObject:addressnamedictionary[@"id"] forKey:@"address_id"];
    
    // 维修范围
    NSArray *businessArray = self.editShopInfo.business;
    NSString *businessString = [[NSString alloc] init];
    NSInteger business_index = 0;
    for (NSInteger index = 0; index < businessArray.count; ++index) {
        NSDictionary *businessdictionary = businessArray[index];
        if ([businessdictionary[@"checked"] isEqualToString:@"1"]) {
            
            businessString = businessdictionary[@"typename"];
            self.severID = [businessdictionary[@"id"] integerValue];
            [self.update setObject:[NSString stringWithFormat:@"%ld", self.severID] forKey:@"categorylist"];
            business_index = index;
            break;
        }
    }
    
    // 维修品类
    NSMutableArray *weixiupinlei_id = [NSMutableArray array];
    NSDictionary *sunDictionary = self.editShopInfo.business[business_index];
    NSArray *sunArray = sunDictionary[@"sun"];
    NSMutableArray *suns = [NSMutableArray array];
    for (NSInteger index = 0; index < sunArray.count; ++index) {
        NSDictionary *sunChildDictionary = sunArray[index];
        if ([sunChildDictionary[@"checked"] isEqualToString:@"1"]) {
            [suns addObject:sunChildDictionary[@"typename"]];
            [weixiupinlei_id addObject:sunChildDictionary[@"id"]];
        }
    }
    self.business_array = suns;
    NSString *sunString = [suns componentsJoinedByString:@","];
    self.weixiupinlei_id = weixiupinlei_id;
    
    // 主修品牌
    NSMutableArray *itemcategory_id = [NSMutableArray array];
    NSMutableArray *brandSuns = [NSMutableArray array];
    NSArray *brandarray = self.editShopInfo.brand;
    for (NSInteger index_x = 0; index_x < brandarray.count; ++ index_x) {
        NSDictionary *brandChildDictionary = brandarray[index_x];
        if ([brandChildDictionary[@"id"] isEqualToString:@"26"]) {
            
            NSArray *brandSunArray = brandChildDictionary[@"sun"];
            for (NSInteger index_y = 0; index_y < brandSunArray.count; ++index_y) {
                
                NSDictionary *brandSunDictionary = brandSunArray[index_y];
                if ([brandSunDictionary[@"checked"] isEqualToString:@"1"]) {
                    [brandSuns addObject:brandSunDictionary[@"typename"]];
                    [itemcategory_id addObject:brandSunDictionary[@"id"]];
                }
            }
        }
    }
    self.itemcategory_array = brandSuns;
    NSString *brandSunString = [brandSuns componentsJoinedByString:@","];
    self.itemcategory_id = itemcategory_id;
    
    // 选择服务类型
    NSMutableArray *servicecategory_id = [NSMutableArray array];
    NSMutableArray *services = [NSMutableArray array];
    NSArray *serverArray = self.editShopInfo.services;
    for (NSInteger index = 0; index < serverArray.count; ++ index) {
        
        NSDictionary *serverDictiuonary = serverArray[index];
        if ([serverDictiuonary[@"checked"] isEqualToString:@"1"]) {
            [servicecategory_id addObject:serverDictiuonary[@"id"]];
            [services addObject:serverDictiuonary[@"typename"]];
        }
    }
    self.servicecategory_array = services;
    NSString *serverString = [services componentsJoinedByString:@","];
    self.servicecategory_id = servicecategory_id;
    
    // 广告图片
//    NSMutableArray *adphotos = [NSMutableArray array];
    NSArray *adphotoArray = self.editShopInfo.adphoto;
//    for (NSInteger index = 0; index < adphotoArray.count; ++ index) {
//        NSDictionary *adphotoDictionary = adphotoArray[index];
//        [adphotos addObject:adphotoDictionary[@"photo"]];
//    }
    if (adphotoArray !=nil && adphotoArray.count > 0) {
        
        for (NSInteger index = 0; index < adphotoArray.count; ++ index) {
            NSDictionary *adphotoDictionary = adphotoArray[index];
            [self.adDataArray insertObject:adphotoDictionary atIndex:index];
        }
    }
    
    
    // 宝贝
    NSArray *goodArray = self.editShopInfo.goods;
    if (goodArray !=nil && goodArray.count > 0) {
        
        for (NSInteger index = 0; index < goodArray.count; ++ index) {
            
            NSDictionary *goodDictionary = goodArray[index];
            
            [self.goodsArray insertObject:goodDictionary atIndex:index];
        }
    }
    
    
    self.headTitleArray = @[@"店铺名称",@"店铺联系方式", @"业务范围", @"维修品类", @"主修品牌", @"服务类型", @"店首广告栏", @"额外的产品和服务"];
    NSArray *cellTitleArray = @[shopnamedictionary[@"shop"], addressstring, businessString, sunString, brandSunString, serverString, @"", @""];
    self.cellTitleArray = [NSMutableArray arrayWithArray:cellTitleArray];
    

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

- (NSMutableArray *)businessStringArray
{
    if (_businessStringArray == nil) {
        _businessStringArray = [NSMutableArray array];
    }
    return _businessStringArray;
}

#pragma mark - ------------------初始化TableView--------------------
- (void)setupEditShopTableView
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
    
//    UIView   *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 100)];
//    tableView.tableFooterView=view;
//    
//    
//    
//    UIButton  *button=[[UIButton alloc]initWithFrame:CGRectMake(10, 50 ,kDeviceWidth-20, kUILoginHeight)];
//    
//    [button setTitle:@"完成编辑" forState:UIControlStateNormal];
//    button.backgroundColor=XMButtonBg;
//    [button addTarget:self action:@selector(buttonClickToEditShopInfo) forControlEvents:UIControlEventTouchDown];
//    button.layer.cornerRadius=5;
//    [view addSubview:button];
    
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
        UICollectionView *collectionView  =[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100) collectionViewLayout:flowLayout];
        
        collectionView.tag = 1;
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collection"];
        [collectionView setBackgroundColor:[UIColor whiteColor]];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        
        [cell addSubview:collectionView];
    }else if (indexPath.section == 7){
        
        static CGFloat button_w = 65;
        static CGFloat button_h = 78;
        static CGFloat button_y = 15;
        
        CGFloat intervl = 20;
        
        NSInteger goodnumber = self.goodsArray.count;
        
        if (self.goodsArray.count > 3) {
//            [self.goodsArray removeLastObject];
            goodnumber = 3;
        }
        
        for (int index = 0; index < goodnumber; ++ index) {
            
            CGFloat button_x = intervl +(button_w + intervl) * index;
            UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 200, 200)];
            
            id goodDictionary = self.goodsArray[index];
            if ([goodDictionary isKindOfClass:[NSDictionary class]]) {
                
                [imageView setImageWithURL:goodDictionary[@"photo"] placeholderImage:[UIImage imageNamed:@"skill_photo"]];
                
            }else{
                [imageView setImage:goodDictionary];
            }
            imageView.tag = index + 1;
            imageView.userInteractionEnabled = YES;
            
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buttonClickToAddGoods:)];
            [imageView addGestureRecognizer:singleTap];
            [imageView setFrame:CGRectMake(button_x, button_y, button_w, button_h)];
            [cell addSubview:imageView];
            
        }

        
    }
    cell.textLabel.text = self.cellTitleArray[indexPath.section];
    [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
    [cell.textLabel setTextColor:kTextFontColor333];
    return cell;
}

- (void)buttonClickToAddGoods:(UIGestureRecognizer *)sender
{
    NSString *onestr = self.cellTitleArray[0];
    if ([onestr isEqualToString:@"4-30字,字母或汉字"]) {
        
        [self showAlertViewWithMessage:@"请填写店铺名称！"];
    }else{
        
        UIImageView *imageView = (UIImageView *)sender.view;
        NSInteger imageViewTag = imageView.tag;
        self.selectGoodNumber = imageViewTag - 1;
        
        JHAddGoodsViewController *addGoodsViewController = [[JHAddGoodsViewController alloc] init];
        if (imageViewTag != self.goodsArray.count) {
            
            addGoodsViewController.goodDataDictionary = self.goodsArray[imageViewTag - 1];
            
        }
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
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已开好的店铺名称暂不能更改" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alert show];
        
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
            
            
            NSArray *array = self.editShopInfo.business;
            JHCheckBar *checkBar = [[JHCheckBar alloc] initWithArray:array andTitle:self.headTitleArray[indexPath.section] andFrame:CGRectMake((kDeviceWidth - 190) * 0.5, 150, 190, 250) andButtonType:kSingleButton];
//            checkBar.buttonStyle = kSingleButton;
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
            
            NSArray *temp_array = self.editShopInfo.business;
            NSDictionary *dict = temp_array[self.severID - 1];
            NSArray *sun_array = dict[@"sun"];
            
            JHCheckBar *checkBar = [[JHCheckBar alloc] initWithArray:sun_array andTitle:self.headTitleArray[indexPath.section] andFrame:CGRectMake((kDeviceWidth - 190) * 0.5, 150, 190, 250) andButtonType:kCheckButton];
//            checkBar.buttonStyle = kCheckButton;
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
            
            NSArray *temp_array = self.editShopInfo.brand;
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
            
            NSArray *array = self.editShopInfo.services;
            JHCheckBar *checkBar = [[JHCheckBar alloc] initWithArray:array andTitle:self.headTitleArray[indexPath.section] andFrame:CGRectMake((kDeviceWidth - 190) * 0.5, 150, 190, 250) andButtonType:kCheckButton];
//            checkBar.buttonStyle = kCheckButton;
            checkBar.index = indexPath.section;
            self.checkBar = checkBar;
            checkBar.delegate = self;
            [self showCoderWithView:checkBar];
            
        }
        
    }else if (indexPath.section == 6){  // 店首广告栏
        
        
    }else if (indexPath.section == 7){  // 店首广告栏
        
        
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.adDataArray.count >9) {
        
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
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 65, 78)];
    
    if (indexPath.row > 8) {
        cell.hidden = YES;
    }else{
        cell.hidden = NO;
    }
    
    id image = self.adDataArray[indexPath.row];
    if ([image isKindOfClass:[UIImage class]]) {
        
        [imageView setImage:image];
        
    }else{
        
        [imageView setImageWithURL:[NSURL URLWithString:image[@"photo"]] placeholderImage:[UIImage imageNamed:@"skill_photo"]];
        
    }
    
    [cell addSubview:imageView];
    return cell;
    
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
        
        [self editShopAdPhoto:indexPath.row];
        [collectionView reloadData];
        
    }else{
        
        XMLog(@"%ld", (long)indexPath.row);
        JHDeleteAdPhotoViewController *deleteAdPhotoViewController = [[JHDeleteAdPhotoViewController alloc] init];
        deleteAdPhotoViewController.selectedIdex = indexPath.row;
        deleteAdPhotoViewController.adPhotoDictionary = self.adDataArray[indexPath.row];
        
        [self.navigationController pushViewController:deleteAdPhotoViewController animated:YES];
        
    }
    
}

#pragma mark - 修改头像
- (void)editShopAdPhoto:(NSInteger)index
{
    self.selectAdPhotoNumber = index;
    
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [choiceSheet showInView:self.view];
}

#pragma mark - VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    //    photo.image = editedImage;
    
    //压缩图片
    UIImage *theImage = [self imageWithImageSimple:editedImage scaledToSize:CGSizeMake(100.0, 100.0)];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置时间格式
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
    
    //保存图片到本地
    [self saveImage:theImage WithName:fileName];
    
    //上传店首广告栏图片
    [self updateWithEditShopInfoForAdImage:fileName url:@"Addshop/addAd"];
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        
//        [self.adDataArray insertObject:editedImage atIndex:self.adDataArray.count - 1];
        NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:6];
        NSArray *indexArray=[NSArray arrayWithObject:indexPath];
        [self.tableView reloadRowsAtIndexPaths:indexArray withRowAnimation: UITableViewRowAnimationAutomatic];
        
        [self.adCollectionView reloadData];
        
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
- (void)updateWithEditShopInfoForAdImage:(NSString *)imageName url:(NSString *)url
{
    [MBProgressHUD showMessage:nil];
    NSString *webUrl = [BaseUrl stringByAppendingString:url];
    
    NSString *userid = [XMDealTool sharedXMDealTool].userid;
    NSString *password = [XMDealTool sharedXMDealTool].password;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; //path数组里貌似只有一个元素
    NSString *filestr = [NSString stringWithFormat:@"/%@",imageName];
    NSString *newstr = [documentsDirectory stringByAppendingString:filestr];
    
    NSData *dd = [NSData dataWithContentsOfFile:newstr];
    
    // 1.创建请求管理对象
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    // 2.设置参数
    NSDictionary *parameters = @{@"userid":userid,@"password":password,@"photo":@""};
    XMLog(@"%@",parameters);
    // 3.上传图片
    [mgr POST:webUrl parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //
        [formData appendPartWithFileData:dd name:imageName fileName:imageName mimeType:@"image/png"];
    } success:^(AFHTTPRequestOperation *operation,id responseObject) {
        [MBProgressHUD hideHUD];
        NSLog(@"Success: %@", responseObject);
        NSMutableDictionary *photoDictionary = [NSMutableDictionary dictionaryWithDictionary:responseObject];
        [self.adDataArray insertObject:photoDictionary atIndex:self.adDataArray.count - 1];
        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}


#pragma mark - -------------------完成编辑按钮点击事件-----------------
-(void)buttonClickToOverEditShopInfo
{
    
    NSString *onestr = self.cellTitleArray[5];
    
    if ([onestr isEqualToString:@"选择服务类型"]) {
        
        [self showAlertViewWithMessage:@"请完整填写信息"];
    }else{
        
        NSDictionary *param = @{@"userid" : [UserDefaults objectForKey:@"userid"],
                                @"password" : [UserDefaults objectForKey:@"password"],
                                @"maintaincategory_id" : self.update[@"categorylist"],
//                                @"maintaincategory_id" : @"1",
                                @"weixiupinlei_id" : [self.weixiupinlei_id componentsJoinedByString:@","],
                                @"itemcategory_id" : [self.itemcategory_id componentsJoinedByString:@","],
//                                @"itemcategory_id" : @"2,3",
                                @"servicecategory_id" : [self.servicecategory_id componentsJoinedByString:@","],
                                @"address_id" : self.update[@"address_id"]};
        
        NSLog(@"---------------%@", param);
        [[XMDealTool sharedXMDealTool] editShopInfoWithParams:param Success:^(NSDictionary *deal) {
            
            if ([deal[@"status"] isEqual: @1]) {
                
                alertTimer=[[UIAlertView alloc]initWithTitle:@"编辑成功" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
                
                [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(disAlert:) userInfo:nil repeats:YES];
                
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
    if (button.titleLabel.text != nil && button.titleLabel.text.length > 0) {
        
        [self.cellTitleArray replaceObjectAtIndex:checkBar.index withObject:button.titleLabel.text];
        self.severID = button.tag;
        [self.update setObject:[NSString stringWithFormat:@"%ld", (long)button.tag] forKey:@"categorylist"];
        [self.tableView reloadData];
    }
    
    [self hidenCover];
    
}


// 复选按钮代理
- (void)checkBar:(JHCheckBar *)checkBar didClickCheckChooseButton:(UIButton *)button
{
    
    if (button.titleLabel.text != nil && button.titleLabel.text.length > 0) {
        
        if (button.selected == YES) {
            [self.tempArray addObject:button.titleLabel.text];
            [self addArrayDataWith:checkBar didClickButton:button];
            NSString *tempString = [self.tempArray componentsJoinedByString:@","];
            [self.cellTitleArray replaceObjectAtIndex:checkBar.index withObject:tempString];
            [self.tableView reloadData];
        }else{
            
            if (self.isCellIIIFirst == YES && self.clickedCellNumber == 3) {
                
                self.tempArray = self.business_array;
            }
            
            if (self.isCellIVFirst == YES && self.clickedCellNumber == 4) {
                self.tempArray = self.itemcategory_array;
            }
            
            if (self.isCellVIFirst == YES && self.clickedCellNumber == 5) {
                self.tempArray = self.servicecategory_array;
            }
            
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
    
}

- (void)addArrayDataWith:(JHCheckBar *)checkBar didClickButton:(UIButton *)button
{
    if (self.clickedCellNumber == 3) {
        
        if (self.isCellIIIFirst == YES) {
            
            [self.weixiupinlei_id removeAllObjects];
            self.isCellIIIFirst = NO;
        }
        
        [self.weixiupinlei_id addObject:@(button.tag)];
        
    }else if (self.clickedCellNumber == 4){
        
        if (self.isCellIVFirst == YES) {
            
            [self.itemcategory_id removeAllObjects];
            self.isCellIVFirst = NO;
        }
        
        [self.itemcategory_id addObject:@(button.tag)];
        
    }else if (self.clickedCellNumber == 5){
        
        if (self.isCellVIFirst == YES) {
            
            [self.servicecategory_id removeAllObjects];
            self.isCellVIFirst = NO;
        }
        
        [self.servicecategory_id addObject:@(button.tag)];
        
    }else{
        
    }
}

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


- (void)commonAddressViewController:(JHCommonAddressViewController *)commonAddressViewController didSaveCommonAddress:(JHCommonAdress *)commonAdress
{
    
    [self.cellTitleArray replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%@%@", commonAdress.area, commonAdress.address]];
    [self.update setObject:commonAdress.ID forKey:@"address_id"];
    [self.tableView reloadData];
    
}



- (void)showAlertViewWithMessage:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    [alertView show];
    
};

- (void)setupNavigationItemInfo
{
    [self.navigationItem setTitle:@"编辑店铺信息"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(buttonClickToOverEditShopInfo)];
}

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
