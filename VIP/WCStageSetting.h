//
//  WCStageSetting.h
//  VIP
//
//  Created by NJWC on 16/4/11.
//  Copyright © 2016年 wancun. All rights reserved.
/*
 * 相位设置
 */

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface WCStageSetting : NSObject<MJKeyValue,NSCoding>

/**
 *  路口编号
 */
@property (nonatomic, copy)NSString *intersectionId;

/**
 *  <#Description#>
 */
@property (nonatomic, copy)NSString *programId;

/**
 *  相位编号的数组
 */
@property (nonatomic, strong)NSArray *stageList;


@end
