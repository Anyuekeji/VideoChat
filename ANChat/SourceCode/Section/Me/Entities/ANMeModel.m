//
//  ANMeModel.m
//  ANChat
//
//  Created by liuyunpeng on 2019/5/23.
//  Copyright © 2019 liuyunpeng. All rights reserved.
//

#import "ANMeModel.h"

@implementation ANMeModel
+ (NSDictionary<NSString *,id> *)propertyToKeyPair {
    return @{@"myHeadImage"           : @"avater",
             @"myId"           : @"uid",
              @"myToken"           : @"token",
             };
}
@end
