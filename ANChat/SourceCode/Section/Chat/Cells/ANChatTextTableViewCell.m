//
//  ANChatTextTableViewCell.m
//  ANChat
//
//  Created by liuyunpeng on 2019/5/31.
//  Copyright © 2019 liuyunpeng. All rights reserved.
//

#import "ANChatTextTableViewCell.h"

@implementation ANChatTextTableViewCell
-(void)setUp
{
    [super setUp];
    [self configureUI];
}
-(void)configureUI
{
    [self.contentView addSubview:self.chatLabel];
    _chatLabel.urlLinkTapHandler = ^(KILabel *label, NSString *string, NSRange range) {
        [ZWREventsManager sendNotCoveredViewControllerEvent:kEventAYWebViewController parameters:string];
    };
}

#pragma mark - Private Method
- (void)setModelFrame:(ANMsgFrameModel *)modelFrame
{
    if ([modelFrame.msgModel.isSender boolValue]) {
       self.chatLabel.textColor = UIColorFromRGB(0xffffff);
        
    }
    else
    {
        self.chatLabel.textColor = UIColorFromRGB(0x333333);
    }
    [super setModelFrame:modelFrame];
    self.chatLabel.frame = modelFrame.chatLabelF;
    self.chatLabel.text = modelFrame.msgModel.content;

}
- (void)attemptOpenURL:(NSURL *)url
{
    BOOL safariCompatible = [url.scheme isEqualToString:@"http"] || [url.scheme isEqualToString:@"https"];
    if (safariCompatible && [[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警示" message:@"您的链接无效" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark - Getter and Setter
- (KILabel *)chatLabel
{
    if (nil == _chatLabel) {
        _chatLabel = [[KILabel alloc] init];
        _chatLabel.numberOfLines = 0;
        _chatLabel.font = [UIFont systemFontOfSize:DEFAUT_NORMAL_FONTSIZE];
        _chatLabel.textColor = UIColorFromRGB(0xffffff);

    }
    return _chatLabel;
}

@end
