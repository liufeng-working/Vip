//
//  WCHTTPRequest.m
//  VIP
//
//  Created by NJWC on 16/3/21.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WCHTTPRequest.h"
#import "WCHTTPTool.h"
#import "AFNetworking.h"
#import "MJExtension.h"

#import "WCAccount.h"
#import "WCTaskNum.h"
#import "WCIntStat.h"
#import "WCLineInfo.h"
#import "WCStageSetting.h"
#import "WCPage.h"
#import "WCTaskInfo.h"
#import "WCTaskStatus.h"
#import "WCTaskStat.h"
#import "WCDataBaseTool.h"
#import "WCTaskInfo.h"
#import "WCIntersectionInfo.h"

@interface WCHTTPRequest ()

@end

@implementation WCHTTPRequest


/**
 *  登陆验证
 *  @param account 登陆参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)loginWithAccount:(NSMutableDictionary *)userDic
                 success:(void(^)(NSString *success))success
                 failure:(void(^)(NSString *error))failure
{
    NSString *urlStr = [self getUrlString:@"login.json"];
    
    [WCHTTPTool GET:urlStr parameters:userDic success:^(id responseObject) {
        
        NSString *retMessage = responseObject[@"retMessage"];
        if ([retMessage isEqualToString:@"success"]) {
    
            //登陆成功 需要保存account
            NSDictionary *resultDic = responseObject[@"result"];
            WCAccount *account = [WCAccount mj_objectWithKeyValues:resultDic];
            [kDefaults setObject:account.account forKey:kAccount];
            [kDefaults synchronize];
        }
        
        if (success) {
            success(retMessage);
        }
    } failure:^(NSError *error) {
        
        [WCPhoneNotification autoHideWithText:@"请求失败，请重试"];
        if (failure) {
            failure(error.domain);
        }
    }];
}

/**
 *  获取当前用户当天执行的任务信息
 *
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)getTaskNumWithSuccess:(void(^)(WCTaskNum *success))success
                      failure:(void(^)(NSString *error))failure
{
    NSString *urlStr = [self getUrlString:@"getTaskNum.json"];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"account"] = [kDefaults objectForKey:kAccount];
    
    [WCHTTPTool GET:urlStr parameters:dic success:^(id responseObject) {
        
        NSString *retMessage = responseObject[@"retMessage"];
        if ([retMessage isEqualToString:@"success"]) {
            
            NSDictionary *resultDic = responseObject[@"result"];
            WCTaskNum *taskNum = [WCTaskNum mj_objectWithKeyValues:resultDic];
            
            if (success) {
                success(taskNum);
            }
        }else{
            [WCPhoneNotification autoHideWithText:@"请求失败，请重试"];
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(@"失败");
        }
    }];
}

/**
 *  获取当前用户已执行所有任务中通过的路口统计信息
 *
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)getIntStatWithSuccess:(void(^)(NSArray *success))success
                      failure:(void(^)(NSString *error))failure
{
    NSString *urlStr = [self getUrlString:@"getIntStat.json"];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"account"] = [kDefaults objectForKey:kAccount];
    
    [WCHTTPTool GET:urlStr parameters:dic success:^(id responseObject) {
        
        NSString *retMessage = responseObject[@"retMessage"];
        if ([retMessage isEqualToString:@"success"]) {
            
            NSArray *resultArr = [WCIntStat mj_objectArrayWithKeyValuesArray:responseObject[@"result"]];
            if (success) {
                success(resultArr);
            }
        }else{
            [WCPhoneNotification autoHideWithText:@"请求失败，请重试"];
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(@"失败");
        }
    }];
}

/**
 *  上传图片
 *
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)uploadImaegWithImages:(UIImage *)image
                      Success:(void(^)(NSString *url))success
                      failure:(void(^)(NSString *error))failure
{
    NSString *urlStr = [self getUrlString:@"uploadAttach.upload"];
    [WCHTTPTool POST:urlStr parameters:nil images:image success:^(id responseObject) {
        
        NSString *retMessage = responseObject[@"retMessage"];

        if ([retMessage contains:@"保存完毕"]) {
    //返回结果
    //{"result":{"url":"xxx"},"retCode":0,"retMessage":"success"
            NSString *url = responseObject[@"result"][@"url"];
            if (success) {
                success(url);
            }
            
        }else{
            [WCPhoneNotification autoHideWithText:@"请求失败，请重试"];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
    
}

/**
 *  获取选择路线途径的信控路口
 *
 *  @param points  所有经纬度组成的字符串
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)getInfoWithPoints:(NSString *)points
                  Success:(void(^)(NSArray *Intersection))success
                  failure:(void(^)(NSString *error))failure
{
    NSString *urlStr = [self getUrlString:@"getIntInfo.json"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"points"] = points;
    [WCHTTPTool POST:urlStr parameters:dic success:^(id responseObject) {
        NSString *retMessage = responseObject[@"retMessage"];
        if ([retMessage isEqualToString:@"success"]) {
            
            NSArray *resultArr = [WCIntersectionInfo mj_objectArrayWithKeyValuesArray:responseObject[@"result"]];
            if (success) {
                success(resultArr);
            }
        }else{
            [WCPhoneNotification autoHideWithText:@"请求失败，请重试"];
        }
        
    } failure:^(NSError *error) {
        [WCPhoneNotification autoHideWithText:@"请求失败，请重试"];
        if (failure) {
            failure(error.domain);
        }
    }];
}
/**
 *  设置为常用路线
 *
 *  @param userDic 参数列表
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)setLineInfo:(NSDictionary *)dic
            success:(void(^)(NSString *success))success
            failure:(void(^)(NSString *error))failure
{
    NSString *urlStr = [self getUrlString:@"setLineInfo.json"];
    
    [WCHTTPTool POST:urlStr parameters:dic success:^(id responseObject) {
        NSString *retMessage = responseObject[@"retMessage"];
        if ([retMessage isEqualToString:@"success"]) {
            
            if (success) {
                success(retMessage);
                
                //缓存常用路线的信息
                [WCDataBaseTool saveLineInfoWithLineInfo:[WCLineInfo mj_objectWithKeyValues:dic]];
            }
        }else{
            [WCPhoneNotification autoHideWithText:@"请求失败，请重试"];
        }
        
    } failure:^(NSError *error) {
        [WCPhoneNotification autoHideWithText:@"请求失败，请重试"];
        if (failure) {
            failure(error.domain);
        }
    }];
}

/**
 *  查询当前用户已设置的常用路线（常用路线由于不经常修改，因此在业务层需要缓存，仅在系统启动时从数据库初始化，后面新增时同时刷新缓存与数据库）
 *
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)getLineInfoWithsuccess:(void(^)(NSArray *success))success
                       failure:(void(^)(NSString *error))failure
{
    //先去本地数据查询
    NSArray *lineArr = [WCDataBaseTool getlineInfo];
    if (lineArr.count) {
        if (success) {
            success(lineArr);
        }
        return;
    }
    
    NSString *urlStr = [self getUrlString:@"getLineInfo.json"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"account"] = [kDefaults objectForKey:kAccount];
    [WCHTTPTool GET:urlStr parameters:dic success:^(id responseObject) {
        
        NSString *retMessage = responseObject[@"retMessage"];
        if ([retMessage isEqualToString:@"success"]) {
            
            NSArray *resultArr = [WCLineInfo mj_objectArrayWithKeyValuesArray:responseObject[@"result"]];
            
            if (success) {
                success(resultArr);
            }
            
            //把常用路线保存到数据库(其实这个地方，永远不会来啊，因为前面肯定会取到数据的啊)
            for (NSInteger i = 0; i < resultArr.count; i ++)
            {
                [WCDataBaseTool saveLineInfoWithLineInfo:resultArr[i]];
            }
            
        }else{
            [WCPhoneNotification autoHideWithText:@"请求失败，请重试"];
        }
        
    } failure:^(NSError *error) {
        [WCPhoneNotification autoHideWithText:@"请求失败，请重试"];
        if (failure) {
            failure(error.domain);
        }
    }];
}

/**
 *  相位设置
 *
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)getStageInfoWithIntersections:(NSString *)intersections
                              success:(void(^)(NSArray *setting))success
                              failure:(void(^)(NSString *error))failure
{
    //先从数据库里去取
//    NSArray *resultArr = [WCDataBaseTool getStageWithInterSection:intersections];
//    if (resultArr.count) {
//    
//        if (success) {
//            
//            success(resultArr);
//        }
//        return;
//    }
    NSString *urlStr = [self getUrlString:@"getStageInfo.json"];
    urlStr = [urlStr stringByAppendingFormat:@"?account=%@&intersections=%@", [kDefaults objectForKey:kAccount], intersections];
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    dic[@"account"] = [kDefaults objectForKey:kAccount];
//    dic[@"intersections"] = intersections;
    [WCHTTPTool GET:urlStr parameters:nil success:^(id responseObject) {
        
        NSString *retMessage = responseObject[@"retMessage"];
        if ([retMessage isEqualToString:@"success"]) {
        
            NSArray *settingArr = [WCStageSetting mj_objectArrayWithKeyValuesArray:responseObject[@"result"]];
            
            if(success){
                success(settingArr);
            }
            
//            //保存相位信息
//            [WCDataBaseTool saveStageWithInterSection:intersections withArray:settingArr];
        
        }else{
            [WCPhoneNotification autoHideWithText:@"请求失败，请重试"];
        }
    } failure:^(NSError *error) {
        [WCPhoneNotification autoHideWithText:@"请求失败，请重试"];
        if (failure) {
            failure(error.domain);
        }
    }];
}

/**
 *  保存或者执行任务
 *
 *  @param dic     参数列表
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)saveTaskWith:(NSMutableDictionary *)dic
             success:(void(^)(WCTaskInfo *info))success
             failure:(void(^)(NSString *error))failure
{
    NSString *urlStr = [self getUrlString:@"saveTask.json"];
    [WCHTTPTool GET:urlStr parameters:dic success:^(id responseObject) {
        
        NSString *retMessage = responseObject[@"retMessage"];
        if ([retMessage isEqualToString:@"success"]) {
        
            WCTaskInfo *info = [WCTaskInfo mj_objectWithKeyValues:responseObject[@"result"]];
            if (success) {
                success(info);
            }
        }else{
            [WCPhoneNotification autoHideWithText:@"操作失败，请重试"];
        }
        
    } failure:^(NSError *error) {
        [WCPhoneNotification autoHideWithText:@"请求失败，请重试"];
        if (failure) {
            failure(error.domain);
        }
    }];
    
}

/**
 *  查询当前用户任务信息（该页面在不同任务状态间切换时移动端需要缓存，避免频率调用后台接口）
 *
 *  @param parameters 参数
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)getTaskInfoWithParameters:(NSMutableDictionary *)parameters
                          success:(void(^)(WCPage *page, NSArray *success))success
                          failure:(void(^)(NSString *error))failure
{
    NSString *urlStr = [self getUrlString:@"getTaskInfo.json"];
    [WCHTTPTool GET:urlStr parameters:parameters success:^(id responseObject) {
        NSString *retMessage = responseObject[@"retMessage"];
        if ([retMessage isEqualToString:@"success"]) {
            
            WCPage *page = [WCPage mj_objectWithKeyValues:responseObject[@"page"]];
            NSArray *resultArr = [WCTaskInfo mj_objectArrayWithKeyValuesArray:responseObject[@"result"]];
            if (success) {
                success(page, resultArr);
            }
        }else{
            
            if (success) {
                success(nil, nil);
            }
            [WCPhoneNotification autoHideWithText:@"请求失败，请重试"];
        }
        
    } failure:^(NSError *error) {
        
        [WCPhoneNotification autoHideWithText:@"请求失败，请重试"];
        if (failure) {
            failure(error.domain);
        }
    }];
}

/**
 *  执行任务接口
 *
 *  @param parameters 参数列表
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)executeTaskWithParameters:(NSMutableDictionary *)parameters
                          success:(void(^)(NSString *success))success
                          failure:(void(^)(NSString *error))failure
{
    NSString *urlStr = [self getUrlString:@"executeTask.json"];
    [WCHTTPTool GET:urlStr parameters:parameters success:^(id responseObject) {
        NSString *retMessage = responseObject[@"retMessage"];
        if ([retMessage isEqualToString:@"success"]) {
        
            if (success) {
                success(retMessage);
            }
        }else{
            [WCPhoneNotification autoHideWithText:@"请求失败，请重试"];
        }
    } failure:^(NSError *error) {
        [WCPhoneNotification autoHideWithText:@"请求失败，请重试"];
        if (failure) {
            failure(error.domain);
        }
    }];
}

/**
 *  中途停止任务
 *
 *  @param parameters 参数列表
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)finishTaskWithParameters:(NSMutableDictionary *)parameters
                         success:(void(^)(NSString *success))success
                         failure:(void(^)(NSString *error))failure
{
    NSString *urlStr = [self getUrlString:@"finishTask.json"];
    [WCHTTPTool GET:urlStr parameters:parameters success:^(id responseObject) {
        NSString *retMessage = responseObject[@"retMessage"];
        if ([retMessage isEqualToString:@"success"]) {
            
            if (success) {
                success(retMessage);
            }
        }else{
            [WCPhoneNotification autoHideWithText:@"操作失败，请重试"];
        }
    } failure:^(NSError *error) {
        [WCPhoneNotification autoHideWithText:@"请求失败，请重试"];
        if (failure) {
            failure(error.domain);
        }
    }];
}

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
                            failure:(void(^)(NSString *error))failure
{
    NSString *urlStr = [self getUrlString:@"getTaskStatus.json"];
    [WCHTTPTool GET:urlStr parameters:parameters success:^(id responseObject) {
        NSString *retMessage = responseObject[@"retMessage"];
        if ([retMessage isEqualToString:@"success"]) {
            
            NSArray *resultArr =[WCTaskStatus mj_objectArrayWithKeyValuesArray:responseObject[@"result"]];
            if (success) {
                success(resultArr);
            }
        }else{
            [WCPhoneNotification autoHideWithText:@"发送当前位置信息失败"];
        }
    } failure:^(NSError *error) {
        [WCPhoneNotification autoHideWithText:@"发送当前位置信息失败"];
        if (failure) {
            failure(error.domain);
        }
    }];
}

/**
 *  任务统计(可以按照日、周、月、年等不同统计周期进行统计)
 *
 *  @param parameters 参数
 *  @param success    成功
 *  @param failure    失败
 */
+ (void)getTaskStatWithParameters:(NSMutableDictionary *)parameters
                          success:(void(^)(NSArray *success))success
                          failure:(void(^)(NSString *error))failure
{
//    //先从本地缓存池去取
//    NSArray *dataArr = [WCDataBaseTool getStatisticsWithDic:parameters];
//    if (dataArr.count) {
//        if (success) {
//            success(dataArr);
//        }
//        return;
//    }
    
    NSString *urlStr = [self getUrlString:@"getTaskStat.json"];
    [WCHTTPTool GET:urlStr parameters:parameters success:^(id responseObject) {
        
        NSString *retMessage = responseObject[@"retMessage"];
        if ([retMessage isEqualToString:@"success"]) {
            
            NSArray *resultArr =[WCTaskStat mj_objectArrayWithKeyValuesArray:responseObject[@"result"]];
            //保存到数据库
//            [WCDataBaseTool saveStatisticsWithArr:responseObject[@"result"] withDic:parameters];
            
            if (success) {
                success(resultArr);
            }
        }else{
            [WCPhoneNotification autoHideWithText:@"请求失败，请重试"];
        }
    } failure:^(NSError *error) {
        [WCPhoneNotification autoHideWithText:@"请求失败，请重试"];
        if (failure) {
            failure(error.domain);
        }
    }];
}

/**
 *  获取所有的信控点
 *
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)getIntersections
{
    NSString *urlStr = [self getUrlString:@"getIntList.json"];
    [WCHTTPTool GET:urlStr parameters:nil success:^(id responseObject) {
        
        NSString *retMessage = responseObject[@"retMessage"];
        if ([retMessage isEqualToString:@"success"]) {
            
            NSDictionary *resultDic = responseObject[@"result"];
            [kDefaults setObject:resultDic forKey:kInterSection];
            [kDefaults synchronize];
            
        }else{
            [WCPhoneNotification autoHideWithText:@"请求失败，请重试"];
        }
    } failure:^(NSError *error) {
        [WCPhoneNotification autoHideWithText:@"请求失败，请重试"];
    }];
}

/**
 *  检测是否有任务正在执行中
 *
 *  @param result 结果
 */
+ (void)isTaskExecution:(void(^)(BOOL isYES))result
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"account"] = [kDefaults objectForKey:kAccount];
    dic[@"pageIndex"] = @1;
    dic[@"pageRecords"] = @10;
    dic[@"status"] = @(1);
    
    [self getTaskInfoWithParameters:dic success:^(WCPage *page, NSArray *success) {
        
        if (success.count > 0) {
            
            if (result) {
                result(YES);
            }
            
        }else{
            
            if (result) {
                result(NO);
            }
        }
        
    } failure:^(NSString *error) {
        
        if (result) {
            result(YES);
        }
    }];
}

/**
 *  获取urlstr
 *
 *  @param suffixStr 后缀
 *
 *  @return 完整的urlstr
 */
+ (NSString *)getUrlString:(NSString *)suffixStr
{
    return kStringWithFormat(@"%@/%@",kBaseUrl,suffixStr);
}

@end
