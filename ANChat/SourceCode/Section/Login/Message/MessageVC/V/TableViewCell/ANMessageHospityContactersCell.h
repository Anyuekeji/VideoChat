//
//  ANMessageHospityContactersCell.h
//  ANChat
//
//  Created by 陈林波 on 2019/7/5.
//  Copyright © 2019 liuyunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ANMessageHospityContactersCell : UITableViewCell

@property (nonatomic, weak, nullable) id <UICollectionViewDelegate> delegate;

@property (nonatomic, weak, nullable) id <UICollectionViewDataSource> dataSource;

@end

NS_ASSUME_NONNULL_END
