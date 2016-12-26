//
//  WCTabBarController.m
//  VIP
//
//  Created by NJWC on 16/3/18.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WCTabBarController.h"
#import "WCBaseViewController.h"
#import "WCTabBarView.h"
#import "WCTabBarItem.h"

@interface WCTabBarController ()<WCTabBarViewDelegate>

@end

@implementation WCTabBarController

-(instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置基背景颜色
    self.view.backgroundColor = [UIColor colorWithHexString:kTabBarControllerBackGroundColor];
    
    //添加tabBarView到基础的viewController
    CGRect tabBarR = CGRectMake(0, kStatusBarHeight, kTabBarWidth, kContentWidth);
    self.tabBarView = [[WCTabBarView alloc]initWithFrame:tabBarR];
    _tabBarView.delegate = self;
    [self.view addSubview:self.tabBarView];
    
    for (NSInteger i = 0; i < self.controllers.count; i++) {
        
        WCBaseViewController * controller = self.controllers[i];
        WCTabBarItem * item = controller.tabBarItem;
        [self.tabBarView setTabBarItemWithItem:item withNormalImage:item.nImage withSelectImage:item.sImage];
        [self addChildViewController:controller];
    }
    
    //默认显示第一个控制器
    self.selectIndex = 0;
}

-(void)setSelectIndex:(NSUInteger)selectIndex
{
    _selectIndex = selectIndex;
    
    UIViewController * nextVC = self.controllers[selectIndex];
    
    if (_currentViewController == nextVC) {
        return;
    }
    
    //移除上一个view
    [_currentViewController.view removeFromSuperview];
    //展示新的view
    [self.view insertSubview:nextVC.view aboveSubview:self.tabBarView];

    //记录当前控制器是哪个
    _currentViewController = nextVC;
}

#pragma mark - ****WCTabBarViewDelegate****
-(void)menuClickWithTabBarView:(WCTabBarView *)tabBarView withIndex:(NSUInteger)index
{
    self.selectIndex = index;
}

//改变状态栏的样式
-(BOOL)prefersStatusBarHidden
{
    return NO;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
