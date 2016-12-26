//
//  WCViewControllers.m
//  VIP
//
//  Created by NJWC on 16/3/21.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WCViewControllers.h"
#import "WCTabBarController.h"
#import "WCTabBarItem.h"
#import "WCMainViewController.h"
#import "WCBasicInfomationViewController.h"
#import "WCTaskCheckViewController.h"
#import "WCCountResultViewController.h"

@implementation WCViewControllers

+(NSArray *)getViewControllers
{
    WCMainViewController * mVC = [[WCMainViewController alloc]init];
    mVC.tabBarItem = [[WCTabBarItem alloc]initWithTitle:nil withNormalImage:[UIImage imageNamed:@"main_unSelect"] withSelectImage:[UIImage imageNamed:@"main_select"]];
    
    WCBasicInfomationViewController * bVC = [[WCBasicInfomationViewController alloc]init];
    bVC.tabBarItem = [[WCTabBarItem alloc]initWithTitle:nil withNormalImage:[UIImage imageNamed:@"basic_unSelect"] withSelectImage:[UIImage imageNamed:@"basic_select"]];
    
    WCTaskCheckViewController * tVC = [[WCTaskCheckViewController alloc]init];
    tVC.tabBarItem = [[WCTabBarItem alloc]initWithTitle:nil withNormalImage:[UIImage imageNamed:@"task_unSelect"] withSelectImage:[UIImage imageNamed:@"task_select"]];
    
    WCCountResultViewController * cVC = [[WCCountResultViewController alloc]init];
    cVC.tabBarItem = [[WCTabBarItem alloc]initWithTitle:nil withNormalImage:[UIImage imageNamed:@"count_unSelect"] withSelectImage:[UIImage imageNamed:@"count_select"]];
    
    return @[mVC,bVC,tVC,cVC];
}

@end
