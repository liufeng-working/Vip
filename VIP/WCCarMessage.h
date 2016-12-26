//
//  WCCarMessage.h
//  VIP
//
//  Created by NJWC on 16/4/14.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCCarMessage : NSObject


/**
 *  车牌号
 */
@property (copy, nonatomic) NSString *plate;

/**
 *  车辆数目
 */
@property (copy, nonatomic) NSString *vehicleNum;

/**
 *  优先级
 */
@property (copy, nonatomic) NSString *priority;

/**
 *  备注
 */
@property (nonatomic, copy)NSString *descriptions;


@end
