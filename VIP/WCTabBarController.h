//
//  WCTabBarController.h
//  VIP
//
//  Created by NJWC on 16/3/18.
//  Copyright © 2016年 wancun. All rights reserved.
//

@class WCTabBarView;
@class WCBaseViewController;
@interface WCTabBarController : UIViewController
/**
 *  控制器的容器
 */
@property(nonatomic,strong)NSArray<WCBaseViewController *> * controllers;
/**
 *  确定选中的视图
 */
@property(nonatomic,assign)NSUInteger selectIndex;//默认选中第一个视图
/**
 *  左侧的tabBarView
 */
@property(nonatomic,strong)WCTabBarView * tabBarView;
/**
 *  当前显示的控制器
 */
@property(nonatomic,strong)UIViewController * currentViewController;

@end

