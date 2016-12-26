//
//  WCThreeTaskViewController.m
//  VIP
//
//  Created by NJWC on 16/4/11.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WCThreeTaskViewController.h"

@interface WCThreeTaskViewController ()

@end

@implementation WCThreeTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.status = 2;
    
    //接到任务执行完成的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"refresh" object:nil];
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
