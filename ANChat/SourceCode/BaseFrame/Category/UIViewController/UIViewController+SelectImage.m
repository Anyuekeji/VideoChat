//
//  UIViewController+SelectImage.m
//  CallYou
//
//  Created by allen on 2017/9/13.
//  Copyright © 2017年 李雷. All rights reserved.
//

#import "UIViewController+SelectImage.h"
#import <objc/runtime.h>
#import <AVFoundation/AVFoundation.h>

static char kCallBackKey;

@implementation UIViewController (SelectImage)
-(void)supportSelectImageWithCallBack: (void(^)(UIImage *selectImage)) callBack
{
    objc_setAssociatedObject(self, &kCallBackKey, callBack,OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    UIActionSheet *action =
            [[UIActionSheet alloc] initWithTitle:nil
                                        delegate:self
                               cancelButtonTitle:nil
                          destructiveButtonTitle:nil
                               otherButtonTitles:@"拍照",
             @"从手机相册选择",
             @"取消",nil];
    [action showInView:self.view];
    
   // void (^block)(void) = objc_getAssociatedObject(self, &kCallBackKey);
}
#pragma mark - Delegate UIActionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *imagePicker = nil;
    if ( [[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"从手机相册选择"] ) {
        
        imagePicker = [[UIImagePickerController alloc] init];
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        
    } else if ( [[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"拍照"] ) {
        
        NSString *mediaType = AVMediaTypeVideo;
        
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        //判断是否开启访问权限
        if ( authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied ) {
            
            //此处需要延迟几秒在弹出，不然这个弹窗会跟着actionSheet一块被回收，就会出现闪的一下就消失的情况
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                occasionalHint(@"无法使用相机,请在iPhone的设置-隐私-相机中允许访问相机");
            });
            
            return;
        }
        if ( ![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ) {
            occasionalHint(@"照相机不可用");
            return;
        }
        
        imagePicker = [[UIImagePickerController alloc] init];
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    } else {
        return;
    }
    
   // [imagePicker setAllowsEditing:YES];
    [imagePicker setDelegate:self];
    imagePicker.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
}
#pragma mark - Delegate UIImagePickerView
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];

    void (^block)() = objc_getAssociatedObject(self, &kCallBackKey);
    block(image);

}
@end
