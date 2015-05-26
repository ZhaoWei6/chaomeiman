//
//  JHShopDetail_MyBabyCell.m
//  XSM_XS
//
//  Created by Andy on 14-12-12.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "JHShopDetail_MyBabyCell.h"
#import "JHShopDetail.h"
#import "UIImageView+WebCache.h"
#import "XMCommon.h"

@interface JHShopDetail_MyBabyCell()

@property (weak, nonatomic) IBOutlet UIView *oneBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *oneGoodsIcon;
@property (weak, nonatomic) IBOutlet UILabel *oneGoodsName;
@property (weak, nonatomic) IBOutlet UILabel *oneGoodsPrise;

@property (weak, nonatomic) IBOutlet UIView *twoBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *twoGoodsIcon;
@property (weak, nonatomic) IBOutlet UILabel *twoGoodsName;
@property (weak, nonatomic) IBOutlet UILabel *twoGoodsPrise;

@property (weak, nonatomic) IBOutlet UIView *threeBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *threeGoodsIcon;
@property (weak, nonatomic) IBOutlet UILabel *threeGoodsName;
@property (weak, nonatomic) IBOutlet UILabel *threeGoodsPrise;

@property (weak, nonatomic) IBOutlet UILabel *nongoodsLabel;

@end

@implementation JHShopDetail_MyBabyCell

- (void)setShopDetail:(JHShopDetail *)shopDetail
{
    _shopDetail = shopDetail;
    
    NSArray *goods = _shopDetail.goodslist;
    CGFloat intervel_x = (self.frame.size.width - 270) / 4;
    CGFloat view_y = 41;
    CGFloat view_w = 90;
    CGFloat view_h = 150;
    
    for (int index = 0; index < goods.count; ++ index) {
        
        NSDictionary *dictionary = goods[index];
        
        CGFloat view_x = index *(intervel_x +view_w) + intervel_x;
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(view_x, view_y, view_w, view_h)];
        
        UIImageView *goodsIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 90, 90)];
        [goodsIcon setImageWithURL:dictionary[@"photo"] placeholderImage:[UIImage imageNamed:@"no_goods"]];
        goodsIcon.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewClickToShowGoods:)];
        [goodsIcon addGestureRecognizer:singleTap];
        [backgroundView addSubview:goodsIcon];
        
        UILabel * goodsNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 95, 90, 21)];
        [goodsNameLabel setTextAlignment:NSTextAlignmentCenter];
        [goodsNameLabel setFont:[UIFont systemFontOfSize:17]];
        [goodsNameLabel setTextColor:kTextFontColor666];
        [goodsNameLabel setText:dictionary[@"goods"]];
        [backgroundView addSubview:goodsNameLabel];
        
        UILabel * goodsPriseLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 121, 90, 21)];
        [goodsPriseLabel setTextAlignment:NSTextAlignmentCenter];
        [goodsPriseLabel setFont:[UIFont systemFontOfSize:15]];
        [goodsPriseLabel setTextColor:[UIColor redColor]];
        NSString *newprice = [NSString stringWithFormat:@"%@", dictionary[@"newprice"]];
        [goodsPriseLabel setText:[NSString stringWithFormat:@"价格:￥%@",newprice]];
        [backgroundView addSubview:goodsPriseLabel];
        
        [self.contentView addSubview:backgroundView];
        
    }
    
}

- (void)imageViewClickToShowGoods:(UITapGestureRecognizer *)sender
{
    UIImageView *goodImageView = (UIImageView *)sender.view;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOWGOODS" object:goodImageView];
}

- (void)layoutSubviews
{
    NSArray *goods = _shopDetail.goodslist;
    
    if (goods.count > 0) {
        self.nongoodsLabel.hidden = YES;
    }else{
        self.nongoodsLabel.hidden = NO;
    }
}

+ (instancetype)shopDetail_MyBabyCellWithTableView:(UITableView *)tableView
{
    static NSString *ID =@"JHShopDetail_MyBabyCell";
    
    JHShopDetail_MyBabyCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JHShopDetail_MyBabyCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self.myBabyColoectionViewd.delegate = self;
//    
//    return self;
//}
////定义展示的Section的个数
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
//{
//    return 1;
//}
////定义展示的UICollectionViewCell的个数
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//{
//    return 3;
//}
////每个UICollectionView展示的内容
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString * CellIdentifier = @"GradientCell";
//    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
//    
//    cell.backgroundColor = [UIColor colorWithRed:((10 * indexPath.row) / 255.0) green:((20 * indexPath.row)/255.0) blue:((30 * indexPath.row)/255.0) alpha:1.0f];
//    return cell;
//}
////定义每个UICollectionView 的大小
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(100, 150);
//}
////定义每个UICollectionView 的 margin
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(5, 5, 5, 5);
//}
////UICollectionView被选中时调用的方法
//-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    cell.backgroundColor = [UIColor whiteColor];
//}
////返回这个UICollectionView是否可以被选择
//-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
