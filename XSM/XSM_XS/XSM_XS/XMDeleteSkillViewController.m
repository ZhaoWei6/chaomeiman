//
//  XMDeleteSkillViewController.m
//  XSM_XS
//
//  Created by Apple on 14/12/9.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMDeleteSkillViewController.h"
#import "UIImageView+WebCache.h"
@interface XMDeleteSkillViewController ()<UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *contentView;

- (IBAction)actionDeleteSkill:(UIButton *)sender;

@end

@implementation XMDeleteSkillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"技术认证";
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self loadSkillImage];
}

- (void)loadSkillImage
{
    UIImageView *skillImage = [[UIImageView alloc] init];
    CGFloat y = (self.contentView.height-kDeviceWidth)/2.0-64;
    skillImage.frame = CGRectMake(0, y, kDeviceWidth, kDeviceWidth);
//    skillImage.center = self.view.center;
    skillImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:skillImage];
    
    [skillImage setImageWithURL:[NSURL URLWithString:self.skillImageUrl]];
    
//    AblumView *ablumView = [[AblumView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
//    ablumView.imageName = self.skillImageUrl;
//    [ablumView downloadImage];
//    ablumView.delegate = self;
//    [self.contentView addSubview:ablumView];
}

- (IBAction)actionDeleteSkill:(UIButton *)sender {
    //确认提示
    [[[UIAlertView alloc] initWithTitle:@"提示"
                                message:@"此操作将会删除此证书"
                               delegate:self
                      cancelButtonTitle:@"取消"
                      otherButtonTitles:@"确定", nil] show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex) {
        //
        NSString *userid = [XMDealTool sharedXMDealTool].userid;
        NSString *password = [XMDealTool sharedXMDealTool].password;
        NSString *maintainertechnology_id = self.skillImageID;
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:userid forKey:@"userid"];
        [params setObject:password forKey:@"password"];
        [params setObject:maintainertechnology_id forKey:@"maintainertechnology_id"];
        
        [XMHttpTool postWithURL:@"Maintaineredit/deletecertification" params:params success:^(id json) {
            if ([json[@"status"] integerValue] == 1) {
                XMLog(@"删除成功");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEUSERDATA" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }                 
        } failure:^(NSError *error) {
            XMLog(@"error-->%@",error);
        }];
    }
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
