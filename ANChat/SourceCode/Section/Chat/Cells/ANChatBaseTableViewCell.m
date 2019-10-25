//
//  ANChatBaseTableViewCell.m
//  ANChat
//
//  Created by liuyunpeng on 2019/5/30.
//  Copyright © 2019 liuyunpeng. All rights reserved.
//

#import "ANChatBaseTableViewCell.h"
#import "ANChatMessageModel.h"

@implementation ANChatBaseTableViewCell
-(void)setUp
{
    [super setUp];
    [self configureBaseData];
    [self configureBaseUI];
}
-(void)configureBaseData
{
    
    UILongPressGestureRecognizer *longRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressRecognizer:)];
    longRecognizer.minimumPressDuration = 0.5;
    [self addGestureRecognizer:longRecognizer];
}
-(void)configureBaseUI
{
    self.backgroundColor = UIColorFromRGB(0xececec);

    [self.contentView addSubview:self.bubbleView];
    //[self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.activityView];
    [self.contentView addSubview:self.retryButton];
    self.contentView.clipsToBounds = YES;
    self.contentView.layer.cornerRadius = 8.0f;
}
#pragma mark - Getter and Setter

- (UIImageView *)headImageView {
    if (_headImageView == nil) {
        _headImageView = [[UIImageView alloc] init];
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headClicked)];
        [_headImageView addGestureRecognizer:tapGes];
    }
    return _headImageView;
}

- (UIView *)bubbleView {
    if (_bubbleView == nil) {
        _bubbleView = [[UIView alloc] init];
    }
    return _bubbleView;
}

- (UIActivityIndicatorView *)activityView {
    if (_activityView == nil) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return _activityView;
}

- (UIButton *)retryButton {
    if (_retryButton == nil) {
        _retryButton = [[UIButton alloc] init];
        [_retryButton setImage:[UIImage imageNamed:@"button_retry_comment"] forState:UIControlStateNormal];
        [_retryButton addTarget:self action:@selector(retryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _retryButton;
}

#pragma mark - Respond Method

- (void)retryButtonClick:(UIButton *)btn {
    if ([self.longPressDelegate respondsToSelector:@selector(reSendMessage:)]) {
        [self.longPressDelegate reSendMessage:self];
    }
}

- (void)setModelFrame:(ANMsgFrameModel *)modelFrame
{
    _modelFrame = modelFrame;
    
    ANChatMessageModel *messageModel = modelFrame.msgModel;
    self.bubbleView.frame        = modelFrame.bubbleViewF;
    self.bubbleView.layer.cornerRadius = 10.0f;

    if ([messageModel.isSender boolValue]) {    // 发送者
        self.activityView.frame  = modelFrame.activityF;
        self.retryButton.frame   = modelFrame.retryButtonF;
        switch ([messageModel.deliveryState integerValue]) { // 发送状态
            case ANMessageDeliveryState_Delivering:
            {
                [self.activityView setHidden:NO];
                [self.retryButton setHidden:YES];
                [self.activityView startAnimating];
            }
                break;
            case ANMessageDeliveryState_Delivered:
            {
                [self.activityView stopAnimating];
                [self.activityView setHidden:YES];
                [self.retryButton setHidden:YES];
                
            }
                break;
            case ANMessageDeliveryState_Failure:
            {
                [self.activityView stopAnimating];
                [self.activityView setHidden:YES];
                [self.retryButton setHidden:NO];
            }
                break;
            default:
                break;
        }
      
        self.bubbleView.backgroundColor = UIColorFromRGB(0x00bb99);
    } else {    // 接收者
        self.retryButton.hidden  = YES;
        self.bubbleView.backgroundColor = UIColorFromRGB(0xffffff);

    }
}

- (void)headClicked
{
    if ([self.longPressDelegate respondsToSelector:@selector(headImageClicked:)]) {
        [self.longPressDelegate headImageClicked:_modelFrame.msgModel.fromId];
    }
}

#pragma mark - longPress delegate

- (void)longPressRecognizer:(UILongPressGestureRecognizer *)recognizer
{
    if ([self.longPressDelegate respondsToSelector:@selector(longPress:)]) {
        [self.longPressDelegate longPress:recognizer];
    }
}

@end
