//
//  ANAuthorizationVC.m
//  ANChat
//
//  Created by 陈林波 on 2019/7/8.
//  Copyright © 2019 liuyunpeng. All rights reserved.
//

#import "ANAuthorizationVC.h"
#import "ANPresentationVC.h"

@interface ANAuthorizationVC ()
@property (weak, nonatomic) IBOutlet UIView *camare;
@property (weak, nonatomic) IBOutlet UIView *MicrophoneView;
@property (weak, nonatomic) IBOutlet UIView *positionView;
@property (weak, nonatomic) IBOutlet UIView *notificationView;

@end

@implementation ANAuthorizationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.layer.cornerRadius = 10;
    [self configUI];
}

-(void)configUI
{
    self.camare.layer.borderColor = [UIColorFromRGB(0xDDDDDD) CGColor];
    self.MicrophoneView.layer.borderColor = [UIColorFromRGB(0xDDDDDD) CGColor];
    self.positionView.layer.borderColor = [UIColorFromRGB(0xDDDDDD) CGColor];
    self.notificationView.layer.borderColor = [UIColorFromRGB(0xDDDDDD) CGColor];
}

- (void)dealloc
{
    NSLog(@"%@ --> dealloc",[self class]);
}
- (IBAction)clickBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
