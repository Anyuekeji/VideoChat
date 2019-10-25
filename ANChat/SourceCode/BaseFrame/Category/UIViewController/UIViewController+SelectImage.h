//
//  UIViewController+SelectImage.h
//  CallYou
//
//  Created by allen on 2017/9/13.
//  Copyright © 2017年 李雷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (SelectImage)<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>
//单选图片
-(void)supportSelectImageWithCallBack: (void(^)(UIImage *selectImage)) callBack;
//多选图片
-(void)supportMutableSelectImageWithCallBack: (void(^)(NSArray<UIImage*> *selectImage)) callBack;
@end
