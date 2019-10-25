//
//  LEArrayPopView.m
//  ANChat
//
//  Created by liuyunpeng on 2019/7/9.
//  Copyright © 2019 liuyunpeng. All rights reserved.
//

#import "LEArrayPopView.h"
#import "LEPopMenuTableViewCell.h"


#define distance (self.menuRadius + 3.0f)

@interface LEArrayPopView()<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>

//菜单视图
@property (nonatomic, readwrite, strong)UITableView *menuView;

//箭头位置枚举
@property (nonatomic, assign)LEPopMenuArrowPosition arrowPosition;

//箭头箭尖的坐标
@property (nonatomic, assign)CGPoint arrowPoint;

//菜单视图的大小
@property (nonatomic, assign)CGSize menuSize;

//菜单视图的frame起点坐标
@property (nonatomic, assign)CGPoint origin;

//绘制箭头的layer
@property (nonatomic, strong)CAShapeLayer *shLayer;

//标志位，是否为本文件内部方法调用(区分是否外部改变背景蒙版的backgroundColor和alpha)
@property (nonatomic, assign)BOOL isInsideInvok;

//视图是否已经展示
@property (nonatomic, assign)BOOL isShow;
//视图是否已经展示
@property (nonatomic, strong)NSArray *itemArray;
@end

@implementation LEArrayPopView

//显示菜单
- (void)showMenu:(BOOL)animated
{
    [self computeArrowPosition:_arrowPosition];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [self bringSubviewToFront:window];
    if (animated) {
        self.menuView.transform = CGAffineTransformMakeScale(0.2, 0.2);
        [UIView animateWithDuration:0.2 animations:^{
            self.menuView.transform = CGAffineTransformIdentity;
            self.menuView.alpha = 1.0;
            self.isInsideInvok = YES;
            self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:self.bgAlpha];
        } completion:^(BOOL finished) {
            //动画执行完添加手势，防止动画还未完成又点击了背景
            [self addTap];
            self.isShow = YES;
        }];
    }else{
        self.menuView.alpha = 1.0;
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:self.bgAlpha];
        self.isShow = YES;
    }
}

//关闭菜单
- (void)closeMenu:(BOOL)animated
{
    self.isShow = NO;
    if (animated) {
        [UIView animateWithDuration:0.15 animations:^{
            self.menuView.transform = CGAffineTransformMakeScale(0.3, 0.3);
            self.menuView.alpha = 0.0;
            self.shLayer.opacity = 0.0;
            self.isInsideInvok = YES;
            self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0];
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }else{
        [self removeFromSuperview];
    }
}

- (UITableView *)menuView
{
    if (!_menuView) {
        _menuView = [[UITableView alloc]initWithFrame:CGRectZero];
    }
    return _menuView;
}

- (instancetype)initWithArrow:(CGPoint)point menuSize:(CGSize)size arrowStyle:(LEPopMenuArrowPosition)position
{
    if (self = [super initWithFrame:CGRectZero]) {
        self.arrowPosition = position;
        self.arrowPoint = point;
        self.menuSize = size;
        [self setUpInit];
        [self addSubview:self.menuView];
    }
    return self;
}
- (instancetype)initWithArrow:(CGPoint)point menuSize:(CGSize)size arrowStyle:(LEPopMenuArrowPosition)position itemArray:(NSArray*)itemArray
{
    if (self = [super initWithFrame:CGRectZero]) {
        self.arrowPosition = position;
        self.arrowPoint = point;
        self.menuSize = size;
        [self setUpInit];
        [self addSubview:self.menuView];
        self.menuView.delegate= self;
        self.menuView.dataSource = self;
        if (itemArray)
        {
            _itemArray = [NSArray arrayWithArray:itemArray];
            [self.menuView reloadData];

        }
    }
    return self;
}
//属性和视图初始化设置
- (void)setUpInit
{
    self.bgAlpha = 0.2;
    self.menuViewBgColor = [UIColor whiteColor];
    self.menuRadius = 5.f;
    self.arrowWidth = 15.f;
    self.arrowHeight = 10.f;
    self.cellHeight = 40.f;
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0];
    _menuView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _menuView.showsVerticalScrollIndicator = NO;
    _menuView.scrollEnabled = NO;
    _menuView.alpha = 1.0;
    _menuView.layer.cornerRadius = _menuRadius;
    _menuView.layer.masksToBounds = YES;
    [self.menuView registerClass:[LEPopMenuTableViewCell class] forCellReuseIdentifier:@"LEPopMenuTableViewCell"];

}

//设置菜单视图的frame
- (void)setUpMenuFrame
{
    switch (_arrowPosition) {
        case LEPopMenuArrowTopHeader:
            _origin = CGPointMake(_arrowPoint.x-distance-_arrowWidth*0.5, _arrowPoint.y+_arrowHeight);
            break;
        case LEPopMenuArrowTopCenter:
            _origin = CGPointMake(_arrowPoint.x-_menuSize.width*0.5, _arrowPoint.y+_arrowHeight);
            break;
        case LEPopMenuArrowTopfooter:
            _origin = CGPointMake(_arrowPoint.x+distance+_arrowWidth*0.5-_menuSize.width, _arrowPoint.y+_arrowHeight);
            break;
        case LEPopMenuArrowBottomHeader:
            _origin = CGPointMake(_arrowPoint.x-distance-_arrowWidth*0.5, _arrowPoint.y-_arrowHeight-_menuSize.height);
            break;
        case LEPopMenuArrowBottomCenter:
            _origin = CGPointMake(_arrowPoint.x-_menuSize.width*0.5, _arrowPoint.y-_arrowHeight-_menuSize.height);
            break;
        case LEPopMenuArrowBottomfooter:
            _origin = CGPointMake(_arrowPoint.x+distance+_arrowWidth*0.5-_menuSize.width, _arrowPoint.y-_arrowHeight-_menuSize.height);
            break;
        default:
            
            break;
    }
    self.menuView.frame = CGRectMake(_origin.x, _origin.y, _menuSize.width, _menuSize.height);
}

//背景蒙版单击手势
- (void)addTap
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapEvent)];
    [self addGestureRecognizer:tap];
    tap.delegate = self;
}

- (void)setArrowWidth:(CGFloat)arrowWidth
{
    if (_isShow) return;
    _arrowWidth = arrowWidth;
    [self setUpMenuFrame];
}

- (void) setArrowHeight:(CGFloat)arrowHeight
{
    if (_isShow) return;
    _arrowHeight = arrowHeight;
    [self setUpMenuFrame];
}

//设置菜单圆角
- (void)setMenuRadius:(CGFloat)menuRadius
{
    if (_isShow) return;
    _menuRadius = menuRadius;
    _menuView.layer.cornerRadius = _menuRadius;
    _menuView.layer.masksToBounds = YES;
    [self setUpMenuFrame];
}

//设置菜单背景色
- (void)setMenuViewBgColor:(UIColor *)menuViewBgColor
{
    if (_isShow) return;
    _menuViewBgColor = menuViewBgColor;
    self.menuView.backgroundColor = menuViewBgColor;
}

-(void)setDataSource:(id<UITableViewDataSource>)dataSource
{
    _dataSource = dataSource;
    _menuView.dataSource = dataSource;
}

-(void)setDelegate:(id<UITableViewDelegate>)delegate
{
    _delegate = delegate;
    _menuView.delegate = delegate;
}

//接管蒙版frame设置
-(void)setFrame:(CGRect)frame
{
    if (_isShow) return;
    [super setFrame:[UIScreen mainScreen].bounds];
}

//设置cell高度
-(void)setCellHeight:(CGFloat)cellHeight
{
    if (_isShow) return;
    _cellHeight = cellHeight;
    self.menuView.rowHeight = cellHeight;
}

//接管背景色设置
- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    if (_isShow) return;
    if (!_isInsideInvok) {
        UIColor *color = [[UIColor blackColor]colorWithAlphaComponent:0];
        [super setBackgroundColor:color];
    }else{
        [super setBackgroundColor:backgroundColor];
    }
    _isInsideInvok = NO;
}

//接管透明度设置
-(void)setAlpha:(CGFloat)alpha
{
    if (_isShow) return;
    _bgAlpha = alpha;
}

//设置缩放动画锚点
-(void)setArrowPosition:(LEPopMenuArrowPosition)arrowPosition
{
    _arrowPosition = arrowPosition;
    switch (_arrowPosition) {
        case LEPopMenuArrowTopHeader:
            self.menuView.layer.anchorPoint = CGPointMake(0, 0);
            break;
        case LEPopMenuArrowTopCenter:
            self.menuView.layer.anchorPoint = CGPointMake(0.5, 0);
            break;
        case LEPopMenuArrowTopfooter:
            self.menuView.layer.anchorPoint = CGPointMake(1.0, 0);
            break;
        case LEPopMenuArrowBottomHeader:
            self.menuView.layer.anchorPoint = CGPointMake(0, 1.0);
            break;
        case LEPopMenuArrowBottomCenter:
            self.menuView.layer.anchorPoint = CGPointMake(0.5, 1.0);
            break;
        case LEPopMenuArrowBottomfooter:
            self.menuView.layer.anchorPoint = CGPointMake(1.0, 1.0);
            break;
        default:
            self.menuView.layer.anchorPoint = CGPointMake(1.0, 0);
            break;
    }
}

//根据位置枚举以及箭头高度和宽度计算绘制箭头的点
- (void)computeArrowPosition:(LEPopMenuArrowPosition)arrowPosition
{
    CGRect _menuFrame = _menuView.frame;
    CGFloat menuX = _menuFrame.origin.x;
    CGFloat menuY = _menuFrame.origin.y;
    CGFloat menuWidth = _menuFrame.size.width;
    CGFloat menuHeight = _menuFrame.size.height;
    
    switch (_arrowPosition) {
        case LEPopMenuArrowTopHeader:
        {
            CGPoint origin = CGPointMake(menuX+distance, menuY);
            CGPoint peak = CGPointMake(menuX+_arrowWidth*0.5 +distance, menuY-_arrowHeight);
            CGPoint terminus = CGPointMake(menuX+_arrowWidth+distance, menuY);
            [self drawArrowInLayer:origin peak:peak terminus:terminus];
        }
            
            break;
        case LEPopMenuArrowTopCenter:
        {
            CGPoint origin = CGPointMake(menuX+(menuWidth-_arrowWidth)*0.5, menuY);
            CGPoint peak = CGPointMake(menuX+menuWidth*0.5, menuY-_arrowHeight);
            CGPoint terminus = CGPointMake(menuX+(menuWidth+_arrowWidth)*0.5, menuY);
            [self drawArrowInLayer:origin peak:peak terminus:terminus];
        }
            break;
        case LEPopMenuArrowTopfooter:
        {
            CGPoint origin = CGPointMake(menuX+menuWidth-_arrowWidth-distance, menuY);
            CGPoint peak = CGPointMake(menuX+menuWidth-_arrowWidth*0.5-distance, menuY-_arrowHeight);
            CGPoint terminus = CGPointMake(menuX+menuWidth-distance, menuY);
            [self drawArrowInLayer:origin peak:peak terminus:terminus];
        }
            break;
        case LEPopMenuArrowBottomHeader:
        {
            CGPoint origin = CGPointMake(menuX+distance, menuY+menuHeight);
            CGPoint peak = CGPointMake(menuX+_arrowWidth*0.5+distance, menuY+menuHeight+_arrowHeight);
            CGPoint terminus = CGPointMake(menuX+_arrowWidth+distance, menuY+menuHeight);
            [self drawArrowInLayer:origin peak:peak terminus:terminus];
        }
            break;
        case LEPopMenuArrowBottomCenter:
        {
            CGPoint origin = CGPointMake(menuX+(menuWidth-_arrowWidth)*0.5, menuY+menuHeight);
            CGPoint peak = CGPointMake(menuX+menuWidth*0.5, menuY+menuHeight+_arrowHeight);
            CGPoint terminus = CGPointMake(menuX+(menuWidth+_arrowWidth)*0.5, menuY+menuHeight);
            [self drawArrowInLayer:origin peak:peak terminus:terminus];
        }
            break;
        case LEPopMenuArrowBottomfooter:
        {
            CGPoint origin = CGPointMake(menuX+menuWidth-_arrowWidth-distance, menuY+menuHeight);
            CGPoint peak = CGPointMake(menuX+menuWidth-_arrowWidth*0.5-distance, menuY+menuHeight+_arrowHeight);
            CGPoint terminus = CGPointMake(menuX+menuWidth-distance, menuY+menuHeight);
            [self drawArrowInLayer:origin peak:peak terminus:terminus];
        }
            break;
        default:
            
            break;
    }
}

//绘制箭头
- (void)drawArrowInLayer:(CGPoint)origin peak:(CGPoint)peak terminus:(CGPoint)terminus{
    //定义画图的path
    self.shLayer = [[CAShapeLayer alloc]init];
    UIBezierPath *path = [[UIBezierPath alloc] init];
    _shLayer.fillColor = self.menuViewBgColor.CGColor;
    
    //path移动到开始画图的位置
    [path moveToPoint:origin];
    [path addLineToPoint:peak];
    [path addLineToPoint:terminus];
    _shLayer.path = [path CGPath];
    
    //关闭path
    [path closePath];
    [self.layer addSublayer:_shLayer];
}

//蒙版背景点击事件
- (void)tapEvent
{
    [self closeMenu:YES];
}

//防止手势透传
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isMemberOfClass:[self class]]) {
        return YES;
    }
    return NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.itemArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LEPopMenuTableViewCell *cell = LEGetCellForTable([LEPopMenuTableViewCell class], tableView, indexPath);
    cell.labText.text = self.itemArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_menuDelete && [_menuDelete respondsToSelector:@selector(menuPopView: clickStr:)]) {
        [_menuDelete menuPopView:self clickStr:self.itemArray[indexPath.row]];
    }
    [self closeMenu:NO];
}

@end
