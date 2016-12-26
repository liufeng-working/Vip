//
//  WCPage.h
//  VIP
//
//  Created by NJWC on 16/4/12.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCPage : NSObject

/**
 *  页数
 */
@property (nonatomic, assign)NSInteger pageIndex;

/**
 *  每页的数据个数
 */
@property (nonatomic, assign)NSInteger pageRecords;

/**
 *  总数
 */
@property (nonatomic, assign)NSInteger totalRecords;

@end
