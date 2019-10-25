//
//  AnMessageHistoryPeopleCell.m
//  ANChat
//
//  Created by 陈林波 on 2019/7/8.
//  Copyright © 2019 liuyunpeng. All rights reserved.
//

#import "AnMessageHistoryPeopleCell.h"

#import "UIImage+Extension.h"
@interface AnMessageHistoryPeopleCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *visualEffectView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLbl;

@end

@implementation AnMessageHistoryPeopleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configureUI];
    
}

-(void)configureUI
{
//    [self.imageV setImage:[UIImage gxz_imageWithColor:[UIColor redColor]]];
    self.imageV.layer.cornerRadius = 10;
    self.nickNameLbl.text = @"你好";

    
}

-(void)setIsBlur:(NSNumber *)isBlur
{
    _isBlur = isBlur;
    if (_isBlur.integerValue == 1) {
        _visualEffectView.hidden = NO;
    }
    else
    {
        _visualEffectView.hidden = YES;
        
    }
    
}



@end
