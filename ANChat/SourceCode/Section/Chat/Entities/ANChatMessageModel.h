//
//  ANChatMessageModel.h
//  ANChat
//
//  Created by liuyunpeng on 2019/5/30.
//  Copyright © 2019 liuyunpeng. All rights reserved.
//

#import "ZWBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ANChatMessageModel : ZWDBBaseModel
// 消息来源用户id
@property (nonatomic, copy) NSString *fromId;
// 消息目的地id
@property (nonatomic, copy) NSString *toId;
// 消息标识:(消息+时间)的MD5
@property (nonatomic, copy) NSString *messageId;
// 消息发送状态//ANMessageDeliveryState
@property (nonatomic, strong)  NSNumber<RLMInt> *deliveryState;
// 消息时间
@property (nonatomic, strong) NSNumber<RLMInt> *msgDate;
@property (nonatomic, strong) NSNumber<RLMBool> *isSender; //是否是发送者

// 消息文本内容
@property (nonatomic, copy) NSString *content;
// 音频文件的fileKey
@property (nonatomic, copy) NSString *fileKey;
// 发送消息对应的type类型:ANMessageType
@property (nonatomic, strong) NSNumber<RLMInt> *type;
// 发送消息对应的type类型:ANMessageType
@property (nonatomic, copy) NSString *typeStr;
// 时长，宽高，首帧id
@property (nonatomic, strong) NSString *lnk;
// (0:未读 1:已读 2:撤回)ANMessageStatus
@property (nonatomic, strong) NSNumber<RLMInt> *status;
// 包含voice，picture，video的路径;有大图时就是大图路径
@property (nonatomic, copy) NSString *mediaPath;

@end

NS_ASSUME_NONNULL_END
