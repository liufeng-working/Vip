//
//  WCTaskCell.h
//  VIP
//
//  Created by NJWC on 16/4/11.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WCTaskInfo;
@protocol WCTaskCellDelegate <NSObject>

@optional
- (void)performTaskWithTask:(WCTaskInfo *)taskInfo;

@end

@interface WCTaskCell : UITableViewCell

@property (nonatomic, strong)WCTaskInfo *taskInfo;
@property (nonatomic, weak)id<WCTaskCellDelegate> delegate;

+ (instancetype)taskCellWithTableView:(UITableView *)tableView;

@end
