//
//  ANChatImageCellTableViewCell.m
//  ANChat
//
//  Created by liuyunpeng on 2019/6/29.
//  Copyright © 2019 liuyunpeng. All rights reserved.
//

#import "ANChatImageCellTableViewCell.h"
#import "ANMediaManager.h"
#import "LEFileManager.h"
#import "ANChatMessageModel.h"
#import "ANMessageHelper.h"


@interface ANChatImageCellTableViewCell ()
@property (nonatomic, strong) UIButton *imageBtn;
@end

@implementation ANChatImageCellTableViewCell

-(void)setUp
{
    [super setUp];
    [self configureUI];
}
-(void)configureUI
{
    [self.contentView addSubview:self.imageBtn];
}
#pragma mark - Private Method

- (void)setModelFrame:(ANMsgFrameModel *)modelFrame
{
    [super setModelFrame:modelFrame];
    
    ANMediaManager *manager = [ANMediaManager sharedManager];
    UIImage *image = [manager imageWithLocalPath:[manager imagePathWithName:modelFrame.msgModel.mediaPath.lastPathComponent]];
    self.imageBtn.frame = modelFrame.picViewF;
    self.bubbleView.userInteractionEnabled = _imageBtn.imageView.image != nil;
    if (modelFrame.msgModel.isSender) {    // 发送者
        UIImage *arrowImage = [manager arrowMeImage:image size:modelFrame.picViewF.size mediaPath:modelFrame.msgModel.mediaPath isSender:[modelFrame.msgModel.isSender boolValue]];
        [self.imageBtn setBackgroundImage:arrowImage forState:UIControlStateNormal];
    } else {
        NSString *orgImgPath = [manager originImgPath:modelFrame];
        if ([LEFileManager isFileExistsAtPath:orgImgPath]) {
            UIImage *orgImg = [manager imageWithLocalPath:orgImgPath];
            UIImage *arrowImage = [manager arrowMeImage:orgImg size:modelFrame.picViewF.size mediaPath:orgImgPath isSender:[modelFrame.msgModel.isSender boolValue]];
            [self.imageBtn setBackgroundImage:arrowImage forState:UIControlStateNormal];
        } else {
            UIImage *arrowImage = [manager arrowMeImage:image size:modelFrame.picViewF.size mediaPath:modelFrame.msgModel.mediaPath isSender:[modelFrame.msgModel.isSender boolValue]];
            [self.imageBtn setBackgroundImage:arrowImage forState:UIControlStateNormal];
        }
    }
}

- (void)imageBtnClick:(UIButton *)btn
{
    if (btn.currentBackgroundImage == nil) {
        return;
    }
    CGRect smallRect = [ANMessageHelper photoFramInWindow:btn];
    CGRect bigRect   = [ANMessageHelper photoLargerInWindow:btn];
    NSValue *smallValue = [NSValue valueWithCGRect:smallRect];
    NSValue *bigValue   = [NSValue valueWithCGRect:bigRect];
    [self routerEventWithName:LERouterEventImageTapEventName
                     userInfo:@{LERouterMessageKey : self.modelFrame,
                                @"smallRect" : smallValue,
                                @"bigRect"   : bigValue
                                }];
}
#pragma mark - Getter And Setter -
- (UIButton *)imageBtn
{
    if (!_imageBtn)
    {
        _imageBtn = [[UIButton alloc] init];
        [_imageBtn addTarget:self action:@selector(imageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _imageBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _imageBtn.layer.masksToBounds = YES;
        _imageBtn.layer.cornerRadius = 5;
        _imageBtn.clipsToBounds = YES;
    }
    return _imageBtn;
}


@end
