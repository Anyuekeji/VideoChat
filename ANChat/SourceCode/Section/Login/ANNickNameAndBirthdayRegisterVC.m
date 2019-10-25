//
//  ANNickNameAndBirthdayRegisterVC.m
//  Practice
//
//  Created by 陈林波 on 2019/7/2.
//  Copyright © 2019 陈林波. All rights reserved.
//

#import "ANNickNameAndBirthdayRegisterVC.h"
#import <ShareSDK/ShareSDK.h>
#import "BRPickerView.h"
#import "ANGendarRegisterVC.h"
#import "UIViewController+AYNavViewController.h"

@interface ANNickNameAndBirthdayRegisterVC ()
@property (weak, nonatomic) IBOutlet UITextField *nicknameTextField;
@property (weak, nonatomic) IBOutlet UITextField *birthdayTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (nonatomic,strong) NSNumber *nameIdnex;
@property (nonatomic,strong) NSNumber *birthdayIdnex;

@end

@implementation ANNickNameAndBirthdayRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self facebookback];
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
    __weak typeof(self) weakSelf = self;
    [self.nextButton addAction:^(UIButton *btn) {
        ANGendarRegisterVC *vc = [[ANGendarRegisterVC alloc]init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    } forControlEvents:UIControlEventTouchUpInside];

    [self.nicknameTextField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    [self.birthdayTextField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    
//    self.extendedLayoutIncludesOpaqueBars = YES;
    self.edgesForExtendedLayout = UIRectEdgeAll;

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.nicknameTextField.text = @"";
    self.birthdayTextField.text = @"";
}


- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    NSLog(@"%ld,%@",textField.tag,textField.text);
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 0) {
        return YES;
    }
    else
    {
        [self.nicknameTextField endEditing:YES] ;
        __weak typeof(self) weakSelf = self;
        NSDate *minDate = [NSDate br_setYear:1990 month:3 day:12];
        NSDate *maxDate = [NSDate date];
        [BRDatePickerView showDatePickerWithTitle:@"出生日期" dateType:BRDatePickerModeYMD defaultSelValue:weakSelf.birthdayTextField.text minDate:minDate maxDate:maxDate isAutoSelect:YES themeColor:nil resultBlock:^(NSString *selectValue)
        {
            weakSelf.birthdayTextField.text = selectValue;

        } cancelBlock:^{
            NSLog(@"点击了背景或取消按钮");
        }];
        return NO;
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSString *,id> *)change
                      context:(void *)context
{
    UITextField *a = (UITextField *)object;
    if (a.tag == 0) {
        if ([[change valueForKey:@"new"] length] > 0) {
            self.nameIdnex = @(1);
        }
        else
        {
            self.nameIdnex = @(0);
        }
        
    }
    else
    {
        if ([[change valueForKey:@"new"] length] > 0) {
            self.birthdayIdnex = @(1);
        }
        else
        {
            self.birthdayIdnex = @(0);
        }
    }
    
    if (self.nameIdnex.integerValue == 1 && self.birthdayIdnex.integerValue == 1) {
        self.nextButton.userInteractionEnabled = YES;
    }
    else
    {
        self.nextButton.userInteractionEnabled = NO;
    }
}

-(void)dealloc
{
    [self.nicknameTextField removeObserver:self forKeyPath:@"text"];
    [self.birthdayTextField removeObserver:self forKeyPath:@"text"];
    self.nicknameTextField = nil;
    self.birthdayTextField = nil;
}

-(void)facebookback
{
    [ShareSDK getUserInfo:SSDKPlatformTypeFacebook
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             
             NSLog(@"uid=%@",user.uid);
             NSLog(@"%@",user.credential);
             NSLog(@"token=%@",user.credential.token);
             NSLog(@"nickname=%@",user.nickname);
         }
         
         else
         {
             NSLog(@"%@",error);
         }
         
     }];
}





@end
