//
//  LoginVC.m
//  Practice
//
//  Created by 陈林波 on 2019/7/2.
//  Copyright © 2019 陈林波. All rights reserved.
//

#import "ANLoginVC.h"

#import "ANNickNameAndBirthdayRegisterVC.h"

#import "UIView+gestureRecognizer.h"
#import <ShareSDK/ShareSDK.h>
#import "AYNavigationController.h"




@interface ANLoginVC ()
@property (weak, nonatomic) IBOutlet UIView *loginView;

@end

@implementation ANLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.loginView addTapGesutureRecognizer:^(UITapGestureRecognizer *ges) {
//        ANNickNameAndBirthdayRegisterVC *vc = [[ANNickNameAndBirthdayRegisterVC alloc]init];
//        [self.navigationController pushViewController:vc animated:YES];
        

//        [ShareSDK authorize:SSDKPlatformTypeFacebook settings:nil onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
//            if (state == SSDKResponseStateSuccess)
//            {
//                NSLog(@"%@",user.rawData);
//                NSLog(@"uid===%@",user.uid);
//                NSLog(@"%@",user.credential);
                ANNickNameAndBirthdayRegisterVC *vc = [[ANNickNameAndBirthdayRegisterVC alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
//            }
//            else if (state == SSDKResponseStateCancel)
//            {
//                NSLog(@"取消");
//            }
//            else if (state == SSDKResponseStateFail)
//            {
//                NSLog(@"%@",error);
//            }
//        }];
        
        
    }];

    
}




-(void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
    [super viewWillAppear:animated];
}

-(void) viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
    [super viewWillDisappear:animated];
}
//-(void) viewWillAppear:(BOOL)animated{
//    [self.navigationControllersetNavigationBarHidden:YES animated:YES]; //设置隐藏
//    [super viewWillAppear:animated];
//}
//
//-(void) viewWillDisappear:(BOOL)animated{
//    [self.navigationControllersetNavigationBarHidden:NO animated:YES]；
//    [super viewWillDisappear:animated];
//}






@end
