//
//  WCTaskInfo.h
//  VIP
//
//  Created by NJWC on 16/4/6.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

/*
 {
 account = shengwang;//账号
 createDate = 201604110952;//创建时间
 description = "\U6ca1\U6709\U54af";//备注
 executeDate = "-1";//执行时间
 intList =             (
 101104
 );//路口列表
 intNum = 1;//
 intersections = 101104;//路口编号
 length = "3.5";//距离
 plate = "\U82cfA88888";//车牌号
 preTime = 35;//时间
 priority = 1;//优先级
 programList =             (
 1
 );//
 programs = 1;//
 stageList =             (
 1
 );//相位列表
 stages = 1;//相位
 status = 1;//任务状态
 taskId = 8;//任务id
 travleTime = "-1";//执行时间
 url1 = "www.baidu.com";//图片链接
 vehicleNum = 5;//车辆数目
 points = ....
 }
 */

@interface WCTaskInfo : NSObject<MJKeyValue>

/**
 *  账号
 */
@property (nonatomic, copy)NSString *account;

/**
 *  创建日期
 */
@property (nonatomic, assign)NSInteger createDate;

/**
 *  备注
 */
@property (nonatomic, copy)NSString *descriptions;

/**
 *  执行日期
 */
@property (nonatomic, copy)NSString *executeDate;

/**
 *  路口列表
 */
@property (nonatomic, strong)NSArray *intList;

/**
 *  <#Description#>
 */
@property (nonatomic, assign)NSInteger intNum;

/**
 *  路口编号
 */
@property (nonatomic, copy)NSString *intersections;

/**
 *  距离
 */
@property (nonatomic, copy)NSString *length;

/**
 *  车牌号
 */
@property (nonatomic, copy)NSString *plate;

/**
 *  时间
 */
@property (nonatomic, assign)NSInteger preTime;

/**
 *  优先级
 */
@property (nonatomic, assign)NSInteger priority;

/**
 *  <#Description#>
 */
@property (nonatomic, strong)NSArray *programList;

/**
 *  <#Description#>
 */
@property (nonatomic, copy)NSString *programs;

/**
 *  相位列表
 */
@property (nonatomic, strong)NSArray *stageList;

/**
 *  相位
 */
@property (nonatomic, copy)NSString *stages;

/**
 *  任务状态
 */
@property (nonatomic, assign)NSInteger status;

/**
 *  任务id
 */
@property (nonatomic, assign)NSInteger taskId;

/**
 *  执行时间
 */
@property (nonatomic, copy)NSString *travleTime;

/**
 *  图片链接
 */
@property (nonatomic, copy)NSString *url1;

/**
 *  车辆数目
 */
@property (nonatomic, assign)NSInteger vehicleNum;

/**
 *  路线上所有经纬度，组成的字符串
 */
@property (nonatomic, copy)NSString *points;


@end
