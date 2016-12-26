//
//  WCTaskCheckViewController.m
//  VIP
//
//  Created by NJWC on 16/3/18.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WCTaskCheckViewController.h"
#import "WCNavigationView.h"
#import "WCPerformTaskViewController.h"

#import "WCTaskBaseViewController.h"
#import "WCOneTaskViewController.h"
#import "WCTwoTaskViewController.h"
#import "WCThreeTaskViewController.h"



@interface WCTaskCheckViewController ()<WCNavigationViewDelegate>

@property (nonatomic, strong)WCTaskBaseViewController *lastVc;

@end

@implementation WCTaskCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    //设置navigationView的类型
    self.navigationView.titleArray = @[@"执行中",@"待执行",@"已执行"];
    self.navigationView.navigationViewType = WCNavigationViewTypeTask;
    self.navigationView.delegate = self;
    
    //添加子控制器
    [self addChildViewControllers];
}

#pragma mark - ****WCNavigationViewDelegate****
-(void)taskButtonClickWithNagivationView:(WCNavigationView *)navigationView fromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
    WCTaskBaseViewController *tVC = self.childViewControllers[toIndex];
    if (_lastVc == tVC) {
        return;
    }
    
    [_lastVc.view removeFromSuperview];
    [self.view addSubview:tVC.view];
    
    _lastVc = tVC;
}

/**
 *  添加子视图控制器，管理view
 */
-(void)addChildViewControllers
{
    WCOneTaskViewController *oVC = [[WCOneTaskViewController alloc]init];
    [self.view addSubview:oVC.view];
    [self addChildViewController:oVC];
    
    WCTwoTaskViewController *tVC = [[WCTwoTaskViewController alloc]init];
    [self addChildViewController:tVC];
    
    WCThreeTaskViewController *thVC = [[WCThreeTaskViewController alloc]init];
    [self addChildViewController:thVC];
    
    _lastVc = oVC;
}


@end
