//
//  TitleHeaderView.m
//  ANChat
//
//  Created by 陈林波 on 2019/7/8.
//  Copyright © 2019 liuyunpeng. All rights reserved.
//

#import "TitleHeaderView.h"

@implementation TitleHeaderView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLbl = [[UILabel alloc] init];
        
        self.titleLbl.textColor = [UIColor blackColor];
//        self.titleLbl.text = @"新朋友";
        self.titleLbl.textColor = [UIColor blackColor];
        self.titleLbl.font = [UIFont systemFontOfSize:30];
        
        [self.contentView addSubview:self.titleLbl];
        [self.titleLbl setTranslatesAutoresizingMaskIntoConstraints:NO];
        NSMutableArray *contrainstAry = [[NSMutableArray alloc] init];
        [contrainstAry addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_titleLbl]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleLbl)]];
        [contrainstAry addObject:[NSLayoutConstraint constraintWithItem:_titleLbl attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
//          [contrainstAry addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_titleLbl]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleLbl)]];
        [self.contentView addConstraints:contrainstAry];
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

@end
