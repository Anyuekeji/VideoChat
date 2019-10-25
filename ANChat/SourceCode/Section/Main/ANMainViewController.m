//
//  ANMainViewController.m
//  ANChat
//
//  Created by liuyunpeng on 2019/5/29.
//  Copyright © 2019 liuyunpeng. All rights reserved.
//

#import "ANMainViewController.h"

@interface ANMainViewController ()

@end

@implementation ANMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) setNavigationBarViewStyle:(ANNavigationBarViewStyle)navigationBarViewStyle {
    if ( _navigationBarViewStyle != navigationBarViewStyle ) {
        _navigationBarViewStyle = navigationBarViewStyle;
        [self setNavigationBaRightItem:navigationBarViewStyle];
        switch ( _navigationBarViewStyle ) {
            case ANNavigationBarViewStylehHome:
            {
                self.title =AYLocalizedString(@"书架");
            }
                break;
            case ANNavigationBarViewStyleChatlist:
                self.title =AYLocalizedString(@"书城");
                break;
            case ANNavigationBarViewStyleMe:
                self.title = AYLocalizedString(@"任务");
                break;
            
            default:    break;
        }
    }
}
-(void) setNavigationBaRightItem:(ANNavigationBarViewStyle)navigationBarViewStyle
{
    switch ( _navigationBarViewStyle ) {
        case ANNavigationBarViewStylehHome:
        {
          self.navigationItem.rightBarButtonItem =nil;
        }
            break;
        case ANNavigationBarViewStyleChatlist:
        {
            self.navigationItem.rightBarButtonItem =nil;
            self.navigationItem.titleView = nil;
        }
            break;

        case ANNavigationBarViewStyleMe:
        {
            self.navigationItem.rightBarButtonItem =nil;
            self.navigationItem.titleView = nil;
            
        }
            break;
        default:    break;
    }
}

@end
