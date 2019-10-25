//
//  constant+Enum.h
//  CallYou
//
//  Created by allen on 2017/8/17.
//  Copyright © 2017年 李雷. All rights reserved.
//

#ifndef constant_Enum_h
#define constant_Enum_h

// 消息发送状态
typedef NS_ENUM(NSInteger,ANMessageDeliveryState)
{
    ANMessageDeliveryState_Pending = 0,  // 待发送
    ANMessageDeliveryState_Delivering,   // 正在发送
    ANMessageDeliveryState_Delivered,    // 已发送，成功
    ANMessageDeliveryState_Failure,      // 发送失败
    ANMessageDeliveryState_ServiceFaid   // 发送服务器失败(可能其它错,待扩展)
};

// 消息状态
typedef enum {
    ANMessageStatus_unRead = 0,          // 消息未读
    ANMessageStatus_read,                // 消息已读
    ANMessageStatus_back                 // 消息撤回
}ANMessageStatus;


// 消息状态
typedef enum {
    ANMessageType_Text = 0,          // 文本
    ANMessageType_Pic,                // 图片
    ANMessageType_Pic_Lock,                // 隐私图片
    ANMessageType_Dynamic,                 // 动图
    ANMessageType_Voice,          // 语音
    ANMessageType_Video,                // 视频
    ANMessageType_Video_Lock,                // 隐私视频
    ANMessageType_Emotion,                 // 表情
    ANMessageType_Link,          // 链接
    ANMessageType_Gift,                // 礼物
    ANMessageType_File,                // 文件
    ANMessageType_System,                // 系统

}ANMessageType;

//充值入口类型
typedef NS_ENUM(NSInteger,AYChargeLocationType) {
    AYChargeLocationTypeUsercenter          =   1, //用户中心充值入口
    AYChargeLocationTypeFictionChapter   =   2,//小说章节
    AYChargeLocationTypeCartoonChapter  =   3, //漫画章节
    AYChargeLocationTypeFictionReward  =   4,//小说打赏
    AYChargeLocationTypeCartoonReward  =   5,//漫画打赏
    
};

typedef enum {
    ANFileType_Other = 0,                // 其它类型
    ANFileType_Audio,                    //
    ANFileType_Video,                    //
    ANFileType_Html,
    ANFileType_Pdf,
    ANFileType_Doc,
    ANFileType_Xls,
    ANFileType_Ppt,
    ANFileType_Img,
    ANFileType_Txt
}ANFileType;
#endif /* constant_Enum_h */


