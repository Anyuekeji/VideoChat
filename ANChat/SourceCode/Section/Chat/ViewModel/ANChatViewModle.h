//
//  ANChatViewModle.h
//  ANChat
//
//  Created by liuyunpeng on 2019/5/31.
//  Copyright © 2019 liuyunpeng. All rights reserved.
//

#import "AYBaseViewModle.h"



@class  ANMsgFrameModel;

NS_ASSUME_NONNULL_BEGIN

@interface ANChatViewModle : AYBaseViewModle
/**
 *  数据组
 */
- (NSInteger) numberOfSections;
/**
 *  数据行
 */
- (NSInteger) numberOfRowsInSection:(NSInteger)section;

/**
 *  获取对象
 */
- (id) objectForIndexPath : (NSIndexPath *) indexPath;

/**
 *  获取最后一个索引对象
 */
- (NSIndexPath*) lastIndexPath;

/**
 *  获取section 标题
 */
- (NSString*) getIndexPathTitle:(NSIndexPath*)indexPath;

//俩天对象
@property (nonatomic, strong) NSString *chatUserId;//聊天对象id


/**
 *  收到消息
 */
@property (copy, nonatomic) void(^receiverMsgFromServer)(ANMsgFrameModel* msgFrameModle);

/*
 *  获取聊天数据
 *
 *  @param completeBlock 成功回调
 *  @param failureBlock  失败回调
 */
- (void) getChatInfoDataByUid :(NSString*)uid complete:(void(^)(void)) completeBlock failure : (void(^)(NSString * errorString)) failureBlock;

//发送消息到后台
-(void)addObject:(ANMsgFrameModel*)msgFrameModle  complete:(void(^)(BOOL newSection)) completeBlock;
@end

NS_ASSUME_NONNULL_END
