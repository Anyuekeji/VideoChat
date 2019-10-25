//
//  ANChatBaseTableViewCell.h
//  ANChat
//
//  Created by liuyunpeng on 2019/5/30.
//  Copyright © 2019 liuyunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewCell.h"
#import "ANMsgFrameModel.h"

@class ANChatBaseTableViewCell;
@protocol ANChatBaseTableViewCellDelegate <NSObject>

- (void)longPress:(UILongPressGestureRecognizer *)longRecognizer;

@optional
- (void)headImageClicked:(NSString *)eId;
- (void)reSendMessage:(ANChatBaseTableViewCell *)baseCell;

@end
NS_ASSUME_NONNULL_BEGIN

@interface ANChatBaseTableViewCell : LETableViewCell
@property (nonatomic, weak) id<ANChatBaseTableViewCellDelegate> longPressDelegate;
// 消息模型
@property (nonatomic, strong) ANMsgFrameModel *modelFrame;
// 头像
@property (nonatomic, strong) UIImageView *headImageView;
// 内容气泡视图
@property (nonatomic, strong) UIView *bubbleView;
// 菊花视图所在的view
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
// 重新发送
@property (nonatomic, strong) UIButton *retryButton;
@end

NS_ASSUME_NONNULL_END
