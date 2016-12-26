//
//  WCBasicInfomationViewController.m
//  VIP
//
//  Created by NJWC on 16/3/18.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WCBasicInfomationViewController.h"
#import "WCOneBasicViewController.h"

@interface WCBasicInfomationViewController ()


@end

@implementation WCBasicInfomationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //设置子控制器为导航控制器
    WCOneBasicViewController *oVC = [[WCOneBasicViewController alloc]init];
    UINavigationController *NAV = [[UINavigationController alloc]initWithRootViewController:oVC];
    NAV.view.frame = CGRectMake(0, 0, kMainViewWidth, kContentHeight);
    NAV.navigationBarHidden = YES;
//    self.view = NAV.view ;
    [NAV willMoveToParentViewController:self] ;
    [self addChildViewController:NAV];
    [self.view addSubview:NAV.view];
    [NAV didMoveToParentViewController:self] ;

}

@end
