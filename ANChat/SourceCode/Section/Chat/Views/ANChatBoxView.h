//
//  ANChatBoxView.h
//  ANChat
//
//  Created by liuyunpeng on 2019/5/31.
//  Copyright © 2019 liuyunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ANChatBoxView;
@class ANVideoRecordView;
@protocol ANChatBoxViewDelegate <NSObject>
/**
 *  发送消息
 *
 *  @param chatBox     chatBox
 *  @param textMessage 消息
 */
- (void)chatBox:(ANChatBoxView *_Nullable)chatBox sendTextMessage:(NSString *_Nullable)textMessage;

// change chatBox height
- (void) chatBox:(ANChatBoxView *_Nullable)chatBox
        didChangeChatBoxHeight:(CGFloat)height;
//显示视频录制视图
- (void) chatBox:(ANChatBoxView *_Nullable)chatBox
didVideoViewAppeared:(ANVideoRecordView *_Nullable)videoView;
//发送视频
- (void) chatBox:(ANChatBoxView *_Nullable)chatBox sendVideoMessage:(NSString *_Nullable)videoPath;

//发送图片
- (void) chatBox:(ANChatBoxView *_Nullable)chatBox sendImage:(UIImage *_Nullable)sendImage;
@end
NS_ASSUME_NONNULL_BEGIN

@interface ANChatBoxView : UIView
@property (nonatomic, weak) id<ANChatBoxViewDelegate>delegate;
//隐藏视频录制视图
-(void)hideVideoView;
@end

NS_ASSUME_NONNULL_END
