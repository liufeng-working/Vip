//
//  WCBaseViewController.h
//  VIP
//
//  Created by NJWC on 16/3/18.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WCTabBarItem;
@class WCNavigationView;
@interface WCBaseViewController : UIViewController

/**
 *  一个控制器对应一个item
 */
@property(nonatomic,strong)WCTabBarItem * tabBarItem;
/**
 *  类导航条,如果不需要，在对应的控制器隐藏
 */
@property(nonatomic,strong)WCNavigationView * navigationView;


@end
