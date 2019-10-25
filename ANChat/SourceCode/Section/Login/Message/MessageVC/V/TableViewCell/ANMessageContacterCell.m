//
//  ANMessageContacterCell.m
//  ANChat
//
//  Created by 陈林波 on 2019/7/5.
//  Copyright © 2019 liuyunpeng. All rights reserved.
//

#import "ANMessageContacterCell.h"
#import "UIImage+CircleImage.h"

@interface ANMessageContacterCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (nonatomic,strong) UILabel *badgeLbl;

@end

@implementation ANMessageContacterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self configureUI];
}

-(void)configureUI
{
    
    LEWeakSelf(self)
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *img = [[UIImage imageNamed:@"touxiang_unclick_m"] drawCircleImage];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself.headImage setImage:img] ;
        });
    });
    
    self.badgeLbl = [[UILabel alloc] init];
    self.badgeLbl.backgroundColor = UIColorFromRGB(0xFF28CB);
    [self.headImage addSubview:self.badgeLbl];
    self.badgeLbl.text = @"1";
    [self.badgeLbl setFont:kFont_Medium(12)];
    [self.badgeLbl setTextColor:[UIColor whiteColor]];
    self.badgeLbl.textAlignment = NSTextAlignmentCenter;
    self.badgeLbl.layer.cornerRadius = 9;
    self.badgeLbl.layer.masksToBounds = YES;
    
    
    [self.badgeLbl setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSMutableArray *mutableAry = [[NSMutableArray alloc] init];
    [mutableAry addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_badgeLbl(18)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_badgeLbl)]];
    [mutableAry addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_badgeLbl(18)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_badgeLbl)]];
    
    [self addConstraints:mutableAry];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
