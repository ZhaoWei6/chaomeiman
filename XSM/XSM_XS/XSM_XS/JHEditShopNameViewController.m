//
//  JHEditShopNameViewController.m
//  XSM_XS
//
//  Created by Andy on 14-12-5.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "JHEditShopNameViewController.h"
#import "XMDealTool.h"

@interface JHEditShopNameViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
- (IBAction)buttonClickedToOk:(UIButton *)sender;

@end

@implementation JHEditShopNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"编辑店铺名称";
    self.shopNameLabel.delegate = self;
    
    //UIControlEventEditingChanged
    [self.shopNameLabel addTarget:self action:@selector(limitLength:) forControlEvents:UIControlEventEditingChanged];
}

-(void)limitLength:(UITextField *)sender
{
    bool isChinese;//判断当前输入法是否是中文
    if ([[[UITextInputMode currentInputMode] primaryLanguage] isEqualToString: @"en-US"]) {
        isChinese = false;
    }
    else
    {
        isChinese = true;
    }
    
    if(sender == self.shopNameLabel) {
        // 8位
        NSString *str = [[self.shopNameLabel text] stringByReplacingOccurrencesOfString:@"?" withString:@""];
        if (isChinese) { //中文输入法下
            UITextRange *selectedRange = [self.shopNameLabel markedTextRange];
            //获取高亮部分
            UITextPosition *position = [self.shopNameLabel positionFromPosition:selectedRange.start offset:0];
            // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (!position) {
//                NSLog(@"汉字");
                if ( str.length > 30) {
                    NSString *strNew = [NSString stringWithString:str];
                    [self.shopNameLabel setText:[strNew substringToIndex:29]];
                }
            }
            else
            {
//                NSLog(@"输入的英文还没有转化为汉字的状态");
            
            }
        }else{
//            NSLog(@"str=%@; 本次长度=%lu",str,(unsigned long)[str length]);
//            self.numberLabel.text = [NSString stringWithFormat:@"(%lu/30)", (unsigned long)[str length]];
            if ([str length]>=30) {
                NSString *strNew = [NSString stringWithString:str];
                [self.shopNameLabel setText:[strNew substringToIndex:29]];
            }
        }
    }
}

- (IBAction)buttonClickedToOk:(UIButton *)sender {
    
    [self.shopNameLabel endEditing:YES];
    

    
    if (self.shopNameLabel.text.length > 3 && self.shopNameLabel.text.length < 30 ) {
        [MBProgressHUD showMessage:nil];
        
        NSLog(@"%@", self.shopNameLabel.text);
        NSDictionary *param = @{@"shop" : self.shopNameLabel.text,
                                @"userid" : [UserDefaults objectForKey:@"userid"],
                                @"password" : [UserDefaults objectForKey:@"password"]};
        
        [[XMDealTool sharedXMDealTool] verifyShopNameWithParams:param Success:^(NSDictionary *deal) {
            
            [MBProgressHUD hideHUD];
            
            if ([deal[@"status"] isEqual: @1]) {
                
                if ([self.delegate respondsToSelector:@selector(editShopNameViewController:didSaveShopName:)]) {
                    [self.delegate editShopNameViewController:self didSaveShopName:self.shopNameLabel.text];
                }
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:deal[@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            }
            
        }];
        
    }else{
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"店铺名不符合规范！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
    
    
}

- (void)dealloc
{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
