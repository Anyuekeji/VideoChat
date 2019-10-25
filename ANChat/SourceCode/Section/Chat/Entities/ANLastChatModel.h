//
//  ANLastChatModel.h
//  ANChat
//
//  Created by liuyunpeng on 2019/6/6.
//  Copyright © 2019 liuyunpeng. All rights reserved.
//

#import "ZWBaseModel.h"
/**
 *  保存一个用户最后的聊天时间，用于获取用户历史数据（比如七天内的）
 */
NS_ASSUME_NONNULL_BEGIN

@interface ANLastChatModel : ZWDBBaseModel
@property(nonatomic,strong) NSString  *uid; //聊天对象id

@property(nonatomic,strong) NSNumber<RLMInt>  *lastChatTime; //最后一次聊天的时间

@end

NS_ASSUME_NONNULL_END
