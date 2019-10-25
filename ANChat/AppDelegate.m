//
//  AppDelegate.m
//  ANChat
//
//  Created by liuyunpeng on 2019/5/23.
//  Copyright © 2019 liuyunpeng. All rights reserved.
//

#import "AppDelegate.h"
#import "ANLoginViewController.h"
#import "ANRootViewController.h"
#import "ANLoginVC.h"
#import "AYNavigationController.h"

#import <ShareSDK/ShareSDK.h>


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];


    [self changeToLoginOrMainViewController:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];

    [ShareSDK registPlatforms:^(SSDKRegister *platformsRegister) {
        [platformsRegister setupFacebookWithAppkey:@"2288795978115782" appSecret:@"016c35bee661c25afd34c232cf61750e" displayName:@"shareSDK"];

    }];
    
    

    return YES;
}

-(void)changeToLoginOrMainViewController:(BOOL)login
{
    if (!login)
    {
        UINavigationController * rootViewController = [ANRootViewController navigationController];
        rootViewController.navigationBar.translucent = NO;
        self.window.rootViewController = rootViewController;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUserDefaultIsLogin];
    }
    else
    {
       
        AYNavigationController *nav = [ANLoginVC navigationController];
        self.window.rootViewController = nav;
        nav.navigationBar.barTintColor = UIColorFromRGB(0x9100FF);
        
      
//        self.window.rootViewController = [[ANLoginViewController alloc] init];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kUserDefaultIsLogin];
        
    }
    [self.window makeKeyAndVisible];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}






@end
