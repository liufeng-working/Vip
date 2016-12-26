//
//  WCIntersections.m
//  VIP
//
//  Created by 万存 on 16/4/6.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WCIntersections.h"
#import "WCHTTPRequest.h"
@implementation WCIntersections

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID":@"id"};
}

//- (void)setLon:(double)lon
//{
//    _lon = [kStringWithFormat(@"%.10f",lon) doubleValue];
//    
//}
//
//-(void)setLat:(double)lat
//{
//    _lat = [kStringWithFormat(@"%.10f",lat) doubleValue];
//}

+(NSDictionary *)getAllInteractions{
    
//    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"intersections" ofType:@"json"];
//    NSData * jsonData = [NSData dataWithContentsOfFile:filePath] ;
//    
//    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];


    return [kDefaults objectForKey:kInterSection];
}
@end
