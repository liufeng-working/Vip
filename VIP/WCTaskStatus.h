//
//  WCTaskStatus.h
//  VIP
//
//  Created by NJWC on 16/4/6.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCTaskStatus : NSObject

/**
 *  路口编号
 */
@property (nonatomic, assign)NSInteger intersectionId;

/**
 *  路口状态(0表示未被优先，1表示正在被优先)
 */
@property (nonatomic, assign)NSInteger status;

@end
