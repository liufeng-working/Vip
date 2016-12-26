//
//  WCOneTaskViewController.m
//  VIP
//
//  Created by NJWC on 16/4/11.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WCOneTaskViewController.h"
#import "WCTaskInfo.h"
#import "WCPerformTaskViewController.h"
#import "WCTaskCheckViewController.h"

@interface WCOneTaskViewController ()

@end

@implementation WCOneTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //请求执行中的 任务
    self.status = 1;
    
    //接到通知改变进度
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeProgress) name:@"progress" object:nil];
    
    //接到任务执行完成的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"refresh" object:nil];
    
    //接到保存提交或者立即执行的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh:) name:@"gotoPerformTaskViewController" object:nil];
}

//点击了执行中按钮
-(void)performTaskWithTask:(WCTaskInfo *)taskInfo
{
    WCTaskCheckViewController *tVC = (WCTaskCheckViewController *)self.parentViewController;
    WCPerformTaskViewController *pVC = [[WCPerformTaskViewController alloc]init];
    pVC.taskInfo = taskInfo;
    [tVC.view addSubview:pVC.view];
    [tVC addChildViewController:pVC];
}

-(void)refresh:(NSNotification *)info
{
    BOOL isGoto = [info.userInfo[@"isGoto"] integerValue];
    if (isGoto) {
        [self refreshData];
    }
}

- (void)changeProgress
{
    [self.tableView reloadData];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
