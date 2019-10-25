//
//  ANUserManager.h
//  ANChat
//
//  Created by liuyunpeng on 2019/5/23.
//  Copyright © 2019 liuyunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANMeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ANUserManager : NSObject
/**
 *  当前用户是否已经登陆
 */
+ (BOOL) isUserLogin;

/**
 *  用户对象获取
 */
+ (ANMeModel *) userItem;

/**
 *  当前用户ID｜如果未登录将返回nil
 */
+ (NSString *) userId;

/**
 *  与其他用户id做比较
 */
+ (BOOL) compareWithId : (NSString *) userId;

/**
 *  当前用户id或者空字符串
 */
+ (NSString *) userIdOrEmptyCode;

/**
 *  登录访问记号
 */
+ (NSString *) accessToken;
/**
 *  更新用户token
 */
+ (BOOL) updateUserToken : (NSString *) token;

/**
 *  设置用户对象
 */
+ (BOOL) setUserItemByRecord : (NSDictionary *) record;

/**
 *  设置用户对象
 */
+ (BOOL) setUserItemByItem : (ANMeModel *) model;

/**
 *  保存用户数据对象到磁盘
 */
+ (BOOL) save;

/**
 *  用户登出操作请调用此方法|会取消个推绑定，微博授权和积分重置
 */
+ (void) logout;
@end

NS_ASSUME_NONNULL_END
