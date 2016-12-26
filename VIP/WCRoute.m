//
//  WCRoute.m
//  VIP
//
//  Created by 万存 on 16/4/13.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WCRoute.h"
#import "MJExtension.h"
#import "WCIntersectionInfo.h"
@implementation WCRoute

//序列化/反序列化
MJCodingImplementation

-(NSMutableArray *)mapAnnotionArr{
    if (!_mapAnnotionArr) {
        _mapAnnotionArr = [NSMutableArray array];
    }
    return _mapAnnotionArr;
}

-(NSMutableArray *) routeTurnings{
    if (!_routeTurnings) {
        _routeTurnings = [NSMutableArray array];
    }
    return _routeTurnings ;
}
-(NSInteger)intersectionCount{
    NSInteger count = 0 ;
    for (NSArray * arr in self.annotionsOnRouteSegments) {
        count+=arr.count ;
    }
    return count -self.annotionsOnRouteSegments.count+ 1 ;
}
-(NSMutableArray *)annotionsOnRoutes{
    
    NSMutableArray * annos = [NSMutableArray array] ;
    
    //    在自定义的路线上，通过的信控路口包含起始点和终点
    for (int i = 0; i<self.annotionsOnRouteSegments.count; i++) {
        NSMutableArray * arrInseg =self.annotionsOnRouteSegments [i] ;
//        防止原来数组被改动
        NSMutableArray * arr =[NSMutableArray arrayWithArray:arrInseg] ;
        //        RouteGenerateType_Choosing 不用移除第一个元素
        if (i>=1&&self.type!=RouteGenerateType_Choosing) {
            [arr removeObjectAtIndex:0];
        }
        [annos addObjectsFromArray:arr];
        
    }
    return annos ;

    
}
@end
