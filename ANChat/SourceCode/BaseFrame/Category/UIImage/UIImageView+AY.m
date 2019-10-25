//
//  UIImageView+AY.m
//  AYNovel
//
//  Created by liuyunpeng on 2019/3/23.
//  Copyright © 2019 liuyunpeng. All rights reserved.
//

#import "UIImageView+AY.h"

@implementation UIImageView (AY)
-(void)addOrRemoveFreeFlag:(BOOL)add
{
    if ([self viewWithTag:12658]) {
        [[self viewWithTag:12658] removeFromSuperview];
    }
    if (add)
    {
        UILabel *freeFlagLable = [UILabel lableWithTextFont:[UIFont systemFontOfSize:10] textColor:RGB(255, 255, 255) textAlignment:NSTextAlignmentCenter numberOfLines:1];
        freeFlagLable.tag = 12658;
        freeFlagLable.backgroundColor =RGB(255, 59, 98);
        [self addSubview:freeFlagLable];
        freeFlagLable.text = AYLocalizedString(@"免费");
        freeFlagLable.frame = CGRectMake(-31, 8, 100, 20);
        freeFlagLable.transform =CGAffineTransformMakeRotation (-M_PI_4);
    }
}

//增加阴影
-(void)addOrRemoveShowdow:(BOOL)add
{
    if (add) {
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 0.7f;
        self.layer.shadowRadius = 4.0f;
        self.layer.shadowOffset = CGSizeMake(4,4);
    }
    else
    {
        self.layer.shadowColor = [UIColor clearColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0,0);
        self.layer.shadowOpacity = 0.0f;
        self.layer.shadowRadius = 4.0f;
    }

}
-(void)addCornorsWithValue:(CGFloat)cornorsValue
{
    self.clipsToBounds = YES;
    self.layer.cornerRadius = cornorsValue;
}
-(void)addImageWithName:(NSString*)imageName
{
    UIImage *centerImage =LEImage(imageName);
    UIImageView *centerImageView = [[UIImageView alloc] initWithImage:centerImage];
    centerImageView.contentMode = UIViewContentModeScaleAspectFill;
    centerImageView.clipsToBounds = YES;
    centerImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:centerImageView];
    
    CGFloat imageWidth = centerImage.size.width;
    CGFloat imageHeight =centerImage.size.height;
    
   [self addConstraint:[NSLayoutConstraint constraintWithItem:centerImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:imageHeight]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:centerImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:imageWidth]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:centerImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:centerImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0]];
}

@end
