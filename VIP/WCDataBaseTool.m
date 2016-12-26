//
//  WCDataBaseTool.m
//  VIP
//
//  Created by NJWC on 16/4/14.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WCDataBaseTool.h"
#import "WCTaskStat.h"
#import "MJExtension.h"
#import "WCRoute.h"
#import "WCTaskId.h"
#import "WCLineInfo.h"
#import "WCStageSetting.h"

static FMDatabase *_db;
@implementation WCDataBaseTool

//只在类初始化时执行一次这个方法
+ (void)initialize
{
    NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/dataBase.sqlite"];
    _db = [FMDatabase databaseWithPath:path];
    
    if([_db open]){
        
        //数据统计的表
        BOOL statisticsResult=[_db executeUpdate:@"create table if not exists t_statistics (id integer primary key autoincrement, dic blob, url text,account text);"];
        if (statisticsResult) {
            NSLog(@"创建图形表成功");
        }else{
            NSLog(@"创建图形表失败");
        }
        
        //常用路线的表
        BOOL lineResult=[_db executeUpdate:@"create table if not exists t_lineInfo (id integer primary key autoincrement, lineInfo blob,account text);"];
        if (lineResult) {
            NSLog(@"创建常用路线表成功");
        }else{
            NSLog(@"创建常用路线表失败");
        }
        
        //相位的表
        BOOL stageResult=[_db executeUpdate:@"create table if not exists t_stage (id integer primary key autoincrement, stageSetting blob, intersection text, account text);"];
        if (stageResult) {
            NSLog(@"创建相位表成功");
        }else{
            NSLog(@"创建相位表失败");
        }
        
        //路线信息的表
        BOOL routeResult=[_db executeUpdate:@"create table if not exists t_routeMessage (id integer primary key autoincrement, route blob, taskId text, account text);"];
        if (routeResult) {
            NSLog(@"创建路线表成功");
        }else{
            NSLog(@"创建路线表失败");
        }
        
        //图片的表
        BOOL imageResult=[_db executeUpdate:@"create table if not exists t_image (id integer primary key autoincrement, image blob, taskId text,account text);"];
        if (imageResult) {
            NSLog(@"创建图片表成功");
        }else{
            NSLog(@"创建图片表失败");
        }
        
        //车牌号的表
        BOOL plateResult=[_db executeUpdate:@"create table if not exists t_plate (id integer primary key autoincrement, plate text, account text);"];
        if (plateResult) {
            NSLog(@"创建车牌号表成功");
        }else{
            NSLog(@"创建车牌号表失败");
        }
    }
}

/**
 *  保存表格的数据
 *
 *  @param dataArr 要保存的数据数组
 *  @param url     数据的标识
 */
+ (void)saveStatisticsWithArr:(NSArray *)dataArr withDic:(NSDictionary *)dic
{
    //增加缓存，提高效率
    [_db setShouldCacheStatements:YES];
    
    NSString *urlStr = [self getStringFromDic:dic];
    for (NSDictionary *dataDic in dataArr) {
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dataDic];
        
        //插入数据
        BOOL flag = [_db executeUpdate:@"insert into t_statistics (dic, url,account) values (?, ?, ?);", data, urlStr, [self getAccount]];
        if (flag) {
            NSLog(@"插入图表数据成功");
        }else{
            NSLog(@"插入图表数据失败");
        }
    }
}

/**
 *  获取缓存的表格数据
 *
 *  @param dic 根据参数去取
 *
 *  @return 符合要求的数据
 */
+ (NSArray *)getStatisticsWithDic:(NSDictionary *)dic
{
    //增加缓存，提高效率
    [_db setShouldCacheStatements:YES];
    
    NSString *urlStr = [self getStringFromDic:dic];
    
    NSMutableArray *dataArr = [NSMutableArray array];
    
    FMResultSet *set = [_db executeQuery:@"select * from t_statistics where url = ? and account = ?",urlStr, [self getAccount]];
    while ([set next]) {
        NSData *data = [set dataForColumnIndex:1];
        NSDictionary *dataDic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        WCTaskStat *taskStat = [WCTaskStat mj_objectWithKeyValues:dataDic];
        [dataArr addObject:taskStat];
        
        NSLog(@"取到缓存的图表数据了");
    }
    return dataArr;
}

/**
 *  保存常用路线信息
 */
+ (void)saveLineInfoWithLineInfo:(WCLineInfo *)lineInfo
{
    //增加缓存，提高效率
    [_db setShouldCacheStatements:YES];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:lineInfo];
    
    //插入数据
    BOOL flag = [_db executeUpdate:@"insert into t_lineInfo (lineInfo,account) values (?, ?);", data, [self getAccount]];
    if (flag) {
        NSLog(@"插入常用路线数据成功");
    }else{
        NSLog(@"插入常用路线数据失败");
    }
}

/**
 *  获取常用路线信息
 *
 *  @return 所有路线信息
 */
+ (NSArray *)getlineInfo
{
    
    //增加缓存，提高效率
    [_db setShouldCacheStatements:YES];
    
    NSMutableArray *dataArr = [NSMutableArray array];

    FMResultSet *set = [_db executeQuery:@"select * from t_lineInfo where account = ?",[self getAccount]];
    while ([set next]) {
        NSData *data = [set dataForColumnIndex:1];
        WCLineInfo *lineInfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [dataArr addObject:lineInfo];
        
        NSLog(@"取到缓存的常用路线数据了");
    }
    return dataArr;
}

/**
 *  保存相位信息
 *
 *  要保存的信息
 */
+ (void)saveStageWithInterSection:(NSString *)interSectionId withArray:(NSArray *)arr
{
    //增加缓存，提高效率
    [_db setShouldCacheStatements:YES];
    
    NSArray *intArr = [self getArrayFromString:interSectionId];
    
    for (NSInteger i = 0; i < intArr.count; i ++)
    {
        NSString *interSection = intArr[i];
        WCStageSetting *stageSetting = arr[i];
        
        //先判断数据库中有没有对应的这条数据，有的话就不用插入了
        NSArray *checkArr = [self getStageWithInterSection:interSection];
        if (checkArr.count != 0) {
            
            NSLog(@"存在的相位信息，不用重复插入");
            continue;
        }
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:stageSetting];
        
        //插入数据
        BOOL flag = [_db executeUpdate:@"insert into t_stage (stageSetting, intersection, account) values (?, ?, ?);", data, interSection, [self getAccount]];
        if (flag) {
            NSLog(@"插入相位数据成功");
        }else{
            NSLog(@"插入相位数据失败");
        }
    }
}

/**
 *  获取相位信息
 *
 *  @return 所有相位信息
 */
+ (NSArray *)getStageWithInterSection:(NSString *)interSectionId
{
    //增加缓存，提高效率
    [_db setShouldCacheStatements:YES];
    NSMutableArray *resultArr = [NSMutableArray array];
    NSArray *intArr = [self getArrayFromString:interSectionId];
    for (NSInteger i = 0; i < intArr.count; i ++)
    {
        NSString *interSection = intArr[i];
        FMResultSet *set = [_db executeQuery:@"select * from t_stage where intersection = ? and account = ?",interSection, [self getAccount]];
        while ([set next]) {
            NSData *data = [set dataForColumnIndex:1];
            WCStageSetting *stageSetting = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [resultArr addObject:stageSetting];
            NSLog(@"取到缓存的相位数据了");
        }
    }
    
    if (resultArr.count == intArr.count) {
        return resultArr;
    }else{
        return nil;
    }
}

+ (NSString*)getStringFromDic:(NSDictionary *)dic
{
    return [NSString stringWithFormat:@"%@-%@-%@-%@",dic[@"account"],dic[@"beginDate"],dic[@"endDate"],dic[@"period"]];  
}

+ (NSArray *)getArrayFromString:(NSString *)interSections
{
    return [interSections componentsSeparatedByString:@","];
}

//************************没用到*******************************
/**
 *  保存路线信息
 *
 *  @param route  路线
 *  @param taskId 任务id
 */
+ (void)saveRouteMessageWithRoute:(WCRoute *)route withTaskId:(NSInteger)taskId
{
    //增加缓存，提高效率
    [_db setShouldCacheStatements:YES];
    
    NSString *idStr = kStringWithFormat(@"%ld",(long)taskId);
    
    //插入数据
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:route];
    
    //插入数据
    BOOL flag = [_db executeUpdate:@"insert into t_routeMessage (route, taskId,account) values (?, ?, ?);", data, idStr, [self getAccount]];
    if (flag) {
        NSLog(@"保存路线数据成功");
    }else{
        NSLog(@"保存路线数据失败");
    }
    
    //保存截图
    [self saveImageWithImage:route.screenShotImage withTaskId:taskId];
    
}

/**
 *  获取路线信息
 *
 *  @param taskId 任务id
 */
+ (WCRoute *)getRouteMessageWithTaskId:(NSInteger)taskId
{
    //增加缓存，提高效率
    [_db setShouldCacheStatements:YES];
    
    NSString *idStr = kStringWithFormat(@"%ld",(long)taskId);
    WCRoute *route ;
    
    FMResultSet *set = [_db executeQuery:@"select * from t_routeMessage where taskId = ? and account = ?",idStr, [self getAccount]];
    while ([set next]) {
        
        //只要保留最后一个就可以了
        NSData *data = [set dataForColumnIndex:1];
        route = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        NSLog(@"取到缓存的路线数据了");
    }
    return route;
}
//************************没用到*******************************



/**
 *  保存截图
 *
 *  @param image 图片
 *
 *  @param taskId 任务id
 */
+ (void)saveImageWithImage:(UIImage *)image withTaskId:(NSInteger)taskId
{
    //增加缓存，提高效率
    [_db setShouldCacheStatements:YES];
    
    NSString *idStr = kStringWithFormat(@"%ld",(long)taskId);
    
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    
    //插入数据
    BOOL flag = [_db executeUpdate:@"insert into t_image (image, taskId, account) values (?, ?, ?);", data, idStr, [self getAccount]];
    if (flag) {
        NSLog(@"保存图片成功");
    }else{
        NSLog(@"保存图片失败");
    }
    
}

/**
 *  获取图片
 *
 *  @param taskId 任务id
 */
+ (UIImage *)getImageWithTaskId:(NSInteger)taskId
{
    //增加缓存，提高效率
    [_db setShouldCacheStatements:YES];
    
    NSString *idStr = kStringWithFormat(@"%ld",(long)taskId);
    UIImage *image;
    
    FMResultSet *set = [_db executeQuery:@"select * from t_image where taskId = ? and account = ?",idStr, [self getAccount]];
    while ([set next]) {
        NSData *data = [set dataForColumnIndex:1];
        image = [UIImage imageWithData:data];
        NSLog(@"取到图片了");
    }
    return image;
}

/**
 *  保存车牌号，要和账号绑定
 */
+ (void)savePlateWithPlate:(NSString *)plate
{
    //增加缓存，提高效率
    [_db setShouldCacheStatements:YES];

    if([self getPlate]){//如果有车牌号，更新
        
        BOOL flag = [_db executeUpdate:@"update t_plate set plate = ? where account = ?", plate, [self getAccount]];
        if (flag) {
            NSLog(@"更新车牌号成功");
        }else{
            NSLog(@"更新车牌号失败");
        }
        
    }else{//如果没有车牌号，插入
        //插入数据
        BOOL flag = [_db executeUpdate:@"insert into t_plate (plate, account) values (?, ?)", plate, [self getAccount]];
        if (flag) {
            NSLog(@"保存车牌号成功");
        }else{
            NSLog(@"保存车牌号失败");
        }
    }
}

/**
 *  获取车牌号
 */
+ (NSString *)getPlate
{
    //增加缓存，提高效率
    [_db setShouldCacheStatements:YES];
    
    NSString *plate;
    
    FMResultSet *set = [_db executeQuery:@"select * from t_plate where account = ?", [self getAccount]];
    while ([set next]) {
        plate = [set stringForColumnIndex:1];

        NSLog(@"取到车牌号了");
    }
    
    return plate;
}

+ (NSString *)getAccount
{
    return [kDefaults objectForKey:kAccount];
}
@end
