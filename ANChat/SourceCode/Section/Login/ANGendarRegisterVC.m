//
//  GendarRegisterVC.m
//  Practice
//
//  Created by 陈林波 on 2019/7/2.
//  Copyright © 2019 陈林波. All rights reserved.
//

#import "ANGendarRegisterVC.h"
#import "ANUploadHeadImageVC.h"


@interface ANGendarRegisterVC ()
@property (weak, nonatomic) IBOutlet UIImageView *womanBtn;
@property (weak, nonatomic) IBOutlet UIImageView *manBtn;
@property (weak, nonatomic) IBOutlet UIImageView *womanImageV;
@property (weak, nonatomic) IBOutlet UIImageView *manImageV;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (strong,nonatomic) NSNumber *gendar;

@end

@implementation ANGendarRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initViews];

}

-(void)initViews
{
    UILabel *lbl = [[UILabel alloc] init];
    lbl.text = @"注册";
    lbl.textColor = [UIColor whiteColor];
    [lbl setFont:kFont_Medium(22)];
    self.navigationItem.titleView = lbl;
    
    self.nextButton.userInteractionEnabled = NO;
    self.womanBtn.userInteractionEnabled = YES;
    self.manBtn.userInteractionEnabled = YES;
    
    __weak typeof(self)weakSelf = self;
    [self.womanBtn addTapGesutureRecognizer:^(UITapGestureRecognizer *ges) {
        [weakSelf.womanImageV setImage:[UIImage imageNamed:@"touxiang_false"]];
        [weakSelf.manImageV setImage:[UIImage imageNamed:@"touxiang_unclick_m"]];
        weakSelf.nextButton.userInteractionEnabled = YES;
        [weakSelf.womanBtn setImage:[UIImage imageNamed:@"choose"]];
        [weakSelf.manBtn setImage:[UIImage imageNamed:@"Oval"]];
        weakSelf.gendar = @(0);
    }];
    
    [self.manBtn addTapGesutureRecognizer:^(UITapGestureRecognizer *ges) {
        [weakSelf.womanImageV setImage:[UIImage imageNamed:@"touxiang_unclick_w"]];
        [weakSelf.manImageV setImage:[UIImage imageNamed:@"touxxiang_man"]];
        self.nextButton.userInteractionEnabled = YES;
        weakSelf.gendar = @(1);
        [weakSelf.manBtn setImage:[UIImage imageNamed:@"choose"]];
        [weakSelf.womanBtn setImage:[UIImage imageNamed:@"Oval"]];

    }];
    
    [self.nextButton addAction:^(UIButton *btn) {
        ANUploadHeadImageVC *vc = [[ANUploadHeadImageVC alloc]init];
        vc.gendar = weakSelf.gendar;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
}

@end
