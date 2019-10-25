//
//  ANMessageHelper.m
//  ANChat
//
//  Created by liuyunpeng on 2019/5/31.
//  Copyright © 2019 liuyunpeng. All rights reserved.
//

#import "ANMessageHelper.h"
#import "ANChatMessageModel.h"
#import "ANMsgFrameModel.h"
#import <AVFoundation/AVFoundation.h>
#import "LEFileManager.h"


#define lastUpdateKey [NSString stringWithFormat:@"%@-%@",[ICUser currentUser].eId,@"LastUpdate"]
#define groupInfoLastUpdateKey [NSString stringWithFormat:@"%@-%@",[ICUser currentUser].eId,@"groupInfoLastUpdate"]
#define directLastUpdateKey [NSString stringWithFormat:@"%@-%@",[ICUser currentUser].eId,@"directLastUpdate"]

@implementation ANMessageHelper
// 创建一条本地消息
+ (ANMsgFrameModel *)createMessageFrame:(ANMessageType )type
                               content:(NSString *)content
                                  path:(NSString *)path
                                  from:(NSString *)from
                                    to:(NSString *)to
                               fileKey:(NSString *)fileKey
                              isSender:(BOOL)isSender
              receivedSenderByYourself:(BOOL)receivedSenderByYourself
{
    ANChatMessageModel *message    = [[ANChatMessageModel alloc] init];
    message.toId            = to;
    message.fromId          = from;
    message.fileKey       = fileKey;
    // 我默认了一个本机的当前时间，其实没用到，成功后都改成服务器时间了
    message.msgDate          = @([ANMessageHelper currentMessageTime]);
    message.type   = @(type);
    if (type == ANMessageType_Text) {
        message.content = content;
    } else if (type == ANMessageType_Pic) {
        message.content = @"[图片]";
    } else if (type == ANMessageType_Voice) {
        message.content = @"[语音]";
    } else if (type == ANMessageType_Video) {
        message.content = @"[视频]";
    } else if (type == ANMessageType_Dynamic) {
        message.content = @"[gif]";
    } else if (type == ANMessageType_Text) {
        message.content = content;
    } else {
        message.content = content;
    }
    message.isSender        = @(isSender);
    message.mediaPath       = path;
    if (isSender) {
        message.deliveryState = @(ANMessageDeliveryState_Delivering);
    } else {
        message.deliveryState = @(ANMessageDeliveryState_Delivered);
    }
    if (receivedSenderByYourself) { // 接收到得信息是自己发的
        message.deliveryState = @(ANMessageDeliveryState_Delivered);
        message.isSender        = @(YES);
    }
    ANMsgFrameModel *modelF = [[ANMsgFrameModel alloc] init];
    modelF.msgModel = message;
    return modelF;
}


+ (ANMsgFrameModel *)createMessageMeReceiverFrame:(ANMessageType)type
                                         content:(NSString *)content
                                            path:(NSString *)path
                                            from:(NSString *)from
                                         fileKey:(NSString *)fileKey
{
    ANChatMessageModel *message    = [[ANChatMessageModel alloc] init];
    message.type   = @(type);
    message.fileKey    = fileKey;
    message.isSender = @(NO);
    message.content    = content;
    message.mediaPath    = path;
    message.deliveryState = @(ANMessageDeliveryState_Delivered);
    ANMsgFrameModel *modelF = [[ANMsgFrameModel alloc] init];
    modelF.msgModel = message;
    return modelF;
}
/**
 *  创建一条发送消息
 *
 *  @param type    消息类型
 *  @param content 消息文本内容，其它类型的类型名称:[图片]
 *  @param fileKey 音频文件的fileKey
 *  @param from    发送者
 *  @param to      接收者
 *  @param lnk     连接地址URL,图片格式,文件名称 （目前没用到）
 *  @param status  消息状态 （目前没用到）
 *
 *  @return 发送的消息
 */
+ (ANChatMessageModel *)createSendMessage:(ANMessageType)type
                         content:(NSString *)content
                         fileKey:(NSString *)fileKey
                            from:(NSString *)from
                              to:(NSString *)to
                             lnk:(NSString *)lnk
                          status:(NSString *)status
{
    ANChatMessageModel *message    = [[ANChatMessageModel alloc] init];
    message.fromId          = from;
    message.toId            = to;
    message.content       = content;
    message.fileKey       = fileKey;
    message.lnk           = lnk;
    message.type = @(type);
    message.msgDate          =@([ANMessageHelper currentMessageTime]);
    return message;
}

// 获取语音消息时长
+ (CGFloat)getVoiceTimeLengthWithPath:(NSString *)path
{
    AVURLAsset* audioAsset =[AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:path] options:nil];
    CMTime audioDuration = audioAsset.duration;
    CGFloat audioDurationSeconds =CMTimeGetSeconds(audioDuration);
    return audioDurationSeconds;
}

// 图片按钮在窗口中得位置
+ (CGRect)photoFramInWindow:(UIButton *)photoView
{
    return [photoView convertRect:photoView.bounds toView:[UIApplication sharedApplication].keyWindow];
}

// 放大后的图片按钮在窗口中的位置
+ (CGRect)photoLargerInWindow:(UIButton *)photoView
{
    //    CGSize imgSize     = photoView.imageView.image.size;
    CGSize  imgSize    = photoView.currentBackgroundImage.size;
    CGFloat appWidth   = [UIScreen mainScreen].bounds.size.width;
    CGFloat appHeight  = [UIScreen mainScreen].bounds.size.height;
    CGFloat height     = imgSize.height / imgSize.width * appWidth;
    CGFloat photoY     = 0;
    if (height < appHeight) {
        photoY         = (appHeight - height) * 0.5;
    }
    return CGRectMake(0, photoY, appWidth, height);
}

// 删除消息附件
+ (void)deleteMessage:(ANChatMessageModel *)messageModel
{
    if ([LEFileManager isFileExistsAtPath:messageModel.mediaPath])
    {
        [LEFileManager deleteFileAtPath:messageModel.mediaPath];
    }
}

// current message time
+ (NSInteger)currentMessageTime
{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSInteger iTime     = (NSInteger)(time * 1);
    return iTime;
}

// time format
+ (NSString *)timeFormatWithDate:(NSInteger)time
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSDate * currentDate = [NSDate dateWithTimeIntervalSince1970:time/1000];
    NSString *date = [formatter stringFromDate:currentDate];
    return date;
}


+ (NSString *)timeFormatWithDate2:(NSInteger)time
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yy/MM/dd HH:mm"];
    NSDate * currentDate = [NSDate dateWithTimeIntervalSince1970:time/1000];
    NSString *date = [formatter stringFromDate:currentDate];
    return date;
    
}

+ (NSDictionary *)fileTypeDictionary
{
    NSDictionary *dic = @{
                          @"mp3":@1,@"mp4":@2,@"mpe":@2,@"docx":@5,
                          @"amr":@1,@"avi":@2,@"wmv":@2,@"xls":@6,
                          @"wav":@1,@"rmvb":@2,@"mkv":@2,@"xlsx":@6,
                          @"mp3":@1,@"rm":@2,@"vob":@2,@"ppt":@7,
                          @"aac":@1,@"asf":@2,@"html":@3,@"pptx":@7,
                          @"wma":@1,@"divx":@2,@"htm":@3,@"png":@8,
                          @"ogg":@1,@"mpg":@2,@"pdf":@4,@"jpg":@8,
                          @"ape":@1,@"mpeg":@2,@"doc":@5,@"jpeg":@8,
                          @"gif":@8,@"bmp":@8,@"tiff":@8,@"svg":@8
                          };
    return dic;
}

+ (NSNumber *)fileType:(NSString *)type
{
    NSDictionary *dic = [self fileTypeDictionary];
    return [dic objectForKey:type];
}

+ (UIImage *)allocationImage:(ANFileType)type
{
    switch (type) {
        case ANFileType_Audio:
            return [UIImage imageNamed:@"yinpin"];
            break;
        case ANFileType_Video:
            return [UIImage imageNamed:@"shipin"];
            break;
        case ANFileType_Html:
            return [UIImage imageNamed:@"html"];
            break;
        case ANFileType_Pdf:
            return  [UIImage imageNamed:@"pdf"];
            break;
        case ANFileType_Doc:
            return  [UIImage imageNamed:@"word"];
            break;
        case ANFileType_Xls:
            return [UIImage imageNamed:@"excerl"];
            break;
        case ANFileType_Ppt:
            return [UIImage imageNamed:@"ppt"];
            break;
        case ANFileType_Img:
            return [UIImage imageNamed:@"zhaopian"];
            break;
        case ANFileType_Txt:
            return [UIImage imageNamed:@"txt"];
            break;
        default:
            return [UIImage imageNamed:@"iconfont-wenjian"];
            break;
    }
}


+ (NSString *)timeDurationFormatter:(NSUInteger)duration
{
    float M = duration/60.0;
    float S = duration - (int)M * 60;
    NSString *timeFormatter = [NSString stringWithFormat:@"%02.0lf:%02.0lf",M,S];
    return  timeFormatter;
    
}

@end
