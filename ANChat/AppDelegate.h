//
//  AppDelegate.h
//  ANChat
//
//  Created by liuyunpeng on 2019/5/23.
//  Copyright © 2019 liuyunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//切换到登录或者主界面状态
-(void)changeToLoginOrMainViewController:(BOOL)login;
@end

