//
//  WhatUpVC.m
//  ANChat
//
//  Created by 陈林波 on 2019/7/3.
//  Copyright © 2019 liuyunpeng. All rights reserved.
//

#import "ANWhatUpVC.h"

#import "ANAuthorizationVC.h"
#import "ANPresentationVC.h"

@interface ANWhatUpVC ()

@end

@implementation ANWhatUpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    UILabel *lbl = [[UILabel alloc] init];
    lbl.text = @"注册";
    lbl.textColor = [UIColor whiteColor];
    [lbl setFont:kFont_Medium(22)];
    self.navigationItem.titleView = lbl;
}
- (IBAction)clickBtn:(id)sender
{
    [self authorizeAppToUseSomething];
}

-(void)authorizeAppToUseSomething
{
    ANAuthorizationVC *vc = [[ANAuthorizationVC alloc]init];
    ANPresentationVC *present = [[ANPresentationVC alloc]initWithPresentedViewController:vc presentingViewController:self];
    vc.transitioningDelegate = present;
    [self presentViewController:vc animated:YES completion:^{
        
    }];
}



@end
