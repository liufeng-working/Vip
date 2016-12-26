//
//  WCDataSolver.h
//  VIP
//
//  Created by 万存 on 16/4/18.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCDataSolver : NSObject

//信控路口编号转字符串
+(NSString *)intersectionsStringFromArray:(NSMutableArray *) arr ;
//路口名数组
+(NSMutableArray*)turningsFromArray:(NSMutableArray *) arr ;
//路口转向id
+(NSString*)turningIDFromArray:(NSMutableArray *) arr ;
//programeid 数组
+(NSString *)programeIDFromArray :(NSMutableArray *) arr ;

//路线上所有的导航点。。
+(NSString *)mapNaviPointFromArray:(NSMutableArray *) arr ;

+(NSString *)mapAllNaviPointFromArray:(NSMutableArray *)arr ;


//内部MAMapAnnotion模型 方法一样。。。
//+(NSString *)intersectionsStringFrom_MA_Array:(NSMutableArray *)arr ;
+(NSString *)interNameStringFrom_MA_Array:(NSMutableArray *)arr ;



//把经纬度的字符串转化为对象数组
+(NSMutableArray *) routeSegmentsFromString:(NSString *) str ;


+(NSString *)nameArrFromArr:(NSMutableArray *)arr ;

+(NSString *)subNameArrFromArr:(NSMutableArray *)arr ;

+(NSMutableArray *)myMApointAnnotionsFromString:(NSString *)str ;
@end
