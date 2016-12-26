//
//  WCBasicBaseViewController.m
//  VIP
//
//  Created by NJWC on 16/4/1.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WCBasicBaseViewController.h"
#import "WCNavigationView.h"

@interface WCBasicBaseViewController ()

@end

@implementation WCBasicBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //设置navigationView的类型
    self.navigationView.titleArray = @[@"基础信息",@"路线设置",@"相位设置",@"控制执行"];
    self.navigationView.navigationViewType = WCNavigationViewTypeBasic;
}

@end
