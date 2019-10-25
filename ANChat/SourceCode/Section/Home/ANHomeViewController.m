//
//  ANHomeViewController.m
//  ANChat
//
//  Created by liuyunpeng on 2019/5/29.
//  Copyright © 2019 liuyunpeng. All rights reserved.
//

#import "ANHomeViewController.h"
#import "ANPeopleCardView.h"
#import "CCDraggableContainer.h"

@interface ANHomeViewController ()<
CCDraggableContainerDataSource,
CCDraggableContainerDelegate
>
@property (nonatomic, strong) CCDraggableContainer *container;
@property (nonatomic, strong) NSMutableArray *dataSources;

@end

@implementation ANHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureData];
    [self configureUI];
    // Do any additional setup after loading the view.
}

- (void)configureUI {
    // 防止视图变黑
    self.view.backgroundColor = RGB(241, 241, 242);
    self.view.backgroundColor = [UIColor whiteColor];

    // 初始化Container
    self.container = [[CCDraggableContainer alloc] initWithFrame:CGRectMake(10, 10, ScreenWidth-20,ScreenHeight-Height_TopBar-Height_TapBar-30) style:CCDraggableStyleUpOverlay];
    self.container.layer.cornerRadius = 16.0f;
    self.container.clipsToBounds = YES;
    self.container.delegate = self;
    self.container.dataSource = self;
    self.container.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.container];
    // 重启加载
    [self.container reloadData];
}

- (void)configureData {
    
    _dataSources = [NSMutableArray array];
    
    for (int i = 0; i < 9; i++) {
        NSDictionary *dict = @{@"image" : [NSString stringWithFormat:@"image_%d.jpg",i + 1],
                               @"title" : [NSString stringWithFormat:@"Page %d",i + 1]};
        [_dataSources addObject:dict];
    }
}

#pragma mark - CCDraggableContainer DataSource

- (CCDraggableCardView *)draggableContainer:(CCDraggableContainer *)draggableContainer viewForIndex:(NSInteger)index {
    
    ANPeopleCardView *cardView = [[ANPeopleCardView alloc] initWithFrame:draggableContainer.bounds];
    return cardView;
}

- (NSInteger)numberOfIndexs {
    return _dataSources.count;
}

#pragma mark - CCDraggableContainer Delegate

- (void)draggableContainer:(CCDraggableContainer *)draggableContainer draggableDirection:(CCDraggableDirection)draggableDirection widthRatio:(CGFloat)widthRatio heightRatio:(CGFloat)heightRatio {
    
    CGFloat scale = 1 + ((kBoundaryRatio > fabs(widthRatio) ? fabs(widthRatio) : kBoundaryRatio)) / 4;
    if (draggableDirection == CCDraggableDirectionLeft) {
        // self.disLikeButton.transform = CGAffineTransformMakeScale(scale, scale);
    }
    if (draggableDirection == CCDraggableDirectionRight) {
        // self.likeButton.transform = CGAffineTransformMakeScale(scale, scale);
    }
}

- (void)draggableContainer:(CCDraggableContainer *)draggableContainer cardView:(CCDraggableCardView *)cardView didSelectIndex:(NSInteger)didSelectIndex {
    
    [self createChatId];
    NSLog(@"点击了Tag为%ld的Card", (long)didSelectIndex);
}

- (void)draggableContainer:(CCDraggableContainer *)draggableContainer finishedDraggableLastCard:(BOOL)finishedDraggableLastCard {
    
    [draggableContainer reloadData];
}
#pragma mark - net work -
-(void)createChatId
{
    [self showHUD];
    [ZWNetwork post:@"HTTP_Post_ChatId" parameters:nil success:^(id record) {
        [self hideHUD];
        if (record && [record isKindOfClass:NSDictionary.class])
        {
            NSString *chatId = record[@"chatid"];
            [ZWREventsManager sendNotCoveredViewControllerEvent:kEventANChatViewController parameters:chatId];
        }
        
    } failure:^(LEServiceError type, NSError *error) {
        occasionalHint([error localizedDescription]);
        [self hideHUD];
    }];
}
@end
