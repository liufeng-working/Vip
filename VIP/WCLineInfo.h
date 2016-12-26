//
//  WCLineInfo.h
//  VIP
//
//  Created by NJWC on 16/4/6.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCLineInfo : NSObject<NSCoding>

/*
 {"lineId":xxx,
 "account":"xxx",
 "lineName":"xxx",
 "intersections":"xxx;xxx;xxx",
 "length":xxx,
 "preTime":xxx, 
 "points":"xxx,xxx,xxx,xxx"}
 */

/**
 *  常用线路编号
 */
@property (nonatomic, assign)NSInteger lineId;

/**
 *  用户账号
 */
@property (nonatomic, copy)NSString *account;

/**
 *  常用线路名称
 */
@property (nonatomic, copy)NSString *lineName;

/**
 *  路口编号
 */
@property (nonatomic, copy)NSString *intersections;

/**
 *  路线长度/实时点位与路口距离
 */
@property (nonatomic, copy)NSString *length;

/**
 *  行程时间
 */
@property (nonatomic, assign)NSInteger preTime;

/**
 *  信控路口经纬度 组成的字符串（纬度，经度）
 */
@property (nonatomic, copy)NSString *points;


@end
