//
//  WCPerformTaskViewController.h
//  VIP
//
//  Created by NJWC on 16/3/23.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WCNaviMapViewController.h"

@class WCTaskInfo;
@interface WCPerformTaskViewController : WCNaviMapViewController

/**
 *  执行的任务
 */
@property (nonatomic, strong)WCTaskInfo *taskInfo;

@end
