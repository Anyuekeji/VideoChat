//
//  UploadHeadImageVC.m
//  ANChat
//
//  Created by 陈林波 on 2019/7/3.
//  Copyright © 2019 liuyunpeng. All rights reserved.
//

#import "ANUploadHeadImageVC.h"
#import "ANWhatUpVC.h"

@interface ANUploadHeadImageVC ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headImageV;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIImageView *addImage;

@end

@implementation ANUploadHeadImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
}

-(void)initViews
{
    UILabel *lbl = [[UILabel alloc] init];
    lbl.text = @"注册";
    lbl.textColor = [UIColor whiteColor];
    [lbl setFont:kFont_Medium(22)];
    self.navigationItem.titleView = lbl;
    
    self.nextBtn.userInteractionEnabled = NO;
    self.headImageV.userInteractionEnabled = YES;
    if (self.gendar.integerValue == 0)
    {
        [self.headImageV setImage:[UIImage imageNamed:@"unclick_women"]];
    }
    else
    {
        [self.headImageV setImage:[UIImage imageNamed:@"unclick_man"]];
    }
    
    [self.headImageV addTapGesutureRecognizer:^(UITapGestureRecognizer *ges) {
        [self chooseImage];
    }];
    [self.nextBtn addAction:^(UIButton *btn) {
        ANWhatUpVC *vc = [[ANWhatUpVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

-(void)chooseImage
{
    UIActionSheet *sheet;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
    }
    else
    {
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
    }
    sheet.tag = 2;
    [sheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 2) {
        NSUInteger sourceType = 0;
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0:
                    return;
                    break;
                case 1:
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 2:
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
                    
                default:
                    break;
            }
        }
        else
        {
            if (buttonIndex == 0)
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
            
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = self;
            imagePickerController.sourceType = sourceType;
            
            [self presentViewController:imagePickerController animated:YES completion:nil];
            
        }
    }
}

#pragma mark - image picker 的代理方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info
{
    [picker dismissViewControllerAnimated:YES
                               completion:^{
                                   
                               }];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [self.headImageV setImage:image];
    self.addImage.hidden = YES;
    self.nextBtn.userInteractionEnabled = YES;
    [self uploadImage:image];
}

-(void)uploadImage:(UIImage *)image
{
    
}


@end
