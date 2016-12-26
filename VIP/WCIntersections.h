//
//  WCIntersections.h
//  VIP
//
//  Created by 万存 on 16/4/6.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface WCIntersections : NSObject<MJKeyValue>

//"intersectionId": "103144",
//"intersectionName": "北门路/环庆路",
//"lat": 31.412394,
//"lon": 120.951164,
//"status": 1,
//"taskId": -1
@property (nonatomic, copy) NSString * intersectionId ;

@property (nonatomic ,copy) NSString  *intersectionName ;

@property (nonatomic ,assign)double lat ;

@property (nonatomic ,assign)double lon ;

@property (nonatomic ,assign)NSInteger status ;

@property (nonatomic ,assign)NSInteger taskId;

+(NSDictionary *)getAllInteractions;

@end
