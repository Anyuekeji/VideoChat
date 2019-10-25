//
//  UIResponder+LERouter.m
//  ANChat
//
//  Created by liuyunpeng on 2019/6/29.
//  Copyright © 2019 liuyunpeng. All rights reserved.
//

#import "UIResponder+LERouter.h"

@implementation UIResponder (LERouter)
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo
{
    [[self nextResponder] routerEventWithName:eventName userInfo:userInfo];
}
@end
