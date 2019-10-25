//
//  ANChatManager.m
//  ANChat
//
//  Created by liuyunpeng on 2019/6/20.
//  Copyright © 2019 liuyunpeng. All rights reserved.
//

#import "ANChatManager.h"
#import "LEWebSocket.h"
#import "ANChatMessageModel.h"
#import <YYKit/YYKit.h>
#import "NSString+Encryption.h"
#import "ANUserManager.h"

@implementation ANChatManager
+(void)sendDataToServerWithChatId:(NSString*)chatId chatModel:(ANChatMessageModel*)chatModel
{
    NSMutableDictionary *sendPara = [NSMutableDictionary new];
    [sendPara setObject:@"cheat" forKey:@"control"];
    [sendPara setObject:@"" forKey:@"fun"];
    NSDictionary *dataDic =@{@"chatid":chatId,@"msg":chatModel.content};
    NSString *dataString =[dataDic jsonStringEncoded];
    if (dataString) {
        dataString = [dataString desEncryptWithKey:[ANUserManager userItem].myToken];
        AYLog(@"the send login encrypy str is %@",dataString);
        [sendPara setObject:dataString forKey:@"data"];
        NSString *sendStr = [sendPara jsonStringEncoded];
        AYLog(@"the send login str is %@",sendStr);
        [[LEWebSocket shareManager] le_send:sendStr];
    }
}
@end
