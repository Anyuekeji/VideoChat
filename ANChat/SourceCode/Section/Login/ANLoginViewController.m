//
//  ANLoginViewController.m
//  ANChat
//
//  Created by liuyunpeng on 2019/5/23.
//  Copyright © 2019 liuyunpeng. All rights reserved.
//

#import "ANLoginViewController.h"
#import "LEWebSocket.h"
#import <YYKit/YYKit.h>
#import "NSString+Encryption.h"
#import "ANUserManager.h"


//zogheng.com
NSString *server_url = @"ws://3.15.90.203:7777";

@interface ANLoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *connectBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UITextField *sendTextField;
@property (weak, nonatomic) IBOutlet UITextView *infoTextView;

@end

@implementation ANLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureData];
    [self getTestUserInfo];
    // Do any additional setup after loading the view from its nib.
}
-(void)configureData
{
    LEWeakSelf(self)
    [self.connectBtn addAction:^(UIButton *btn) {
        LEStrongSelf(self)
        [[LEWebSocket shareManager] le_open:server_url connect:^{
            [self.connectBtn setTitle:@"已连接" forState:UIControlStateNormal];
            self.infoTextView.text = @"连接成功";
        } receive:^(id message, LESocketReceiveType type) {
            self.infoTextView.text =[NSString stringWithFormat:@"收到:%@\n%@",message,self.infoTextView.text];
            NSDictionary *dic = LEConvertDataToDictionary(message);
            if (dic)
            {
                if (dic[@"data"])
                {
                    NSString *dataStr =dic[@"data"];
                    NSString *aftermessage =[dataStr desDecryptWithKey:[ANUserManager userItem].myToken];
                    self.infoTextView.text =[NSString stringWithFormat:@"收到:%@\n%@",aftermessage,self.infoTextView.text];
                }
            }
        } failure:^(NSError *error) {
            self.infoTextView.text =[NSString stringWithFormat:@"错误：%@\n%@",[error localizedDescription],self.infoTextView.text];
            [self.connectBtn setTitle:@"断开" forState:UIControlStateNormal];
        }] ;
    }];

    [self.sendBtn addAction:^(UIButton *btn) {
        LEStrongSelf(self)
        [[LEWebSocket shareManager] le_send:self.sendTextField.text];
        self.infoTextView.text =[NSString stringWithFormat:@"发送：%@\n%@",self.sendTextField.text,self.infoTextView.text];
        [self sendStr:self.sendTextField.text];
    }];
    [LEWebSocket shareManager].close = ^(NSInteger code, NSString *reason, BOOL wasClean) {
        self.infoTextView.text =[NSString stringWithFormat:@"socket断开：%@\n%@",reason,self.infoTextView.text];
        [self.connectBtn setTitle:@"断开" forState:UIControlStateNormal];
    };
}
-(void)loginServer
{
    NSMutableDictionary *loginPara = [NSMutableDictionary new];
    [loginPara setObject:@"login" forKey:@"control"];
    [loginPara setObject:@"" forKey:@"fun"];
    [loginPara setObject:[AYUtitle return16LetterAndNumber] forKey:@"tid"];

    NSDictionary *dataDic =@{@"uid":[ANUserManager userId]};
    NSString *dataString =[dataDic jsonStringEncoded];
    if (dataString) {
        dataString = [dataString desEncryptWithKey:@"123456789"];
        AYLog(@"the send login encrypy str is %@",dataString);

        [loginPara setObject:dataString forKey:@"data"];
        NSString *loginStr = [loginPara jsonStringEncoded];
        AYLog(@"the send login str is %@",loginStr);
        [[LEWebSocket shareManager] le_send:loginStr];
    }

}
-(void)sendStr:(NSString*)serverstr
{
    NSMutableDictionary *sendPara = [NSMutableDictionary new];
    [sendPara setObject:@"cheat" forKey:@"control"];
    [sendPara setObject:@"" forKey:@"fun"];
    NSDictionary *dataDic =@{@"name":@(123),@"msg":serverstr};
    NSString *dataString =[dataDic jsonStringEncoded];
    if (dataString) {
        dataString = [dataString desEncryptWithKey:@"123456789"];
        AYLog(@"the send login encrypy str is %@",dataString);
        [sendPara setObject:dataString forKey:@"data"];
        NSString *sendStr = [sendPara jsonStringEncoded];
        AYLog(@"the send login str is %@",sendStr);
        [[LEWebSocket shareManager] le_send:sendStr];
    }
}

#pragma mark - network  -

-(void)getTestUserInfo
{
    [self showHUD];
    [ZWNetwork post:@"HTTP_Post_Token" parameters:nil success:^(id record) {
        [self hideHUD];
        if (record && [record isKindOfClass:NSDictionary.class]) {
            ANMeModel *meModel = [ANMeModel itemWithDictionary:record];
            if (meModel)
            {
                [ANUserManager setUserItemByItem:meModel];
                [self loginServer];
                [[AYUtitle getAppDelegate] changeToLoginOrMainViewController:NO];

            }
        }
        
    } failure:^(LEServiceError type, NSError *error) {
        occasionalHint([error localizedDescription]);
        [self hideHUD];
    }];
}
@end
