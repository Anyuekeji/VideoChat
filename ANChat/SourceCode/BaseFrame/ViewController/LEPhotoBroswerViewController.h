//
//  LEPhotoBroswerViewController.h
//  ANChat
//
//  Created by liuyunpeng on 2019/6/29.
//  Copyright © 2019 liuyunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LEPhotoBroswerViewController : UIViewController
@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong,) UIImageView *imageView;


- (instancetype)initWithImage:(UIImage *)image;
@end

NS_ASSUME_NONNULL_END
