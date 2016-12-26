//
//  WCBaseViewController.m
//  VIP
//
//  Created by NJWC on 16/3/18.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WCBaseViewController.h"
#import "WCTabBarItem.h"
#import "WCNavigationView.h"

@interface WCBaseViewController ()

@end

@implementation WCBaseViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //浏览了这个页面对应的提示数字要清零
    if (self.tabBarItem.badgeCount) {
        
        self.tabBarItem.badgeCount = 0;
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置统一的背景颜色，各个页面可以设置自己的背景色
    self.view.backgroundColor = [UIColor colorWithHexString:kBaseControllerBackGroundColor];
    
    //设置子view的大小
    self.view.frame = CGRectMake(kTabBarWidth, kStatusBarHeight, kContentWidth, kContentHeight);
    //对子view左上角进行切角
    UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:self.view.bounds byRoundingCorners:UIRectCornerTopLeft cornerRadii:kCornerSize];
    CAShapeLayer * maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = self.view.bounds;
    maskLayer.path = maskPath.CGPath;
    self.view.layer.mask = maskLayer;
}
//如果需要类导航条，就会去创建一个
-(WCNavigationView *)navigationView
{
    if (!_navigationView) {
        //添加一个类似于导航条的视图
        _navigationView = [[WCNavigationView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth - kTabBarWidth, kNavigationHeight)];
        _navigationView.backgroundColor = [UIColor colorWithHexString:kNavigationBackGroundColor];
        [self.view addSubview:_navigationView];
    }
    return _navigationView;
}

@end
