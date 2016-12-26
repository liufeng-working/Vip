//
//  WCIntStat.h
//  VIP
//
//  Created by NJWC on 16/4/6.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCIntStat : NSObject

/**
 *  路口编号
 */
@property (nonatomic, copy)NSString *intersectionId;

/**
 *  路口经过次数
 */
@property (nonatomic, assign)NSInteger count;



@end
