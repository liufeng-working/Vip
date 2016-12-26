//
//  WCTaskNum.h
//  VIP
//
//  Created by NJWC on 16/4/6.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCTaskNum : NSObject

/**
 *  账号
 */
@property (nonatomic, copy)NSString *account;

/**
 *  已执行任务数
 */
@property (nonatomic, assign)NSInteger executedNum;

/**
 *  正在执行任务数
 */
@property (nonatomic, assign)NSInteger executingNum;

/**
 *  待执行任务数
 */
@property (nonatomic, assign)NSInteger watingNum;


@end
