//
//  ANMessageHospityContactersCell.m
//  ANChat
//
//  Created by 陈林波 on 2019/7/5.
//  Copyright © 2019 liuyunpeng. All rights reserved.
//

#import "ANMessageHospityContactersCell.h"



@interface ANMessageHospityContactersCell ()<UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) UICollectionView *collectionView;

@end

@implementation ANMessageHospityContactersCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configureUI];
}

-(void)configureUI
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(100, 140);
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flowLayout];
//    self.collectionView.delegate = self.delegate;
//    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.collectionView registerNib:[UINib nibWithNibName:@"ANMessageHistoryCell" bundle:nil] forCellWithReuseIdentifier:@"ANMessageHistoryCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"AnMessageHistoryPeopleCell" bundle:nil] forCellWithReuseIdentifier:@"AnMessageHistoryPeopleCell"];
    
    [self.contentView addSubview:self.collectionView];
    
    [self.collectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSMutableArray *constranitAry = [[NSMutableArray alloc]init];
    [constranitAry addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_collectionView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_collectionView)]];
    [constranitAry addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_collectionView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_collectionView)]];
    [self addConstraints:constranitAry];
    
}

-(void)setDelegate:(id<UICollectionViewDelegate>)delegate
{
    if (!_collectionView.delegate) {
        _collectionView.delegate = delegate;
    }
}

-(void)setDataSource:(id<UICollectionViewDataSource>)dataSource
{
    if (!_collectionView.dataSource) {
        _collectionView.dataSource = dataSource;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}




@end
