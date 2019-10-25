//
//  LEWebSocket.m
//  ANChat
//
//  Created by liuyunpeng on 2019/5/23.
//  Copyright © 2019 liuyunpeng. All rights reserved.
//

#import "LEWebSocket.h"
#import <SocketRocket/SRWebSocket.h>
#import <YYKit/YYKit.h>


@interface LEWebSocket ()<SRWebSocketDelegate>
@property (nonatomic,strong)SRWebSocket *webSocket;
@property (nonatomic,assign)LESocketStatus le_socketStatus;
@property (nonatomic,weak)NSTimer *timer;
@property (nonatomic,copy)NSString *urlString;
@property(nonatomic,strong)NSTimer *heartBeat;

@end
@implementation LEWebSocket
{
    NSInteger _reconnectCounter;
}

+ (instancetype)shareManager{
    static LEWebSocket *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        instance.overtime = 1;
        instance.reconnectCount = 5;
    });
    return instance;
}

- (void)le_open:(NSString *)urlStr connect:(LESocketDidConnectBlock)connect receive:(LESocketDidReceiveBlock)receive failure:(LESocketDidFailBlock)failure{
    [LEWebSocket shareManager].connect = connect;
    [LEWebSocket shareManager].receive = receive;
    [LEWebSocket shareManager].failure = failure;
    [self le_open:urlStr];
}

- (void)le_close:(LESocketDidCloseBlock)close{
    [LEWebSocket shareManager].close = close;
    [self le_close];
}

// Send a UTF8 String or Data.
- (void)le_send:(id)data{
    switch ([LEWebSocket shareManager].le_socketStatus) {
            case LESocketStatusConnected:
            case LESocketStatusReceived:{
                AYLog(@"发送中。。。");
                [self.webSocket send:data];
                break;
            }
            case LESocketStatusFailed:
            AYLog(@"发送失败");
            break;
            case LESocketStatusClosedByServer:
            [self le_reconnect];
            AYLog(@"已经关闭");
            break;
            case LESocketStatusClosedByUser:
            [self le_reconnect];
            AYLog(@"已经关闭");
            break;
    }
    
}

#pragma mark -- private method
- (void)le_open:(id)params{
    //    NSLog(@"params = %@",params);
    NSString *urlStr = nil;
    if ([params isKindOfClass:[NSString class]]) {
        urlStr = (NSString *)params;
    }
    else if([params isKindOfClass:[NSTimer class]]){
        NSTimer *timer = (NSTimer *)params;
        urlStr = [timer userInfo];
    }
    [LEWebSocket shareManager].urlString = urlStr;
    [self.webSocket close];
    self.webSocket.delegate = nil;
    self.webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    self.webSocket.delegate = self;
    [self.webSocket open];
}

- (void)le_close{
    
    [self.webSocket close];
    self.webSocket = nil;
    [self.timer invalidate];
    self.timer = nil;
}

- (void)le_reconnect{
    // 计数+1
    if (_reconnectCounter < self.reconnectCount - 1) {
        _reconnectCounter ++;
        // 开启定时器
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.overtime target:self selector:@selector(le_open:) userInfo:self.urlString repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        self.timer = timer;
    }
    else{
        AYLog(@"Websocket Reconnected Outnumber ReconnectCount");
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
        return;
    }
    
}
#pragma mark -- 心跳

//  初始化心跳
- (void)initHearBeat
{
    dispatch_main_async_safe(^{
        [self destoryHeartBeat];
        LEWeakSelf(self)
        //心跳设置为3分钟，NAT超时一般为5分钟
       self.heartBeat= [NSTimer scheduledTimerWithTimeInterval:30 block:^(NSTimer * _Nonnull timer) {
           AYLog(@"heart");
           LEStrongSelf(self)
           //和服务端约定好发送什么作为心跳标识，尽可能的减小心跳包大小
           [self le_send:@"heart"];
        } repeats:YES];
    });
}
//  取消心跳
- (void)destoryHeartBeat
{
    LEWeakSelf(self)
    dispatch_main_async_safe(^{
        LEStrongSelf(self)
        if (self.heartBeat) {
            [self.heartBeat invalidate];
            self.heartBeat = nil;
        }
    });
}
#pragma mark -- SRWebSocketDelegate
- (void)webSocketDidOpen:(SRWebSocket *)webSocket{
    AYLog(@"Websocket Connected");
    [LEWebSocket shareManager].connect ? [LEWebSocket shareManager].connect() : nil;
    [LEWebSocket shareManager].le_socketStatus = LESocketStatusConnected;
    // 开启成功后重置重连计数器
    _reconnectCounter = 0;
    [self initHearBeat];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    
    AYLog(@":( Websocket Failed With Error %@", error);
    [LEWebSocket shareManager].le_socketStatus = LESocketStatusFailed;
    [LEWebSocket shareManager].failure ? [LEWebSocket shareManager].failure(error) : nil;
    // 重连
    [self le_reconnect];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{
    if ([message isKindOfClass:NSData.class])
    {
        NSString *receiveMsg = [[NSString alloc] initWithData:message encoding:NSUTF8StringEncoding];
        AYLog(@":( Websocket Receive With message %@", receiveMsg);

    }
    else
    {
        AYLog(@":( Websocket Receive With message %@", message);

    }
    if ([message isEqualToString:@"ACT: heart"])
    {
        return;
    }
    
    NSDictionary *receiveDic =LEConvertDataToDictionary(message);
    
    //发送收到消息通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationReceiveMsg object:LEConvertDataToDictionary(message)];
    [LEWebSocket shareManager].le_socketStatus = LESocketStatusReceived;
    [LEWebSocket shareManager].receive ? [LEWebSocket shareManager].receive(message,LESocketReceiveTypeForMessage) : nil;
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    AYLog(@"Closed Reason:%@  code = %zd",reason,code);
    if (reason) {
        [LEWebSocket shareManager].le_socketStatus = LESocketStatusClosedByServer;
        // 重连
        [self le_reconnect];
    }
    else{
        [LEWebSocket shareManager].le_socketStatus = LESocketStatusClosedByUser;
    }
    [LEWebSocket shareManager].close ? [LEWebSocket shareManager].close(code,reason,wasClean) : nil;
    self.webSocket = nil;
    [self le_close];
    //断开连接时销毁心跳
    [self destoryHeartBeat];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload{
    [LEWebSocket shareManager].receive ? [LEWebSocket shareManager].receive(pongPayload,LESocketReceiveTypeForPong) : nil;
}

- (void)dealloc{
    // Close WebSocket
    [self le_close];
}
@end
