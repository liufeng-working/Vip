//
//  WCDataBaseTool.h
//  VIP
//
//  Created by NJWC on 16/4/14.
//  Copyright © 2016年 wancun. All rights reserved.
//

//用来操作数据库
#import <Foundation/Foundation.h>
#import "FMDB.h"

@class WCRoute;
@class WCLineInfo;

@interface WCDataBaseTool : NSObject

/**
 *  保存表格的数据
 *
 *  @param dataArr 要保存的数据数组
 *  @param url     数据的标识
 */
+ (void)saveStatisticsWithArr:(NSArray *)dataArr withDic:(NSDictionary *)dic;

/**
 *  获取缓存的表格数据
 *
 *  @param dic 根据参数去取
 *
 *  @return 符合要求的数据
 */
+ (NSArray *)getStatisticsWithDic:(NSDictionary *)dic;

/**
 *  保存常用路线信息
 */
+ (void)saveLineInfoWithLineInfo:(WCLineInfo *)lineInfo;

/**
 *  获取常用路线信息
 *
 *  @return 所有路线信息
 */
+ (NSArray *)getlineInfo;

/**
 *  保存相位信息
 *  要保存的信息
 */
+ (void)saveStageWithInterSection:(NSString *)interSectionId withArray:(NSArray *)arr;

/**
 *  获取相位信息
 *
 *  @return 所有相位信息
 */
+ (NSArray *)getStageWithInterSection:(NSString *)interSectionId;


//************************没用到*******************************
/**
 *  保存路线信息
 *
 *  @param route  路线
 *  @param taskId 任务id
 */
+ (void)saveRouteMessageWithRoute:(WCRoute *)route withTaskId:(NSInteger)taskId;
/**
 *  获取路线信息
 *
 *  @param taskId 任务id
 */
+ (WCRoute *)getRouteMessageWithTaskId:(NSInteger)taskId;
//************************没用到*******************************


/**
 *  保存截图
 *
 *  @param image 图片
 *
 *  @param taskId 任务id
 */
+ (void)saveImageWithImage:(UIImage *)image withTaskId:(NSInteger)taskId;

/**
 *  获取图片
 *
 *  @param taskId 任务id
 */
+ (UIImage *)getImageWithTaskId:(NSInteger)taskId;

/**
 *  保存车牌号，要和账号绑定
 */
+ (void)savePlateWithPlate:(NSString *)plate;

/**
 *  获取车牌号
 */
+ (NSString *)getPlate;
@end
