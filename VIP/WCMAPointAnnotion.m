//
//  WCMAPointAnnotion.m
//  VIP
//
//  Created by 万存 on 16/4/18.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WCMAPointAnnotion.h"
#import <AMapNaviKit/MAPointAnnotation.h>
#import "MJExtension.h"
#import "WCIntersectionInfo.h"
#import "WCIntersections.h"
#import "MyMAPointAnnotation.h"
@implementation WCMAPointAnnotion

MJCodingImplementation

+(NSMutableArray *)modelTransformFrom:(NSMutableArray *)arr{
    NSMutableArray * wcPointArr = [NSMutableArray array] ;
    for (MyMAPointAnnotation * ann in arr) {
        WCMAPointAnnotion * p  =[WCMAPointAnnotion new] ;
        p.title = ann.title ;
        p.subtitle = ann.ID ;
        p.lat = ann.coordinate.latitude;
        p.lon = ann.coordinate.longitude ;
        [wcPointArr addObject:p] ;
    }
    return wcPointArr ;
}
+(NSMutableArray *)modelTransformTo:(NSMutableArray *)arr{
    NSMutableArray * maPointArr = [NSMutableArray array] ;
    NSDictionary *allDic = [WCIntersections getAllInteractions] ;
    for (WCIntersectionInfo  *wcp in arr) {
        NSString * key = [NSString stringWithFormat:@"%@",@(wcp.intersectionId)] ;
        NSDictionary * valueDic = allDic [ key];
        MyMAPointAnnotation *annotation = [[MyMAPointAnnotation alloc] init];
        annotation.coordinate = CLLocationCoordinate2DMake( [valueDic[@"lat"] doubleValue], [valueDic[@"lon"] doubleValue]);
        annotation.title    = valueDic[@"intersectionName"] ;
        annotation.ID = valueDic[@"intersectionId"] ;
        [maPointArr addObject:annotation] ;
    }
    return maPointArr ;
}
@end
