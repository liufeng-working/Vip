//
//  WCTaskCell.m
//  VIP
//
//  Created by NJWC on 16/4/11.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WCTaskCell.h"
#import "WCRoadLineView.h"
#import "WCTaskInfo.h"

#import "WCIntersections.h"
#import "MJExtension.h"
#import "WCDataBaseTool.h"
#import "WCDeviceDirectionTool.h"

@interface WCTaskCell ()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *plate;
@property (weak, nonatomic) IBOutlet UILabel *vehicleNum;
@property (weak, nonatomic) IBOutlet UILabel *priority;
@property (weak, nonatomic) IBOutlet UIButton *performbtn;
@property (weak, nonatomic) IBOutlet WCRoadLineView *roadLineView;

- (IBAction)perfomBtnClick:(UIButton *)sender;



@end

@implementation WCTaskCell

+ (instancetype)taskCellWithTableView:(UITableView *)tableView
{
    static NSString *idetifier = @"taskCell";
    WCTaskCell * cell = [tableView dequeueReusableCellWithIdentifier:idetifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"WCTaskCell" owner:nil options:nil] lastObject];
    }
    
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.roadLineView.width = 688;
    self.roadLineView.count = 7;
    self.roadLineView.roadLineViewType = WCRoadLineViewTypeHasProgress;
}

- (void)setTaskInfo:(WCTaskInfo *)taskInfo
{
    _taskInfo = taskInfo;
    
    self.roadLineView.nameArr = [self getRoadNameWithIntersections:taskInfo.intList];
    [self.roadLineView settingRoadLine];
    if (taskInfo.status == 1) {
        
        //控制当前执行到第几个信控口（默认为0）
        self.roadLineView.index = [WCDeviceDirectionTool shareDeviceDirection].index;
    }else{
        
        //待执行/已执行 的全是灰色状态
        self.roadLineView.index = 0;
    }
    
    
    UIImage *image = [WCDataBaseTool getImageWithTaskId:taskInfo.taskId];
    if(image){
        //如果有就用本地获取的图片
        self.icon.image = image;
    }else{
        //如果没有就用默认图片
        self.icon.image = [UIImage imageNamed:@"thumbnail_map"];
    }
    
    
    self.plate.text = taskInfo.plate;
    self.vehicleNum.text = kStringWithFormat(@"%ld",(long)taskInfo.vehicleNum);
    self.priority.text = [self getPriorityWith:taskInfo.priority];
    [self.performbtn setTitle:[self getTaskStatusWith:taskInfo.status] forState:UIControlStateNormal];
    
    if(taskInfo.status == 2){
        [self.performbtn setBackgroundImage:[UIImage imageNamed:@"button_implementation-in"] forState:UIControlStateNormal];
        self.performbtn.userInteractionEnabled = NO;
    }else{
        [self.performbtn setBackgroundImage:[UIImage imageNamed:@"button_implementation-in_desalination"] forState:UIControlStateNormal];
        self.performbtn.userInteractionEnabled = YES;
    }
}

- (NSArray *)getRoadNameWithIntersections:(NSArray *)intersections
{
    NSMutableArray *nameArr = [NSMutableArray array];
    NSDictionary *nameDic = [WCIntersections getAllInteractions];
    for (NSString *key in intersections) {
        WCIntersections *inter = [WCIntersections mj_objectWithKeyValues:nameDic[key]];
        [nameArr addObject:inter.intersectionName];
    }
    
    return (NSArray *)nameArr;
}

//优先级
- (NSString *)getPriorityWith:(NSInteger)priority
{
    NSString *priorityStr;
    switch (priority) {
        case 3:
            priorityStr = @"紧急";
            break;
        case 2:
            priorityStr = @"优先";
            break;
        case 1:
            priorityStr = @"一般";
            break;
            
        default:
            break;
    }
    return priorityStr;
}

//任务状态
- (NSString *)getTaskStatusWith:(NSInteger)status
{
    NSString *statusStr;
    switch (status) {
        case 0:
            statusStr = @" 执  行";
            break;
        case 1:
            statusStr = @"执行中";
            break;
        case 2:
            statusStr = @"已执行";
            break;
            
        default:
            break;
    }
    return statusStr;
}

- (IBAction)perfomBtnClick:(UIButton *)sender {
    
    if ([_delegate respondsToSelector:@selector(performTaskWithTask:)]) {
        [_delegate performTaskWithTask:self.taskInfo];
    }
    
}
@end
