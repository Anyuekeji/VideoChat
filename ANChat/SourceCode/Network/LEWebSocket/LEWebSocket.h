//
//  LEWebSocket.h
//  ANChat
//
//  Created by liuyunpeng on 2019/5/23.
//  Copyright © 2019 liuyunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  socket状态
 */
typedef NS_ENUM(NSInteger,LESocketStatus){
    LESocketStatusConnected,// 已连接
    LESocketStatusFailed,// 失败
    LESocketStatusClosedByServer,// 系统关闭
    LESocketStatusClosedByUser,// 用户关闭
    LESocketStatusReceived// 接收消息
};
/**
 *  消息类型
 */
typedef NS_ENUM(NSInteger,LESocketReceiveType){
    LESocketReceiveTypeForMessage,
    LESocketReceiveTypeForPong
};
/**
 *  连接成功回调
 */
typedef void(^LESocketDidConnectBlock)(void);
/**
 *
 *  失败回调
 */
typedef void(^LESocketDidFailBlock)(NSError * _Nullable error);
/**
 *  关闭回调
 */
typedef void(^LESocketDidCloseBlock)(NSInteger code,NSString *reason,BOOL wasClean);
/**
 *  消息接收回调
 */
typedef void(^LESocketDidReceiveBlock)(id message ,LESocketReceiveType type);
NS_ASSUME_NONNULL_BEGIN

@interface LEWebSocket : NSObject
/**
 *  连接回调
 */
@property (nonatomic,copy)LESocketDidConnectBlock connect;
/**
 *  接收消息回调
 */
@property (nonatomic,copy)LESocketDidReceiveBlock receive;
/**
 *  失败回调
 */
@property (nonatomic,copy)LESocketDidFailBlock failure;
/**
 *  关闭回调
 */
@property (nonatomic,copy)LESocketDidCloseBlock close;
/**
 *
 *  当前的socket状态
 */
@property (nonatomic,assign,readonly)LESocketStatus le_socketStatus;
/**
 *  超时重连时间，默认1秒
 */
@property (nonatomic,assign)NSTimeInterval overtime;
/**
 *  重连次数,默认5次
 */
@property (nonatomic, assign)NSUInteger reconnectCount;
/**
  *  单例调用
 */
+ (instancetype)shareManager;
/**
 *  开启socket
 *
 *  @param urlStr  服务器地址
 *  @param connect 连接成功回调
 *  @param receive 接收消息回调
 *  @param failure 失败回调
 */
- (void)le_open:(NSString *)urlStr connect:(LESocketDidConnectBlock)connect receive:(LESocketDidReceiveBlock)receive failure:(LESocketDidFailBlock)failure;
/**
 *  关闭socket
 *
 *  @param close 关闭回调
 */
- (void)le_close:(LESocketDidCloseBlock)close;
/**
 *  发送消息，NSString 或者 NSData
 *
 *  @param data Send a UTF8 String or Data.
 */
- (void)le_send:(id)data;
@end

NS_ASSUME_NONNULL_END
