//
//  WCTaskBaseViewController.h
//  VIP
//
//  Created by NJWC on 16/4/11.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCTaskCell.h"
#import "MJRefresh.h"
#import "WCPage.h"

@interface WCTaskBaseViewController : UITableViewController<WCTaskCellDelegate>

/**
 *  所有数据
 */
@property (nonatomic, strong)NSMutableArray *taskInfoArr;

/**
 *  任务状态
 */
@property (nonatomic, assign)NSInteger status;

/**
 *  记录每次的数据(第几页，每页几个)
 */
@property (nonatomic, strong)WCPage *page;

/**
 *  下拉刷新
 */
-(void)refreshData;

@end
