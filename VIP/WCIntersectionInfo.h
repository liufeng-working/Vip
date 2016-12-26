//
//  WCIntersectionInfo.h
//  VIP
//
//  Created by NJWC on 16/4/18.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCIntersectionInfo : NSObject

/**
 *  信控路口id
 */
@property (nonatomic, assign)NSInteger intersectionId;

/**
 *  信控路口名称
 */
@property (nonatomic, copy)NSString *intersectionName;

@end
