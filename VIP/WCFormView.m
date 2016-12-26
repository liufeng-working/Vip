//
//  WCFormView.m
//  VIP
//
//  Created by NJWC on 16/3/28.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WCFormView.h"
#import "WCFormHeaderView.h"
#import "WCFormCell.h"
#import "MJRefresh.h"

@interface WCFormView ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation WCFormView

+(instancetype)formViewWithFrame:(CGRect)frame
{
    WCFormView * formView = [[[NSBundle mainBundle] loadNibNamed:@"WCFormView" owner:nil options:nil] lastObject];
    formView.frame = frame;
    return formView;
}

//上下拉刷新，感觉没什么必要，因为请求图形数据的时候，数据就已经全部加载出来了
-(void)awakeFromNib
{
//    //下拉刷新
//    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshDate)];
//    header.automaticallyChangeAlpha = YES;
//    header.lastUpdatedTimeLabel.hidden = YES;
//    self.tableView.mj_header = header;
}

-(void)refreshDate
{
    [self.tableView.mj_header endRefreshing];
}


-(void)setDataArr:(NSArray *)dataArr
{
    _dataArr = dataArr;
    [self.tableView reloadData];
}

#pragma mark - ****表的协议方法****
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WCFormCell *cell = [WCFormCell formCellWithTableView:tableView];
    cell.taskStat = self.dataArr[indexPath.row];
    return cell;
}

//区头
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    WCFormHeaderView * headerView = [WCFormHeaderView formHeaderView];
    return headerView;
}

@end
