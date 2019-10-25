//
//  ANChatTableViewCell.h
//  ANChat
//
//  Created by liuyunpeng on 2019/5/30.
//  Copyright © 2019 liuyunpeng. All rights reserved.
//

#import "LETableViewCell.h"

@class ANChatTableViewCell;
@protocol ANChatTableViewCellDelegate <NSObject>

- (void)longPress:(UILongPressGestureRecognizer *_Nullable)longRecognizer;

@optional
- (void)headImageClicked:(NSString *)eId;
- (void)reSendMessage:(ANChatTableViewCell *)msgCell;

@end

NS_ASSUME_NONNULL_BEGIN
//别人的发送的消息基类cell
@interface ANChatTableViewCell : LETableViewCell
@property (nonatomic, weak) id<ANChatTableViewCellDelegate> longPressDelegate;
-(void)fillCellWithModel:(id)model;
@end

//自己的发送的消息基类cell
@interface ANMyChatTableViewCell : ANChatTableViewCell
@end

//别人的发送的文本消息 接收消息 cell
@interface ANChatTextTableViewCell : ANChatTableViewCell
-(void)fillCellWithModel:(id)model;
@end

//自己的发送的文本消息 发送消息cell
@interface ANMyChatTextTableViewCell : ANMyChatTableViewCell
-(void)fillCellWithModel:(id)model;
@end

NS_ASSUME_NONNULL_END
