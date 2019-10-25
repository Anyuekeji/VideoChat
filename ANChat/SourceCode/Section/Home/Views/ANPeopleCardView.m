//
//  ANPeopleCardView.m
//  ANChat
//
//  Created by liuyunpeng on 2019/5/29.
//  Copyright © 2019 liuyunpeng. All rights reserved.
//

#import "ANPeopleCardView.h"
@interface ANPeopleCardView ()
// current显示控制器
@property (nonatomic, strong) UIImageView * headImageview;
@property (nonatomic, strong) UIButton * refreshBtn;
@property (nonatomic, strong) UIButton * giftBtn;
@property (nonatomic, strong) UIButton *  lightningBtn;
@property (nonatomic, strong) UIButton * chatBtn;
@property (nonatomic, strong) UILabel * nameLable;
@property (nonatomic, strong) UILabel * ageLable;

@end
@implementation ANPeopleCardView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self configureUI];
    }
    return self;
}
-(void)configureUI
{
   _headImageview = [UIImageView new];
  //  _headImageview.contentMode = UIViewContentModeScaleAspectFill;
    _headImageview.clipsToBounds = YES; _headImageview.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_headImageview];
    _headImageview.image = LEImage(@"head_defalut");
    self.refreshBtn = [self createBtn:@"test_icon"];
    [self addSubview:_refreshBtn];
    self.giftBtn = [self createBtn:@"test_icon"];
    [self addSubview:self.giftBtn];
    self.lightningBtn = [self createBtn:@"test_icon"];
    [self addSubview:_lightningBtn];
    self.chatBtn = [self createBtn:@"test_icon"];
    [self addSubview:_chatBtn];
    
    _nameLable  = [UILabel lableWithTextFont:[UIFont systemFontOfSize:DEFAUT_FONTSIZE] textColor:UIColorFromRGB(0x000000) textAlignment:NSTextAlignmentCenter numberOfLines:1];
    _nameLable.font = [UIFont boldSystemFontOfSize:DEFAUT_FONTSIZE];
    _nameLable.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_nameLable];
    
    _nameLable.text = @"jojowwe";
    
    _ageLable  = [UILabel lableWithTextFont:[UIFont systemFontOfSize:DEFAUT_NORMAL_FONTSIZE] textColor:UIColorFromRGB(0xcccccc) textAlignment:NSTextAlignmentCenter numberOfLines:1];
    _ageLable.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_ageLable];
    
    _ageLable.text = @"27岁";
    
    [self layoutUI];
    
}
-(void)layoutUI
{
    NSDictionary * _binds = @{@"headImageview":self.headImageview, @"refreshBtn":self.refreshBtn, @"giftBtn":self.giftBtn, @"lightningBtn":self.lightningBtn, @"chatBtn":self.chatBtn, @"nameLable":self.nameLable, @"ageLable":self.ageLable};
    
    CGFloat btnSmallWidth = 45;
    CGFloat btnBigWidth =60;
    
    
    CGFloat btn_dis = (ScreenWidth - 40 - 2*(btnBigWidth+btnSmallWidth))/5.0f;
    
    CGFloat originx =btn_dis+20;
    CGFloat originy =self.height-105;

    self.refreshBtn.layer.cornerRadius  =btnSmallWidth/2.0f;
    self.giftBtn.layer.cornerRadius  =btnBigWidth/2.0f;
    self.lightningBtn.layer.cornerRadius  =btnBigWidth/2.0f;
    self.chatBtn.layer.cornerRadius  =btnSmallWidth/2.0f;

    NSDictionary * _metrics =  @{@"originx":@(originx),@"originy":@(originy),@"btn_dis":@(btn_dis),@"btnSmallWidth":@(btnSmallWidth),@"btnBigWidth":@(btnBigWidth)};
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.refreshBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.headImageview attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.refreshBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:btnSmallWidth]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.giftBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:btnBigWidth]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.lightningBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:btnBigWidth]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.chatBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:btnSmallWidth]];


    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[headImageview]-0-|" options:0 metrics:_metrics views:_binds]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[headImageview]-105-|" options:0 metrics:_metrics views:_binds]];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-originx-[refreshBtn(==btnSmallWidth@999)]-btn_dis@999-[giftBtn(==btnBigWidth@999)]-btn_dis@999-[lightningBtn(==btnBigWidth@999)]-btn_dis@999-[chatBtn(==btnSmallWidth@999)]-originx-|" options:NSLayoutFormatAlignAllCenterY metrics:_metrics views:_binds]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[nameLable]-20-|" options:0 metrics:_metrics views:_binds]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[ageLable]-20-|" options:0 metrics:_metrics views:_binds]];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-originy-[nameLable]-(==10@999)-[ageLable]-10-|" options:0 metrics:_metrics views:_binds]];
    

}
#pragma mark - getter and setter -
-(UIButton*)createBtn:(NSString*)imageName
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundColor:[UIColor whiteColor]];
    btn.translatesAutoresizingMaskIntoConstraints= NO;
    btn.contentEdgeInsets = UIEdgeInsetsMake(2, 2, 2, 2);
    [btn setBackgroundImage:LEImage(imageName) forState:UIControlStateNormal];
    [btn setBackgroundImage:LEImage(imageName) forState:UIControlStateHighlighted];
    btn.clipsToBounds = YES;
    return btn;
}
@end
