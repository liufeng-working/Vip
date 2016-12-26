//
//  WCTaskStat.h
//  VIP
//
//  Created by NJWC on 16/4/6.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCTaskStat : NSObject

/**
 *  统计时间段
 */
@property (nonatomic, copy)NSString *statDate;

/**
 *  任务数
 */
@property (nonatomic, assign)NSInteger taskNum;

/**
 *  优先路口数
 */
@property (nonatomic, assign)NSInteger prioIntNum;

/**
 *  执行时间(总时间)
 */
@property (nonatomic, assign)NSInteger travelTime;

/**
 *  节约时间
 */
@property (nonatomic, assign)NSInteger saveTime;


@end
