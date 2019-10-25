//
//  ANChatVideoUnlockTableViewCell.m
//  ANChat
//
//  Created by liuyunpeng on 2019/7/6.
//  Copyright © 2019 liuyunpeng. All rights reserved.
//

#import "ANChatVideoUnlockTableViewCell.h"
#import "ANChatMessageModel.h"
#import "ANMediaManager.h"
#import "ANVideoManager.h"
#import "UIImage+Extension.h"
#import "ZacharyPlayManager.h"
#import "ICAVPlayer.h"
#import "LEFileManager.h"

@interface ANChatVideoUnlockTableViewCell ()
@property (nonatomic, strong) UIButton *imageBtn;
@property (nonatomic, strong) UIButton *topBtn;
@end

@implementation ANChatVideoUnlockTableViewCell
-(void)setUp
{
    [super setUp];
    [self configureUI];
}
-(void)configureUI
{
    [self.contentView addSubview:self.imageBtn];
    [self.imageBtn addSubview:self.topBtn];
    
}
- (void)setModelFrame:(ANMsgFrameModel *)modelFrame
{
    [super setModelFrame:modelFrame];
    ANMediaManager *manager = [ANMediaManager sharedManager];
    
    NSString *path          = [[ANVideoManager shareManager] receiveVideoPathWithFileKey:[modelFrame.msgModel.mediaPath.lastPathComponent stringByDeletingPathExtension]];
    UIImage *videoArrowImage = [manager videoConverPhotoWithVideoPath:path size:modelFrame.picViewF.size isSender:modelFrame.msgModel.isSender];
    self.imageBtn.frame = modelFrame.picViewF;
    self.bubbleView.userInteractionEnabled = videoArrowImage != nil;
    [self.imageBtn setImage:videoArrowImage forState:UIControlStateNormal];
    self.topBtn.frame = CGRectMake(0, 0, _imageBtn.width, _imageBtn.height);
}
- (void)imageBtnClick:(UIButton *)btn
{
    __block NSString *path = [[ANVideoManager shareManager] videoPathForMP4:self.modelFrame.msgModel.mediaPath];
    [self videoPlay:path];
}
- (void)videoPlay:(NSString *)path
{
    ICAVPlayer *player = [[ICAVPlayer alloc] initWithPlayerURL:[NSURL fileURLWithPath:path]];
    [player presentFromVideoView:self.imageBtn toContainer:App_RootCtr.view animated:YES completion:nil];
}
#pragma mark - videoPlay
- (void)firstPlay
{
    __block NSString *path = [[ANVideoManager shareManager] videoPathForMP4:self.modelFrame.msgModel.mediaPath];
    if ([LEFileManager isFileExistsAtPath:path]) {
        [self reloadStart];
        _topBtn.hidden = YES;
    }
}

-(void)reloadStart {
    __weak typeof(self) weakSelf=self;
    NSString *path = [[ANVideoManager shareManager] videoPathForMP4:self.modelFrame.msgModel.mediaPath];
    [[ZacharyPlayManager sharedInstance] startWithLocalPath:path WithVideoBlock:^(UIImage *imageData, NSString *filePath,CGImageRef tpImage) {
        if ([filePath isEqualToString:path]) {
            [self.imageBtn setImage:imageData forState:UIControlStateNormal];
        }
    }];
    
    [[ZacharyPlayManager sharedInstance] reloadVideo:^(NSString *filePath) {
        MAIN(^{
            if ([filePath isEqualToString:path]) {
                [weakSelf reloadStart];
            }
        });
    } withFile:path];
}

-(void)stopVideo {
    _topBtn.hidden = NO;
    [[ZacharyPlayManager sharedInstance] cancelVideo:[[ANVideoManager shareManager] videoPathForMP4:self.modelFrame.msgModel.mediaPath]];
}

-(void)dealloc {
    [[ZacharyPlayManager sharedInstance] cancelAllVideo];
}

#pragma mark - Getter

- (UIButton *)imageBtn
{
    if (nil == _imageBtn) {
        _imageBtn = [[UIButton alloc] init];
        [_imageBtn addTarget:self action:@selector(imageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _imageBtn.layer.masksToBounds = YES;
        _imageBtn.layer.cornerRadius = 5;
        _imageBtn.clipsToBounds = YES;
    }
    return _imageBtn;
}

- (UIButton *)topBtn
{
    if (!_topBtn) {
        _topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_topBtn addTarget:self action:@selector(firstPlay) forControlEvents:UIControlEventTouchUpInside];
        _topBtn.layer.masksToBounds = YES;
        _topBtn.layer.cornerRadius = 5;
    }
    return _topBtn;
}
@end
