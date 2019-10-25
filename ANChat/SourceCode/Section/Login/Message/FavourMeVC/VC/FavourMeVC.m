//
//  FavourMeVC.m
//  ANChat
//
//  Created by 陈林波 on 2019/7/8.
//  Copyright © 2019 liuyunpeng. All rights reserved.
//

#import "FavourMeVC.h"
#import "AnMessageHistoryPeopleCell.h"

@interface FavourMeVC ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;

@end

@implementation FavourMeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(100,140);
    flowLayout.minimumInteritemSpacing = 18;
    flowLayout.minimumLineSpacing = 20;
    flowLayout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor= [UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"AnMessageHistoryPeopleCell" bundle:nil] forCellWithReuseIdentifier:@"AnMessageHistoryPeopleCell"];
    
    [self.view addSubview:self.collectionView];
    
    NSMutableArray *contrainsAry = [[NSMutableArray alloc] init];
    [self.collectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [contrainsAry addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_collectionView]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_collectionView)]];
    [contrainsAry addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_collectionView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_collectionView)]];
    [self.view addConstraints:contrainsAry];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AnMessageHistoryPeopleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AnMessageHistoryPeopleCell" forIndexPath:indexPath];
    cell.isBlur = @(1);
    
    return cell;
}



@end
