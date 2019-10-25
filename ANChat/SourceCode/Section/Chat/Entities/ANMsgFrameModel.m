//
//  ANMsgFrameModel.m
//  ANChat
//
//  Created by liuyunpeng on 2019/5/30.
//  Copyright © 2019 liuyunpeng. All rights reserved.
//

#import "ANMsgFrameModel.h"
#import "ANMediaManager.h"
#import "ANVideoManager.h"
#import "UIImage+Extension.h"

@implementation ANMsgFrameModel
- (void)setMsgModel:(ANChatMessageModel *)model
{
    _msgModel = model;
    CGFloat headToView    = 10;
    CGFloat headToBubble  = 3;
   // CGFloat headWidth     = 45;
    CGFloat cellMargin    = 10;
    CGFloat bubblePadding = 10;
    CGFloat chatLabelMax  = ScreenWidth - 100;
  //  CGFloat arrowWidth    = 7;      // 气泡箭头
    CGFloat topViewH      = 10;
    CGFloat cellMinW      = 60;     // cell的最小宽度值,针对文本
    CGSize timeSize  = CGSizeMake(0, 0);
    if ([model.isSender boolValue])
    {
        if ([model.type integerValue] == ANMessageType_Text)
        { // 文字
            CGSize chateLabelSize = [model.content sizeWithMaxWidth:chatLabelMax andFont:[UIFont systemFontOfSize:DEFAUT_FONTSIZE]];
            CGSize bubbleSize     = CGSizeMake(chateLabelSize.width + bubblePadding * 2 , chateLabelSize.height + bubblePadding * 2);
            _bubbleViewF          = CGRectMake(ScreenWidth-headToView- bubbleSize.width, cellMargin+topViewH, bubbleSize.width, bubbleSize.height);
            CGFloat x             = CGRectGetMinX(_bubbleViewF)+bubblePadding;
            _chatLabelF           = CGRectMake(x, topViewH + cellMargin + bubblePadding, chateLabelSize.width, chateLabelSize.height);
        } else if ([model.type integerValue] == ANMessageType_Pic) { // 图片
            CGSize imageSize = CGSizeMake(40, 40);
            UIImage *image   = [UIImage imageWithContentsOfFile:[[ANMediaManager sharedManager] imagePathWithName:model.mediaPath.lastPathComponent]];
            if (image) {
                imageSize          = [self handleImage:image.size];
            }
            imageSize.width        = imageSize.width > timeSize.width ? imageSize.width : timeSize.width;
            CGSize topViewSize     = CGSizeMake(imageSize.width, topViewH);
            CGSize bubbleSize      = CGSizeMake(imageSize.width, imageSize.height);
            CGFloat bubbleX        = ScreenWidth-headToView- bubbleSize.width;
            _bubbleViewF           = CGRectMake(bubbleX, cellMargin+topViewH, bubbleSize.width, bubbleSize.height);
            CGFloat x              = CGRectGetMinX(_bubbleViewF);
            _picViewF              = CGRectMake(x, cellMargin+topViewH, imageSize.width, imageSize.height);
        }
        else if ([model.type integerValue] == ANMessageType_Video) { // 视频信息
            CGSize imageSize       = CGSizeMake(150, 150);
            UIImage *videoImage = [[ANMediaManager sharedManager] videoImageWithFileName:model.mediaPath.lastPathComponent];
            if (!videoImage) {
                NSString *path          = [[ANVideoManager shareManager] receiveVideoPathWithFileKey:[model.mediaPath.lastPathComponent stringByDeletingPathExtension]];
                videoImage    = [UIImage videoFramerateWithPath:path];
            }
            if (videoImage) {
                float scale        = videoImage.size.height/videoImage.size.width;
                imageSize = CGSizeMake(150, 140*scale);
            }
            CGSize bubbleSize = CGSizeMake(imageSize.width, imageSize.height);
            _bubbleViewF = CGRectMake(ScreenWidth-headToBubble-bubbleSize.width, cellMargin+topViewH, bubbleSize.width, bubbleSize.height);
            CGFloat x              = CGRectGetMinX(_bubbleViewF);
            _picViewF              = CGRectMake(x, cellMargin+topViewH, imageSize.width, imageSize.height);
        }
        CGFloat activityX = _bubbleViewF.origin.x-40;
        CGFloat activityY = (_bubbleViewF.origin.y + _bubbleViewF.size.height)/2 - 5;
        CGFloat activityW = 40;
        CGFloat activityH = 40;
        _activityF        = CGRectMake(activityX, activityY, activityW, activityH);
        _retryButtonF     = _activityF;
    } else {    // 接收者
        if ([model.type integerValue] == ANMessageType_Text) {
            CGSize chateLabelSize = [model.content sizeWithMaxWidth:chatLabelMax andFont:[UIFont systemFontOfSize:DEFAUT_FONTSIZE]];
            CGSize bubbleSize = CGSizeMake(chateLabelSize.width + bubblePadding * 2 , chateLabelSize.height + bubblePadding * 2);
            _bubbleViewF  = CGRectMake(headToView, cellMargin+topViewH, bubbleSize.width, bubbleSize.height);
            CGFloat x     = CGRectGetMinX(_bubbleViewF) + bubblePadding ;
            _chatLabelF   = CGRectMake(x, cellMargin + bubblePadding + topViewH, chateLabelSize.width, chateLabelSize.height);
        } else if ([model.type integerValue] == ANMessageType_Pic) {
            CGSize imageSize = CGSizeMake(40, 40);
            UIImage *image   = [UIImage imageWithContentsOfFile:[[ANMediaManager sharedManager] imagePathWithName:model.mediaPath.lastPathComponent]];
            if (image) {
                imageSize = [self handleImage:image.size];
            }
            imageSize.width        = imageSize.width > cellMinW ? imageSize.width : cellMinW;
            CGSize bubbleSize      = CGSizeMake(imageSize.width, imageSize.height);
            CGFloat bubbleX        =  headToBubble;
            _bubbleViewF           = CGRectMake(bubbleX, cellMargin+topViewH, bubbleSize.width, bubbleSize.height);
            CGFloat x              = CGRectGetMinX(_bubbleViewF);
            _picViewF              = CGRectMake(x, cellMargin+topViewH, imageSize.width, imageSize.height);
            
        }
        else if ([model.type integerValue] == ANMessageType_Video) {   // 视频
            CGSize imageSize       = CGSizeMake(150, 150);
            UIImage *videoImage = [[ANMediaManager sharedManager] videoImageWithFileName:[NSString stringWithFormat:@"%@.png",model.fileKey]];
            if (!videoImage)
            {
                NSString *path  = [[ANVideoManager shareManager] receiveVideoPathWithFileKey:model.fileKey];
                videoImage    = [UIImage videoFramerateWithPath:path];
            }
            if (videoImage) {
                float scale        = videoImage.size.height/videoImage.size.width;
                imageSize = CGSizeMake(150, 140*scale);
            }
            CGSize bubbleSize = CGSizeMake(imageSize.width, imageSize.height+topViewH);
            _bubbleViewF = CGRectMake(headToBubble, cellMargin+topViewH, bubbleSize.width, bubbleSize.height);
            CGFloat x              = CGRectGetMinX(_bubbleViewF);
            _picViewF              = CGRectMake(x, cellMargin+topViewH, imageSize.width, imageSize.height);
        }
    }
    _cellHight = CGRectGetMaxY(_bubbleViewF)  + cellMargin;
    if ([model.type integerValue] == ANMessageType_System) {
        CGSize size           = [model.content sizeWithMaxWidth:[UIScreen mainScreen].bounds.size.width-40 andFont:[UIFont systemFontOfSize:11.0]];
        _cellHight = size.height+10;
    }
}



// 缩放，临时的方法
- (CGSize)handleImage:(CGSize)retSize
{
    CGFloat scaleH = 0.22;
    CGFloat scaleW = 0.38;
    CGFloat height = 0;
    CGFloat width = 0;
    if (retSize.height / ScreenHeight + 0.16 > retSize.width / ScreenWidth) {
        height = ScreenHeight * scaleH;
        width = retSize.width / retSize.height * height;
    } else {
        width = ScreenWidth * scaleW;
        height = retSize.height / retSize.width * width;
    }
    return CGSizeMake(width, height);
}

@end
