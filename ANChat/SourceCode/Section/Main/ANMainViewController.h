//
//  ANMainViewController.h
//  ANChat
//
//  Created by liuyunpeng on 2019/5/29.
//  Copyright © 2019 liuyunpeng. All rights reserved.
//

#import "LEAFViewController.h"

typedef NS_ENUM(NSInteger, ANNavigationBarViewStyle) {
    ANNavigationBarViewStylehHome         =   1, //首页
    ANNavigationBarViewStyleChatlist   =   2,  //聊天列表
    ANNavigationBarViewStyleMe      =   3, //我的
};

NS_ASSUME_NONNULL_BEGIN

@interface ANMainViewController : LEAFViewController
/**
 导航栏样式设置
 */
@property (nonatomic, assign) ANNavigationBarViewStyle navigationBarViewStyle;
@end

NS_ASSUME_NONNULL_END
