//
//  ANChatViewController.h
//  ANChat
//
//  Created by liuyunpeng on 2019/5/30.
//  Copyright © 2019 liuyunpeng. All rights reserved.
//

#import "LETableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ANChatViewController : LETableViewController<ZWREventsProtocol>
-(instancetype)initWithParas:(id)para;
@end

NS_ASSUME_NONNULL_END
