//
//  ANChatBoxView.m
//  ANChat
//
//  Created by liuyunpeng on 2019/5/31.
//  Copyright © 2019 liuyunpeng. All rights reserved.
//

#import "ANChatBoxView.h"
#import "UIViewController+SelectImage.h"
#import "UITextView+Placeholder.h"
#import "ANVideoManager.h"
#import "ANVideoRecordView.h" //视频录制view
#import "AN_Chat_Config.h"//聊天配置文件
#import <ZLPhotoBrowser/ZLPhotoBrowser.h>//图片选择

@interface ANChatBoxView ()<UITextViewDelegate>
@property(nonatomic,strong) UIView *containTextView; //textView 父视图

@property(nonatomic,strong) UITextView *sentTextView;
@property(nonatomic,strong) UIButton *writeBtn;
@property (nonatomic, assign) CGRect keyboardFrame;
@property(nonatomic,strong) UIButton *videoBtn;
@property(nonatomic,assign) CGFloat btnWidth;
@property(nonatomic,assign) CGFloat contain_old_left;
@property(nonatomic,assign) CGFloat contain_old_width;
@property(nonatomic,assign) CGFloat textView_old_left;
@property(nonatomic,assign) CGFloat textView_old_width;
@property (nonatomic, weak) ANVideoRecordView *videoView; //视频录制视图

@end
@implementation ANChatBoxView

- (id) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self configureUI];
        [self configureNotification];
    }
    return self;
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
-(void)configureUI
{
    self.backgroundColor = [UIColor whiteColor];

    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0.5)];
    [topLine setBackgroundColor:RGB(165, 165, 165)];
    [self addSubview:topLine];

    NSArray *btnImageArray = [NSArray arrayWithObjects:@"video_chat",@"voice_chat",@"send_video",@"send_picture", nil];
    CGFloat btnWidth = 46.0f;
    _btnWidth = btnWidth;
    LEWeakSelf(self)
    [btnImageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *imageBtn  = [self createBtnWithImage:LEImage(btnImageArray[idx]) frame:CGRectMake(10+idx*btnWidth, (self.height-btnWidth)/2.0f, btnWidth, btnWidth)];
        [self addSubview:imageBtn];
        if (idx==0) {
            self.videoBtn = imageBtn;
        }
        
        [imageBtn addAction:^(UIButton *btn) {
            LEStrongSelf(self)
            switch (idx) {
                case 0: //视频聊天
                    
                    break;
                case 1: //语音聊天
                    
                    break;
                case 2: //发送视频
                    [self showVideo];
                    break;
                case 3: //发送图片
                {
                    [self showSelectPhotoview];
      
                }
                    break;
                default:
                    break;
            }
        }];
    }];
    
    _contain_old_left =4*btnWidth+15;
    _contain_old_width =ScreenWidth-_contain_old_left-20;
    
    UIView *textContainView = [[UIView alloc] initWithFrame:CGRectMake(_contain_old_left, 9, _contain_old_width, self.height-18)];
    textContainView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    textContainView.clipsToBounds = YES;
    textContainView.layer.cornerRadius = 16.0f;
    [self addSubview:textContainView];
 
    UIButton *write_btn  = [self createBtnWithImage:LEImage(@"chat_flag") frame:CGRectMake(10, (textContainView.height-14)/2.0f, 14, 14)];
    [textContainView addSubview:write_btn];
    _writeBtn = write_btn;
    _containTextView = textContainView;
    
    _textView_old_left =write_btn.left+10+write_btn.width;
    _textView_old_width =textContainView.width-write_btn.left-10-write_btn.width;
    
    CGFloat textViewHeight  = 49*0.74f;
    _sentTextView = [[UITextView alloc] initWithFrame:CGRectMake(_textView_old_left, (textContainView.height-textViewHeight)/2.0f, _textView_old_width, textViewHeight)];
    [_sentTextView setFont:[UIFont systemFontOfSize:16.0f]];
    [_sentTextView.layer setMasksToBounds:YES];
    [_sentTextView setScrollsToTop:NO];
    [_sentTextView setReturnKeyType:UIReturnKeySend];
    [_sentTextView setDelegate:self];
    _sentTextView.placeholder = AYLocalizedString(@"聊天才显真诚");
    _sentTextView.placeholderLabel.font = [UIFont systemFontOfSize:DEFAUT_SMALL_FONTSIZE];
    _sentTextView.backgroundColor = [UIColor clearColor];
    [textContainView addSubview:_sentTextView];
    

    
}
-(void)configureNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];

}
#pragma mark - UI -

-(UIButton*)createBtnWithImage:(UIImage*)btnImage frame:(CGRect)btnFrame
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:btnImage forState:UIControlStateNormal];
    btn.frame = btnFrame;
    return btn;
}
#pragma mark - photo -
-(void)showSelectPhotoview
{
    ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
   // actionSheet.configuration.allowSelectImage = YES;
    actionSheet.configuration.maxSelectCount =1;
    actionSheet.configuration.allowMixSelect = NO;
    actionSheet.configuration.allowSelectVideo = NO;
    actionSheet.configuration.allowRecordVideo = NO;
    actionSheet.configuration.allowEditImage = YES;
    actionSheet.configuration.showSelectBtn = NO;
    UIViewController *parentCon = (UIViewController*)self.superview.nextResponder;
    actionSheet.configuration.navBarColor = parentCon.navigationController.navigationBar.barTintColor;
   actionSheet.configuration.bottomBtnsNormalTitleColor = parentCon.navigationController.navigationBar.barTintColor;
 actionSheet.configuration.allowSelectOriginal = NO;
 actionSheet.configuration.editAfterSelectThumbnailImage = NO;
    //如果调用的方法没有传sender，则该属性必须提前赋值
    actionSheet.sender = (UIViewController*)self.superview.nextResponder;
    LEWeakSelf(self);
    [actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        if ([images count]>0) {
            LEStrongSelf(self);
            if (self.delegate && [self.delegate respondsToSelector:@selector(chatBox:sendImage:)]) {
                [self.delegate chatBox:self sendImage:images[0]];
            }
        }
    }];
    
    actionSheet.selectImageRequestErrorBlock = ^(NSArray<PHAsset *> * _Nonnull errorAssets, NSArray<NSNumber *> * _Nonnull errorIndex) {
        AYLog(@"图片解析出错的索引为: %@, 对应assets为: %@", errorIndex, errorAssets);
    };
    
    actionSheet.cancleBlock = ^{
        AYLog(@"取消选择图片");
    };
    [actionSheet showPreviewAnimated:YES];


}
#pragma mark - Video -
-(void)showVideo
{
    [AYUtitle authDeviceType:ANDeviceTypeCamera obj:self compete:^{
        [self resignFirstResponder];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            ANVideoRecordView *videoView = [[ANVideoRecordView alloc] initWithFrame:CGRectMake(0, ScreenHeight, SCREEN_WIDTH, videwViewH)];
            [self.superview addSubview:videoView];
            self.videoView = videoView;
            videoView.alpha =0.2;
            [UIView animateWithDuration:0.3 animations:^{
                videoView.alpha =1.0f;
                videoView.top = ScreenHeight-videoView.height+Height_TopBar;
                if (self.delegate && [self.delegate respondsToSelector:@selector(chatBox:didVideoViewAppeared:)]) {
                    [self.delegate chatBox:self didVideoViewAppeared:videoView];
                }
            } completion:^(BOOL finished) { // 状态改变
                // 在这里创建视频设配
                UIView *videoLayerView = [videoView viewWithTag:1000];
                UIView *placeholderView = [videoView viewWithTag:1001];
                [[ANVideoManager shareManager] setVideoPreviewLayer:videoLayerView];
              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [placeholderView removeFromSuperview];
                });
            }];
        });

    } failure:^(NSString * _Nonnull errorString) {
        
    }];
}

#pragma mark - UITextViewDelegate

- (void) textViewDidBeginEditing:(UITextView *)textView
{
}

- (void) textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 5000) { // 限制5000字内
        textView.text = [textView.text substringToIndex:5000];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        if (textView.text.length > 0) {     // send Text
            //            if ([self.textView.text isTrimmingSpace]) {
            ////                [MBProgressHUD showError:@"不能发送空白消息"];
            //            } else {
            [self sendTextMsg];
            //            }
        }
        [textView setText:@""];
        return NO;
    }
    return YES;
}

-(void)sendTextMsg
{
    if (_delegate && [_delegate respondsToSelector:@selector(chatBox:sendTextMessage:)]) {
        [_delegate chatBox:self sendTextMessage:_sentTextView.text];
    }
}
#pragma mark - Public Methods
- (BOOL)resignFirstResponder
{
    [self.sentTextView resignFirstResponder];
    return [super resignFirstResponder];
}
-(void)hideVideoView
{
    if (_delegate && [_delegate respondsToSelector:@selector(chatBox:didChangeChatBoxHeight:)]) {
        [UIView animateWithDuration:0.3 animations:^{
            self.videoView.alpha=0.3;
            self.videoView.top = ScreenHeight;
            [self.delegate chatBox:self didChangeChatBoxHeight:0];
        } completion:^(BOOL finished) {
            [self.videoView removeFromSuperview]; // 移除video视图
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[ANVideoManager shareManager] exit];  // 防止内存泄露
            });
        }];
    }}
#pragma mark - event handle

- (void)keyboardWillHide:(NSNotification *)notification
{
    self.keyboardFrame = CGRectZero;
    NSTimeInterval time = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:time animations:^{
        self.containTextView.left = self.contain_old_left;
        self.containTextView.width = self.contain_old_width;
        self.sentTextView.left = self.textView_old_left;
        self.sentTextView.width = self.textView_old_width;
        self.writeBtn.alpha=1;
        self.videoBtn.alpha = 1;

    }];
    if (_delegate && [_delegate respondsToSelector:@selector(chatBox:didChangeChatBoxHeight:)]) {
        [_delegate chatBox:self didChangeChatBoxHeight:0];
    }
}
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSTimeInterval time = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:time animations:^{
        self.containTextView.left = 20;
        self.containTextView.width = ScreenWidth-40;
        self.sentTextView.left = 10;
        self.sentTextView.width = self.containTextView.width- 20;
        self.writeBtn.alpha=0;
        self.videoBtn.alpha = 0;
    }];
}
- (void)keyboardFrameWillChange:(NSNotification *)notification
{
      self.keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];

    if (_delegate && [_delegate respondsToSelector:@selector(chatBox:didChangeChatBoxHeight:)])
    {
     AYLog(@"keyboardFrameWillChange:%f",self.keyboardFrame.size.height);
        [_delegate chatBox:self didChangeChatBoxHeight:self.keyboardFrame.size.height];
    }
}
@end
