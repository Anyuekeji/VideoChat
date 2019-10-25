//
//  LEPopMenuTableViewCell.m
//  ANChat
//
//  Created by liuyunpeng on 2019/7/9.
//  Copyright © 2019 liuyunpeng. All rights reserved.
//

#import "LEPopMenuTableViewCell.h"

@implementation LEPopMenuTableViewCell
-(void)setUp
{
    [super setUp];
    [self configureUI];
    
}
-(void)configureUI
{
    self.contentView.backgroundColor  =[UIColor whiteColor];
    UILabel *titleLable = [UILabel lableWithTextFont:[UIFont systemFontOfSize:DEFAUT_SMALL_FONTSIZE] textColor:RGB(51, 51, 51) textAlignment:NSTextAlignmentCenter numberOfLines:1];
    titleLable.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:titleLable];
    _labText = titleLable;
    
    NSDictionary * _binds = @{@"titleLable":titleLable};
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[titleLable]-0-|" options:0 metrics:nil views:_binds]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[titleLable]-0-|" options:0 metrics:nil views:_binds]];
    
}

@end
