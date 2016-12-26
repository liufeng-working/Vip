//
//  WCDataSolver.m
//  VIP
//
//  Created by 万存 on 16/4/18.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WCDataSolver.h"
#import "WCMAPointAnnotion.h"
#import "WCStageList.h"
#import "WCStageSetting.h"
#import <AMapNaviKit/AMapNaviKit.h>
#import <AMapNaviKit/MAPointAnnotation.h>
#import "WCIntersectionInfo.h"
#import "WCIntersections.h"
#import "MyMAPointAnnotation.h"
@implementation WCDataSolver

//+(NSString *)intersectionsStringFrom_MA_Array:(NSMutableArray *)arr{
//    NSMutableArray * IDArr = [NSMutableArray array] ;
//    for (MAPointAnnotation * p in arr) {
//        [IDArr addObject:p.subtitle] ;
//    }
//    NSString * IDString = [IDArr componentsJoinedByString:@","] ;
//    
//    return IDString ;
//}
+(NSString *)interNameStringFrom_MA_Array:(NSMutableArray *)arr{
    NSMutableArray * nameArr = [NSMutableArray array] ;
    for (MAPointAnnotation * p in arr) {
        [nameArr addObject:p.title] ;
    }
    NSString * nameString = [nameArr componentsJoinedByString:@","] ;
    
    return nameString ;
}
+(NSString *)intersectionsStringFromArray:(NSMutableArray *)arr{
    NSMutableArray * IDArr = [NSMutableArray array] ;
    for (WCIntersectionInfo * p in arr) {
        [IDArr addObject:@(p.intersectionId)] ;
    }
    NSString * IDString = [IDArr componentsJoinedByString:@","] ;
    
    return IDString ;
}
+(NSMutableArray*)turningsFromArray:(NSMutableArray *) arr{
    NSMutableArray * offsetTurnings = [NSMutableArray array] ;
    for (WCStageList *list in arr) {
        
        [offsetTurnings addObject:list.stageName==nil?@"":list.stageName] ;
    }
    return offsetTurnings ;

}
+(NSString*)turningIDFromArray:(NSMutableArray *) arr{
    NSMutableArray * offsetIDs = [NSMutableArray array] ;
    for (WCStageList *list in arr) {
        [offsetIDs addObject:list.stageId==nil?@"":list.stageId] ;
    }
    NSString * offsetIDString = [offsetIDs componentsJoinedByString:@","] ;
    return offsetIDString ;
    
}
+(NSString *)programeIDFromArray:(NSMutableArray *)arr{
    NSMutableArray *programIDArr = [NSMutableArray array] ;
    for (WCStageSetting * setting in arr) {
        [programIDArr addObject:setting.programId==nil?@"":setting.programId] ;
    }
    NSString * programeString = [programIDArr componentsJoinedByString:@","] ;
    
    return programeString ;
}
+(NSString *)mapNaviPointFromArray:(NSMutableArray *)arr{
    NSMutableArray * naviPoints = [NSMutableArray array] ;

        for (AMapNaviPoint * p in arr) {
            [naviPoints addObject:@(p.latitude)] ;
            [naviPoints addObject:@(p.longitude)];
        
    }
    NSString * naviString = [naviPoints componentsJoinedByString:@","] ;
    return naviString ;
}
+(NSString *)mapAllNaviPointFromArray:(NSMutableArray *)arr{
    NSMutableArray * naviPoints = [NSMutableArray array] ;
    for (NSArray * pArr in arr) {
        for (AMapNaviPoint * p in pArr) {
            [naviPoints addObject:@(p.latitude)] ;
            [naviPoints addObject:@(p.longitude)];
            
        }
    }
  
    NSString * naviString = [naviPoints componentsJoinedByString:@","] ;
    return naviString ;
}
+(NSMutableArray *) routeSegmentsFromString:(NSString *) str {
    NSArray * arr =[str componentsSeparatedByString:@","] ;
    if (arr.count%2 != 0) {
        NSLog(@"+++++++++++++++经纬度不完整");
        return nil;
    }
    NSMutableArray * segmentsArray = [NSMutableArray array] ;
    for (int i = 0; i<arr.count-1; i++) {
        if (i%2 == 0) {
            CLLocationDegrees lat = [arr [i] doubleValue];
            CLLocationDegrees lon = [arr [i+1] doubleValue] ;
            AMapNaviPoint * p  =[AMapNaviPoint locationWithLatitude:lat longitude:lon] ;
            [segmentsArray addObject:p] ;
        }
    }
    
    return segmentsArray ;
    
}
+(NSString *)nameArrFromArr:(NSMutableArray *)arr{
    NSMutableArray * nameArr = [NSMutableArray array] ;
    for (WCIntersectionInfo * info in arr) {
        [nameArr addObject:info.intersectionName] ;
    }
    NSString * nameString = [nameArr componentsJoinedByString:@","] ;
    return nameString ;
}
+(NSString *)subNameArrFromArr:(NSMutableArray *)arr {
    NSMutableArray * IDs = [NSMutableArray array] ;
    for (WCIntersectionInfo * info in arr) {
        [IDs addObject:@(info.intersectionId)] ;
    }
    NSString * IDstring = [IDs componentsJoinedByString:@","] ;
    return IDstring ;
}
+(NSMutableArray *)myMApointAnnotionsFromString:(NSString *)str{
    NSDictionary * allDic = [WCIntersections getAllInteractions] ;
    NSArray * annos = [str componentsSeparatedByString:@","] ;
    NSMutableArray * myAnnos = [NSMutableArray array] ;
    for (NSString * ID in annos) {
        NSDictionary * valueDic = allDic[ID] ;
        MyMAPointAnnotation * myAnno = [MyMAPointAnnotation new] ;
        myAnno.coordinate=CLLocationCoordinate2DMake([valueDic[@"lat"] doubleValue], [valueDic[@"lon"] doubleValue]);
        myAnno.title = valueDic[@"intersectionName"];
        myAnno.ID = valueDic[@"intersectionId"];
        
        myAnno.status = [valueDic[@"status"] integerValue];
        [myAnnos addObject:myAnno] ;
    }
    
    return myAnnos ;
}
//"105102": {
//    "intersectionId": "105102",
//    "intersectionName": "柏庐路/萧林路",
//    "lat": 31.403603,
//    "lon": 120.96527,
//    "status": 1,
//    "taskId": -1
//},
@end
