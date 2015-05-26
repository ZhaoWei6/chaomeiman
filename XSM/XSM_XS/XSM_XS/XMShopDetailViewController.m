//
//  XMShopDetailViewController.m
//  XSM_XS
//
//  Created by Apple on 14/11/28.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMShopDetailViewController.h"
#import "XMRatingView.h"
#import "XMRepairmanDetail.h"
#import "XMAlbumViewController.h"
#import "XMGoodsView.h"
#import "XMDevoteController.h"
#import "XMRatingListViewController.h"

@interface XMShopDetailViewController ()<UITableViewDelegate,UITableViewDataSource,XMGoodsViewTouchDelegate>
{
    UIView *_headView;
    UIScrollView *_topScrollView;//顶部滑动视图
    UILabel *currentIndex;//照片墙当前页标签
//    UITableView *_tableView;
    NSArray *_arrayImage;
    UIAlertView  *alertView11;
    
    CGRect frame_first;
    UIImageView *fullImageView;
    
    UIButton *collectButton;//收藏
}
@property (nonatomic , retain) XMRepairmanDetail *repairman;
@end

@implementation XMShopDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = XMGlobalBg;
    self.tableView.backgroundColor = XMGlobalBg;
    //
    self.title = @"店铺详情";
    //收藏、分享
    [self loadNavigationItem];
    //请求数据
    [self requestData];
    //照片墙
    [self loadHeadView];
    //初始化下单按钮状态
    self.repairStyle1.enabled = NO;
    self.repairStyle2.enabled = NO;
    self.repairStyle3.enabled = NO;
    //
    [self loadNavigationItem];
}
#pragma mark - 加载导航栏右侧分享与收藏按钮
//顶部分享和收藏按钮
- (void)loadNavigationItem
{
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 25)];
    //收藏
    collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    collectButton.frame = CGRectMake(0, 0, 25, 25);
    [collectButton setImage:[UIImage imageNamed:@"icon_collect"] forState:UIControlStateNormal];
    [collectButton addTarget:self action:@selector(collectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:collectButton];
    collectButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    //分享
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(collectButton.right+10, 0, 25, 25);
    [shareButton setImage:[UIImage imageNamed:@"icon_share"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:shareButton];
    shareButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
}
#pragma mark - 顶部照片墙
//加载顶部照片墙
- (void)loadHeadView
{
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDetailPhotoHeight)];
    _tableView.tableHeaderView = _headView;
    //滑动视图
    _topScrollView = [[UIScrollView alloc] initWithFrame:_headView.bounds];
    _topScrollView.contentMode = UIViewContentModeScaleAspectFill;
    _topScrollView.pagingEnabled = YES;
    _topScrollView.delegate = self;
    _topScrollView.showsHorizontalScrollIndicator = NO;
    [_headView addSubview:_topScrollView];
    
    _arrayImage = _repairman.maintainphoto;
    if ([_arrayImage isKindOfClass:[NSArray class]] && _arrayImage.count) {
        for (int i=0; i<_arrayImage.count; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*_headView.width, 0, _headView.width, _headView.height)];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            NSDictionary *file = _arrayImage[i];
            [imageView setImageWithURL:[NSURL URLWithString:file[@"photo"]] placeholderImage:[UIImage imageNamed:@"banner_register"]];
            [_topScrollView addSubview:imageView];
            imageView.userInteractionEnabled = YES;
            _topScrollView.delegate = self;
            //为照片请添加手势
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage:)]];
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

#pragma mark - 请求数据
- (void)requestData
{
    [[XMDealTool sharedXMDealTool] dealsWithMaintainerid:_maintainer_id success:^(NSArray *deals, int islast) {
        _repairman = [deals lastObject];
        _tableView.hidden = NO;
        //顶部照片墙
        [self loadHeadView];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView reloadData];
        //
        [self  setButtonState];
        //修改收藏按钮
//        [self setCollectButtonState:islast];
    }];
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
            UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, backgroundView.width-30, 20)];
            detailLabel.font = [UIFont systemFontOfSize:20];
            detailLabel.textColor = XMButtonBg;
            detailLabel.text = _repairman.shop;
//                detailLabel.layer.cornerRadius=5;
//                detailLabel.layer.borderWidth=0;
            [backgroundView addSubview:detailLabel];
            
            UIImageView  *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(detailLabel.right-30, detailLabel.top, 24, 24)];
            imageView.contentMode=UIViewContentModeScaleAspectFit;
            imageView.image=[UIImage imageNamed:@"icon_go"];
            [backgroundView addSubview:imageView];
            //分割线
            UIView *separateView = [[UIView alloc] initWithFrame:CGRectMake(detailLabel.left, detailLabel.bottom+15, backgroundView.width - detailLabel.left*2, 1)];
            separateView.backgroundColor = kBorderColor;
            [backgroundView addSubview:separateView];
            
            //修神姓名
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(separateView.left, separateView.bottom+15, kDeviceWidth-30, 20)];
            nameLabel.backgroundColor = [UIColor clearColor];
            nameLabel.text = [NSString stringWithFormat:@"修神：%@",_repairman.nickname];
//            nameLabel.font = kDetailLabelFont;
            nameLabel.textColor = kTextFontColor666;
            [backgroundView addSubview:nameLabel];
            
            kColorText(nameLabel, 3, _repairman.nickname, kTextFontColor333)
//                UILabel *name_Label = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.right, nameLabel.top, 100, 20)];
//                name_Label.backgroundColor = [UIColor clearColor];
//                name_Label.font = kDetailLabelFont;
//                name_Label.text = _repairman.nickname;
//                name_Label.textColor = kTextFontColor333;
//                [backgroundView addSubview:name_Label];
            
            //修神擅长
            UILabel *specialLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.left, nameLabel.bottom+10, kDeviceWidth-30, 20)];
            specialLabel.backgroundColor = [UIColor clearColor];
            specialLabel.text = @"主修：";
//            specialLabel.font = kDetailLabelFont;
            specialLabel.textColor = kTextFontColor666;
            [backgroundView addSubview:specialLabel];
            //设置高度自适应
            specialLabel.width = [specialLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, specialLabel.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:specialLabel.font} context:nil].size.width;
            
//                kColorText(specialLabel, 0, @"主修：", kTextFontColor666)
            UILabel *special_Label = [[UILabel alloc] initWithFrame:CGRectMake(specialLabel.right, specialLabel.top, kDeviceWidth-30-specialLabel.width, 1000)];
            special_Label.backgroundColor = [UIColor clearColor];
            special_Label.numberOfLines = 0;
//            special_Label.font = kDetailLabelFont;
            special_Label.text = ![_repairman.desc isEqualToString:@""] ? _repairman.desc:@"无";
            special_Label.textColor = kTextFontColor333;
            [special_Label sizeToFit];
            [backgroundView addSubview:special_Label];
            
            special_Label.height = [special_Label.text boundingRectWithSize:CGSizeMake(special_Label.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:special_Label.font} context:nil].size.height;
            //修理数量
            UILabel *numberlLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.left, special_Label.bottom+10, (kDeviceWidth-30)/3, 20)];
            numberlLabel.backgroundColor = [UIColor clearColor];
            numberlLabel.text = [NSString stringWithFormat:@"已修：%i部",_repairman.maintaincount];
            numberlLabel.textColor = XMColor(254, 187, 51);
//            numberlLabel.font = kDetailLabelFont;
            [backgroundView addSubview:numberlLabel];
            
//                UILabel *numberl_Label = [[UILabel alloc] initWithFrame:CGRectMake(numberlLabel.right, special_Label.bottom, 150, 20)];
//                numberl_Label.backgroundColor = [UIColor clearColor];
//                numberl_Label.font = kDetailLabelFont;
//                numberl_Label.textColor = kTextFontColor333;
//                numberl_Label.text = [NSString stringWithFormat:@"%i部",_repairman.maintaincount];
//                [backgroundView addSubview:numberl_Label];

//                numberlLabel.textColor = XMColor(254, 187, 51);
//                numberl_Label.textColor = XMColor(254, 187, 51);
            
            //评价
            XMRatingView *ratingView = [[XMRatingView alloc]initWithFrame: CGRectMake(separateView.right-75, numberlLabel.top, 75, numberlLabel.height)];
//            ratingView.backgroundColor=[UIColor redColor];
            [ratingView loadSubViews];
            ratingView.ratingScore=_repairman.evaluate;
            ratingView.style = kSmallStyle;
            ratingView.isShopDetail = YES;
            [backgroundView addSubview:ratingView];
            backgroundView.frame = CGRectMake(0, 10, kDeviceWidth, ratingView.bottom+10);
        }
            break;
        case 1:
        {
            backgroundView.frame = CGRectMake(0, 10, kDeviceWidth, 80);
//                backgroundView.layer.cornerRadius = 5;
//                backgroundView.layer.borderColor = XMColor(232, 232, 232).CGColor;
            backgroundView.backgroundColor = [UIColor whiteColor];
            
            //评价
            UILabel *rating = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, backgroundView.width-20, 20)];
            rating.backgroundColor = [UIColor clearColor];
//            rating.font = kDetailLabelFont;
            rating.text = [NSString stringWithFormat:@"评价(%i)",_repairman.evaluatecount];
            rating.textColor = kTextFontColor666;
            [backgroundView addSubview:rating];
            
            kColorText(rating, 0, @"评价", kTextFontColor333)
//                UILabel  *ratingLabel=[[UILabel alloc]initWithFrame:CGRectMake(rating.right-80, 10, 50, 20)];
//                ratingLabel.text=[NSString stringWithFormat:@"(%i)",_repairman.evaluatecount];
//                ratingLabel.textAlignment = NSTextAlignmentRight;
//                [backgroundView addSubview:ratingLabel];
            
            UIImageView  *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(rating.right-30, rating.top, 20, 20)];
            imageView.image=[UIImage imageNamed:@"icon_go"];
            imageView.contentMode=UIViewContentModeScaleAspectFit;
            [backgroundView addSubview:imageView];
            
            //分割线
            UIView *separateView = [[UIView alloc] initWithFrame:CGRectMake(rating.left, rating.bottom+15, backgroundView.width - rating.left*2, 1)];
            separateView.backgroundColor = kBorderColor;
            [backgroundView addSubview:separateView];
            
            //收藏
            UILabel *order = [[UILabel alloc] initWithFrame:CGRectMake(separateView.left, separateView.bottom+15, rating.width, 20)];
            order.textColor = kTextFontColor333;
//            order.font = kDetailLabelFont;
            order.text = @"收藏";
            [backgroundView addSubview:order];
            
            //收藏数量
            NSString *ss = [NSString stringWithFormat:@"  %i",_repairman.collectionnumber];
            XMLog(@"=======收藏数量:%@",ss);
            UIButton *collect = [UIButton buttonWithType:UIButtonTypeCustom];
            [collect setImage:[UIImage imageNamed:@"icon_collect_order"] forState:UIControlStateDisabled];
            [collect setTitle:ss forState:UIControlStateDisabled];
            [collect setTitleColor:kTextFontColor999 forState:UIControlStateDisabled];
            [backgroundView addSubview:collect];
            
            collect.frame = CGRectMake(order.right-80, order.top, 100, 24);
            
            collect.frame = CGRectMake(order.right-80, order.top-10, 100, 40);
            
            collect.enabled = NO;
            backgroundView.frame = CGRectMake(0, 10, kDeviceWidth, rating.height*2+60);
        }
            break;
        case 2:
        {
            backgroundView.frame = CGRectMake(0, 20, kDeviceWidth, 160);
            backgroundView.backgroundColor = [UIColor whiteColor];
            
            NSArray *imagesName = _repairman.goodslist;
            if ([imagesName isKindOfClass:[NSArray class]] && imagesName.count) {
                UILabel *more = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, kDeviceWidth-40, 20)];
                more.font = kDetailLabelFont;
                more.textColor = kTextFontColor666;
                more.text = @"修神还有下面宝贝：";
                [backgroundView addSubview:more];
                for (int i=0; i<imagesName.count; i++) {
                    NSDictionary *dict = imagesName[i];
                    XMGoodsView *goosView = [[XMGoodsView alloc] initWithFrame:CGRectMake(more.left + ((kDeviceWidth-60)/3+15)*i, more.bottom+15, (kDeviceWidth-60)/3,(kDeviceWidth-60)/3+(kDeviceWidth-60)/6)];
                    
                    [goosView loadSubViewWithIcon:dict[@"photo"] title:dict[@"goods"] price:[dict[@"newprice"] floatValue] oldprice:[dict[@"oldprice"] floatValue]];
//                    [goosView loadSubViewWithIcon:dict[@"photo"] title:dict[@"goods"] newprice:[dict[@"newprice"] floatValue] oldprice:[dict[@"oldprice"]floatValue]];
                    goosView.delegate = self;
                    [backgroundView addSubview:goosView];
                }
                CGFloat h = (kDeviceWidth-60)/3+(kDeviceWidth-60)/6;
                backgroundView.frame = CGRectMake(0, 10, kDeviceWidth, h+75);
            }else{
                backgroundView.hidden = YES;
                backgroundView.frame = CGRectMake(0, 0, 0, 0);
            }
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
    if (indexPath.row == 2) {
        frame.size.height = backgroundView.height+50;
    }else{
        frame.size.height = backgroundView.height+20;
    }
    cell.frame = frame;
    
    return cell;
}
// 设置单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}
#pragma mark - 滑动视图代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    XMLog(@"%@",[NSCalendar currentCalendar]);
    if (scrollView == _topScrollView) {
        [self changeCurrentIndex];
    }
}

- (void)changeCurrentIndex
{
    currentIndex.text = [NSString stringWithFormat:@"%i/%i",(NSInteger)(_topScrollView.contentOffset.x/_topScrollView.width)+1,_arrayImage.count];
}
#pragma mark - 点击照片墙上照片
- (void)clickImage:(UITapGestureRecognizer *)tap
{
    XMLog(@"%i",(int)(_topScrollView.contentOffset.x/self.view.width));
    
    XMAlbumViewController *albumVC = [[XMAlbumViewController alloc] init];
    albumVC.array = _arrayImage;
    albumVC.index = (int)(_topScrollView.contentOffset.x/kDeviceWidth);
    albumVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:albumVC animated:YES completion:^{}];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==0) {
        XMDevoteController  *devote=[[XMDevoteController alloc]init];
        devote.maintainer_id=self.repairman.maintainer_id;
        devote.title=@"修神详情";
        [self.navigationController  pushViewController:devote animated:YES];
    }else if (indexPath.row==1){
    
        XMRatingListViewController  *ratingView=[[XMRatingListViewController alloc]init];
        ratingView.maintainer_id=self.repairman.maintainer_id;
        [self.navigationController pushViewController:ratingView animated:YES];
    
    }
}

#pragma mark - 设置下单按钮状态
- (void)setButtonState
{
    NSString *server = @"";
    if ([_repairman.servicelist isKindOfClass:[NSArray class]]) {
        
        NSArray *arr = _repairman.servicelist;
        
        for (NSDictionary *dict in arr) {
            NSInteger i = [dict[@"id"] integerValue];
            if (i==1) {
                self.repairStyle1.enabled=YES;
                server = [NSString stringWithFormat:@"%@上门服务  ",server];
            }else if(i==2){
                self.repairStyle2.enabled=YES;
                server = [NSString stringWithFormat:@"%@寄修服务  ",server];
            }else{
                self.repairStyle3.enabled=YES;
                server = [NSString stringWithFormat:@"%@进店维修",server];
            }
        }
        UIView *bottom = [[UIView alloc] initWithFrame:CGRectMake(0, -20, kDeviceWidth, 80)];
        bottom.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = bottom;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, kDeviceWidth-30, 17)];
        label.text = @"修神提供的服务有：";
        label.textColor = kTextFontColor666;
        [bottom addSubview:label];
        
        UILabel *serverLabel = [[UILabel alloc] initWithFrame:CGRectMake(label.left, label.bottom+10, label.width, label.height)];
        serverLabel.textColor = kTextFontColor333;
        serverLabel.text = server;
        [bottom addSubview:serverLabel];
    }else{
        XMLog(@"服务列表获取失败");
    }
}
#pragma mark - 
#pragma mark 收藏
- (void)collectButtonClick:(UIButton *)sender
{
    XMLog(@"收藏");
}
#pragma mark 分享
- (void)shareButtonClick
{
    XMLog(@"分享");
}

- (void)backButtonClick
{
    [self dismissViewControllerAnimated:YES completion:^{
        [UIApplication sharedApplication].statusBarHidden = YES;;
    }];
}
#pragma mark -
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

- (IBAction)orderCategory:(UIButton *)sender {
    
}

- (void)dealloc
{
    [_topScrollView removeFromSuperview];
    _topScrollView.delegate = nil;
    _topScrollView = nil;
    
    _tableView.delegate = nil;
    [_tableView removeFromSuperview];
    _tableView = nil;
}
@end
