//
//  WCFormCell.m
//  VIP
//
//  Created by NJWC on 16/3/28.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WCFormCell.h"
#import "WCTaskStat.h"

@interface WCFormCell ()

/**
 *  日期
 */
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
/**
 *  执行任务
 */
@property (weak, nonatomic) IBOutlet UILabel *taskLabel;
/**
 *  优先路口
 */
@property (weak, nonatomic) IBOutlet UILabel *roadLabel;
/**
 *  总花费时间
 */
@property (weak, nonatomic) IBOutlet UILabel *allTimeLabel;
/**
 *  节约时间
 */
@property (weak, nonatomic) IBOutlet UILabel *saveTimeLabel;

@end

@implementation WCFormCell

+(instancetype)formCellWithTableView:(UITableView *)tableView
{
    static NSString *idetifier = @"formCell";
    WCFormCell * cell = [tableView dequeueReusableCellWithIdentifier:idetifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"WCFormCell" owner:nil options:nil] lastObject];
    }
    
    return cell;
}

-(void)setTaskStat:(WCTaskStat *)taskStat
{
    _taskStat = taskStat;
    
    //赋值
    self.dateLabel.text = taskStat.statDate;
    self.taskLabel.text = kStringWithFormat(@"%ld",(long)taskStat.taskNum);
    self.roadLabel.text = kStringWithFormat(@"%ld",(long)taskStat.prioIntNum);
    self.allTimeLabel.text = kStringWithFormat(@"%ld",(long)taskStat.travelTime);
    self.saveTimeLabel.text = kStringWithFormat(@"%ld",(long)taskStat.saveTime);
}

@end
