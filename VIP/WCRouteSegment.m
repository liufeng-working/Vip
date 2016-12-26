//
//  WCRouteSegment.m
//  VIP
//
//  Created by 万存 on 16/4/13.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WCRouteSegment.h"
#import "MJExtension.h"

@implementation WCRouteSegment

MJCodingImplementation

-(NSMutableArray *)routeSegments{
    if (!_routeSegments) {
        _routeSegments = [NSMutableArray array] ;
    }
    return _routeSegments ;
}
-(NSMutableArray *)routeTimeSegments{
    if (!_routeTimeSegments) {
        _routeTimeSegments = [NSMutableArray array] ;
    }
    return _routeTimeSegments;
}
-(NSMutableArray *)routeLenthSegments{
    if (!_routeLenthSegments) {
        _routeLenthSegments = [NSMutableArray array];
    }
    return _routeLenthSegments ;
}
-(NSMutableArray *) annotionsOnRouteSegments{
    if (!_annotionsOnRouteSegments) {
        _annotionsOnRouteSegments = [NSMutableArray array] ;
    }
    return _annotionsOnRouteSegments ;
}
@end
