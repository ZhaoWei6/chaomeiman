//
//  AdviceDetailController.m
//  Chaomeiman 专家端
//
//  Created by imac on 14-12-12.
//  Copyright (c) 2014年 imac. All rights reserved.
//

#import "AdviceDetailController.h"
#import "showAdviceViewController.h"
#import "ChatViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "UIImageView+WebCache.h"
#import "UserDetailController.h"
@interface AdviceDetailController (){
    NSMutableDictionary *listArray;
    UITableView *table;
}

@end

@implementation AdviceDetailController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=@"建议书详情";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    listArray=[NSMutableDictionary dictionary];
    [self loadTable];
    [self getCustomeByID];
    [self addLeftButtonReturn:@selector(dismiss)];
    [self addRightImageReturn:@"share" with:@selector(rightDismiss)];
    
}

-(void)loadTable{
    //表视图
    table=[[UITableView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth, kDeviceHeight-44) style:UITableViewStyleGrouped];
    table.backgroundColor=[UIColor whiteColor];
    table.showsVerticalScrollIndicator=NO;
    table.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:table];

}

-(void)getCustomeByID{
    [[LoginUser sharedLoginUser]loadurl:GetVerification(@"client", @"getMemberById") with:@{@"member_id":_member_ID} BlockWithSuccess:^(id mes) {
        if ([mes[@"success_code"]integerValue]==200) {
            listArray=[NSMutableDictionary dictionaryWithDictionary:mes[@"success_message"]];
            MyLog(@"%@",listArray);
            [self loadLayout];
        }
    } Failure:^(NSError *mes) {
        MyLog(@"%@",mes);
    }];
}

-(void)loadLayout{
    //显示日期和时间
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(5, 0, 100, 25)];
    label.textColor=[UIColor grayColor];
    
    int year=[[_time valueForKey:@"year"] intValue]+1900;
    int month=[[_time valueForKey:@"month"] intValue]+1;
    int day=[[_time valueForKey:@"date"] intValue];
    label.text=[NSString stringWithFormat:@"%02d-%02d-%02d",year,month,day];
    [table addSubview:label];
    
    
    //画图
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(label.left, label.bottom, kDeviceWidth-10, kDeviceHeight-330)];
    imageView.image=[UIImage imageNamed:@"advice"];
    [table addSubview:imageView];
    
    
    //信息
    UILabel *text=[[UILabel alloc]init];
    text.text=_name;
    CGSize size =[self hightForText:text.text Font:[UIFont systemFontOfSize:16] Wigth:kDeviceWidth-10];
    text.frame=CGRectMake(label.left, imageView.bottom+20, kDeviceWidth-10, size.height+30);
    text.textColor=[UIColor blackColor];
    text.numberOfLines=0;
    [table addSubview:text];
    
    //“用户信息“
    UILabel *tech=[[UILabel alloc]initWithFrame:CGRectMake(label.left, text.bottom+20, kDeviceWidth-10, 20)];
    tech.text=@"用户信息";
    tech.textColor=[UIColor blueColor];
    tech.font=[UIFont systemFontOfSize:20];
    [table addSubview:tech];
    
    //line
    UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(label.left, tech.bottom+10, kDeviceWidth-10, 5)];
    line.image=[UIImage imageNamed:@"line"];
    [table addSubview:line];
    
    //用户头像
    UIImageView *phone=[[UIImageView alloc]initWithFrame:CGRectMake(label.left, line.bottom+5, 75, 75)];
    [phone setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",listArray[@"member_head"]]] placeholderImage:[UIImage imageNamed:@"头像1.jpg"]options:SDWebImageRetryFailed|SDWebImageLowPriority];
    phone.layer.masksToBounds =YES;
    phone.layer.cornerRadius =phone.frame.size.height/2;
    [table addSubview:phone];
    
    //人名字
    UILabel *name=[[UILabel alloc]initWithFrame:CGRectMake(phone.right+5, line.bottom+10, 80, 50)];
    if ([listArray[@"member_nickname"] length]==0) {
        name.text=@"无";
    }else
        name.text=[NSString stringWithFormat:@"%@",listArray[@"member_nickname"]];
    name.textColor=[UIColor blackColor];
    name.font=[UIFont boldSystemFontOfSize:20];
    [table addSubview:name];
    
    //导航按钮
    UIImageView *navphone=[[UIImageView alloc]initWithFrame:CGRectMake(kDeviceWidth-55,line.bottom+10, 40, 50)];
    navphone.image=[UIImage imageNamed:@"goBack2"];
    [table addSubview:navphone];
    
    //点击按钮
    UIButton *navButton=[UIButton buttonWithType:UIButtonTypeCustom];
    navButton.frame=CGRectMake(0,line.bottom+5, kDeviceWidth, 70);
    [navButton addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
    [table addSubview:navButton];
    
    //底部发消息
//    UIButton *sendNews=[UIButton buttonWithType:UIButtonTypeCustom];
//    sendNews.layer.borderWidth=0.5f;
//    sendNews.layer.borderColor=[[UIColor blackColor]CGColor];
//    sendNews.frame=CGRectMake(0.1,kDeviceHeight-41, kDeviceWidth/2, 41);
//    [sendNews setTitle:@"发消息" forState:UIControlStateNormal];
//    [sendNews setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    //[sendNews setImage:[UIImage imageNamed:@"sendNews"] forState:UIControlStateNormal];
//    [sendNews addTarget:self action:@selector(sendNews) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:sendNews];
    
    [self addViewInButton:@"发消息" rect:CGRectMake(0.1,kDeviceHeight-41, kDeviceWidth/2, 41) with:@selector(sendNews)];
    
    //编辑建议书
    [self addViewInButton:@"编辑建议书" rect:CGRectMake(kDeviceWidth/2+0.1-1,kDeviceHeight-41, kDeviceWidth/2+3, 41) with:@selector(editNews)];
}


//根据内容获取高度
-(CGSize)hightForText:(NSString *)text Font:(UIFont *)font Wigth:(CGFloat)wigth
{
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGSize sizezz = [text boundingRectWithSize:CGSizeMake(wigth, 9999) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return sizezz;
}


-(void)sendNews{
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"ChatViewController" bundle:nil];
    ChatViewController *controller=[storyboard instantiateViewControllerWithIdentifier:@"ChatViewController"];
    
    controller.bareName=[NSString stringWithFormat:@"%@",[listArray valueForKey:@"member_nickname"]];
    controller.bareJidStr =[NSString stringWithFormat:@"%@@%@",[listArray valueForKey:@"member_phone"],kHostName];
    controller.bareImageUrl =[NSString stringWithFormat:@"%@",[listArray valueForKey:@"member_head"]];
    controller.bareId=_member_ID;
    // 取出对话方的头像数据
    controller.myImageUrl =[[NSUserDefaults standardUserDefaults]objectForKey:kPersonHeadImage];

    [self.navigationController pushViewController:controller animated:YES];
    self.hidesBottomBarWhenPushed=YES;
}


-(void)editNews{
    showAdviceViewController *show=[[showAdviceViewController alloc]init];
    show.title=@"编辑建议书";
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:show animated:YES];
}


-(void)dismiss{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)push{
    [[LoginUser sharedLoginUser]setMember_id:[NSString stringWithFormat:@"%@",_member_ID]];
    UserDetailController *user=[[UserDetailController alloc]init];
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:user animated:YES];
}

-(void)rightDismiss{
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"icon80_new"  ofType:@"png"];
        //1、构造分享内容
        id<ISSContent> publishContent = [ShareSDK content:@"我(专家)开的建议书"
                                           defaultContent:@"专家建议书"
                                                    image:[ShareSDK imageWithPath:imagePath]
                                                    title:@"超健康"
                                                      url:[NSString stringWithFormat:@"%@/app/share.html?id=%@",ChaojiankangServer,[[NSUserDefaults standardUserDefaults]objectForKey:E_id]]
                                              description:@"超健康(专家端)"
                                                mediaType:SSPublishContentMediaTypeNews];
        //1+创建弹出菜单容器（iPad必要）
        id<ISSContainer> container = [ShareSDK container];
        [container setIPadContainerWithView:self.view arrowDirect:UIPopoverArrowDirectionUp];
        
        //2、弹出分享菜单
        [ShareSDK showShareActionSheet:container
                             shareList:nil
                               content:publishContent
                         statusBarTips:YES
                           authOptions:nil
                          shareOptions:nil
                                result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                    
                                    //可以根据回调提示用户。
                                    if (state == SSResponseStateSuccess)
                                    {
                                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                        message:nil
                                                                                       delegate:self
                                                                              cancelButtonTitle:@"OK"
                                                                              otherButtonTitles:nil, nil];
                                        [alert show];
                                    }
                                    else if (state == SSResponseStateFail)
                                    {
                                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                                        message:[NSString stringWithFormat:@"失败描述：%@",[error errorDescription]]
                                                                                       delegate:self
                                                                              cancelButtonTitle:@"OK"
                                                                              otherButtonTitles:nil, nil];
                                        [alert show];
                                    }
                                }];
}

@end
