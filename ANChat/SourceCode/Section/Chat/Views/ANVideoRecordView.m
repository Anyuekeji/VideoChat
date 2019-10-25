//
//  ANVideoRecordView.m
//  ANChat
//
//  Created by liuyunpeng on 2019/7/5.
//  Copyright © 2019 liuyunpeng. All rights reserved.
//

#import "ANVideoRecordView.h"
#import "AN_Chat_Config.h"//聊天配置文件
#import "ANVideoManager.h"

#define kDurationTime 10.0

@interface ANVideoRecordView ()
{
    NSDate *_startDate;
    NSDate *_endDate;
}

@property (nonatomic, strong) UIView *videoLayerView;

@property (nonatomic, weak) UILabel *recordBtn;

// 提示label:上移取消
@property (nonatomic, weak) UILabel *promptLabel;

@property (nonatomic, weak) UIView *timeLine;
// 时钟
@property (nonatomic, strong) NSTimer *recordTimer;

@property (nonatomic, copy) NSString *videoName;

@end

@implementation ANVideoRecordView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        [self setupUIwithFrame:frame];
    }
    return self;
}

#pragma mark - UI

- (void)setupUIwithFrame:(CGRect)frame
{
    self.recordBtn.centerX = self.centerX;
    UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:exitBtn];
    exitBtn.frame = CGRectMake(self.width-50, 0, 40, 40);
    exitBtn.centerY= _recordBtn.centerY;

    [exitBtn setTitle:AYLocalizedString(@"取消") forState:UIControlStateNormal];
    [exitBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [exitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [exitBtn addTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];
    
    self.videoLayerView.frame = CGRectMake(0, 10, ScreenWidth,self.recordBtn.top-20-10);
    
    // 占位图片,现写成label
    UILabel *label = [[UILabel alloc] init];
    label.tag = 1001;
    [self.videoLayerView addSubview:label];
    [self addTapGestureRecognizer];
    label.text = AYLocalizedString(@"正在加载...");
    label.frame = CGRectMake(0, 0, ScreenWidth, 25);
    label.textAlignment = NSTextAlignmentCenter;
    label.centerX = _videoLayerView.centerX;
    label.centerY = _videoLayerView.centerY;
    label.textColor = [UIColor whiteColor];
}



#pragma mark - Private Method

- (void)addTapGestureRecognizer
{
    UITapGestureRecognizer *tapTecoginzer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap)];
    tapTecoginzer.numberOfTapsRequired = 1;
    tapTecoginzer.delaysTouchesBegan = YES;
    [self.videoLayerView addGestureRecognizer:tapTecoginzer];
}

- (void)singleTap
{
}

- (void)recordVideoStarted
{
    self.recordBtn.hidden = YES;
    self.timeLine.frame = CGRectMake(0,self.videoLayerView.bottom , ScreenWidth, 1);
    _startDate = [NSDate date];
    self.timeLine.hidden = NO;
    self.promptLabel.hidden = NO;
    [UIView animateWithDuration:kDurationTime animations:^{
       self->_timeLine.frame = CGRectMake(self->_timeLine.centerX, self->_timeLine.top, 0, 1);
    } completion:^(BOOL finished) {
        
    }];
    self.recordTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(recordTimeOver) userInfo:nil repeats:NO];
    self.videoName = [NSString currentName];
    [[ANVideoManager shareManager] startRecordingVideoWithFileName:self.videoName];
}

- (void)recordVideoFinished
{
    _endDate = [NSDate date];
    [self destroyTimer];
    self.promptLabel.hidden = YES;
    NSTimeInterval timeInterval = [_endDate timeIntervalSinceDate:_startDate];
    if ((double)timeInterval <= kDurationTime) { //小于或等于规定时间
        self.recordBtn.hidden = YES; // 录制完了就隐藏,录制页面直接下去
        self.timeLine.hidden = YES;
        [[ANVideoManager shareManager] stopRecordingVideo:^(NSString *path) {
            NSDictionary *userInfo = @{VideoPathKey : path};
            [self routerEventWithName:LERouterEventVideoRecordFinish userInfo:userInfo];
        }];
    } else {
        return;
    }
}

- (void)recordVideoCanceled
{
    // 这里如果以后出问题，就直接让videoView下去
    [self destroyTimer];
    self.timeLine.hidden = YES;
    self.timeLine = nil;
    self.recordBtn.hidden = YES;
    self.promptLabel.hidden = YES;
    LEWeakSelf(self)
    [[ANVideoManager shareManager] stopRecordingVideo:^(NSString *path) {
        LEStrongSelf(self)
        self.recordBtn.hidden = NO;
        // 删除已经录制的文件
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[ANVideoManager shareManager] cancelRecordingVideoWithFileName:self.videoName];
        });
    }];
}

- (void)exit
{
    [self destroyTimer];
    [[ANVideoManager shareManager] exit]; // 防止内存泄露
    [self routerEventWithName:LERouterEventVideoRecordExit userInfo:nil];
}

// 提示信息
- (void)setTimeLineAndPromptView
{
    self.promptLabel.text = @"↑上移取消";
    self.promptLabel.bottom = self.timeLine.bottom-40;
    [self.promptLabel sizeToFit];
    self.promptLabel.center = CGPointMake(self.width*0.5, _promptLabel.centerY);
    self.promptLabel.textColor = [UIColor greenColor];
    self.promptLabel.backgroundColor = [UIColor clearColor];
}

// time is over
- (void)recordTimeOver
{
    self.promptLabel.hidden = YES;
    [self destroyTimer];
    // 结束录制
    [[ANVideoManager shareManager] stopRecordingVideo:^(NSString *path) {
        NSDictionary *userInfo = @{VideoPathKey : path};
        [self routerEventWithName:LERouterEventVideoRecordFinish userInfo:userInfo];
    }];
}

// 销毁定时器
- (void)destroyTimer
{
    [self.recordTimer invalidate];
    self.recordTimer = nil;
}

// 手指相对位置
- (BOOL)touchInButtonWithPoint:(CGPoint)point
{
    CGFloat x = point.x;
    CGFloat y = point.y;
    return (x>=self.recordBtn.left-80&&x<=self.recordBtn.right+50)&&(y<=self.recordBtn.bottom&&y>=self.recordBtn.top);
}

- (void)promptStatuesChanged:(BOOL)status
{
    if (status) {
        self.promptLabel.text = @"↑上移取消";
        self.promptLabel.textColor = [UIColor greenColor];
    } else {
        self.promptLabel.text = @"松开取消录制";
        self.promptLabel.textColor = [UIColor redColor];
    }
    [self.promptLabel sizeToFit];
}

- (BOOL)isMoveToTop:(CGPoint)point
{
    CGFloat y = point.y;
    return y<self.recordBtn.top-10;
}


- (void)dealloc
{
    [self destroyTimer];
    //    [[ICVideoManager shareManager] exit];// 预防直接返回的情况,但是目前还不行
    //    ICLog(@"ICVideoView------dealloc");
}


#pragma mark - touch

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint  point = [touch locationInView:self];
    BOOL touchResult = [self touchInButtonWithPoint:point];
    if (touchResult) {
        [self recordVideoStarted]; // 开始录制
        [self setTimeLineAndPromptView];
        [self promptStatuesChanged:touchResult];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch   = [touches anyObject];
    CGPoint  point   = [touch locationInView:self];
    BOOL isTopStatus = [self isMoveToTop:point];
    [self promptStatuesChanged:!isTopStatus];
    if (isTopStatus) {
        
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint  point = [touch locationInView:self];
    BOOL isTopStatus = [self isMoveToTop:point];
    if (isTopStatus) { // 取消录制
        [self recordVideoCanceled];
    } else { // 结束录制
        [self recordVideoFinished];
    }
}

#pragma mark - Getter

- (UIView *)timeLine
{
    if (!_timeLine) {
        UIView *timeLine = [[UIView alloc] init];
        [self addSubview:timeLine];
        timeLine.backgroundColor = [UIColor greenColor];
        _timeLine = timeLine;
    }
    return _timeLine;
}

- (UILabel *)promptLabel
{
    if (!_promptLabel) {
        UILabel *label = [[UILabel alloc] init];
        [self addSubview:label];
        label.font = [UIFont systemFontOfSize:15];
        _promptLabel = label;
    }
    return _promptLabel;
}

- (UIView *)videoLayerView
{
    if (!_videoLayerView) {
        UIView *videoLayerView = [[UIView alloc] init];
        videoLayerView.backgroundColor = [UIColor blackColor];
        videoLayerView.tag = 1000;
        [self addSubview:videoLayerView];
        _videoLayerView = videoLayerView;
    }
    return _videoLayerView;
}

- (UILabel *)recordBtn
{
    if (!_recordBtn) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height-20-70-64, 70, 70)];
        [self addSubview:label];
        _recordBtn = label;
        _recordBtn.layer.cornerRadius = 70/2.0;
        _recordBtn.layer.masksToBounds = YES;
        _recordBtn.layer.borderWidth = 2;
        _recordBtn.layer.borderColor = [UIColor greenColor].CGColor;
    }
    return _recordBtn;
}



@end
