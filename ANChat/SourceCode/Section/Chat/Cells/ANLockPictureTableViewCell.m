//
//  ANLockPictureTableViewCell.m
//  ANChat
//
//  Created by liuyunpeng on 2019/7/7.
//  Copyright © 2019 liuyunpeng. All rights reserved.
//

#import "ANLockPictureTableViewCell.h"
#import "UIImageView+AY.h"

@interface ANLockPictureTableViewCell ()
@property (nonatomic, strong) UIImageView *privateImageView; //图片
@property (nonatomic, strong) UILabel *titleLable; //标题
@property (nonatomic, strong) UILabel *introduceLable; //简介
@property (nonatomic, strong) UILabel *actionLable; //查看lable
@property (nonatomic, strong) UIImageView *actionImageView; //查看lable

@end
@implementation ANLockPictureTableViewCell
+ (NSString *) identifier {
    return Msg_TypePriPic;
}
-(void)setUp
{
    [super setUp];
    [self configureUI];
}
-(void)configureUI
{
  self.bubbleView.translatesAutoresizingMaskIntoConstraints = NO;
    self.bubbleView.clipsToBounds = YES;
    self.bubbleView.layer.cornerRadius =5.0f;
    //布局
    NSDictionary * _binds = @{@"bubbleView":self.bubbleView};
     [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[bubbleView]-100-|" options:0 metrics:nil views:_binds]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[bubbleView]-10-|" options:0 metrics:nil views:_binds]];

    
    _titleLable = [UILabel lableWithTextFont:[UIFont systemFontOfSize:DEFAUT_NORMAL_FONTSIZE] textColor:UIColorFromRGB(0x333333) textAlignment:NSTextAlignmentLeft numberOfLines:2];
    _titleLable.preferredMaxLayoutWidth =ScreenWidth-20-100-20;
    _titleLable.translatesAutoresizingMaskIntoConstraints = NO;
    [self.bubbleView addSubview:_titleLable];
    _titleLable.text = AYLocalizedString(@"发来一张隐私照片");
    _introduceLable = [UILabel lableWithTextFont:[UIFont systemFontOfSize:DEFAUT_SMALL_MORE_FONTSIZE] textColor:UIColorFromRGB(0x8d8d8d) textAlignment:NSTextAlignmentLeft numberOfLines:2];
    _introduceLable.preferredMaxLayoutWidth =ScreenWidth-20-100-20;
    _introduceLable.translatesAutoresizingMaskIntoConstraints = NO;
    [self.bubbleView addSubview:_introduceLable];
    _introduceLable.text = AYLocalizedString(@"该消息为隐私消息，只限本人查看");
    
    _privateImageView = [UIImageView new];
    _privateImageView.contentMode = UIViewContentModeScaleAspectFill;
    _privateImageView.clipsToBounds = YES;
    _privateImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.bubbleView addSubview:_privateImageView];
    _privateImageView.layer.cornerRadius = 9.0f;
    _privateImageView.backgroundColor = [UIColor blackColor];
    [self.privateImageView addImageWithName:@"chat_private_pic"];

    UIView *bottomContainView = [UIView new];
    bottomContainView.translatesAutoresizingMaskIntoConstraints = NO;
    bottomContainView.backgroundColor = UIColorFromRGB(0x9100ff);
    [self.bubbleView addSubview:bottomContainView];
    
    UIButton *privateBtn = [UIButton buttonWithType:UIButtonTypeCustom font:[UIFont systemFontOfSize:DEFAUT_SMALL_MORE_FONTSIZE] textColor:[UIColor whiteColor] title:AYLocalizedString(@" 隐私消息") image:LEImage(@"chat_private_flag")];
    privateBtn.frame  = CGRectMake(0, 4, 100, 26);
    [bottomContainView addSubview:privateBtn];
    privateBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [privateBtn setImageEdgeInsets:UIEdgeInsetsMake(7, 7, 7, 7)];

    UILabel *pri_actionLable = [UILabel lableWithTextFont:[UIFont systemFontOfSize:DEFAUT_SMALL_MORE_FONTSIZE] textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentRight numberOfLines:1];
    pri_actionLable.frame = CGRectMake(ScreenWidth-100-23-100, privateBtn.top, 100, privateBtn.height);
    [bottomContainView addSubview:pri_actionLable];
    pri_actionLable.text = AYLocalizedString(@"立即查看");
    _actionLable = pri_actionLable;
    //布局
    _binds = @{@"titleLable":_titleLable, @"introduceLable":_introduceLable, @"privateImageView":_privateImageView, @"bottomContainView":bottomContainView};
    [self.bubbleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[titleLable]-10-|" options:0 metrics:nil views:_binds]];
    [self.bubbleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[introduceLable]-10-|" options:0 metrics:nil views:_binds]];
    [self.bubbleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[privateImageView]-10-|" options:0 metrics:nil views:_binds]];
    [self.bubbleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[bottomContainView]-0-|" options:0 metrics:nil views:_binds]];
   
    [self.bubbleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[titleLable]-2-[introduceLable]-10@999-[privateImageView(==200@999)]-10@999-[bottomContainView(==34@999)]-0-|" options:0 metrics:nil views:_binds]];
}
- (void)setModelFrame:(ANMsgFrameModel *)modelFrame
{
    [super setModelFrame:modelFrame];
}
@end


@implementation ANLockVideoTableViewCell
+ (NSString *) identifier {
    return Msg_TypePriVideo;
}
-(void)setUp
{
    [super setUp];
    [self configureUI];
}
-(void)configureUI
{
    [super configureUI];
    self.titleLable.text  = AYLocalizedString(@"发来一个隐私视频");
    self.actionLable.text = AYLocalizedString(@"立即播放");
    [self.privateImageView addImageWithName:@"play_video"];
}
- (void)setModelFrame:(ANMsgFrameModel *)modelFrame
{
    [super setModelFrame:modelFrame];
}
@end
