//
//  ANChatViewModle.m
//  ANChat
//
//  Created by liuyunpeng on 2019/5/31.
//  Copyright © 2019 liuyunpeng. All rights reserved.
//

#import "ANChatViewModle.h"
#import "ANMsgFrameModel.h"
#import "ANLastChatModel.h" //保存用户最后一次聊天信息
#import "AN_Chat_Config.h"//聊天配置文件


@interface ANChatViewModle ()
{
    NSInteger _lastOriginTime;  //一条消息的时间
}
@property (nonatomic, strong) NSMutableArray<NSDictionary*> *chatInfoArray;//聊天任务


@end

@implementation ANChatViewModle
- (void) setUp
{
    [super setUp];
    [self configureData];
}
-(void)configureData
{
    _lastOriginTime =0;
    _chatInfoArray = [NSMutableArray new];
}
- (void) getChatInfoDataByUid :(NSString*)uid complete:(void(^)(void)) completeBlock failure : (void(^)(NSString * errorString)) failureBlock
{
    self.chatUserId =uid;
    ANLastChatModel *lastChatModel  = [self getLocalChatModle];
    if (lastChatModel)
    {
        //获取本地前七天数据
        NSString *qureyStr = [NSString stringWithFormat:@"toId = '%@' AND msgDate >= %ld AND msgDate<= %ld",self.chatUserId,(long)[self getQueryChatInfoMinTimeWithChatModel:lastChatModel],(long)[lastChatModel.lastChatTime integerValue]];
        NSArray<ANChatMessageModel*>  *localChatMessage = [ANChatMessageModel r_query:qureyStr sortProperty:@"msgDate" ascending:YES];
        if (localChatMessage)
        {
            [self dealWithChatArray:localChatMessage];
        }
        if (completeBlock) {
            completeBlock();
        }
    }
}
#pragma mark - db -
-(ANLastChatModel*)getLocalChatModle
{
    NSString *qureyStr = [NSString stringWithFormat:@"uid = '%@'",self.chatUserId];
    NSArray<ANLastChatModel*>  *lastChatModel = [ANLastChatModel r_query:qureyStr];
    if ([lastChatModel count]>0) {
        return lastChatModel[0];
    }
    return nil;
}
#pragma mark - private -
-(ANMsgFrameModel*)msgFrameModelWithModel:(ANChatMessageModel*)chatMsgModel
{
    if (chatMsgModel)
    {
        ANMsgFrameModel *msgFrameModel = [[ANMsgFrameModel alloc] init];
        msgFrameModel.msgModel = chatMsgModel;
        return msgFrameModel;
    }
    return nil;
}
//获取本地聊天数据的最早时间
-(NSInteger)getQueryChatInfoMinTimeWithChatModel:(ANLastChatModel*)lastChatModel
{
   NSDate *maxDate = [NSDate dateWithTimeIntervalSince1970:[lastChatModel.lastChatTime integerValue]];
   NSTimeInterval oneDay = 24 * 60 * 60;  // 一天一共有多少秒
   NSDate  *minDate = [maxDate initWithTimeIntervalSinceNow: -(oneDay * DEFAULT_CHAT_DAY)];
   NSInteger maxTime= (long)[minDate timeIntervalSince1970];
    return maxTime;
}
//判断是否需要显示时间
-(BOOL)msgNeedShowTime:(NSInteger)originTimeStamp currentTime:(NSInteger)currentTime
{
    //大于5分钟 显示时间
    if (currentTime - originTimeStamp> (DEFAULT_CHAT_TIME_SHOW*60)) {
        return YES;
    }
    return NO;
}
-(NSString *)getTimeStr:(NSInteger)currentTimeStamp
{
    NSDate *fromdate= [NSDate dateWithTimeIntervalSince1970:currentTimeStamp];
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString* string=[dateFormat stringFromDate:fromdate];
    return string;
}
//nsarry处理成 nsdiction数据
-(void)dealWithChatArray:(NSArray<ANChatMessageModel*>*) chatInfoArray
{
    __block NSInteger originTimpStamp;
    if (chatInfoArray ) {
        [chatInfoArray enumerateObjectsUsingBlock:^(ANChatMessageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
        {
            NSMutableArray *msgModelArray;
            NSMutableDictionary *msgModelDic;
            if (idx ==0)
            {
                originTimpStamp  = [obj.msgDate integerValue];
                msgModelArray = [NSMutableArray new];
                msgModelDic = [NSMutableDictionary new];
                [msgModelArray safe_addObject:[self msgFrameModelWithModel:obj]];
            }
            else
            {
                if ([self msgNeedShowTime:originTimpStamp currentTime:[obj.msgDate integerValue]])//需要显示时间 新增一个section  dic 的可以 是时间
                {
                    if(msgModelArray && msgModelArray.count>0)
                    {
                        [msgModelDic setObject:msgModelArray forKey:[self getTimeStr:originTimpStamp]];
                        [self.chatInfoArray safe_addObject:msgModelDic];
                    }
                    originTimpStamp  = [obj.msgDate integerValue];
                    msgModelArray = [NSMutableArray new];
                    msgModelDic = [NSMutableDictionary new];
                    [msgModelArray safe_addObject:[self msgFrameModelWithModel:obj]];
                }
                else //不需要显示时间，
                {
                    [msgModelArray safe_addObject:[self msgFrameModelWithModel:obj]];
                    if (idx == chatInfoArray.count-1)
                    {
                        self->_lastOriginTime = [obj.msgDate integerValue];
                        if(msgModelArray && msgModelArray.count>0)
                        {
                            [msgModelDic setObject:msgModelArray forKey:[self getTimeStr:originTimpStamp]];
                            [self.chatInfoArray safe_addObject:msgModelDic];
                        }
                    }
                }
            }
            
        }];
    }
}
#pragma mark - Table Used
- (NSInteger)numberOfSections
{
    return _chatInfoArray.count;
}
- (NSInteger) numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *itemDic = [_chatInfoArray safe_objectAtIndex:section];
    if (itemDic) {
        NSArray *chatArray = (NSArray*)[itemDic allValues][0];
        if (chatArray) {
            return chatArray.count;
        }
    }
    return 0;
}

- (id) objectForIndexPath : (NSIndexPath *) indexPath
{
    NSDictionary *itemDic = [_chatInfoArray safe_objectAtIndex:indexPath.section];
    if (itemDic)
    {
        NSArray *chatArray = (NSArray*)[itemDic allValues][0];
        if (chatArray) {
            return [chatArray objectAtIndex:indexPath.row];
        }
    }
    return nil;
}
- (NSString*) getIndexPathTitle:(NSIndexPath*)indexPath
{
    NSDictionary *itemDic = [_chatInfoArray safe_objectAtIndex:indexPath.section];
    if (itemDic)
    {
        NSString *sectionStr = (NSString*)[itemDic allKeys][0];
        return sectionStr;
    }
    return nil;
}
-(void)addObject:(ANMsgFrameModel*)msgFrameModle complete:(void(^)(BOOL newSection)) completeBlock;
{
    if(msgFrameModle)
    {
        if (_lastOriginTime>=0 )
        {
            if([self msgNeedShowTime:self->_lastOriginTime currentTime:[msgFrameModle.msgModel.msgDate integerValue]] || _lastOriginTime==0)
            {
                _lastOriginTime  = [msgFrameModle.msgModel.msgDate integerValue];
                NSMutableArray *msgArray = [NSMutableArray new];
                [msgArray safe_addObject:msgFrameModle];
                NSMutableDictionary *msgModelDic= [NSMutableDictionary new];
                [msgModelDic setObject:msgArray forKey:[self getTimeStr:_lastOriginTime]];
                [self.chatInfoArray safe_addObject:msgModelDic];
                
            }
            else
            {
                if (_chatInfoArray.count > 0)
                {
                    NSDictionary *msgdic = [_chatInfoArray safe_objectAtIndex:_chatInfoArray.count-1];
                    if (msgdic)
                    {
                        NSMutableArray *msgModelArray = [msgdic allValues][0];
                        if (msgModelArray) {
                            [msgModelArray safe_addObject:msgFrameModle];
                        }
                    }
                }
                
            }
        }
        
    }
    if (completeBlock) {
        completeBlock(NO);
    }
}
- (NSIndexPath*) lastIndexPath
{
    if (self.chatInfoArray.count)
    {
        NSInteger lastSeciont = self.chatInfoArray.count-1;
        NSDictionary *itemDic = [_chatInfoArray safe_objectAtIndex:lastSeciont];
        if (itemDic) {
            NSArray *chatArray = (NSArray*)[itemDic allValues][0];
            if (chatArray) {
                NSInteger lastRow = chatArray.count-1;
                return [NSIndexPath indexPathForRow:lastRow inSection:lastSeciont];
            }
        }
    }
    return nil;
}
@end
