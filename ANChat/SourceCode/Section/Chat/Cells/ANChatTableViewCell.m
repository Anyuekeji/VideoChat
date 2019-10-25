//
//  ANChatTableViewCell.m
//  ANChat
//
//  Created by liuyunpeng on 2019/5/30.
//  Copyright © 2019 liuyunpeng. All rights reserved.
//

#import "ANChatTableViewCell.h"
#import "ANChatMessageModel.h"

#define  HEAD_IMAGE_SIZE 50
#define  ARRAY_WIDTH 7  // 气泡箭头
#define  Bubble_Padding 10  //
#define  Cell_Padding 15  //

@interface ANChatTableViewCell()
// 头像
@property (nonatomic, strong) UIImageView *headImageView;
// 内容气泡视图
@property (nonatomic, strong) UIImageView *bubbleView;
// 菊花视图所在的view
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
// 重新发送
@property (nonatomic, strong) UIButton *retryButton;
@property (nonatomic, strong) ANChatMessageModel *msgModel;
@end
@implementation ANChatTableViewCell

-(void)setUp
{
    [super setUp];
    [self configureUI];
    [self layoutUI];
}
-(void)configureUI
{
    UILongPressGestureRecognizer *longRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressRecognizer:)];
    longRecognizer.minimumPressDuration = 0.5;
    [self addGestureRecognizer:longRecognizer];
    
    _headImageView = [[UIImageView alloc] init];
    _headImageView.translatesAutoresizingMaskIntoConstraints =NO;
    _headImageView.contentMode = UIViewContentModeScaleAspectFill;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headClicked)];
    [_headImageView addGestureRecognizer:tapGes];
    [self.contentView addSubview:_headImageView];
    
    _bubbleView = [[UIImageView alloc] init];
    _bubbleView.translatesAutoresizingMaskIntoConstraints =NO;
    _bubbleView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_bubbleView];
    
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_activityView];
    
    _retryButton = [[UIButton alloc] init];
    [_retryButton setImage:[UIImage imageNamed:@"button_retry_comment"] forState:UIControlStateNormal];
    [_retryButton addTarget:self action:@selector(retryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _retryButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_retryButton];
}
-(void)layoutUI
{
    [self.contentView removeConstraints:self.contentView.constraints];

    NSDictionary * _binds = @{@"headImageView":self.headImageView};
    
    NSDictionary * _metrics = @{@"imgW":@(HEAD_IMAGE_SIZE),@"padding":@(Cell_Padding)};

    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-padding-[headImageView(==imgW)]" options:0 metrics:_metrics views:_binds]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[headImageView(==imgW)]" options:0 metrics:_metrics views:_binds]];

}
#pragma mark - event handle -
- (void)retryButtonClick:(UIButton *)btn {
    if ([self.longPressDelegate respondsToSelector:@selector(reSendMessage:)]) {
        [self.longPressDelegate reSendMessage:self];
    }
}
- (void)headClicked
{
    if ([self.longPressDelegate respondsToSelector:@selector(headImageClicked:)]) {
        [self.longPressDelegate headImageClicked:_msgModel.fromId];
    }
}

#pragma mark - longPress delegate

- (void)longPressRecognizer:(UILongPressGestureRecognizer *)recognizer
{
    if ([self.longPressDelegate respondsToSelector:@selector(longPress:)]) {
        [self.longPressDelegate longPress:recognizer];
    }
}
#pragma mark - public -

-(void)fillCellWithModel:(id)model
{
    if ([model isKindOfClass:ANChatMessageModel.class])
    {
        ANChatMessageModel *msgModel = (ANChatMessageModel*)model;
        self.msgModel = msgModel;
        [self.activityView setHidden:YES];
        self.retryButton.hidden  = YES;
        self.bubbleView.image    = [UIImage imageNamed:@"liaotianbeijing1"];
        [self.headImageView setImage:[UIImage imageNamed:@"mahuateng.jpeg"]];
    }
}

@end


@implementation ANMyChatTableViewCell

-(void)layoutUI
{
    [self.contentView removeConstraints:self.contentView.constraints];
    NSDictionary * _binds = @{@"headImageView":self.headImageView};
    NSDictionary * _metrics = @{@"imgW":@(HEAD_IMAGE_SIZE),@"padding":@(Cell_Padding)};

    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-padding-[headImageView(==imgW)]" options:0 metrics:_metrics views:_binds]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[headImageView(==imgW)]-padding-|" options:0 metrics:_metrics views:_binds]];
}
-(void)fillCellWithModel:(id)model
{
    if ([model isKindOfClass:ANChatMessageModel.class])
    {
        ANChatMessageModel *msgModel = (ANChatMessageModel*)model;
        self.msgModel = msgModel;
        switch ([msgModel.deliveryState integerValue])
        {
                // 发送状态
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
        if ([msgModel.type integerValue] == ANMessageType_File ) {
            self.bubbleView.image = [UIImage imageNamed:@"liaotianfile"];
        } else
        {
            self.bubbleView.image = [UIImage imageNamed:@"liaotianbeijing2"];
        }
        [self.headImageView setImage:[UIImage imageNamed:@"mayun.jpg"]];
    }
}

@end

#import "KILabel.h"

@interface ANChatTextTableViewCell()
// 消息文本label
@property (nonatomic, strong) KILabel *msgLable;
;
@end
@implementation ANChatTextTableViewCell
-(void)setUp
{
    [super setUp];
    [self configureUI];
    [self layoutUI];
}
-(void)configureUI
{
    [super configureUI];
    
    _msgLable = [[KILabel alloc] init];
    _msgLable.numberOfLines = 0;
    _msgLable.font = [UIFont systemFontOfSize:DEFAUT_NORMAL_FONTSIZE];
    _msgLable.textColor = UIColorFromRGB(0x282724);
    _msgLable.translatesAutoresizingMaskIntoConstraints = NO;
    _msgLable.preferredMaxLayoutWidth = ScreenWidth-HEAD_IMAGE_SIZE-100;
    [self.contentView addSubview:_msgLable];
    _msgLable.urlLinkTapHandler = ^(KILabel *label, NSString *string, NSRange range) {
        [ZWREventsManager sendNotCoveredViewControllerEvent:kEventAYWebViewController parameters:string];
    };
}
-(void)layoutUI
{
    [super layoutUI];
    NSDictionary * _binds = @{@"bubbleView":self.bubbleView,@"activityView":self.activityView,@"msgLable":self.msgLable,@"retryButton":self.retryButton};
    NSDictionary * _metrics = @{@"originx":@(15+HEAD_IMAGE_SIZE+10),@"textOriginx":@(15+HEAD_IMAGE_SIZE+10+Bubble_Padding),@"padding":@(Cell_Padding),@"textPadding":@(Cell_Padding+Bubble_Padding)};

    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-padding-[bubbleView]-padding-|" options:0 metrics:_metrics views:_binds]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-originx-[bubbleView]-70-|" options:0 metrics:_metrics views:_binds]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-textPadding-[msgLable]-textPadding-|" options:0 metrics:_metrics views:_binds]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-textOriginx-[msgLable]-80-|" options:0 metrics:_metrics views:_binds]];
}
#pragma mark - public -

-(void)fillCellWithModel:(id)model
{
    [super fillCellWithModel:model];
    if ([model isKindOfClass:ANChatMessageModel.class])
    {
        self.msgLable.text  = self.msgModel.content;
    }
}

@end

@interface ANMyChatTextTableViewCell()
// 消息文本label
@property (nonatomic, strong) KILabel *msgLable;
;
@end

@implementation ANMyChatTextTableViewCell
-(void)setUp
{
    [super setUp];
    [self configureUI];
    [self layoutUI];
}
-(void)configureUI
{
    [super configureUI];
    
    _msgLable = [[KILabel alloc] init];
    _msgLable.numberOfLines = 0;
    _msgLable.font = [UIFont systemFontOfSize:DEFAUT_NORMAL_FONTSIZE];
    _msgLable.textColor = UIColorFromRGB(0x282724);
    _msgLable.translatesAutoresizingMaskIntoConstraints = NO;
    _msgLable.preferredMaxLayoutWidth = ScreenWidth-HEAD_IMAGE_SIZE-100;
    [self.contentView addSubview:_msgLable];
    _msgLable.urlLinkTapHandler = ^(KILabel *label, NSString *string, NSRange range) {
        [ZWREventsManager sendNotCoveredViewControllerEvent:kEventAYWebViewController parameters:string];
    };
}
-(void)layoutUI
{
    [super layoutUI];
    
    NSDictionary * _binds = @{@"bubbleView":self.bubbleView,@"activityView":self.activityView,@"msgLable":self.msgLable,@"retryButton":self.retryButton};
    NSDictionary * _metrics = @{@"originx":@(15+HEAD_IMAGE_SIZE+10),@"textOriginx":@(15+HEAD_IMAGE_SIZE+10+Bubble_Padding),@"padding":@(Cell_Padding),@"textPadding":@(Cell_Padding+Bubble_Padding)};
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-padding-[bubbleView]-padding-|" options:0 metrics:_metrics views:_binds]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[activityView(==40)]-10-[bubbleView]-originx-|" options:0 metrics:_metrics views:_binds]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-textPadding-[msgLable]-textPadding-|" options:0 metrics:_metrics views:_binds]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-90-[msgLable]-textOriginx-|" options:0 metrics:_metrics views:_binds]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.retryButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:40.0f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.activityView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:40.0f]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.activityView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];

    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.retryButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:40.0f]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.retryButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.retryButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.activityView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];

}
#pragma mark - public -

-(void)fillCellWithModel:(id)model
{
    [super fillCellWithModel:model];
    if ([model isKindOfClass:ANChatMessageModel.class])
    {
        self.msgLable.text  = self.msgModel.content;
    }
}

@end
