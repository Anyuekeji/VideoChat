//
//  ANRootViewController.m
//  ANChat
//
//  Created by liuyunpeng on 2019/5/29.
//  Copyright © 2019 liuyunpeng. All rights reserved.
//

#import "ANRootViewController.h"
#import "ANHomeViewController.h" //首页
#import "ANChatListViewController.h"//聊天
#import "ANMeViewController.h" //我的
#import "ANContactersVC.h"//消息首页
#import "UITabBarController+LETabBarController.h"
#import "AYNavigationController.h"

@interface ANRootViewController ()<UITabBarControllerDelegate>
{
    UITabBarController * _tabbarController;
}
// current显示控制器
@property (nonatomic, strong) UIViewController * currentViewController;
@end

@implementation ANRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configurateTabBarController];
    [self setUpCurrentChildViewController];
    //  [self changeTabBarSelectedIndex];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(BOOL)shouldShowNavigationBar
{
    return YES;
}
- (BOOL)prefersStatusBarHidden{
    return NO;
}
#pragma mark - init -
+ (UINavigationController *) navigationController {
    AYNavigationController *nav = [[AYNavigationController alloc] initWithRootViewController:[[self alloc] init]];
    nav.navigationBar.barTintColor = UIColorFromRGB(0x9100FF);
    NSDictionary *barButtonTitleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:18.0f],
                                                   NSForegroundColorAttributeName:[UIColor whiteColor]};
    [[UINavigationBar appearance] setTitleTextAttributes:barButtonTitleTextAttributes];
    return nav;
}
- (void) setUpNavigationItem {
    [super setUpNavigationItem];
}
- (void)configurateTabBarController {
   
    //字体
    [UITabBarController setAppearanceTitleFont:[UIFont systemFontOfSize:11] color:UIColorFromRGB(0xfa556c) shadowColor:nil shadowOffset:NANSIZE forState:UIControlStateSelected];
    
    [UITabBarController setAppearanceTitleFont:[UIFont systemFontOfSize:11] color:UIColorFromRGB(0x666666) shadowColor:nil shadowOffset:NANSIZE forState:UIControlStateNormal];
    [UITabBarController setTitlePositionAdjustment:UIOffsetZero];
    
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
}
- (void)setUpCurrentChildViewController {
    [[self tabBarController] didMoveToParentViewController:self];
    [self.view addSubview:_tabbarController.view];
    self.currentViewController = _tabbarController;
    [self setNavigationBarViewStyle:ANNavigationBarViewStylehHome];
}
- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _tabbarController.view.frame = self.view.bounds;
}
#pragma mark - event handle -
-(void)changeTabBarSelectedIndex
{
    [self tabbarController].selectedIndex=1;
}
#pragma mark - getter and setter -

- (UITabBarController *) tabbarController {
    if ( !_tabbarController ) {
        _tabbarController = [[UITabBarController alloc] init];
        _tabbarController.delegate = self;
        _tabbarController.viewControllers =
        @[[ANHomeViewController controller],
          [ANContactersVC controller],
          [ANMeViewController controller],
          ];
        //Tabbar设置
        UITabBar * tabbar = _tabbarController.tabBar;
        tabbar.autoresizesSubviews = YES;
        [_tabbarController setTabBarItemAtIndex:0
                                          title:AYLocalizedString(@"首页")
                                    normalImage:[UIImage imageNamed:@"tab_bookrack"]
                                  selectedImage:[UIImage imageNamed:@"tab_bookrack_select"]];
        
        [_tabbarController setTabBarItemAtIndex:1
                                          title:AYLocalizedString(@"消息")
                                    normalImage:[UIImage imageNamed:@"tab_bookmail"]
                                  selectedImage:[UIImage imageNamed:@"tab_bookmail_select"]];

        [_tabbarController setTabBarItemAtIndex:2
                                          title:AYLocalizedString(@"我的")
                                    normalImage:[UIImage imageNamed:@"tab_my"]
                                  selectedImage:[UIImage imageNamed:@"tab_my_select"]];
        //添加到主体
        [self addChildViewController:_tabbarController];
    }
    return _tabbarController;
}

- (UITabBarController *) tabBarController {
    return [self tabbarController];
}
#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if ( [viewController isKindOfClass:[ANHomeViewController class]] ) {
        [self setNavigationBarViewStyle:ANNavigationBarViewStylehHome];
    } else if ([viewController isKindOfClass:[ANChatListViewController class]])
    {
        [self setNavigationBarViewStyle:ANNavigationBarViewStyleChatlist];
    } else if ( [viewController isKindOfClass:[ANMeViewController class]] )
    {
        [self setNavigationBarViewStyle:ANNavigationBarViewStyleMe];
    }
    return YES;
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    
}
@end
