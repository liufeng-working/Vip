//
//  WCStageList.h
//  VIP
//
//  Created by NJWC on 16/4/6.
//  Copyright © 2016年 wancun. All rights reserved.
//

/*
 * 相位列表
 */
#import <Foundation/Foundation.h>

@interface WCStageList : NSObject<NSCoding>

/**
 *  路口id
 */
@property (nonatomic, copy)NSString *intersectionId;

/**
 *  未知id
 */
@property (nonatomic, copy)NSString *programId;

/**
 *  相位id
 */
@property (nonatomic, copy)NSString *stageId;

/**
 *  相位名称
 */
@property (nonatomic, copy)NSString *stageName;

@end
