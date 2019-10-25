//
//  ANMessageHistoryCell.m
//  ANChat
//
//  Created by 陈林波 on 2019/7/5.
//  Copyright © 2019 liuyunpeng. All rights reserved.
//

#import "ANMessageHistoryCell.h"

@implementation ANMessageHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = UIColorFromRGB(0x9100ff);
    self.layer.cornerRadius = 10;
}

@end
