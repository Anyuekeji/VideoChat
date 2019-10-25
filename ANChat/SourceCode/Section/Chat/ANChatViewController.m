//
//  ANChatViewController.m
//  ANChat
//
//  Created by liuyunpeng on 2019/5/30.
//  Copyright © 2019 liuyunpeng. All rights reserved.
//

#import "ANChatViewController.h"
#import "ANChatBoxView.h"
#import "ANChatTextTableViewCell.h"
#import "ANLockPictureTableViewCell.h" //隐私cell
#import "ANChatVideoUnlockTableViewCell.h"
//正常的视频cell
#import "ANChatViewModle.h"
#import "ANMsgFrameModel.h"
#import "ANMediaManager.h"
#import "ANMessageHelper.h"
#import "LEWebSocket.h"
#import "ANChatManager.h"
#import "UIScrollView+YYAdd.h"
#import "LEFileManager.h"
#import "LEPhotoBroswerViewController.h" //图片显示器
#import "ANChatImageCellTableViewCell.h"
#import "UIViewController+SelectImage.h"
#import "UIImage+Extension.h"
#import "AN_Chat_Config.h"//聊天配置文件
#import "LEArrayPopView.h" //弹出带箭头视图

@interface ANChatViewController ()<ANChatBoxViewDelegate,ANChatBaseTableViewCellDelegate,UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning,LEMenuPopDelegate>
{
    BOOL   _isKeyBoardAppear;     // 键盘是否弹出来了
    
    CGRect _smallRect;
    CGRect _bigRect;
    
    UIMenuItem * _copyMenuItem;
    UIMenuItem * _deleteMenuItem;
    UIMenuItem * _forwardMenuItem;
    UIMenuItem * _recallMenuItem;
    NSIndexPath *_longIndexPath;
}

@property(nonatomic,strong) ANChatBoxView *chatBoxView;
@property (nonatomic, readwrite, strong) ANChatViewModle * viewModel; //数据处理
@property (nonatomic, readwrite, strong) ANMeModel *chatUserModel; //聊天对象model
@property (nonatomic, strong) NSString *chatId; //聊天对象model
@property (nonatomic, strong) UIImageView *presentImageView;
@property (nonatomic, assign)  BOOL presentFlag;  // 是否model出控制器

@end

#define  SECTION_HEAD_HEIGHT 30.0f

@implementation ANChatViewController
-(instancetype)initWithParas:(id)para
{
    self = [super init];
    if (self) {
        _chatId = para;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureUI];
    [self configureNotification];
    [self configureNavigation];
    [self configurateTableView];
    [self configureData];
    // Do any additional setup after loading the view.
}
-(BOOL)shouldShowNavigationBar
{
    return NO;
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
-(void)configureUI
{
    self.view.backgroundColor = UIColorFromRGB(0xececec);

    [self.view addSubview:self.chatBoxView];
    self.tableBottomConstraint.constant = - self.chatBoxView.height;
    [self.tableView setNeedsLayout];
    [self.tableView layoutIfNeeded];//更新tableview的高度
    
    //增加礼物图片
    UIButton *giftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [giftBtn setBackgroundImage:LEImage(@"chat_Gift") forState:UIControlStateNormal];
    [giftBtn setBackgroundImage:LEImage(@"chat_Gift") forState:UIControlStateHighlighted];
    giftBtn.frame = CGRectMake(ScreenWidth-40-25, ScreenHeight-(_ZWIsIPhoneXSeries()?LEIphoneXSafeBottomMargin:0)-self.chatBoxView.height-30-40, 40, 40);
    [self.view addSubview:giftBtn];
    LEWeakSelf(self)
    [giftBtn addAction:^(UIButton *btn) {
       LEStrongSelf(self)
    }];

}
-(void)configureNavigation
{
    CGFloat titleWidth = LETextWidth(self.chatUserModel.myNickName, [UIFont systemFontOfSize:DEFAUT_SMALL_FONTSIZE]);
    CGFloat leftViewWidth = titleWidth+36+10+30+10;
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, Height_TopBar)];
    [navView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:navView];
    self.tableTopConstraint.constant= navView.height;
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, leftViewWidth, navView.height)];
    [navView addSubview:leftView];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, navView.height-0.5f, ScreenWidth, 0.5)];
    [bottomLine setBackgroundColor:RGB(165, 165, 165)];
    [navView addSubview:bottomLine];

    
    UIImageView *backImageViw = [[UIImageView alloc] initWithFrame:CGRectMake(8, STATUS_BAR_HEIGHT+(44-20)/2.0f, 20, 20)];
    [backImageViw setImage:LEImage(@"btn_back_nav")];
    [leftView addSubview:backImageViw];
    
    UIImageView *headImageViw = [[UIImageView alloc] initWithFrame:CGRectMake(36, STATUS_BAR_HEIGHT+(44-30)/2.0f, 30, 30)];
    headImageViw.clipsToBounds = YES;
    headImageViw.layer.cornerRadius = headImageViw.width/2.0f;
    [headImageViw setImage:LEImage(@"test_icon")];
    LEImageSet(headImageViw, self.chatUserModel.myHeadImage, @"test_icon");
    [leftView addSubview:headImageViw];
    
    UILabel *nameLable  = [UILabel lableWithTextFont:[UIFont systemFontOfSize:DEFAUT_SMALL_FONTSIZE] textColor:UIColorFromRGB(0x222222) textAlignment:NSTextAlignmentLeft numberOfLines:1];
    nameLable.text = self.chatUserModel.myNickName?self.chatUserModel.myNickName:@"161w6ef";
    nameLable.frame = CGRectMake(headImageViw.left+headImageViw.width+10, STATUS_BAR_HEIGHT+(44-30)/2.0f, 160, 30);
    [leftView addSubview:nameLable];
    LEWeakSelf(self)
    [leftView addTapGesutureRecognizer:^(UITapGestureRecognizer *ges) {
        LEStrongSelf(self)
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    UIButton *writeActionBtn = [UIButton buttonWithType:UIButtonTypeCustom font:[UIFont boldSystemFontOfSize:DEFAUT_READ_FONTSIZE+5] textColor:UIColorFromRGB(0x222222) title:@"..." image:nil];
    writeActionBtn.frame = CGRectMake(ScreenWidth-10-30, STATUS_BAR_HEIGHT+(44-30)/2.0f-8, 30, 30);
    [writeActionBtn addAction:^(UIButton *btn) {
        LEStrongSelf(self)
        [self showPopMenu];
    }];
    [navView addSubview:writeActionBtn];
}
-(void)configureNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMessage:) name:kNotificationReceiveMsg object:nil];
}
-(void)configureData
{
    self.viewModel = [ANChatViewModle viewModelWithViewController:self];
    //加载本地数据
    [self.viewModel getChatInfoDataByUid:self.chatUserModel.myId complete:^{
        [self.tableView reloadData];
    } failure:^(NSString * _Nonnull errorString) {
        
    }];
}
- (void) configurateTableView
{
  self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[ANChatTextTableViewCell class] forCellReuseIdentifier:Msg_TypeText];
  [self.tableView registerClass:[ANChatImageCellTableViewCell class] forCellReuseIdentifier:Msg_TypePic];
    LERegisterCellForTable([ANLockPictureTableViewCell class], self.tableView);
    LERegisterCellForTable([ANLockVideoTableViewCell class], self.tableView);
        [self.tableView registerClass:[ANChatVideoUnlockTableViewCell
 class] forCellReuseIdentifier:Msg_TypeVideo];

   // self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   //关闭selfSizing功能，会影响reloaddata以后的contentoffset  ios11默认开启
   // self.tableView.estimatedRowHeight = 0;
//    self.tableView.estimatedSectionHeaderHeight = 0;
//    self.tableView.estimatedSectionFooterHeight = 0;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.viewModel numberOfSections];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel numberOfRowsInSection:section];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id obj = [self.viewModel objectForIndexPath:indexPath];
    if (obj && [obj isKindOfClass:ANMsgFrameModel.class])
    {
        ANMsgFrameModel *modelFrame     = (ANMsgFrameModel *)obj;
        NSString *ID                   = modelFrame.msgModel.typeStr;
//        if ([ID isEqualToString:TypeSystem]) {
//            ICChatSystemCell *cell = [ICChatSystemCell cellWithTableView:tableView r eusableId:ID];
//            cell.messageF              = modelFrame;
//            return cell;
//        }
        ANChatBaseTableViewCell *cell    = [tableView dequeueReusableCellWithIdentifier:ID];
        cell.longPressDelegate         = self;
      //  [[ANMediaManager sharedManager] clearReuseImageMessage:cell.modelFrame.msgModel];
        cell.modelFrame  = modelFrame;
        return cell;
        
    }
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
    UIView *sectionHeadView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    sectionHeadView.backgroundColor = UIColorFromRGB(0xececec);
    NSString *sectionTitle = [self.viewModel getIndexPathTitle:[NSIndexPath indexPathForRow:0 inSection:section]];
    UILabel *sectionLable = [UILabel lableWithTextFont:[UIFont systemFontOfSize:DEFAUT_SMALL_FONTSIZE] textColor:UIColorFromRGB(0x999999) textAlignment:NSTextAlignmentCenter numberOfLines:1];
    sectionLable.frame= CGRectMake(0, 0, ScreenWidth, 30);
    sectionLable.text = sectionTitle;
    [sectionLable setBackgroundColor:[UIColor clearColor]];
    [sectionHeadView addSubview:sectionLable];
    return sectionHeadView;
}
#pragma mark - UITableViewDelegate
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ANMsgFrameModel *messageF = [self.viewModel objectForIndexPath:indexPath];
    NSString *cell_ID                   = messageF.msgModel.typeStr;

    if ([cell_ID isEqualToString:Msg_TypePriPic]) {
        CGFloat  cellHeight =LEGetHeightForCellWithObject(ANLockPictureTableViewCell.class, nil,nil);
        return cellHeight;
    }
    else if ([cell_ID isEqualToString:Msg_TypePriVideo]) {
        CGFloat  cellHeight =LEGetHeightForCellWithObject(ANLockVideoTableViewCell.class, nil,nil);
        return cellHeight;
    }
    return messageF.cellHight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SECTION_HEAD_HEIGHT;
}
//- (CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 100;
//}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.chatBoxView resignFirstResponder];
}
//headerview  不悬停
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [super scrollViewDidScroll:scrollView];
    CGFloat sectionHeaderHeight  = SECTION_HEAD_HEIGHT;
    if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

#pragma mark - event handle  -
-(void)handleRightAction
{
    
}
-(void)didReceiveMessage:(id)msg
{
    if([msg isKindOfClass:ANChatMessageModel.class])
    {
        ANChatMessageModel *chatMessageModel  = msg;
        
        if(chatMessageModel && chatMessageModel.content.length>0)
        {
            ANMsgFrameModel *msgFrameModel = [ANMessageHelper createMessageFrame:ANMessageType_Text content:chatMessageModel.content path:nil from:chatMessageModel.fromId to:chatMessageModel.toId fileKey:nil isSender:NO receivedSenderByYourself:NO];
            LEWeakSelf(self)
            [self.viewModel addObject:msgFrameModel complete:^(BOOL newSection) {
                LEStrongSelf(self)
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:[self.viewModel numberOfSections]-1] withRowAnimation:UITableViewRowAnimationFade];
            }];
        }
        
    }
}

#pragma mark - router

// 路由响应
- (void)routerEventWithName:(NSString *)eventName
                   userInfo:(NSDictionary *)userInfo
{
    [super routerEventWithName:eventName userInfo:userInfo];
    ANMsgFrameModel *modelFrame = [userInfo objectForKey:LERouterMessageKey];
    if ([eventName isEqualToString:LERouterEventImageTapEventName]) {
        _smallRect             = [[userInfo objectForKey:@"smallRect"] CGRectValue];
        _bigRect               =  [[userInfo objectForKey:@"bigRect"] CGRectValue];
        NSString *imgPath      = modelFrame.msgModel.mediaPath;
        NSString *orgImgPath = [[ANMediaManager sharedManager] originImgPath:modelFrame];
        if ([LEFileManager isFileExistsAtPath:orgImgPath]) {
            modelFrame.msgModel.mediaPath = orgImgPath;
            imgPath                    = orgImgPath;
        }
        [self showLargeImageWithPath:imgPath withMessageF:modelFrame];
    } else if ([eventName isEqualToString:LERouterEventVoiceTapEventName]) {
        
//        UIImageView *imageView = (UIImageView *)userInfo[VoiceIcon];
//        UIView *redView        = (UIView *)userInfo[RedView];
//        [self chatVoiceTaped:modelFrame voiceIcon:imageView redView:redView];
    }
    if ([eventName isEqualToString:LERouterEventVideoRecordExit]) {
        [self.chatBoxView hideVideoView];
    } else if ([eventName isEqualToString:LERouterEventVideoRecordFinish]) {
        NSString *videoPath = userInfo[VideoPathKey];
        [self.chatBoxView hideVideoView];
        [self chatBox:self.chatBoxView sendVideoMessage:videoPath];
    }
}

#pragma mark - ui  -
-(void)showPopMenu
{
    CGFloat menuWidth = LETextWidth(AYLocalizedString(@"举报用户"), [UIFont systemFontOfSize:DEFAUT_SMALL_FONTSIZE])+20;
    
    LEArrayPopView *popMenu = [[LEArrayPopView alloc] initWithArrow:CGPointMake(self.view.frame.size.width-25, Height_TopBar) menuSize:CGSizeMake(menuWidth, 80) arrowStyle:LEPopMenuArrowTopfooter itemArray:@[AYLocalizedString(@"举报用户"),AYLocalizedString(@"删除用户")]];
    popMenu.menuViewBgColor = [UIColor whiteColor];
    popMenu.alpha = 0.1;
    popMenu.menuDelete= self;
    [popMenu showMenu:YES];
}
// tap image
- (void)showLargeImageWithPath:(NSString *)imgPath
                  withMessageF:(ANMsgFrameModel *)messageF
{
    UIImage *image = [[ANMediaManager sharedManager] imageWithLocalPath:imgPath];
    if (image == nil) {
        AYLog(@"image is not existed");
        return;
    }
    LEPhotoBroswerViewController *photoVC = [[LEPhotoBroswerViewController alloc] initWithImage:image];
    self.presentImageView.image       = image;
    photoVC.transitioningDelegate     = self;
    photoVC.modalPresentationStyle    = UIModalPresentationCustom;
    [self presentViewController:photoVC animated:YES completion:nil];
}
#pragma mark - ANChatBoxViewDelegate -
- (void) chatBox:(ANChatBoxView *)chatBox
       didChangeChatBoxHeight:(CGFloat)height
{
    AYLog(@"didChangeChatBoxHeight:%f",height);
    self.chatBoxView.top = ScreenHeight-(_ZWIsIPhoneXSeries()?LEIphoneXSafeBottomMargin:0)-self.chatBoxView.height-height;
    self.tableBottomConstraint.constant = -(self.chatBoxView.height+height);
    [self.tableView setNeedsLayout];
    [self.tableView layoutIfNeeded];//更新tableview的高度
    AYLog(@"self.table height is :%f",self.tableView.bounds.size.height);
    if (height == 0)
    {
       [self.tableView reloadData];
        _isKeyBoardAppear  = NO;
    }
    else
    {
        [self scrollTableToBottom];
        _isKeyBoardAppear  = YES;
    }
}
- (void)extracted:(ANMsgFrameModel *)msgFrameModel weakself:(ANChatViewController *const __weak)weakself {
    [self.viewModel addObject:msgFrameModel complete:^(BOOL newSection) {
        LEStrongSelf(self)
        [self.tableView reloadData];
        [self scrollTableToBottom];
    }];
}

- (void)chatBox:(ANChatBoxView *_Nullable)chatBox sendTextMessage:(NSString *)textMessage
{
    if(textMessage && textMessage.length>0)
    {
        ANMsgFrameModel *msgFrameModel = [ANMessageHelper createMessageFrame:ANMessageType_Text content:textMessage path:@"" from:[ANUserManager userId] to:self.chatUserModel.myId fileKey:@"" isSender:YES receivedSenderByYourself:NO];
        LEWeakSelf(self)
        [self extracted:msgFrameModel weakself:weakself];
       // [ANChatManager sendDataToServerWithChatId:self.chatId chatModel:msgFrameModel.msgModel];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            ANMsgFrameModel *replay_msgFrameModel = [ANMessageHelper createMessageFrame:ANMessageType_Text content:textMessage path:@"" from:[ANUserManager userId] to:[ANUserManager userId] fileKey:@"" isSender:NO receivedSenderByYourself:NO];
            // 创建本地消息
            [self extracted:replay_msgFrameModel weakself:weakself];
            
        });

    }
}
- (void) chatBox:(ANChatBoxView *)chatBox sendVideoMessage:(NSString *)videoPath
{
    ANMsgFrameModel *msgFrameModel = [ANMessageHelper createMessageFrame:ANMessageType_Video content:@"[视频]" path:videoPath from:[ANUserManager userId] to:self.chatUserModel.myId fileKey:@"" isSender:YES receivedSenderByYourself:NO]; // 创建本地消息
    LEWeakSelf(self)
    [self extracted:msgFrameModel weakself:weakself];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            ANMsgFrameModel *replay_msgFrameModel = [ANMessageHelper createMessageFrame:[[ANUserManager userItem].vip boolValue]?ANMessageType_Video:ANMessageType_Video_Lock content:@"[视频]" path:videoPath from:[ANUserManager userId] to:[ANUserManager userId] fileKey:@"" isSender:NO receivedSenderByYourself:NO]; // 创建本地消息
        [self extracted:replay_msgFrameModel weakself:weakself];

    });

   // [ANChatManager sendDataToServerWithChatId:self.chatId chatModel:msgFrameModel.msgModel];
}

- (void) chatBox:(ANChatBoxView *_Nullable)chatBox
       didVideoViewAppeared:(ANVideoRecordView *_Nullable)videoView
{
    self.tableBottomConstraint.constant = -videwViewH+Height_TopBar;
    [self.tableView setNeedsLayout];
    [self.tableView layoutIfNeeded];//更新tableview的高度
    [self scrollTableToBottom];
}

- (void) chatBox:(ANChatBoxView *_Nullable)chatBox sendImage:(UIImage *_Nullable)sendImage
{
    // 图片压缩后再上传服务器
    // 保存路径
    UIImage *simpleImg = [UIImage simpleImage:sendImage];
    NSString *filePath = [[ANMediaManager sharedManager] saveImage:simpleImg];
    [self sendImageMessageWithImgPath:filePath];
}
- (void)sendImageMessageWithImgPath:(NSString *)imgPath
{
    ANMsgFrameModel *msgFrameModel = [ANMessageHelper createMessageFrame:ANMessageType_Pic content:@"[图片]" path:imgPath from:[ANUserManager userId] to:self.chatUserModel.myId fileKey:@"" isSender:YES receivedSenderByYourself:NO];
    LEWeakSelf(self)
    [self extracted:msgFrameModel weakself:weakself];
  //  [ANChatManager sendDataToServerWithChatId:self.chatId chatModel:msgFrameModel.msgModel];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ANMsgFrameModel *replay_msgFrameModel = [ANMessageHelper createMessageFrame:[[ANUserManager userItem].vip boolValue]?ANMessageType_Pic:ANMessageType_Pic_Lock content:@"[视频]" path:@"" from:[ANUserManager userId] to:[ANUserManager userId] fileKey:@"" isSender:NO receivedSenderByYourself:NO]; // 创建本地消息
        [self extracted:replay_msgFrameModel weakself:weakself];
    });
}
#pragma mark - baseCell delegate

- (void)longPress:(UILongPressGestureRecognizer *)longRecognizer
{
    if (longRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint location       = [longRecognizer locationInView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
        _longIndexPath         = indexPath;
        id object              = [self.viewModel objectForIndexPath:indexPath];
        if (![object isKindOfClass:[ANMsgFrameModel class]]) return;
        ANChatBaseTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [self showMenuViewController:cell.bubbleView andIndexPath:indexPath message:cell.modelFrame];
    }
}
#pragma mark - private
- (void) scrollTableToBottom
{
    
    if (self.tableView.contentSize.height<self.tableView.height) {
        return;
    }
    NSIndexPath *lastIndexPath = [self.viewModel lastIndexPath];
    if (lastIndexPath)
    {

        [self.tableView scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}


#pragma mark - menu -

- (void)showMenuViewController:(UIView *)showInView andIndexPath:(NSIndexPath *)indexPath message:(ANMsgFrameModel *)messageModel
{
    if (_copyMenuItem   == nil) {
        _copyMenuItem   = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyMessage:)];
    }
    if (_deleteMenuItem == nil) {
        _deleteMenuItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteMessage:)];
    }
    if (_forwardMenuItem == nil) {
        _forwardMenuItem = [[UIMenuItem alloc] initWithTitle:@"转发" action:@selector(forwardMessage:)];
    }
    NSInteger currentTime = [ANMessageHelper currentMessageTime];
    NSInteger interval    = currentTime - [messageModel.msgModel.msgDate integerValue];
    if ([messageModel.msgModel.isSender boolValue]) {
        if ((interval/1000) < 5*60 && !([messageModel.msgModel.deliveryState integerValue] == ANMessageDeliveryState_Failure)) {
            if (_recallMenuItem == nil) {
                _recallMenuItem = [[UIMenuItem alloc] initWithTitle:@"撤回" action:@selector(recallMessage:)];
            }
            [[UIMenuController sharedMenuController] setMenuItems:@[_copyMenuItem,_deleteMenuItem,_recallMenuItem,_forwardMenuItem]];
        } else {
            [[UIMenuController sharedMenuController] setMenuItems:@[_copyMenuItem,_deleteMenuItem,_forwardMenuItem]];
        }
    } else {
        [[UIMenuController sharedMenuController] setMenuItems:@[_copyMenuItem,_deleteMenuItem,_forwardMenuItem]];
    }
    [[UIMenuController sharedMenuController] setTargetRect:showInView.frame inView:showInView.superview ];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
}
//- (void)copyMessage:(UIMenuItem *)copyMenuItem
//{
//    UIPasteboard *pasteboard  = [UIPasteboard generalPasteboard];
//    ANMsgFrameModel * messageF = [self.dataSource objectAtIndex:_longIndexPath.row];
//    pasteboard.string         = messageF.model.message.content;
//}
//
//- (void)deleteMessage:(UIMenuItem *)deleteMenuItem
//{
//    // 这里还应该把本地的消息附件删除
//    ICMessageFrame * messageF = [self.dataSource objectAtIndex:_longIndexPath.row];
//    [self statusChanged:messageF];
//}
//
//- (void)recallMessage:(UIMenuItem *)recallMenuItem
//{
//    // 这里应该发送消息撤回的网络请求
//    ANMsgFrameModel * messageF = [self.dataSource objectAtIndex:_longIndexPath.row];
//    [self.dataSource removeObject:messageF];
//
//    ICMessageFrame *msgF = [ICMessageHelper createMessageFrame:TypeSystem content:@"你撤回了一条消息" path:nil from:@"gxz" to:self.group.gId fileKey:nil isSender:YES receivedSenderByYourself:NO];
//    [self.dataSource insertObject:msgF atIndex:_longIndexPath.row];
//    [self.tableView reloadData];
//}
//- (void)forwardMessage:(UIMenuItem *)forwardItem
//{
//    ICLog(@"需要用到的数据库，等添加了数据库再做转发...");
//}
#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.presentFlag = YES;
    return self;
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.presentFlag = NO;
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if (self.presentFlag) {
        UIView *toView              = [transitionContext viewForKey:UITransitionContextToViewKey];
        self.presentImageView.frame = _smallRect;
        [[transitionContext containerView] addSubview:self.presentImageView];
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            self.presentImageView.frame = self->_bigRect;
        } completion:^(BOOL finished) {
            if (finished) {
                [self.presentImageView removeFromSuperview];
                [[transitionContext containerView] addSubview:toView];
                [transitionContext completeTransition:YES];
            }
        }];
    } else {
        LEPhotoBroswerViewController *photoVC = (LEPhotoBroswerViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIImageView *iv     = photoVC.imageView;
        UIView *fromView    = [transitionContext viewForKey:UITransitionContextFromViewKey];
        iv.center = fromView.center;
        [fromView removeFromSuperview];
        [[transitionContext containerView] addSubview:iv];
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            iv.frame = self->_smallRect;
        } completion:^(BOOL finished) {
            if (finished) {
                [iv removeFromSuperview];
                [transitionContext completeTransition:YES];
            }
        }];
    }
}
#pragma mark - LEMenuPopDelegate -
- (void)menuPopView:(LEArrayPopView *_Nullable)popView clickStr:(NSString *_Nullable)itemStr
{
    if ([itemStr isEqualToString:AYLocalizedString(@"举报用户")]) {
        
    }
    else if ([itemStr isEqualToString:AYLocalizedString(@"删除用户")]) {
        
    }
}

#pragma mark - getter and setter -
-(ANChatBoxView*)chatBoxView
{
    if (!_chatBoxView)
    {
        _chatBoxView = [[ANChatBoxView alloc] initWithFrame:CGRectMake(0, ScreenHeight-(_ZWIsIPhoneXSeries()?LEIphoneXSafeBottomMargin:0)-50, ScreenWidth, 50)];
        _chatBoxView.delegate= self;
    }
    return _chatBoxView;
}
- (UIImageView *)presentImageView
{
    if (!_presentImageView) {
        _presentImageView = [[UIImageView alloc] init];
    }
    return _presentImageView;
}
#pragma mark - 页面跳转 -
+ (BOOL) eventAvaliableCheck : (id) parameters
{
    if (parameters && [parameters isKindOfClass:NSString.class]) {
        return YES;
    }
    return NO;
}
+ (id) eventRecievedObjectWithParams : (id) parameters
{
    return [[ANChatViewController alloc] initWithParas:parameters];
}
@end
