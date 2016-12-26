//
//  WCRoute.h
//  VIP
//
//  Created by 万存 on 16/4/13.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WCRouteSegment.h"
typedef NS_ENUM(NSInteger , RouteGenerateType){
    RouteGenerateType_Automatic =0,
    RouteGenerateType_Customed  =1,
    RouteGenerateType_Choosing  =2
    
};
@interface WCRoute : WCRouteSegment<NSCoding>


//纪录自己选择的地图上信控点
@property (nonatomic,strong) NSMutableArray * mapAnnotionArr;

//经过的途径点（包含起点，终点）
@property (nonatomic,strong) NSMutableArray * annotionsOnRoutes ;
//途经点数目 该值依赖annotionsOnRoutes 的存在。 不可直接赋值操作
@property (nonatomic,assign) NSInteger intersectionCount ;

//路线的时间与距离。 注意： 自定义模式的时间和距离需要根据路线segments 获取。
@property (nonatomic,assign) NSInteger  routeTime ;
@property (nonatomic,assign) CGFloat    routeLength;

//路线截屏
@property (nonatomic,strong) UIImage * screenShotImage ;

//相位详细转向。
@property (nonatomic,strong) NSMutableArray * routeTurnings ;

@property (nonatomic,assign) RouteGenerateType  type ;
@end
