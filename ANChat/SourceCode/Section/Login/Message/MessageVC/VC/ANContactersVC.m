//
//  ANContactersVC.m
//  ANChat
//
//  Created by 陈林波 on 2019/7/5.
//  Copyright © 2019 liuyunpeng. All rights reserved.
//

#import "ANContactersVC.h"
#import "LETable.h"

#import "ANMessageContacterCell.h"
#import "ANMessageHospityContactersCell.h"
#import "TitleHeaderView.h"

#import "ANMessageHistoryCell.h"
#import "AnMessageHistoryPeopleCell.h"

#import "FavourMeVC.h"




@interface ANContactersVC ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>


@property (weak, nonatomic) IBOutlet LETable *tableView;
@end

@implementation ANContactersVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureUI];
    [self configureData];
}

-(void)configureUI
{
    [self.tableView registerNib:[UINib nibWithNibName:@"ANMessageContacterCell" bundle:nil] forCellReuseIdentifier:@"ANMessageContacterCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ANMessageHospityContactersCell" bundle:nil] forCellReuseIdentifier:@"ANMessageHospityContactersCell"];
    [self.tableView registerClass:[TitleHeaderView class] forHeaderFooterViewReuseIdentifier:@"TitleHeaderView"];
}

-(void)configureData
{
    
}

#pragma mark - TableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else
    {
        return 20;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ANMessageHospityContactersCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ANMessageHospityContactersCell"];
        cell.delegate = self;
        cell.dataSource = self;
        return cell;
    }
    else
    {
        ANMessageContacterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ANMessageContacterCell"];
        return cell;
    }
   
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    TitleHeaderView *titleHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"TitleHeaderView"];
    if (section == 0) {
       titleHeaderView.titleLbl.text = @"新朋友";
    }
    else
    {
        titleHeaderView.titleLbl.text = @"对话";
    }
    
    
    return titleHeaderView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 84;
}


#pragma mark - UItableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 140;
    }
    else
    {
        return 80;
    }
    
}

#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController pushViewController:[[FavourMeVC alloc] init] animated:YES];

}

#pragma mark- UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        ANMessageHistoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ANMessageHistoryCell" forIndexPath:indexPath];
        return cell;
    }
    else
    {
        AnMessageHistoryPeopleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AnMessageHistoryPeopleCell" forIndexPath:indexPath];
        cell.isBlur = @(0);
        return cell;
    }
    
}



@end
