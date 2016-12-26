//
//  WCHTTPRequest.h
//  VIP
//
//  Created by NJWC on 16/3/21.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WCTaskNum;
@class WCPage;
@class WCTaskInfo;
@interface WCHTTPRequest : NSObject


/**
 *  登陆验证
 *
 *  @param account 登陆参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)loginWithAccount:(NSMutableDictionary *)userDic
                 success:(void(^)(NSString *success))success
                 failure:(void(^)(NSString *error))failure;

/**
 *  获取当前用户当天执行的任务信息
 *
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)getTaskNumWithSuccess:(void(^)(WCTaskNum *success))success
                      failure:(void(^)(NSString *error))failure;


/**
 *  获取当前用户已执行所有任务中通过的路口统计信息(为提高系统性能任务执行接口与路口执行频率接口数据在后台业务层需要做缓存，避免重复进行数据库查询操作)
 *
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)getIntStatWithSuccess:(void(^)(NSArray *success))success
                      failure:(void(^)(NSString *error))failure;

/**
 *  上传图片(只能是一张图片)
 *
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)uploadImaegWithImages:(UIImage *)image
                      Success:(void(^)(NSString *url))success
                       failure:(void(^)(NSString *error))failure;

/**
 *  获取选择路线途径的信控路口
 *
 *  @param points  所有经纬度组成的字符串
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)getInfoWithPoints:(NSString *)points
                  Success:(void(^)(NSArray *intersection))success
                  failure:(void(^)(NSString *error))failure;

/**
 *  设置为常用路线
 *
 *  @param userDic 参数列表
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)setLineInfo:(NSDictionary *)dic
            success:(void(^)(NSString *success))success
            failure:(void(^)(NSString *error))failure;

/**
 *  查询当前用户已设置的常用路线(常用路线由于不经常修改，因此在业务层需要缓存，仅在系统启动时从数据库初始化，后面新增时同时刷新缓存与数据库)
 *
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)getLineInfoWithsuccess:(void(^)(NSArray *success))success
                       failure:(void(^)(NSString *error))failure;

/**
 *  相位设置
 *
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)getStageInfoWithIntersections:(NSString *)intersections
                              success:(void(^)(NSArray *setting))success
                              failure:(void(^)(NSString *error))failure;

/**
 *  保存或者执行任务
 *
 *  @param dic     参数列表
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)saveTaskWith:(NSMutableDictionary *)dic
             success:(void(^)(WCTaskInfo *info))success
             failure:(void(^)(NSString *error))failure;

/**
 *  查询当前用户任务信息（该页面在不同任务状态间切换时移动端需要缓存，避免频率调用后台接口）
 *
 *  @param parameters 参数
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)getTaskInfoWithParameters:(NSMutableDictionary *)parameters
                          success:(void(^)(WCPage *page, NSArray *success))success
                          failure:(void(^)(NSString *error))failure;

/**
 *  执行任务接口
 *
 *  @param parameters 参数列表
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)executeTaskWithParameters:(NSMutableDictionary *)parameters
                          success:(void(^)(NSString *success))success
                          failure:(void(^)(NSString *error))failure;

/**
 *  中途停止任务
 *
 *  @param parameters 参数列表
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)finishTaskWithParameters:(NSMutableDictionary *)parameters
                         success:(void(^)(NSString *success))success
                         failure:(void(^)(NSString *error))failure;


/**
 *  任务执行过程中，移动端需要动态展示应急车辆行驶轨迹、各路口状态，并发送车辆实时GPS轨迹、车辆与附近路口距离至后台（暂定为当前位置的前两个和后两个信控路口）
    注：车辆与应急路线中未通过路口之间的距离通过高德API中的测距功能获取，接口调用频率暂定为5s/次
 *
 *  @param parameters 参数
 *  @param success    成功
 *  @param failure    失败
 */
+ (void)getTaskStatusWithParameters:(NSMutableDictionary *)parameters
                            success:(void(^)(NSArray *success))success
                            failure:(void(^)(NSString *error))failure;

/**
 *  任务统计(可以按照日、周、月、年等不同统计周期进行统计)
 *
 *  @param parameters 参数
 *  @param success    成功
 *  @param failure    失败
 */
+ (void)getTaskStatWithParameters:(NSMutableDictionary *)parameters
                          success:(void(^)(NSArray *success))success
                          failure:(void(^)(NSString *error))failure;
/*
 注：当统计周期为天/月/年时，statDate为当天/当月/当年；当统计周期为周时，statDate为一个时间段，如：20160307~20160313。另外结果集显示为图形时，不传入分页信息，图形横坐标支持拖拉效果
 */

/**
 *  获取所有的信控点
 *
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)getIntersections;

/**
 *  检测是否有任务真正执行中
 *
 *  @param result 结果
 */
+ (void)isTaskExecution:(void(^)(BOOL isYES))result;
@end
