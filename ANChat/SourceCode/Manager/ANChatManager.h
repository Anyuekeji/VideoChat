//
//  ANChatManager.h
//  ANChat
//
//  Created by liuyunpeng on 2019/6/20.
//  Copyright © 2019 liuyunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ANChatMessageModel;

NS_ASSUME_NONNULL_BEGIN

@interface ANChatManager : NSObject
+(void)sendDataToServerWithChatId:(NSString*)chatId chatModel:(ANChatMessageModel*)chatModel;
@end

NS_ASSUME_NONNULL_END
