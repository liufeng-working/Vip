//
//  WCTaskBaseViewController.m
//  VIP
//
//  Created by NJWC on 16/4/11.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WCTaskBaseViewController.h"
#import "WCHTTPRequest.h"
#import "WCTaskInfo.h"

@interface WCTaskBaseViewController ()


@end

@implementation WCTaskBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.frame = CGRectMake(tLineViewAndTabDis, kNavigationHeight, kMainViewWidth - 2*tLineViewAndTabDis, kMainViewHeight);
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.rowHeight = 155;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    
    //下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    //立即进入刷新状态
    [self.tableView.mj_header beginRefreshing];
    
    //上拉更多
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.taskInfoArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WCTaskCell *cell = [WCTaskCell taskCellWithTableView:tableView];
    WCTaskInfo *taskInfo = self.taskInfoArr[indexPath.row];
    cell.taskInfo = taskInfo;
    cell.delegate = self;
    return cell;
}

/**
 *  下拉刷新
 */
-(void)refreshData
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"account"] = [kDefaults objectForKey:kAccount];
    dic[@"pageIndex"] = @1;
    dic[@"pageRecords"] = @5;
    dic[@"status"] = @(self.status);
    
    [WCHTTPRequest getTaskInfoWithParameters:dic success:^(WCPage *page, NSArray *success) {
        
        if (page && success && success.count > 0 ) {
            self.page = page;
        }else{
            [WCPhoneNotification autoHideWithText:@"没有新数据"];
        }
        self.taskInfoArr = (NSMutableArray *)success;
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSString *error) {
        
        [self.tableView.mj_header endRefreshing];
    }];
}

/**
 *  上拉更多
 */
-(void)loadMoreData
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"account"] = [kDefaults objectForKey:kAccount];
    dic[@"pageIndex"] = @(self.page.pageIndex + 1);
    dic[@"pageRecords"] = @5;
    dic[@"status"] = @(self.status);
    
    [WCHTTPRequest getTaskInfoWithParameters:dic success:^(WCPage *page, NSArray *success) {
        
        if (page && success && success.count > 0 ) {
            
            self.page = page;
            [self.taskInfoArr addObjectsFromArray:success];
            [self.tableView reloadData];
        }else{
            
            [WCPhoneNotification autoHideWithText:@"没有更多数据了"];
        }
        
        [self.tableView.mj_footer endRefreshing];

    } failure:^(NSString *error) {
        
        [self.tableView.mj_footer endRefreshing];
    }];
}

@end
