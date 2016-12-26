//
//  WCRouteSegment.h
//  VIP
//
//  Created by 万存 on 16/4/13.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCRouteSegment : NSObject<NSCoding>


@property (nonatomic ,strong) NSMutableArray * routeSegments ;

//纪录自定义路线的每段时间与距离
@property (nonatomic,strong) NSMutableArray * routeTimeSegments ;
@property (nonatomic,strong) NSMutableArray * routeLenthSegments ;


//途径的所有信控点ID .
@property (nonatomic,strong) NSMutableArray * annotionsOnRouteSegments  ;
@end
