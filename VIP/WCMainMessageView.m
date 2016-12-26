//
//  WCMainMessageView.m
//  VIP
//
//  Created by NJWC on 16/3/23.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WCMainMessageView.h"
#import "WCBasicMessageView.h"
#import "WCExtraView.h"
#import "WCSelectLineView.h"
#import "WCResetAndRevokeView.h"
#import "WCLineMessageView.h"
#import "WCBigAndSmallView.h"
#import "WCRoadLineView.h"
#import "WCCarMessageView.h"
#import "WCControView.h"

/*
 *地图头文件
 */
#import <AMapNaviKit/MAMapKit.h>
#import <AMapNaviKit/AMapNaviKit.h>
#import "NavPointAnnotation.h"
/*
 *
 */
/*
 *相位设置
 */
#import "OffsetTableView.h"
typedef NS_ENUM(NSInteger, TravelTypes)
{
    TravelTypeCar = 0,      // 驾车方式
    TravelTypeWalk,         // 步行方式
};
typedef NS_ENUM(NSInteger, NavigationTypes)
{
    NavigationTypeNone = 0,
    NavigationTypeSimulator, // 模拟导航
    NavigationTypeGPS,       // 实时导航
};
//智能导航还是自定义导航
typedef NS_ENUM(NSInteger , RouteGenerateType){
    RouteGenerateType_Automatic =0,
    RouteGenerateType_Customed  =1,
    
};

@interface WCMainMessageView () <MAMapViewDelegate,WCSelectLineViewDelegate,AMapNaviManagerDelegate>
/*
 *  for WCMainViewTypeLine (地图界面)
 */
@property (nonatomic ,strong) MAMapView * mapView ;
//点击手势
@property (nonatomic ,strong) UITapGestureRecognizer * mapTapGsture ;
//交通方式
@property (nonatomic ,assign) TravelTypes travelType;
//导航方式
@property (nonatomic ,assign) NavigationTypes naviType;
//路线生成方式
@property (nonatomic ,assign) RouteGenerateType routeGenerateType ;
//导航管理类
@property (nonatomic, strong) AMapNaviManager *naviManager;
//用户位置
@property (nonatomic ,strong) AMapNaviPoint * userLocation ;
//智能选择终点
@property (nonatomic ,strong) AMapNaviPoint * endPoint ;
//智能导航终点标记
@property (nonatomic ,strong) NavPointAnnotation * endPointAnnotation ;

//途径点数组
@property (nonatomic ,strong) NSMutableArray * wayNaviPointArr;
//途径点标记数组
@property (nonatomic ,strong) NSMutableArray * wayNavPointAnnotationArr;



/*
 *
 */
@end

@implementation WCMainMessageView

-(void)dealloc{
    _mapView .delegate = nil ;
    [_mapView removeFromSuperview ];
    _naviManager .delegate = nil ;
}

-(instancetype)initWithFrame:(CGRect)frame withType:(WCMainViewType)mainViewType
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.mainViewType = mainViewType;
        self.travelType   = TravelTypeCar ;
        self.routeGenerateType = RouteGenerateType_Automatic ;
        [self initTapGesture] ;
    }
    return self;
}

-(void)settingViewStyle
{
    __weak typeof(self) weakSelf   =self ;

    dispatch_async(dispatch_get_main_queue(), ^{
        switch (weakSelf.mainViewType) {
            case WCMainViewTypeBasic:
                [weakSelf basicView];
                break;
            case WCMainViewTypeLine:
                [weakSelf lineView];
                break;
            case WCMainViewTypePhase:
                [weakSelf phaseView];
                break;
            case WCMainViewTypeContro:
                [weakSelf controView];
                break;
                
            default:
                break;
        }

    });
}

-(void)basicView
{
//    for (id obj in self.subviews) {
//        [obj removeFromSuperview];
//    }
  
    WCBasicMessageView * basicView = [WCBasicMessageView basicMessageViewWithFrame:CGRectMake(bMainViewAndTabDis, bMainViewAndNavDis, kContentWidth - 2 * bMainViewAndTabDis, 245)];
    [self addSubview:basicView];
    
    
    //附件
    WCExtraView * extraView = [WCExtraView extraViewWithFrame:CGRectMake(bMainViewAndTabDis, bMainViewAndNavDis + basicView.bottom, kContentWidth - 2 * bMainViewAndTabDis, 280)];
    [self addSubview:extraView];
}

-(void)lineView
{
    
//    for (id obj in self.subviews) {
//        [obj removeFromSuperview];
//    }
//    地图初始化
    [self loadMapView] ;
    
    WCSelectLineView * selectView = [WCSelectLineView selectLineViewWithFrame:CGRectMake(bLineSelectAndTabDis, bLineSelectAndNavDis, 122.5 + 122.5 + 120, 50)];
    selectView.delegate  =self ;
    [self addSubview:selectView];
    
    CGFloat rrW = 93 + 92;
    WCResetAndRevokeView * rrView = [WCResetAndRevokeView resetAndRevokeViewWithFrame:CGRectMake(kContentWidth - rrW - bResetAndRightDis, bResetAndNavDis, rrW, 50)];
    [self addSubview:rrView];
    
    CGFloat lmH = 145;
    CGFloat lmW = 280;
    for (NSInteger i = 0; i < 3; i ++)
    {
        WCLineMessageView * lineMessageView = [WCLineMessageView lineMessageViewWithFrame:CGRectMake(bLineMessageAndTabDis + (lmW + bLineMessageDistance) * i, kMainViewHeight - lmH - bLineMessageAndBottomDis, lmW, lmH)];
        [self addSubview:lineMessageView];
    }
    
    CGFloat bsW = 50;
    CGFloat bsH = (101 + 109) / 2.0;
    WCBigAndSmallView * bigAndSmallView = [WCBigAndSmallView bigAndSmallViewWithFrame:CGRectMake(kMainViewWidth - bsW - bResetAndRightDis , kMainViewHeight - bsH - bLineMessageAndBottomDis, bsW, bsH)];
    [self addSubview:bigAndSmallView];
}
#pragma  mark -- 初始化地图
-(void)loadMapView{
    _mapView = [[MAMapView alloc]initWithFrame:CGRectMake(0,
                                                          0,
                                                          kMainViewWidth,
                                                          kMainViewHeight)
                                                        ];
    _mapView.delegate =self ;
    _mapView.showsUserLocation =YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    [_mapView setZoomLevel:14 animated:YES];
    [self  addSubview:_mapView];
    _mapView.tag = 3 ;
    
    [_mapView addGestureRecognizer:_mapTapGsture] ;

}

#pragma  mark -- setter-getter
-(AMapNaviManager *)naviManager{
    if (!_naviManager) {
        _naviManager = [AMapNaviManager new] ;
        _naviManager.delegate = self;
    }
    return  _naviManager;
}
-(NSMutableArray *)wayNaviPointArr{
    if (!_wayNaviPointArr) {
        _wayNaviPointArr = [NSMutableArray array];
    }
    return _wayNaviPointArr;
}
-(NSMutableArray *)wayNavPointAnnotationArr{
    if (!_wayNavPointAnnotationArr) {
        _wayNavPointAnnotationArr = [NSMutableArray array] ;
    }
    return _wayNavPointAnnotationArr ;
}

#pragma  mark -- 初始化手势

-(void)initTapGesture{
    _mapTapGsture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                 action:@selector(handleSingleTap:)];
}
#pragma  mark -- 初始化终点标示
-(NavPointAnnotation *)endPointAnnotation{
    if (!_endPointAnnotation ) {
        _endPointAnnotation = [NavPointAnnotation new];
    }
    return _endPointAnnotation;
}
#pragma mark -- 手势事件
-(void) handleSingleTap :(UITapGestureRecognizer *)tapGesture{
    
    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:[tapGesture locationInView:self.mapView]
                                              toCoordinateFromView:self.mapView];
    if (self.routeGenerateType ==RouteGenerateType_Automatic) {
        _endPoint = [AMapNaviPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
// 移除上一个标记点
        [_mapView removeAnnotation:_endPointAnnotation] ;
        
        [self.endPointAnnotation setCoordinate:coordinate];
        self.endPointAnnotation.title        = @"终点";
        self.endPointAnnotation.navPointType = NavPointAnnotationEnd;
        [_mapView addAnnotation:self.endPointAnnotation];
        
        [self drawOverLayer];

        
    }else if (self.routeGenerateType == RouteGenerateType_Customed){
        if (self.wayNaviPointArr.count>=5) {
            [self.wayNaviPointArr removeObjectAtIndex:0];
        }
        
        AMapNaviPoint *wayPoint = [AMapNaviPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        [self.wayNaviPointArr addObject:wayPoint];
        
        NavPointAnnotation *wayAnnotation = [[NavPointAnnotation alloc] init];
        [wayAnnotation setCoordinate:coordinate];
        wayAnnotation.title        = @"途径点";
        wayAnnotation.navPointType = NavPointAnnotationEnd;
        [self.wayNavPointAnnotationArr addObject:wayAnnotation];
        [self.mapView addAnnotation:wayAnnotation];
        
        [self drawOverLayer];

    }

}
#pragma mark -- 计算规划路线的参数
-(void)drawOverLayer{
    NSArray *startPoints = @[_userLocation];
    NSArray *endPoints;
    NSMutableArray * wayPoints;
    if (self.routeGenerateType ==RouteGenerateType_Automatic) {
        endPoints = @[_endPoint];
    }else if (self.routeGenerateType == RouteGenerateType_Customed){
        startPoints=@[_wayNaviPointArr.firstObject];
        endPoints =@[_wayNaviPointArr.lastObject];
        wayPoints = [_wayNaviPointArr mutableCopy];
        [wayPoints removeLastObject];
    }
   
    
    if (self.travelType == TravelTypeCar) {
        [self.naviManager calculateDriveRouteWithStartPoints:startPoints endPoints:endPoints wayPoints:wayPoints drivingStrategy:0];
        
    }else{
        [self.naviManager calculateWalkRouteWithStartPoints:startPoints endPoints:endPoints];
    }
    
}
#pragma  mark -- 地图代理
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    NSLog(@"用户位置");
    _userLocation = [AMapNaviPoint locationWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
    [self.wayNaviPointArr addObject:_userLocation] ;
    
}
-(MAAnnotationView * )mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    if ([annotation isKindOfClass:[NavPointAnnotation class]])
    {
        static NSString *annotationIdentifier = @"annotationIdentifier";
        
        MAPinAnnotationView *pointAnnotationView = (MAPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
        if (pointAnnotationView == nil)
        {
            pointAnnotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation
                                                                  reuseIdentifier:annotationIdentifier];
        }
        
        pointAnnotationView.animatesDrop   = NO;
        pointAnnotationView.canShowCallout = NO;
        pointAnnotationView.draggable      = NO;
        
        NavPointAnnotation *navAnnotation = (NavPointAnnotation *)annotation;
        
        if (navAnnotation.navPointType == NavPointAnnotationStart)
        {
            [pointAnnotationView setPinColor:MAPinAnnotationColorGreen];
        }
        else if (navAnnotation.navPointType == NavPointAnnotationEnd)
        {
            [pointAnnotationView setPinColor:MAPinAnnotationColorRed];
        }else if (navAnnotation.navPointType == NavPointAnnotationWay)
        {
            [pointAnnotationView setPinColor:MAPinAnnotationColorPurple];
        }
        return pointAnnotationView;
    }else if ([annotation isKindOfClass:[MAUserLocation class]]){
        static NSString *userLocationStyleReuseIndetifier = @"userLocationStyleReuseIndetifier";
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:userLocationStyleReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:userLocationStyleReuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"icon_map_coordinate"];
        
        return annotationView;
    }
    
    return nil;
    

}
-(MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        
        polylineRenderer.lineWidth   = 4.f;
//        magentaColor
        polylineRenderer.strokeColor = [UIColor redColor];
        
        return polylineRenderer;
    }
    
    return nil;

}
#pragma  mark --  AMapNaviManager Delegate
-(void)naviManagerOnCalculateRouteSuccess:(AMapNaviManager *)naviManager{
    [self showRouteWithNaviRoute:[[naviManager naviRoute] copy]];
    
   NSLog(@"距离==%.2f,时间==%ld",naviManager.naviRoute.routeLength/1000.0,naviManager.naviRoute.routeTime / 60);
}
#pragma mark --展示路线
- (void)showRouteWithNaviRoute:(AMapNaviRoute *)naviRoute
{
    if (naviRoute == nil)
    {
        return;
    }
    
    // 清除旧的overlays
    if (self.routeGenerateType ==RouteGenerateType_Automatic) {
        [self.mapView removeOverlays:self.mapView.overlays];

    }
    
    NSUInteger coordianteCount = [naviRoute.routeCoordinates count];
    CLLocationCoordinate2D coordinates[coordianteCount];
    for (int i = 0; i < coordianteCount; i++)
    {
        AMapNaviPoint *aCoordinate = [naviRoute.routeCoordinates objectAtIndex:i];
        coordinates[i] = CLLocationCoordinate2DMake(aCoordinate.latitude, aCoordinate.longitude);
    }
    
    MAPolyline *polyline = [MAPolyline polylineWithCoordinates:coordinates count:coordianteCount];
    [self.mapView addOverlay:polyline];
    
    /* 缩放地图使其适应polylines的展示. */
    
    [self.mapView setVisibleMapRect:[polyline boundingMapRect] animated:YES];
    
}
#pragma  mark -- WCSelectLineViewDelegate
-(void)selectLineWithIndex:(NSInteger)index
{
    if (index == self.routeGenerateType) {
        return ;
    }
    if (index != 2 ) {
//        切换点时候清除地图标记和路线
        [_mapView removeAnnotation:_endPointAnnotation] ;
        _endPoint = nil;
        [_mapView removeAnnotations:_wayNavPointAnnotationArr] ;
        [_mapView removeOverlays:_mapView.overlays] ;
        
//        清除自定义规划路线的点
        [_wayNavPointAnnotationArr removeAllObjects];
        [_wayNaviPointArr removeAllObjects] ;
//        切换路线生成方式，保留用户当前位置点
        [_wayNaviPointArr addObject:_userLocation] ;
    }
    
    self.routeGenerateType = index ;
}

-(void)phaseView
{
    
//    for (id obj in self.subviews) {
//        [obj removeFromSuperview];
//    }
    
    OffsetTableView * tabView = [[OffsetTableView alloc]initWithFrame:CGRectMake(20, 20, kMainViewWidth-40, kMainViewHeight -40+1)];
    [self addSubview:tabView] ;
}
-(void)controView
{
    
//    for (id obj in self.subviews) {
//        [obj removeFromSuperview];
//    }

    WCCarMessageView *carView = [WCCarMessageView carMessageViewWithFrame:CGRectMake(tLineViewAndTabDis, tLineViewAndNavDis, kMainViewWidth - 2 * tLineViewAndTabDis, 260)];
    
    carView.nameArray = @[
                          
                          @"清水亭西/",
                          @"吉印大道/",
                          @"金鑫东路/",
                          @"清水亭西/",
                          @"清水亭西/",
                          @"清水亭西/",
                          @"清水亭西/",
                          @"清水亭西/",
                          @"苏源大道/",
                          @"秣周东路/",
                          @"清水西苑/",
                          @"清水亭西/",
                          @"吉印大道/",
                          ];
    [self addSubview:carView];
    
    WCExtraView *extraView = [WCExtraView extraViewWithFrame:CGRectMake(bMainViewAndTabDis, bMainViewAndNavDis + carView.bottom, kMainViewWidth - 2 * bMainViewAndTabDis, 250)];
    [self addSubview:extraView];
    
    
    WCControView *controView = [WCControView controViewWithFrame:CGRectMake(0, kMainViewHeight - 100, kMainViewWidth, 100)];
    
    [self addSubview:controView];
    
}



@end
