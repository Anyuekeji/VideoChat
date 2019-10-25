//
//  AYUtitle.m
//  AYCartoon
//
//  Created by liuyunpeng on 2019/5/6.
//  Copyright © 2019 liuyunpeng. All rights reserved.
//

#import "AYUtitle.h"
#import "LEKeyChain.h"
#import "ZWDeviceSupport.h"
#import <YYKit/YYKit.h>
#import "ZWCacheHelper.h"
#import <SDImageCache.h>
#import "LESandBoxHelp.h"
#import "LEFileManager.h"
#import "LERMLRealm.h"
#import <StoreKit/StoreKit.h>
#import "WTAuthorizationTool.h"  //获取相机，相册权限

UIKIT_EXTERN BOOL _ZWIsIPhoneXSeries() {
    BOOL iPhoneXSeries = NO;
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return iPhoneXSeries;
    }
    
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            iPhoneXSeries = YES;
        }
    }
    
    return iPhoneXSeries;
}


@implementation AYUtitle
+(NSString*)getDeviceUniqueId
{
    //从本地沙盒取
    NSString *uqid = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUniqueDeviceId];
    
    if (!uqid) {
        //从keychain取
        uqid = (NSString *)[LEKeyChain readObjectForKey:kUserDefaultUniqueDeviceId];
        
        if (uqid) {
            [[NSUserDefaults standardUserDefaults] setObject:uqid forKey:kUserDefaultUniqueDeviceId];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        } else {
            //从pasteboard取
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            id data = [pasteboard dataForPasteboardType:kUserDefaultUniqueDeviceId];
            if (data) {
                uqid = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            }
            if (uqid) {
                [[NSUserDefaults standardUserDefaults] setObject:uqid forKey:kUserDefaultUniqueDeviceId];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [LEKeyChain saveObject:uqid forKey:kUserDefaultUniqueDeviceId];
            } else {
                //获取idfa
                uqid = [ZWDeviceSupport idfaString];
                //idfa获取失败的情况，获取idfv
                if (!uqid || [uqid isEqualToString:@"00000000-0000-0000-0000-000000000000"]) {
                    //idfv获取失败的情况，获取uuid
                    uqid = [ZWDeviceSupport deviceUUID];
                }
                [[NSUserDefaults standardUserDefaults] setObject:uqid forKey:kUserDefaultUniqueDeviceId];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [LEKeyChain saveObject:uqid forKey:kUserDefaultUniqueDeviceId];
                
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                NSData *data = [uqid dataUsingEncoding:NSUTF8StringEncoding];
                [pasteboard setData:data forPasteboardType:kUserDefaultUniqueDeviceId];
                
            }
        }
    }
    return uqid;
}

+(void)showChargeView:(void(^)(void)) completeBlock
{
    [ZWREventsManager sendViewControlleWithCallBackEvent:kEventAYChargeViewController parameters:@(YES) animated:YES callBack:^(id obj) {
            if (completeBlock) {
                completeBlock();
            }
        }];

}

//返回16位大小写字母和数字
+(NSString *)return16LetterAndNumber
{
    //定义一个包含数字，大小写字母的字符串
    NSString * strAll = @"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    //定义一个结果
    NSString * result = [[NSMutableString alloc]initWithCapacity:16];
    for (int i = 0; i < 16; i++)
    {
        //获取随机数
        NSInteger index = arc4random() % (strAll.length-1);
        char tempStr = [strAll characterAtIndex:index];
        result = (NSMutableString *)[result stringByAppendingString:[NSString stringWithFormat:@"%c",tempStr]];
    }
    
    return result;
}
@end

@implementation AYUtitle (Encryption)

+(NSString *)hmacStringUsingAlg:(CCHmacAlgorithm)alg withKey:(NSString *)key  str:(NSData*)str{
    size_t size;
    switch (alg) {
        case kCCHmacAlgMD5: size = CC_MD5_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA1: size = CC_SHA1_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA224: size = CC_SHA224_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA256: size = CC_SHA256_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA384: size = CC_SHA384_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA512: size = CC_SHA512_DIGEST_LENGTH; break;
        default: return nil;
    }
    unsigned char result[size];
    const char *cKey = [key cStringUsingEncoding:NSUTF8StringEncoding];
    CCHmac(alg, cKey, strlen(cKey), str.bytes, str.length, result);
    NSMutableString *hash = [NSMutableString stringWithCapacity:size * 2];
    for (int i = 0; i < size; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }
    return hash;
}

@end

@implementation AYUtitle (AppDeletate)

+ (AppDelegate *)getAppDelegate
{
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

@end

@implementation AYUtitle (NetWork)

+ (BOOL)networkAvailable
{
    return [[ZWNetwork sharedInstance] isNetworkConnected];
}

+ (NSString *)currentReachabilityString {
    return [ZWNetwork currentReachabilityString];
}
@end

@implementation AYUtitle (Ios11)
+(UIEdgeInsets)al_safeAreaInset:(UIView*)view
{
    if (@available(iOS 11.0, *)) {
        return view.safeAreaInsets;
    }
    return UIEdgeInsetsZero;
}
@end
@implementation AYUtitle (FileManager)
+(float)appCacheSize
{
    long long folderSize = 0;
    //数据库大小
    
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    NSArray<NSURL *> *realmFileURLs = @[
                                        config.fileURL,
                                        [config.fileURL URLByAppendingPathExtension:@"lock"],
                                        [config.fileURL URLByAppendingPathExtension:@"note"],
                                        [config.fileURL URLByAppendingPathExtension:@"management"]
                                        ];
    
    for (NSURL *URL in realmFileURLs) {
        folderSize+=[AYUtitle folderSizeAtPath:[URL absoluteString]];
    }
    //小说内容
    NSString *bookDirPath = [[LESandBoxHelp docPath] stringByAppendingPathComponent:@"AYNovel"];
    folderSize +=[AYUtitle folderSizeAtPath:bookDirPath];
    //图片缓存
    YYImageCache *cache = [YYWebImageManager sharedManager].cache;
    folderSize +=[AYUtitle folderSizeAtPath:cache.diskCache.path];
    
    
    float sdImageCache = [[SDImageCache sharedImageCache] totalDiskSize]/1000.0f/1000.0f;
    
    folderSize +=sdImageCache;
    
    return folderSize;
    
}
+ (float)folderSizeAtPath:(NSString*)folderPath
{
    return  [LEFileManager sizeAtPath:folderPath];
}

+ (void)cleanCache
{
    
    NSURLCache *urlCache =[NSURLCache sharedURLCache];
    [urlCache removeAllCachedResponses];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    //清空图片缓存
    YYImageCache *cache = [YYWebImageManager sharedManager].cache;
    [cache.memoryCache removeAllObjects];
    [cache.diskCache removeAllObjects];
    
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
    [[SDImageCache sharedImageCache] deleteOldFilesWithCompletionBlock:nil];
    
    [LERMLRealm cleanRealm];
    [ZWCacheHelper deleteAllCatche];
    //删除小说内容缓存
    NSString *bookDirPath = [[LESandBoxHelp docPath] stringByAppendingPathComponent:@"AYNovel"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:bookDirPath error:nil];
}

+ (long long)fileSizeAtPath:(NSString*)filePath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath])
    {
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
@end

@implementation AYUtitle (AppComment)
//弹出评论界面
+ (void)addAppReview
{
    BOOL hasCommentd = [[NSUserDefaults standardUserDefaults] boolForKey:kUserDefaultUserHasAppCommented];
    NSDate *beforeData = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultUserAppCommentedShowTime];
    NSDate *currentDate = [NSDate date];
    NSTimeInterval time = [currentDate timeIntervalSinceDate:beforeData];//秒
    if(((time>2*24*3600) && !hasCommentd) || !beforeData)//两天后提示
    {
        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:AYLocalizedString(@"喜欢マンガpower吗? 给个五星好评吧!") message:nil preferredStyle:UIAlertControllerStyleAlert];
        //跳转APPStore 中应用的撰写评价页面
        UIAlertAction *review = [UIAlertAction actionWithTitle:AYLocalizedString(@"喜欢，我要评论") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                 {
                                     [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUserDefaultUserHasAppCommented];
                                     [[NSUserDefaults standardUserDefaults] synchronize];
                                     
                                     NSURL *appReviewUrl = [NSURL URLWithString:[NSString stringWithFormat: @"itms-apps://itunes.apple.com/app/id%@?action=write-review",@"1440719422"]];
                                     
                                     if (@available(iOS 10.0, *)) {
                                         [[UIApplication sharedApplication] openURL:appReviewUrl options:@{} completionHandler:nil];
                                     }
                                     else
                                     {
                                         [[UIApplication sharedApplication] openURL:appReviewUrl];
                                     }
                                     
                                 }];
        
        [alertVC addAction:review];
        
        //判断系统,是否添加五星好评的入口
        if (@available(iOS 10.3, *)) {
            if([SKStoreReviewController respondsToSelector:@selector(requestReview)]){
                UIAlertAction *fiveStar = [UIAlertAction actionWithTitle:AYLocalizedString(@"喜欢，五星好评") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUserDefaultUserHasAppCommented];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [[UIApplication sharedApplication].keyWindow endEditing:YES];
                    //  五星好评
                    [SKStoreReviewController requestReview];
                    
                }];
                [alertVC addAction:fiveStar];
            }
        } else {
        }
        //去反馈
        UIAlertAction *notLikeReview = [UIAlertAction actionWithTitle:AYLocalizedString(@"不喜欢，我要反馈") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUserDefaultUserHasAppCommented];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [ZWREventsManager sendNotCoveredViewControllerEvent:kEventAYAdverseViewController parameters:nil];
        }];
        [alertVC addAction:notLikeReview];
        //不做任何操作
        UIAlertAction *noReview = [UIAlertAction actionWithTitle:AYLocalizedString(@"用用再说") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [alertVC removeFromParentViewController];
        }];
        [alertVC addAction:noReview];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[[UIApplication sharedApplication]keyWindow] rootViewController] presentViewController:alertVC animated:YES completion:nil];
            [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kUserDefaultUserAppCommentedShowTime];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
        });
    }
}
@end
@implementation AYUtitle (ViewController)
+ (UIViewController*)getParentViewControlerWith:(UIResponder*)responser
{
    UIResponder *nextResponser = [responser nextResponder];
    while (nextResponser) {
        if ([nextResponser isKindOfClass:UIViewController.class])
        {
            return (UIViewController*)nextResponser;
        }
        nextResponser = nextResponser.nextResponder;
    }
    return nil;
}
@end

@implementation AYUtitle (DeviceAuthor)
//设备授权
+ (void)authDeviceType:(ANDeviceType) deviceType obj:(UIResponder*)responser compete: (void(^)(void)) completeBlock failure : (void(^)(NSString * errorString)) failureBlock
{
    if (deviceType == ANDeviceTypeCamera)
    {
        [WTAuthorizationTool requestCameraAuthorization:^(WTAuthorizationStatus status)
        {
            [AYUtitle requestAuthCallback:status response:responser compete:completeBlock failure:failureBlock];
        }];
    }
    else if (deviceType == ANDeviceTypePhoto)
    {
        [WTAuthorizationTool requestImagePickerAuthorization:^(WTAuthorizationStatus status) {
          [AYUtitle requestAuthCallback:status response:responser compete:completeBlock failure:failureBlock];
        }];
    }
}
+ (void)requestAuthCallback:(WTAuthorizationStatus)status response:(UIResponder*)responser compete: (void(^)(void)) completeBlock failure : (void(^)(NSString * errorString)) failureBlock
{
    switch (status) {
        case WTAuthorizationStatusAuthorized:
        {
            if (completeBlock) {
                completeBlock();
            }
        }
            break;
            
        case WTAuthorizationStatusDenied:
        case WTAuthorizationStatusRestricted:
        {
            if (failureBlock) {
                failureBlock(AYLocalizedString(@"用户拒绝"));
            }
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:AYLocalizedString(@"授权失败")
                                                                                     message:AYLocalizedString(@"用户拒绝")
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:AYLocalizedString(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"OK Action");
            }];
            UIAlertAction *settingAction = [UIAlertAction actionWithTitle:AYLocalizedString(@"现在设置") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSURL *settingUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:settingUrl]) {
                    [[UIApplication sharedApplication] openURL:settingUrl];
                }
            }];
            
            [alertController addAction:okAction];
            [alertController addAction:settingAction];
            [[AYUtitle getParentViewControlerWith:responser] presentViewController:alertController animated:YES completion:nil];
        }
            break;
            
        case WTAuthorizationStatusNotSupport:
        {
            if (failureBlock) {
                failureBlock(AYLocalizedString(@"设备不支持"));
            }
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:AYLocalizedString(@"授权失败")
                                                                                     message:AYLocalizedString(@"设备不支持")
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:AYLocalizedString(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"OK Action");
            }];
            [alertController addAction:okAction];
            [[AYUtitle getParentViewControlerWith:responser] presentViewController:alertController animated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
    
}
@end
