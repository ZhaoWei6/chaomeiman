//
//  XMRepairDetailViewController.m
//  XiuShemMa
//
//  Created by Apple on 14-10-5.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMRepairDetailViewController.h"
#import "XMHomeHeadView.h"
#import "XMGoodsView.h"
#import "XMAlbumViewController.h"
#import "XMRatingView.h"
#import "XMLoginViewController.h"
#import "XMBaseNavigationController.h"
#import "XMRepairman.h"

#import "XMProvideHomeServiceController.h"
#import "XMSendViewController.h"

#import "XMOrderListViewController.h"
#import "XMMainViewController.h"
#import "XMRatingOrderViewController.h"
#import "XMDevoteController.h"
#import "XMRatingListViewController.h"

#import "XMDealTool.h"
#import "XMRepairmanDetail.h"
#import "XMHttpTool.h"

#import "XMGoViewController.h"
#import "XMGetAddressViewController.h"
#import "UMSocial.h"
@interface XMRepairDetailViewController ()<UITableViewDataSource,UITableViewDelegate,XMGoodsViewTouchDelegate>
{
    UIView *_headView;
    UIScrollView *_topScrollView;//顶部滑动视图
    UILabel *currentIndex;//照片墙当前页标签
    UITableView *_tableView;
    NSArray *_arrayImage;
    UIAlertView  *alertView11;
    
    CGRect frame_first;
    UIImageView *fullImageView;
    UIView  *view;
    
    UIButton *collectButton;//收藏
}
@end

@implementation XMRepairDetailViewController

- (void)viewDidLoad
{
    self.title = @"店铺详情";
    [super viewDidLoad];
    
    [self initNavigationItem];
    [self initTableView];
    [self initBottomButton];
    //请求数据
    [self requestData];
}

#pragma mark -
#pragma mark 导航栏按钮  - 分享、收藏
- (void)initNavigationItem
{
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 25)];
    //收藏
    collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    collectButton.frame = CGRectMake(0, 0, 25, 25);
    [collectButton setImage:[UIImage imageWithName:@"icon_collect"] forState:UIControlStateNormal];
    [collectButton addTarget:self action:@selector(collectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:collectButton];
    collectButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    //分享
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(collectButton.right+10, 0, 25, 25);
    [shareButton setImage:[UIImage imageWithName:@"icon_share"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:shareButton];
    shareButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
}
#pragma mark 表格
- (void)initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kDeviceWidth, kDeviceHeight-64-49) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.hidden = YES;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = XMGlobalBg;
}
#pragma mark 照片墙
- (void)loadHeadView
{
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDetailPhotoHeight)];
    _tableView.tableHeaderView = _headView;
    //滑动视图
    _topScrollView = [[UIScrollView alloc] initWithFrame:_headView.bounds];
    _topScrollView.contentMode = UIViewContentModeScaleAspectFill;
    _topScrollView.pagingEnabled = YES;
//    _topScrollView.delegate = self;
    _topScrollView.showsHorizontalScrollIndicator = NO;
    [_headView addSubview:_topScrollView];
    
    _arrayImage = _repairman.maintainphoto;
    if ([_arrayImage isKindOfClass:[NSArray class]] && _arrayImage.count) {
        for (int i=0; i<_arrayImage.count; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*_headView.width, 0, _headView.width, _headView.height)];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            NSDictionary *file = _arrayImage[i];
            [imageView setImageWithURL:[NSURL URLWithString:file[@"photo"]] placeholderImage:[UIImage imageNamed:@"banner_register"]];
            [_topScrollView addSubview:imageView];
            imageView.userInteractionEnabled = YES;
            _topScrollView.delegate = self;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage:)];
            [imageView addGestureRecognizer:tap];
        }
        _topScrollView.contentSize = CGSizeMake(_headView.width*_arrayImage.count, 0);
        
        currentIndex = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth-50, _headView.height-50, 40, 40)];
        currentIndex.text = [NSString stringWithFormat:@"1/%i",_arrayImage.count];
        currentIndex.textColor = [UIColor whiteColor];
        currentIndex.textAlignment = NSTextAlignmentCenter;
        currentIndex.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        currentIndex.layer.cornerRadius = 20;
        currentIndex.layer.masksToBounds = YES;
        [_headView addSubview:currentIndex];
    }else{
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _headView.width, _headView.height)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [imageView setImage:[UIImage imageNamed:@"banner_register"]];
        [_topScrollView addSubview:imageView];
    }
}
#pragma mark 下单按钮
- (void)initBottomButton
{
    NSArray *titles = @[@"上门服务",@"寄修",@"进店维修"];
    self.view.backgroundColor = [UIColor whiteColor];
    for (int i=0; i<3; i++) {
        UIButton *orderButton = [UIButton buttonWithType:UIButtonTypeSystem];
        orderButton.tag = 100+i;
        //        orderButton.backgroundColor = XMButtonBg;
        orderButton.titleLabel.font = kDetailLabelFont;
        [orderButton setTitle:titles[i] forState:UIControlStateNormal];
        [orderButton setTitleColor:kTextFontColor333  forState:UIControlStateNormal];
        [orderButton setTitleColor:kTextFontColor999 forState:UIControlStateDisabled];
        [orderButton setTitleColor:XMButtonBg  forState:UIControlStateHighlighted];
        
        //有寄修模块
//        orderButton.frame = CGRectMake((kDeviceWidth-2)/3*i+(kDeviceWidth/3-75)/2+i, self.view.bottom-49/2-15, 75, 30);
        //无寄修模块
        CGFloat w = 75;
        CGFloat h = 30;
        CGFloat x = i==0 ? (kDeviceWidth-150)/3.0 : (kDeviceWidth-150)*2/3.0 + w;
        CGFloat y = self.view.bottom-49/2.0-15;
        orderButton.frame = CGRectMake(x, y, w, h);
        
        //
        [orderButton addTarget:self action:@selector(orderButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:orderButton];
        //        orderButton.layer.cornerRadius = 5;
        orderButton.enabled = NO;
        
        //隐藏寄修模块
        orderButton.hidden = i==1;
    }
    
    UIView *separateView = [[UIView alloc] initWithFrame:CGRectMake(0, kDeviceHeight-49, kDeviceWidth, 0.5)];
    separateView.backgroundColor = kBorderColor;
    [self.view addSubview:separateView];
}

#pragma mark - 请求数据
- (void)requestData
{
    //    [MBProgressHUD showMessage:@"加载中..."];
    [[XMDealTool sharedXMDealTool] dealsWithMaintainerid:_maintainer_id success:^(NSArray *deals, int islast) {
        //        [MBProgressHUD hideHUD];
        //
        _repairman = [deals lastObject];
        _tableView.hidden = NO;
        //顶部照片墙
        [self loadHeadView];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView reloadData];
        //        修神上门、寄修、进店维修
        [self  buttonState];
        //修改收藏按钮
        [self setCollectButtonState:islast];
    }];
}

- (void)buttonState
{
    if ([_repairman.servicelist isKindOfClass:[NSArray class]]) {
        
        NSArray *arr = _repairman.servicelist;
        
        for (NSDictionary *dict in arr) {
            NSInteger i = [dict[@"id"] integerValue];
            UIButton *orderButton;
            if (i==1) {
                orderButton = (UIButton *)[self.view viewWithTag:100];
                orderButton.enabled=YES;
            }else if(i==2){
                orderButton = (UIButton *)[self.view viewWithTag:101];
                orderButton.enabled=YES;
                
            }else{
                orderButton = (UIButton *)[self.view viewWithTag:102];
                orderButton.enabled=YES;
            }
        }
    }else{
        XMLog(@"服务列表获取失败");
    }
}

- (void)setCollectButtonState:(int)state
{
    if (state==1) {
        [collectButton setImage:[UIImage imageWithName:@"icon_collect-1"] forState:UIControlStateNormal];
        collectButton.tag = 2;
    }else{
        [collectButton setImage:[UIImage imageWithName:@"icon_collect"] forState:UIControlStateNormal];
        collectButton.tag = 1;
    }
}

#pragma mark - 表格方法
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    UIView *backgroundView = [[UIView alloc] init];
    switch (indexPath.row) {
        case 0:
        {
            backgroundView.frame = CGRectMake(0, 10, kDeviceWidth, 160);
            backgroundView.backgroundColor = [UIColor whiteColor];
            //                backgroundView.layer.cornerRadius = 5;
            //                backgroundView.layer.borderColor = XMColor(232, 232, 232).CGColor;
            //店铺简介
            QHLabel *detailLabel = [[QHLabel alloc] initWithFrame:CGRectMake(15, 15, backgroundView.width-30, 20)];
            detailLabel.font = [UIFont systemFontOfSize:20];
            detailLabel.textColor = XMButtonBg;
            detailLabel.text = _repairman.shop;
            //                detailLabel.layer.cornerRadius=5;
            //                detailLabel.layer.borderWidth=0;
            [backgroundView addSubview:detailLabel];
            
            UIImageView  *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(detailLabel.right-30, detailLabel.top, 24, 24)];
            imageView.contentMode=UIViewContentModeScaleAspectFit;
            imageView.image=[UIImage resizedImage:@"icon_go"];
            [backgroundView addSubview:imageView];
            //分割线
            UIView *separateView = [[UIView alloc] initWithFrame:CGRectMake(detailLabel.left, detailLabel.bottom+15, backgroundView.width - detailLabel.left*2, 1)];
            separateView.backgroundColor = kBorderColor;
            [backgroundView addSubview:separateView];
            
            //修神姓名
            QHLabel *nameLabel = [[QHLabel alloc] initWithFrame:CGRectMake(separateView.left, separateView.bottom+15, kDeviceWidth-30, 20)];
            nameLabel.backgroundColor = [UIColor clearColor];
            nameLabel.text = [NSString stringWithFormat:@"修神：%@",_repairman.nickname];
            nameLabel.font = kDetailLabelFont;
            nameLabel.textColor = kTextFontColor666;
            [backgroundView addSubview:nameLabel];
            
            kColorText(nameLabel, 3, _repairman.nickname, kTextFontColor333)
            //                QHLabel *name_Label = [[QHLabel alloc] initWithFrame:CGRectMake(nameLabel.right, nameLabel.top, 100, 20)];
            //                name_Label.backgroundColor = [UIColor clearColor];
            //                name_Label.font = kDetailLabelFont;
            //                name_Label.text = _repairman.nickname;
            //                name_Label.textColor = kTextFontColor333;
            //                [backgroundView addSubview:name_Label];
            
            //修神擅长
            QHLabel *specialLabel = [[QHLabel alloc] initWithFrame:CGRectMake(nameLabel.left, nameLabel.bottom+10, kDeviceWidth-30, 20)];
            specialLabel.backgroundColor = [UIColor clearColor];
            specialLabel.text = @"主修：";
            specialLabel.font = kDetailLabelFont;
            specialLabel.textColor = kTextFontColor666;
            //                specialLabel.numberOfLines = 0;
            [backgroundView addSubview:specialLabel];
            //设置高度自适应
            specialLabel.width = [specialLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, specialLabel.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:specialLabel.font} context:nil].size.width;
            
            //                kColorText(specialLabel, 0, @"主修：", kTextFontColor666)
            QHLabel *special_Label = [[QHLabel alloc] initWithFrame:CGRectMake(specialLabel.right, specialLabel.top, kDeviceWidth-30-specialLabel.width, 1000)];
            special_Label.backgroundColor = [UIColor clearColor];
            special_Label.numberOfLines = 0;
            special_Label.font = kDetailLabelFont;
            special_Label.text = [_repairman.desc isEqualToString:@""] ?@"无":_repairman.desc;
            special_Label.textColor = kTextFontColor333;
            [special_Label sizeToFit];
            [backgroundView addSubview:special_Label];
            
            special_Label.height = [special_Label.text boundingRectWithSize:CGSizeMake(special_Label.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:special_Label.font} context:nil].size.height;
            //修理数量
            QHLabel *numberlLabel = [[QHLabel alloc] initWithFrame:CGRectMake(nameLabel.left, special_Label.bottom+10, (kDeviceWidth-30)/3, 20)];
            numberlLabel.backgroundColor = [UIColor clearColor];
            numberlLabel.text = [NSString stringWithFormat:@"已修：%i部",_repairman.maintaincount];
            numberlLabel.textColor = XMColor(254, 187, 51);
            numberlLabel.font = kDetailLabelFont;
            [backgroundView addSubview:numberlLabel];
            
            //                QHLabel *numberl_Label = [[QHLabel alloc] initWithFrame:CGRectMake(numberlLabel.right, special_Label.bottom, 150, 20)];
            //                numberl_Label.backgroundColor = [UIColor clearColor];
            //                numberl_Label.font = kDetailLabelFont;
            //                numberl_Label.textColor = kTextFontColor333;
            //                numberl_Label.text = [NSString stringWithFormat:@"%i部",_repairman.maintaincount];
            //                [backgroundView addSubview:numberl_Label];
            
            //                numberlLabel.textColor = XMColor(254, 187, 51);
            //                numberl_Label.textColor = XMColor(254, 187, 51);
            
            //评价
            XMRatingView *ratingView = [[XMRatingView alloc]initWithFrame: CGRectMake(separateView.right, numberlLabel.top, numberlLabel.width, numberlLabel.height)];
            ratingView.backgroundColor=[UIColor clearColor];
            ratingView.ratingScore=_repairman.evaluate;
            ratingView.style = kSmallStyle;
            [backgroundView addSubview:ratingView];
            
            backgroundView.frame = CGRectMake(0, 10, kDeviceWidth, ratingView.bottom+10);
            [backgroundView makeInsetShadowWithRadius:0.5 Color:kBorderColor Directions:@[@"top",@"bottom"]];
        }
            break;
        case 1:
        {
            backgroundView.frame = CGRectMake(0, 10, kDeviceWidth, 80);
            //                backgroundView.layer.cornerRadius = 5;
            //                backgroundView.layer.borderColor = XMColor(232, 232, 232).CGColor;
            backgroundView.backgroundColor = [UIColor whiteColor];
            
            //评价
            QHLabel *rating = [[QHLabel alloc] initWithFrame:CGRectMake(15, 15, backgroundView.width-20, 20)];
            rating.backgroundColor = [UIColor clearColor];
            rating.font = kDetailLabelFont;
            rating.text = [NSString stringWithFormat:@"评价(%i)",_repairman.evaluatecount];
            rating.textColor = kTextFontColor666;
            [backgroundView addSubview:rating];
            
            kColorText(rating, 0, @"评价", kTextFontColor333)
            //                QHLabel  *ratingLabel=[[QHLabel alloc]initWithFrame:CGRectMake(rating.right-80, 10, 50, 20)];
            //                ratingLabel.text=[NSString stringWithFormat:@"(%i)",_repairman.evaluatecount];
            //                ratingLabel.textAlignment = NSTextAlignmentRight;
            //                [backgroundView addSubview:ratingLabel];
            
            UIImageView  *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(rating.right-30, rating.top, 20, 20)];
            imageView.image=[UIImage resizedImage:@"icon_go"];
            imageView.contentMode=UIViewContentModeScaleAspectFit;
            [backgroundView addSubview:imageView];
            
            //分割线
            UIView *separateView = [[UIView alloc] initWithFrame:CGRectMake(rating.left, rating.bottom+15, backgroundView.width - rating.left*2, 1)];
            separateView.backgroundColor = kBorderColor;
            [backgroundView addSubview:separateView];
            
            //收藏
            QHLabel *order = [[QHLabel alloc] initWithFrame:CGRectMake(separateView.left, separateView.bottom+15, rating.width, 20)];
            order.textColor = kTextFontColor333;
            order.font = kDetailLabelFont;
            order.text = @"收藏";
            [backgroundView addSubview:order];
            
            //收藏数量
            NSString *ss = [NSString stringWithFormat:@"  (%i)",_repairman.collectionnumber];
            XMLog(@"=======收藏数量:%@",ss);
            UIButton *collect = [UIButton buttonWithType:UIButtonTypeCustom];
            [collect setImage:[UIImage resizedImage:@"icon_collect_order"] forState:UIControlStateDisabled];
            [collect setTitle:ss forState:UIControlStateDisabled];
            [collect setTitleColor:kTextFontColor999 forState:UIControlStateDisabled];
            [backgroundView addSubview:collect];
            
            collect.frame = CGRectMake(order.right-80, order.top, 100, 24);
            
            collect.frame = CGRectMake(order.right-80, order.top-10, 100, 40);
            
            collect.enabled = NO;
            backgroundView.frame = CGRectMake(0, 10, kDeviceWidth, rating.height*2+60);
            
            [backgroundView makeInsetShadowWithRadius:0.5 Color:kBorderColor Directions:@[@"top",@"bottom"]];
        }
            break;
        case 2:
        {
            backgroundView.frame = CGRectMake(0, 20, kDeviceWidth, 160);
            backgroundView.backgroundColor = [UIColor whiteColor];
            backgroundView.userInteractionEnabled = YES;
            NSArray *imagesName = _repairman.goodslist;
            if ([imagesName isKindOfClass:[NSArray class]] && imagesName.count) {
                QHLabel *more = [[QHLabel alloc] initWithFrame:CGRectMake(20, 15, cell.width-40, 20)];
                more.font = kDetailLabelFont;
                more.textColor = kTextFontColor666;
                more.text = @"修神还有下面宝贝：";
                [backgroundView addSubview:more];
                for (int i=0; i<imagesName.count; i++) {
                    NSDictionary *dict = imagesName[i];
                    XMGoodsView *goosView = [[XMGoodsView alloc] initWithFrame:CGRectMake(more.left + ((kDeviceWidth-60)/3+15)*i, more.bottom+15, (kDeviceWidth-60)/3,(kDeviceWidth-60)/3+(kDeviceWidth-60)/6)];
                    [goosView loadSubViewWithIcon:dict[@"photo"] title:dict[@"goods"] price:[dict[@"newprice"] floatValue] oldprice:[dict[@"oldprice"] floatValue]];
                    goosView.delegate = self;
                    [backgroundView addSubview:goosView];
                }
                backgroundView.frame = CGRectMake(0, 10, kDeviceWidth, 220);
            }else{
                backgroundView.hidden = YES;
                backgroundView.frame = CGRectMake(0, 0, 0, 0);
            }
            [backgroundView makeInsetShadowWithRadius:0.5 Color:kBorderColor Directions:@[@"top",@"bottom"]];
        }
            break;
        default:
            break;
    }
    [cell.contentView addSubview:backgroundView];
    cell.backgroundColor = XMGlobalBg;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGRect frame = [cell frame];
    //计算出自适应的高度
    frame.size.height = backgroundView.height+20;
    cell.frame = frame;
    
    return cell;
}
// 设置单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        //进入修神的详细介绍界面  包括技能认证等
        XMDevoteController  *devoteView=[[XMDevoteController alloc]init];
        //        取model中的值
        devoteView.maintainer_id = self.repairman.maintainer_id;
        //        获取model中的title
        devoteView.title = @"修神详情";
        [self.navigationController pushViewController:devoteView animated:YES];
    }else if (indexPath.row == 1){
        //进入评价列表控制器
        XMRatingListViewController *ratingListVC = [[XMRatingListViewController alloc] init];
        ratingListVC.maintainer_id = self.repairman.maintainer_id;
        [self.navigationController pushViewController:ratingListVC animated:YES];
    }
    
}

#pragma mark - 滑动视图代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _topScrollView) {
        currentIndex.text = [NSString stringWithFormat:@"%i/%i",(NSInteger)(_topScrollView.contentOffset.x/_topScrollView.width)+1,_arrayImage.count];
    }
}

#pragma mark -
#pragma mark 点击下单按钮
- (void)orderButtonClick:(UIButton *)button
{
    if (flag) {
        if (button.tag == 100) {
            XMProvideHomeServiceController *pro = [[XMProvideHomeServiceController alloc] init];
            pro.shop = _repairman.shop;
            pro.maintainer_id = _repairman.maintainer_id;
            [self.navigationController pushViewController:pro animated:YES];
            
        }else if (button.tag == 101){
            XMSendViewController *send = [[XMSendViewController alloc] init];
            send.shop = _repairman.shop;
            [self.navigationController pushViewController:send animated:YES];
        }else{
            if (button.tag==102) {
                alertView11=[[UIAlertView alloc]initWithTitle:@"我要进店" message:@"您可以先打电话咨询修神，也可以直接去店里" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"电话咨询",@"直接去",nil];
                
                [alertView11 show];
            }
        }
    }else{
        UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您尚未登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录", nil];
        [alert1 show];
    }
}

#pragma mark 分享、收藏
- (void)shareButtonClick
{
    XMLog(@"分享");
    //分享
    //分享到新浪微博、腾讯微博
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"54680edefd98c5e1160084a0"
                                      shareText:@"维修就用修神马\n和谐、便宜不败家"
                                     shareImage:[UIImage imageNamed:@"Icon"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone,UMShareToSms,nil]
                                       delegate:nil];
    //    [UMSocialConfig showAllPlatform:YES];
}

- (void)collectButtonClick:(UIButton *)sender
{
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(doCollectOrCancle:) object:nil];
    if (sender.tag == 1) {
        [self doCollectOrCancle:NO];
    }else{
        [self doCollectOrCancle:YES];
    }
}

- (void)doCollectOrCancle:(BOOL)cancle
{
    collectButton.enabled = NO;
    if (cancle) {
        [[XMDealTool sharedXMDealTool]deleteWithContent:self.repairman.maintainer_id success:^(NSString *deal) {
            [MBProgressHUD showSuccess:deal];
            [self setCollectButtonState:0];
            
            collectButton.enabled = YES;
        } failure:^(NSString *deal) {
            [MBProgressHUD showError:deal];
            
            collectButton.enabled = YES;
        }];
    }else{
        if (flag) {
            NSString *userid = [XMDealTool sharedXMDealTool].userid;
            NSString *password = [XMDealTool sharedXMDealTool].password;
            
            [XMHttpTool postWithURL:@"user/collection"
                             params:@{@"userid":userid,
                                      @"password":password,
                                      @"maintainer_id":self.repairman.maintainer_id
                                      }
                            success:^(id json) {
                                collectButton.enabled = YES;
                                
                                if ([json[@"status"] integerValue] == 1) {
                                    XMLog(@"收藏成功");
                                    [self setCollectButtonState:1];
                                    [MBProgressHUD showSuccess:@"收藏成功"];
                                }else{
                                    XMLog(@"收藏失败");
                                    [MBProgressHUD showError:@"收藏失败"];
                                }
                            }
                            failure:^(NSError *error) {
                                collectButton.enabled = YES;
                                
                                XMLog(@"网络问题%@",error);
                                [MBProgressHUD showError:@"网络异常"];
                            }];
        }else{
            collectButton.enabled = YES;
            
            UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您尚未登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录", nil];
            [alert1 show];
        }
    }
}

#pragma mark 点击照片墙上照片
- (void)clickImage:(UITapGestureRecognizer *)tap
{
    XMLog(@"%i",(int)(_topScrollView.contentOffset.x/self.view.width));
    
    XMAlbumViewController *albumVC = [[XMAlbumViewController alloc] init];
    albumVC.array = _arrayImage;
    albumVC.index = (int)(_topScrollView.contentOffset.x/kDeviceWidth);
    albumVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:albumVC animated:YES completion:^{}];
}

#pragma mark -返回
- (void)backButtonClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == alertView11) {
//        if (buttonIndex != 3) {
            NSInteger itemcategoryid = [XMDealTool sharedXMDealTool].itemcategoryid;
//        }
        
        if (buttonIndex ==1) {
            //打电话
            UIWebView*callWebview =[[UIWebView alloc] init];
            
            NSString *telUrl = [NSString stringWithFormat:@"tel:%@",_repairman.telephone];
            
            NSURL *telURL =[NSURL URLWithString:telUrl];// 貌似tel:// 或者 tel: 都行
            
            [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
            
            //添加到view上
            [self.view addSubview:callWebview];
            
            [self setIntoShopOrderWithItemcategoryid:itemcategoryid];
        }else if(buttonIndex==2){
            /*
            //导航
            XMGoViewController *goViewController = [[XMGoViewController alloc] init];
            CLLocationDegrees latitude = [XMDealTool sharedXMDealTool].currentLatitude;
            CLLocationDegrees longitude = [XMDealTool sharedXMDealTool].currentLongitude;
            
            goViewController.startCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
            goViewController.destinationCoordinate = CLLocationCoordinate2DMake(_repairman.latitude, _repairman.longitude);
            [self.navigationController presentViewController:[[XMBaseNavigationController alloc] initWithRootViewController:goViewController] animated:YES completion:^{
                
            }];*/
            XMGetAddressViewController *getAddressVC = [[XMGetAddressViewController alloc] init];
            getAddressVC.coordinate = CLLocationCoordinate2DMake(_repairman.latitude, _repairman.longitude);
            getAddressVC.address = _repairman.address;
            XMLog(@"address--------------->%@",_repairman.address);
            [self.navigationController pushViewController:getAddressVC animated:YES];
            
            
            [self setIntoShopOrderWithItemcategoryid:itemcategoryid];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kOrderChangeNote object:nil];
    }else{
        if (buttonIndex == 1) {
            XMLoginViewController *login=[[XMLoginViewController alloc]init];
            [self.navigationController  pushViewController:login animated:YES];
            
        }
    }
}
- (void)setIntoShopOrderWithItemcategoryid:(NSInteger)itemcategoryid
{
    [[XMDealTool sharedXMDealTool] orderWithMaintainerid:_repairman.maintainer_id itemcategoryid:itemcategoryid servicecategoryid:3 success:^(NSString *deal) {
        
    }];
}

- (void)touchImageViewWithImage:(UIImage *)image
{
    fullImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    fullImageView.backgroundColor=[UIColor blackColor];
    fullImageView.userInteractionEnabled=YES;
    [fullImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap2:)]];
    fullImageView.contentMode=UIViewContentModeScaleAspectFit;
    
    if (![fullImageView superview]) {
        fullImageView.image=image;
        [self.view.window addSubview:fullImageView];
        fullImageView.alpha = 0;
        [UIView animateWithDuration:0.5 animations:^{
            fullImageView.alpha = 1;
        } completion:^(BOOL finished) {
            [UIApplication sharedApplication].statusBarHidden=YES;
        }];
    }
}

-(void)actionTap2:(UITapGestureRecognizer *)sender{
    [UIView animateWithDuration:0.5 animations:^{
        fullImageView.alpha=0;
    } completion:^(BOOL finished) {
        [fullImageView removeFromSuperview];
    }];
    
    [UIApplication sharedApplication].statusBarHidden=NO;
}

@end


