//
//  WCTwoTaskViewController.m
//  VIP
//
//  Created by NJWC on 16/4/11.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WCTwoTaskViewController.h"
#import "WCPerformTaskViewController.h"
#import "WCTaskCheckViewController.h"
#import "WCHTTPRequest.h"
#import "WCTaskInfo.h"


@interface WCTwoTaskViewController ()

@end

@implementation WCTwoTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.status = 0;
    
    //接到任务执行完成的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"refresh" object:nil];
    
    //接到保存提交或者立即执行的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh:) name:@"gotoPerformTaskViewController" object:nil];
}

#pragma mark - ****WCTaskCellDelegate****
-(void)performTaskWithTask:(WCTaskInfo *)taskInfo
{
    //如果有执行中的任务，直接返回
    [WCHTTPRequest isTaskExecution:^(BOOL isYES) {
        if (isYES) {
            [WCPhoneNotification autoHideWithText:@"有任务正在执行中"];
        }else{
            [self gotoPerformTaskWithTask:taskInfo];
        }
    }];
}

- (void)gotoPerformTaskWithTask:(WCTaskInfo *)taskInfo
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"account"] = taskInfo.account;
    dic[@"taskId"] = @(taskInfo.taskId);
    dic[@"plate"] = taskInfo.plate;
    dic[@"vehicleNum"] = @(taskInfo.vehicleNum);
    dic[@"priority"] = @(taskInfo.priority);
    dic[@"urls"] = taskInfo.url1;
    dic[@"intersections"] = taskInfo.intersections;
    dic[@"length"] = taskInfo.length;
    dic[@"preTime"] = @(taskInfo.preTime);
    dic[@"programs"] = taskInfo.programs;
    dic[@"stages"] = taskInfo.stages;
    dic[@"description"] = taskInfo.descriptions;
    //新增参数
    dic[@"points"] = taskInfo.points;
    
    [WCHTTPRequest executeTaskWithParameters:dic success:^(NSString *success) {
        
        WCTaskCheckViewController *tVC = (WCTaskCheckViewController *)self.parentViewController;
        WCPerformTaskViewController *pVC = [[WCPerformTaskViewController alloc]init];
        pVC.taskInfo = taskInfo;
        [tVC.view addSubview:pVC.view];
        [tVC addChildViewController:pVC];
        
        [self refreshData];
    } failure:^(NSString *error) {
        
    }];
}

-(void)refresh:(NSNotification *)info
{
    BOOL isGoto = [info.userInfo[@"isGoto"] integerValue];
    if (!isGoto) {
        [self refreshData];
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
