//
//  WCFormCell.h
//  VIP
//
//  Created by NJWC on 16/3/28.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WCTaskStat;
@interface WCFormCell : UITableViewCell

@property (nonatomic, strong)WCTaskStat *taskStat;

+(instancetype)formCellWithTableView:(UITableView *)tableView;

@end
