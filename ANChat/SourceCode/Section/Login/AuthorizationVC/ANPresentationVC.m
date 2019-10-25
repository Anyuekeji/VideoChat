//
//  ANPresentationVC.m
//  ANChat
//
//  Created by 陈林波 on 2019/7/8.
//  Copyright © 2019 liuyunpeng. All rights reserved.
//

#import "ANPresentationVC.h"

@interface ANPresentationVC ()<UIViewControllerAnimatedTransitioning>

@property (nonatomic, strong)UIVisualEffectView *visualView;

@end

@implementation ANPresentationVC

#pragma mark - 重写UIPresentationController个别方法

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController
{
    self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
    
    if (self) {
        // 必须设置 presentedViewController 的 modalPresentationStyle
        // 在自定义动画效果的情况下，苹果强烈建议设置为 UIModalPresentationCustom
        presentedViewController.modalPresentationStyle = UIModalPresentationCustom;
    }
    
    return self;
}

- (void)presentationTransitionWillBegin
{
    UIBlurEffect *blur  = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    _visualView = [[UIVisualEffectView alloc]initWithEffect:blur];
    _visualView.frame = [UIScreen mainScreen].bounds;
    _visualView.alpha = 0.4;
    _visualView.backgroundColor = [UIColor blackColor];
    
    [self.containerView addSubview:_visualView];
//    [self. addSubview:_visualView];
}

- (void)presentationTransitionDidEnd:(BOOL)completed
{
    if (!completed) {
        
        [_visualView removeFromSuperview];
        
    }
}

- (void)dismissalTransitionWillBegin
{
    _visualView.alpha = 0.0;
}

- (void)dismissalTransitionDidEnd:(BOOL)completed
{
    if (completed) {
        
        [_visualView removeFromSuperview];
    }
}


- (CGRect)frameOfPresentedViewInContainerView
{
    CGRect containerViewBounds = self.containerView.bounds;
    CGSize presentedViewContentSize = [self sizeForChildContentContainer:self.presentedViewController withParentContainerSize:containerViewBounds.size];
    
    // The presented view extends presentedViewContentSize.height points from
    // the bottom edge of the screen.
    CGRect presentedViewControllerFrame = containerViewBounds;
    presentedViewControllerFrame.size.height = presentedViewContentSize.height;
    presentedViewControllerFrame.origin.y = CGRectGetMaxY(containerViewBounds) - presentedViewContentSize.height;
    return presentedViewControllerFrame;
    
}



#pragma mark - UIViewControllerTransitioningDelegate

- (UIPresentationController* )presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source
{
    return self;
}

// 返回的对象控制Presented时的动画 (开始动画的具体细节负责类)
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self;
}
// 由返回的控制器控制dismissed时的动画 (结束动画的具体细节负责类)
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self;
}

#pragma mark UIViewControllerAnimatedTransitioning具体动画实现
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return [transitionContext isAnimated] ? 0.55 : 0;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // 1.获取源控制器、目标控制器、动画容器View
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    __unused UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = transitionContext.containerView;
    
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    
    [containerView addSubview:toView];  //必须添加到动画容器View上。
    
    // 判断是present 还是 dismiss
    BOOL isPresenting = (fromViewController == self.presentingViewController);
    
    CGFloat screenW = CGRectGetWidth(containerView.bounds);
    CGFloat screenH = CGRectGetHeight(containerView.bounds);
    
    // 左右留35
    // 上下留80
    
    // 屏幕顶部：
//    CGFloat x = 35.f;
    CGFloat x = 53.f;
    CGFloat y = -1 * screenH;
    CGFloat w = screenW - x * 2;
//    CGFloat h = screenH - 80.f * 2;
    CGFloat h = 381.f;
    CGRect topFrame = CGRectMake(x, y, w, h);
    
    // 屏幕中间：
    CGRect centerFrame = CGRectMake(x, 143.0, w, h);
    
    // 屏幕底部
    CGRect bottomFrame = CGRectMake(x, screenH + 10, w, h);  //加10是因为动画果冻效果，会露出屏幕一点
    
    if (isPresenting) {
        toView.frame = topFrame;
    }
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    // duration： 动画时长
    // delay： 决定了动画在延迟多久之后执行
    // damping：速度衰减比例。取值范围0 ~ 1，值越低震动越强
    // velocity：初始化速度，值越高则物品的速度越快
    // UIViewAnimationOptionCurveEaseInOut 加速，后减速
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:0.7f initialSpringVelocity:0.3f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (isPresenting)
            toView.frame = centerFrame;
        else
            fromView.frame = bottomFrame;
    } completion:^(BOOL finished) {
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!wasCancelled];
    }];
}

- (void)animationEnded:(BOOL) transitionCompleted
{
    // 动画结束...
}

@end
