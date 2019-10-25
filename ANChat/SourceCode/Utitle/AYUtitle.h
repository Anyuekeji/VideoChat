//
//  AYUtitle.h
//  AYCartoon
//
//  Created by liuyunpeng on 2019/5/6.
//  Copyright © 2019 liuyunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSData+CommonCrypto.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonHMAC.h>
#import "AppDelegate.h"


//充值入口类型
typedef NS_ENUM(NSInteger,ANDeviceType) {
    ANDeviceTypeCamera          =   1, //相机授权
    ANDeviceTypePhoto   =   2,//相册授权
};

#define  DEFAUT_READ_FONTSIZE (isIPhone4|| isIPhone5)?18:20

#define  DEFAUT_FONTSIZE (isIPhone4|| isIPhone5)?14:16

#define  DEFAUT_BIG_FONTSIZE (isIPhone4|| isIPhone5)?16:18

#define  DEFAUT_NORMAL_FONTSIZE (isIPhone4|| isIPhone5)?12:14

#define  DEFAUT_NORMAL_BIG_FONTSIZE (isIPhone4|| isIPhone5)?13:15


#define  DEFAUT_SMALL_FONTSIZE  (isIPhone4|| isIPhone5)?11:13

#define  DEFAUT_SMALL_MORE_FONTSIZE (isIPhone4|| isIPhone5)?10:12


#define  SHAREVIEW_TAG 10265 //分享视图的tag

//判断是否是iphonex系列
UIKIT_EXTERN BOOL _ZWIsIPhoneXSeries(void);

//小说和漫画图片的高宽
#define CELL_BOOK_IMAGE_WIDTH ((isIPhone4|| isIPhone5)?(700/2.0f):ScreenWidth)*90.0f/348.0f
//#define CELL_BOOK_WIDTH (ScreenWidth-4*20)/3.0f
#define CELL_BOOK_IMAGE_HEIGHT CELL_BOOK_IMAGE_WIDTH*(12.5f/10.0f)

#define CELL_HORZON_BOOK_IMAGE_WIDTH (ScreenWidth-32)/3.0f
//#define CELL_BOOK_WIDTH (ScreenWidth-4*20)/3.0f
#define CELL_HORZON_BOOK_IMAGE_HEIGHT CELL_HORZON_BOOK_IMAGE_WIDTH*(12.5f/10.0f)

#define  HEADIMAGE_CARTOON_WIDTH CELL_BOOK_IMAGE_WIDTH*1.2f
#define  HEADIMAGE_CARTOON_HEIGHT HEADIMAGE_CARTOON_WIDTH*(12.5f/10.0f)

#define  DEFAUT_PAGE_SIZE 10 //分页 每页条数

#define kDiscvoerVideoPath @"Download/Video"  // video子路径
#define kChatVideoPath @"Chat/Video"  // video子路径
#define kVideoType @".mp4"        // video类型
#define kRecoderType @".wav"


#define kChatRecoderPath @"Chat/Recoder"
#define kRecodAmrType @".amr"

NS_ASSUME_NONNULL_BEGIN

@interface AYUtitle : NSObject
//获取设备的唯一id
+(NSString*)getDeviceUniqueId;
//显示充值视图
+(void)showChargeView:(void(^)(void)) completeBlock;
//返回16位大小写字母和数字
+(NSString *)return16LetterAndNumber;
@end

@interface AYUtitle (Encryption)
+ (NSString *)hmacStringUsingAlg:(CCHmacAlgorithm)alg withKey:(NSString *)key  str:(NSData*)str;
@end

@interface AYUtitle (AppDeletate)

/**
 *  @return 获取appdelegate
 */
+ (AppDelegate *)getAppDelegate;

@end

@interface AYUtitle (NetWork)
/**
 判断当前网络状态是否可用，有网则返回YES，断网则返回NO
 */
+ (BOOL)networkAvailable;

/** 获取当前网络状态的描述 */
+ (NSString *)currentReachabilityString;
@end

@interface AYUtitle (Ios11)

/**
 *  获取安全区域
 *  @param view 视图
 */
+(UIEdgeInsets)al_safeAreaInset:(UIView*)view;

@end

/**
 */
@interface AYUtitle (FileManager)

/**
 *  遍历文件夹获得文件夹大小，返回多少M,计算缓存大小时用到
 *  @param folderPath 文件地址
 *  @return 文件大小
 */
+ (float)folderSizeAtPath:(NSString*)folderPath;

/**
 *  清理缓存
 */
+ (void)cleanCache;
/**
 *  获取app的缓存大小 m
 */
+(float)appCacheSize;


@end

@interface AYUtitle (AppComment)
//弹出评论界面
+ (void)addAppReview;
@end

@interface AYUtitle (ViewController)
//获取uiviewController
+ (UIViewController*)getParentViewControlerWith:(UIResponder*)responser;
@end

@interface AYUtitle (DeviceAuthor)
//设备授权
+ (void)authDeviceType:(ANDeviceType) deviceType obj:(UIResponder*)responser compete: (void(^)(void)) completeBlock failure : (void(^)(NSString * errorString)) failureBlock;
@end
NS_ASSUME_NONNULL_END
