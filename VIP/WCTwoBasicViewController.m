//
//  WCTwoBasicViewController.m
//  VIP
//
//  Created by NJWC on 16/4/1.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WCTwoBasicViewController.h"
#import "WCThreeBasicViewController.h"
#import "WCSelectLineView.h"
#import "WCResetAndRevokeView.h"
#import "WCLineMessageView.h"
#import "WCBigAndSmallView.h"
#import "WCNavigationView.h"
#import "WCRoute.h"

#import "WCIntersectionInfo.h"
#import "OffsetTableView.h"
#import "WCIntersections.h"
#import "CustomAnnotationView.h"
#import "PresentOverUsedAlertView.h"
#import "PresentCollectRouteView.h"
#import "WCHTTPRequest.h"
#import "WCMAPointAnnotion.h"
#import "WCDataSolver.h"
#import "MyMAPointAnnotation.h"
//智能导航还是自定义导航
//typedef NS_ENUM(NSInteger , RouteGenerateType){
//    RouteGenerateType_Automatic =0,
//    RouteGenerateType_Customed  =1,
//    RouteGenerateType_Choosing  =2
//    
//};

@interface WCTwoBasicViewController ()<WCNavigationViewDelegate,MAMapViewDelegate,WCSelectLineViewDelegate,AMapNaviManagerDelegate,WCResetAndRevokeViewDelegate,WCBigAndSmallViewDelegate,WCLineMessageViewDelegate>
{
    MAAnnotationView *_lastView;
}

/*
 *  for WCMainViewTypeLine (地图界面)
 */
@property (nonatomic ,strong) MAMapView * mapView ;
//路线生成方式
@property (nonatomic ,assign) RouteGenerateType routeGenerateType ;
//导航管理类
@property (nonatomic, strong) AMapNaviManager *naviManager;
////用户位置
//@property (nonatomic ,strong) AMapNaviPoint * userLocation ;

//选择的信控点
@property (nonatomic ,strong) NSMutableArray * routeNaviPoints ;

//当前地图缩放等级
@property (nonatomic ,assign) CGFloat currentLevel ;

//所有信控路口
@property (nonatomic ,strong) NSMutableArray * allIntersections ;

//是否增加途径点
@property (nonatomic ,assign) BOOL isNeedAddWayPoint ;

//路线的起点，终点，途径点
@property (nonatomic,strong) NSArray *startPoints;
@property (nonatomic,strong) NSArray *endPoints;
@property (nonatomic,strong) NSArray *wayPoints ;

@property (nonatomic,assign) BOOL isFirstAppear;


@property (nonatomic,strong)  NSArray * strategies ;
@property (nonatomic,assign)  NSInteger currentStrategyIndex ;
@property (nonatomic,assign)  NSInteger lastStratetyIndex;

@property (nonatomic ,strong) NSMutableArray * autoRouteArr;
@property (nonatomic ,strong) WCRoute * customedRoute ;
@property (nonatomic ,strong) WCRoute * choosingRoute ;




@end

@implementation WCTwoBasicViewController

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.strategies = @[
                     @(AMapNaviDrivingStrategyFastestTime),  @(AMapNaviDrivingStrategyShortDistance),@(AMapNaviDrivingStrategySaveMoney)];
        self.currentStrategyIndex =0;
        self.lastStratetyIndex    =0;
        self.currentLevel = 18 ;
        self.routeGenerateType = RouteGenerateType_Automatic ;
        self.isNeedAddWayPoint = NO;
        self.isFirstAppear = YES;

    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated] ;
    if (self.isFirstAppear == YES) {
        [self.mapView addAnnotations:self.allIntersections];
        self.isFirstAppear = NO;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置navigationView的类型
//    self.navigationView.titleArray = @[@"基础信息",@"路线设置",@"相位设置",@"控制执行"];
//    self.navigationView.navigationViewType = WCNavigationViewTypeBasic;
    self.navigationView.index = 2;
    self.navigationView.delegate = self;
    
    [self loadMapView] ;
    
    WCSelectLineView * selectView = [WCSelectLineView selectLineViewWithFrame:CGRectMake(bLineSelectAndTabDis, kNavigationHeight + bLineSelectAndNavDis, 122.5 + 122.5 + 120, 50)];
    selectView.delegate  = self ;
    [self.view addSubview:selectView];
    
    CGFloat rrW = 93 + 92;
    WCResetAndRevokeView * rrView = [WCResetAndRevokeView resetAndRevokeViewWithFrame:CGRectMake(kContentWidth - rrW - bResetAndRightDis, kNavigationHeight + bResetAndNavDis, rrW, 50)];
    rrView.delegate = self;
    [self.view addSubview:rrView];
    
    CGFloat bsW = 50;
    CGFloat bsH = (101 + 109) / 2.0;
    WCBigAndSmallView * bigAndSmallView = [WCBigAndSmallView bigAndSmallViewWithFrame:CGRectMake(kMainViewWidth - bsW - bResetAndRightDis , kContentHeight - bsH - bLineMessageAndBottomDis, bsW, bsH)];
    bigAndSmallView.delegate = self ;
    [self.view addSubview:bigAndSmallView];
}

#pragma  mark -- 初始化地图
-(void)loadMapView{
    _mapView = [[MAMapView alloc]initWithFrame:CGRectMake(0,
                                                        kNavigationHeight,
                                                         kMainViewWidth,
                                                          kMainViewHeight)
                ];
    _mapView.delegate =self ;
    _mapView.showsUserLocation =YES;
    [_mapView setZoomLevel:18 animated:NO];
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(31.385598, 120.980737)];
    [self.view  addSubview:_mapView];

}

#pragma  mark -- setter-getter
-(NSMutableArray *) routeNaviPoints{
    if (!_routeNaviPoints) {
        _routeNaviPoints = [NSMutableArray array] ;
    }
    return _routeNaviPoints ;
}

-(WCRoute *)choosingRoute{
    if (!_choosingRoute) {
        _choosingRoute = [WCRoute new];
    }
    return _choosingRoute ;
}
-(WCRoute *)customedRoute{
    if (!_customedRoute) {
        _customedRoute = [WCRoute new] ;

    }
    return _customedRoute ;
}
-(NSMutableArray *)autoRouteArr{
    if (!_autoRouteArr) {
        _autoRouteArr = [NSMutableArray array] ;
    }
    return _autoRouteArr ;
}

-(NSMutableArray *)allIntersections{
    if (!_allIntersections) {
        _allIntersections = [NSMutableArray array] ;
        NSDictionary * dic = [WCIntersections getAllInteractions] ;
        NSArray * allValues =[WCIntersections mj_objectArrayWithKeyValuesArray:dic.allValues];
        for (int i =0; i<allValues.count; i++) {
            WCIntersections * inter = allValues [i] ;
            MyMAPointAnnotation *annotation = [[MyMAPointAnnotation alloc] init];
            annotation.coordinate = CLLocationCoordinate2DMake( inter.lat, inter.lon);
            annotation.title    = inter.intersectionName;
            annotation.ID = inter.intersectionId ;
            annotation.status   = inter.status ;
            [_allIntersections addObject:annotation] ;
        }
    }
    return _allIntersections ;
}
-(AMapNaviManager *)naviManager{
    if (!_naviManager) {
        _naviManager = [AMapNaviManager new] ;
        _naviManager.delegate = self;
    }
    return  _naviManager;
}
#pragma  mark -- 初始化手势
-(void)longPress :(UILongPressGestureRecognizer *)longPress {
    
    if ([longPress.view isKindOfClass:[CustomAnnotationView class]]
        &&longPress.state == UIGestureRecognizerStateBegan
        &&self.routeGenerateType==RouteGenerateType_Automatic
        &&self.routeNaviPoints.count>=2)
    {
        CustomAnnotationView * ann = (CustomAnnotationView *) longPress.view;
        
        if ([ann.annotation isKindOfClass:[MyMAPointAnnotation class]])
        {
            MyMAPointAnnotation * p  =(MyMAPointAnnotation *) ann.annotation ;
//self.routeNaviPoints.count- 1 || 1-- 插入位置有两种选择 可能产生不同的两种显示方式
            [self.routeNaviPoints insertObject:p atIndex:self.routeNaviPoints.count- 1] ;
            if (self.routeNaviPoints.count<=5) {
                 NSLog(@"___count____%lu",(unsigned long)self.routeNaviPoints.count);
                self.isNeedAddWayPoint = YES ;
//                重绘地图上所有路线加途经点。
                [self reset] ;
                
                [self drawOverLayer] ;
                
            }else{
                [WCPhoneNotification autoHideWithText:@"最多设置三个途经点!"];

            }
        }
    }
}

#pragma mark -- 计算规划路线的参数
-(void)drawOverLayer{

    if (self.routeGenerateType ==RouteGenerateType_Automatic&&self.routeNaviPoints.count>=2) {
        
        MAPointAnnotation *s =_routeNaviPoints[0] ;
        AMapNaviPoint *sp = [AMapNaviPoint locationWithLatitude:s.coordinate.latitude longitude:s.coordinate.longitude] ;
        
        MAPointAnnotation *e =_routeNaviPoints.lastObject ;
        AMapNaviPoint *ep = [AMapNaviPoint locationWithLatitude:e.coordinate.latitude longitude:e.coordinate.longitude] ;
        
        NSArray * wayPoints =  [_routeNaviPoints subarrayWithRange:NSMakeRange(1, self.routeNaviPoints.count-2)] ;
        NSMutableArray *wayNaviPoints =[NSMutableArray array] ;
        for (MAPointAnnotation *mp in wayPoints) {
            AMapNaviPoint *naviMP = [AMapNaviPoint locationWithLatitude:mp.coordinate.latitude longitude:mp.coordinate.longitude] ;
            [wayNaviPoints addObject:naviMP] ;
        }
        
        _startPoints = @[sp];
        _wayPoints   = [NSArray arrayWithArray:wayNaviPoints] ;
        _endPoints   = @[ep] ;
        
        
    }else if (self.routeGenerateType == RouteGenerateType_Customed){
        
        MAPointAnnotation *s =_routeNaviPoints[_routeNaviPoints.count - 2] ;
        AMapNaviPoint *sp = [AMapNaviPoint locationWithLatitude:s.coordinate.latitude longitude:s.coordinate.longitude] ;
        
        MAPointAnnotation *e =_routeNaviPoints[_routeNaviPoints.count - 1] ;
        AMapNaviPoint *ep = [AMapNaviPoint locationWithLatitude:e.coordinate.latitude longitude:e.coordinate.longitude] ;
        
        _startPoints = @[sp] ;
        _endPoints =   @[ep];
    }
    
    
    NSInteger strategy = [self.strategies[self.currentStrategyIndex] integerValue];
  BOOL success =  [self.naviManager calculateDriveRouteWithStartPoints:_startPoints endPoints:_endPoints wayPoints:_wayPoints drivingStrategy:strategy];
    NSLog(@"策略＝＝＝%ld,成功＝＝＝%d",(long)strategy,success) ;

}
#pragma  mark -- 地图代理
- (void)mapInitComplete:(MAMapView *)mapView{
    NSLog(@"_________") ;
}
-(void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
    if ([view isKindOfClass:[CustomAnnotationView class]]&&[view.annotation isKindOfClass:[MyMAPointAnnotation class]]) {
        
        //记录最后点击的大头针
        _lastView = view;
        
        MyMAPointAnnotation * point = (MyMAPointAnnotation *) view.annotation ;
        if (self.routeGenerateType == RouteGenerateType_Automatic) {
            if (self.routeNaviPoints.count>= 2) {
                [self reset] ;
            }
            [self.routeNaviPoints addObject:point] ;
            //        有了起终点才划线在不长按的时候
            if (self.routeNaviPoints.count == 2) {
                [self drawOverLayer];
            }
        }else if (self.routeGenerateType ==RouteGenerateType_Customed){
            
            [self.routeNaviPoints addObject:point];
            
            if (self.routeNaviPoints.count >=2) {
                [self drawOverLayer];
            }
        }
    }
}

-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    NSLog(@"用户位置___%s",__FUNCTION__);
    
}
-(MAAnnotationView * )mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
        if ([annotation isKindOfClass:[MAUserLocation class]]){
        static NSString *userLocationStyleReuseIndetifier = @"userLocationStyleReuseIndetifier";
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:userLocationStyleReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:userLocationStyleReuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"icon_map_coordinate"];
        
        return annotationView;
    }else
        if ([annotation isKindOfClass:[MyMAPointAnnotation class]])
    {
        MyMAPointAnnotation* myMAPointAnnotation = (MyMAPointAnnotation *)annotation;
        
        static NSString *customReuseIndetifier = @"customReuseIndetifier";
        
        CustomAnnotationView *annotationView = (CustomAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
        
        if (annotationView == nil)
        {
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
            // must set to NO, so we can show the custom callout view.
            annotationView.canShowCallout = YES;
            annotationView.draggable = YES;
            annotationView.calloutOffset = CGPointMake(0, -5);
            
            UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
            [annotationView addGestureRecognizer:longPress];
        }
        UIImage * image ;
        if (myMAPointAnnotation.status == 1) {
            image = [UIImage imageNamed:@"icon_map_signal-lamp_focusing"] ;
        }else{
            image = [UIImage imageNamed:@"icon_map_signal-lamp_desalination"] ;
        }
        
        
        annotationView.portrait = image ;
        
        return annotationView;
    }

    
    return nil;
    
    
}


#pragma  mark --  AMapNaviManager Delegate
-(void)naviManagerOnCalculateRouteSuccess:(AMapNaviManager *)naviManager{
//    智能路径
    if (RouteGenerateType_Automatic ==self.routeGenerateType) {
      //       生成路线
        WCRoute * r = [WCRoute new] ;
        r.routeTime   = naviManager.naviRoute.routeTime / 60 ;
        r.routeLength = naviManager.naviRoute.routeLength/1000.0 ;
        //    做路线保存 -- TODO:如果coordinates 不包含起点和终点，可能还需要添加进去。。
        [r.routeSegments addObject:naviManager.naviRoute.routeCoordinates] ;
        [self.autoRouteArr addObject:r] ;
        self.isNeedAddWayPoint = NO ;
        //    计算经过多少个信控路口
        r.type = RouteGenerateType_Automatic ;
        [self getIntersections:r count:self.autoRouteArr.count] ;

//        自定义路径
        
    }else if(self.routeGenerateType == RouteGenerateType_Customed){
        
        self.customedRoute.type = RouteGenerateType_Customed ;
        [self.customedRoute.routeTimeSegments addObject:@(self.naviManager.naviRoute.routeTime/60)];
        
        [self.customedRoute.routeLenthSegments addObject:@(self.naviManager.naviRoute.routeLength/1000.0)];
        [self.customedRoute.routeSegments addObject:naviManager.naviRoute.routeCoordinates] ;
        [self showRouteWithNaviRoute:[[naviManager naviRoute] copy]];

        [self getIntersections:self.customedRoute count:1] ;

//自选路径
    }
    
    if (self.routeGenerateType == RouteGenerateType_Automatic) {
        if (_currentStrategyIndex<=1) {
            if (_currentStrategyIndex == 0) {
                //            只画第一条
                [self showRouteWithNaviRoute:[[naviManager naviRoute] copy]];
            }
            _currentStrategyIndex++ ;
            [self caculateNextStrategy] ;
        }else{
            self.currentStrategyIndex =0;
        }
    }
 
  
    
    
}
-(void)naviManager:(AMapNaviManager *)naviManager onCalculateRouteFailure:(NSError *)error{
    [WCPhoneNotification autoHideWithText:error.localizedDescription];
    self.isNeedAddWayPoint = NO ;
    if (_currentStrategyIndex<=1) {
        _currentStrategyIndex++ ;
        [self caculateNextStrategy] ;
    }else{
        self.currentStrategyIndex =0;
    }

}
- (void)naviManager:(AMapNaviManager *)naviManager error:(NSError *)error{
    [WCPhoneNotification autoHideWithText:error.localizedDescription];

}
#pragma mark --展示路线
- (void)showRouteWithNaviRoute:(AMapNaviRoute *)naviRoute
{
    if (naviRoute == nil)
    {
        return;
    }
//   获取line
    MAPolyline * line = [self getPolylineWithCoordinates:naviRoute.routeCoordinates] ;
    [self.mapView addOverlay:line];
    /* 缩放地图使其适应polylines的展示. */
//    AMapNaviPointBounds  @brief 导航路线最小坐标点和最大坐标点围成的矩形区域 -- 自定义模式不需要缩小
}
-(MAPolyline *)getPolylineWithCoordinates:(NSArray *)routeCoordinates{
    NSUInteger coordianteCount = [routeCoordinates count];

    CLLocationCoordinate2D coordinates[coordianteCount];
    for (int i = 0; i < coordianteCount; i++)
    {
        AMapNaviPoint *aCoordinate = [routeCoordinates objectAtIndex:i];
        coordinates[i] = CLLocationCoordinate2DMake(aCoordinate.latitude, aCoordinate.longitude);
    }
    MAPolyline *polyline = [MAPolyline polylineWithCoordinates:coordinates count:coordianteCount];
    return polyline ;
}
#pragma mark -- 计算下一条路径策略
-(void)caculateNextStrategy{
     NSInteger strategy = [self.strategies[self.currentStrategyIndex] integerValue];
     BOOL success = [self.naviManager calculateDriveRouteWithStartPoints:_startPoints endPoints:_endPoints wayPoints:_wayPoints drivingStrategy:strategy];
       NSLog(@"策略＝＝＝%ld,成功＝＝＝%d",(long)strategy,success) ;
}
#pragma mark -- 计算经过多少个信控路口
-(void)getIntersections:(WCRoute *)r count:(NSInteger)count{
    
    NSString * naviPointString ;

    if (self.routeGenerateType == RouteGenerateType_Automatic) {
        
        naviPointString = [WCDataSolver mapNaviPointFromArray:r.routeSegments[0]] ;

    }else if (self.routeGenerateType == RouteGenerateType_Customed){
        
        naviPointString = [WCDataSolver mapNaviPointFromArray:r.routeSegments[r.routeSegments.count-1]];
    }
    __weak typeof (self) weakSelf = self;

    [WCHTTPRequest getInfoWithPoints:naviPointString Success:^(NSArray *intersection) {
        [r.annotionsOnRouteSegments addObject:intersection] ;
        [weakSelf addTagView:r count:count] ;
        
    } failure:^(NSString *error) {
        [WCPhoneNotification autoHideWithText:@"获取途径信控信息失败！"];
    }];

    
}
-(void)addTagView:(WCRoute *)r count:(NSInteger)count{
    CGFloat lmH = 145;
    CGFloat lmW = 280;
    WCLineMessage * mes =[WCLineMessage new] ;
    if (self.routeGenerateType == RouteGenerateType_Automatic||
        self.routeGenerateType==RouteGenerateType_Choosing) {
        mes.time = r.routeTime ;
        mes.distance =r.routeLength ;
    }else{
        mes.time = [[r.routeTimeSegments valueForKeyPath:@"@sum.intValue"] integerValue];
        mes.distance = [[r.routeLenthSegments valueForKeyPath:@"@sum.floatValue"] floatValue];
    }
    
    mes.roadCount =r.intersectionCount;
    
    WCLineMessageView *lineMessageView = [WCLineMessageView lineMessageViewWithFrame:CGRectMake(bLineMessageAndTabDis+(lmW +9)*(count-1), kContentHeight - lmH - bLineMessageAndBottomDis, lmW, lmH)];
    lineMessageView.delegate = self ;
    lineMessageView.message = mes ;
    lineMessageView.tag =  count -1   ;
//    设置过的路线不用再设置常用路线
    if (self.routeGenerateType == RouteGenerateType_Choosing) {
        [lineMessageView setStatus];
    }else if (count == 1){
        lineMessageView.backGround = NO;
    }
    
    [self.view addSubview:lineMessageView] ;

}
#pragma mark WCLineMessViewDelegate 切换线路
-(void)otherAreaClick:(WCLineMessageView *)messageView{
    if (self.routeGenerateType ==RouteGenerateType_Customed||
        self.routeGenerateType == RouteGenerateType_Choosing) {
        return ;
    }
    for (UIView *v in self.view.subviews) {
        if ([v isKindOfClass:[WCLineMessageView class]]&&v.tag ==self.lastStratetyIndex) {
            WCLineMessageView * mesView =(WCLineMessageView *)v;
            mesView.backGround = YES ;
        }
    }
    
    self.currentStrategyIndex = messageView.tag ;
    [self exchangeLinesWithSelectedIndex:messageView.tag] ;
    messageView.backGround = NO;
    self.lastStratetyIndex = messageView.tag ;
}
-(void)setUserLineBtnClick:(WCLineMessageView *)view{
    WCRoute * r  ;
    if (_routeGenerateType == RouteGenerateType_Automatic) {
        r = self.autoRouteArr[view.tag] ;
        
    }else if (_routeGenerateType == RouteGenerateType_Customed){
        r= self.customedRoute ;
    }
    NSString * titleString = [WCDataSolver nameArrFromArr:r.annotionsOnRoutes] ;

    NSString * subString = [WCDataSolver subNameArrFromArr:r.annotionsOnRoutes] ;
    
    __weak typeof (self) weakSelf= self;
   [PresentCollectRouteView showAlertWithDataSource:titleString cancel:^{
      
   } sure:^(UITextField *tf){
       if (tf.text == nil ||[tf.text isEqualToString:@""]) {
           [WCPhoneNotification autoHideWithText:@"路线名不能为空!"];
           return ;
       }
   CGFloat time ;
   CGFloat distance ;
   WCRoute * r ;
       if (weakSelf.routeGenerateType == RouteGenerateType_Automatic) {
           r = weakSelf.autoRouteArr[weakSelf.currentStrategyIndex] ;
           time = r.routeTime;
           distance =r .routeLength ;
       }else{
           r = weakSelf.customedRoute ;
           time = [[r.routeTimeSegments valueForKeyPath:@"@sum.intValue"] integerValue] ;
           distance=[[r.routeLenthSegments valueForKeyPath:@"@sum.floatValue"] floatValue];
       }
       //TODO:为什么不直接保存经过的信控路口数目？
    NSDictionary * dic =@{@"account":[kDefaults objectForKey:kAccount],
                          @"lineName":tf.text,
                          @"intersections":subString,
                          @"length":@(distance),
                          @"preTime":@(time),
                          @"points": [WCDataSolver mapAllNaviPointFromArray:r.routeSegments]
                          };
       
      [WCHTTPRequest setLineInfo:dic success:^(NSString *success) {
          [view setStatus];
          [WCPhoneNotification autoHideWithText:@"保存成功"];

        } failure:^(NSString *error) {
            
          [WCPhoneNotification autoHideWithText:error];

      }];
  }] ;
    
}
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:(MAPolyline*)overlay];
        polylineRenderer.lineWidth   = 10.f;
//        UIColor * color ;
//        switch (self.routeGenerateType) {
//            case RouteGenerateType_Automatic:
//            {
//                if (self.currentStrategyIndex == 0) {
//                    color = [UIColor redColor];
//                }else if (self.currentStrategyIndex == 1){
//                    color = [UIColor blueColor] ;
//                }else if (self.currentStrategyIndex == 2){
//                    color = [UIColor greenColor] ;
//                }
//            }
//                break;
//            case RouteGenerateType_Customed:
//            case RouteGenerateType_Choosing:
//            {
//                color = [UIColor colorWithHexString:@"2e96de"];
//            }
//                break;
//                
//            default:
//                break;
//        }
        
        polylineRenderer.strokeColor =[UIColor colorWithHexString:@"2e96de"];
        
        return polylineRenderer;
    }
    
    return nil;
}
#pragma  mark -- WCSelectLineViewDelegate
-(void)selectLineWithIndex:(NSInteger)index
{

    if (index == self.routeGenerateType) {
        return ;
    }
    [self reset] ;
    if (index == 2 ) {
//        重置

//    }else{
        __weak typeof (self) weakSelf= self ;
        [PresentOverUsedAlertView showOverUsedViewWhenRouteSelected:^(WCRoute *route) {
            if (route && route.mapAnnotionArr.count>= 2) {
                
                
                weakSelf.choosingRoute = route;
                weakSelf.choosingRoute.type = RouteGenerateType_Choosing ;
                
                [weakSelf drawChoosedLine] ;
                
                [self addTagView:route count:1] ;
            }
            
        }];
    }
    
    self.routeGenerateType = index ;
}
-(void)exchangeLinesWithSelectedIndex:(NSInteger)idx{
    [self.mapView removeOverlays:self.mapView.overlays] ;
    if (self.routeGenerateType == RouteGenerateType_Automatic) {
        WCRoute *route= self.autoRouteArr[idx] ;
        MAPolyline * line = [self getPolylineWithCoordinates:route.routeSegments[0]] ;
        [self.mapView addOverlay:line] ;
    }

}
-(void) drawChoosedLine{
    [self reset] ;
    
    self.routeGenerateType = RouteGenerateType_Choosing ;

    MAPolyline * selectedLine = [self getPolylineWithCoordinates:self.choosingRoute.routeSegments[0]] ;
    [self.mapView addOverlay:selectedLine] ;
    
    
    
}
#pragma mark WCResetAndRevokeViewDelegate
-(void)resetAndRevokeWithIndex:(NSInteger)index{
    
    //取消view的显示
    [self.mapView deselectAnnotation:_lastView.annotation animated:YES];
    
    if (index == 0) {
        [self reset] ;
    }else{
        [self getToForeStep] ;
    }
    
}
#pragma mark  --WCBigAndSmallViewDelegate
-(void)bigAndSmallViewClickWithIndex:(NSInteger)index{
    
    CGFloat maxLevel = self.mapView.maxZoomLevel;
    CGFloat minLevel = self.mapView.minZoomLevel ;
    if (index == 0 && _currentLevel< maxLevel ) {
        _currentLevel ++ ;
        [self.mapView setZoomLevel:_currentLevel animated:YES] ;
    }else if(index == 1 &&_currentLevel >minLevel){
        _currentLevel -- ;
        [self.mapView setZoomLevel:_currentLevel animated:YES] ;
    }
}
-(void)reset{
    for (UIView *v in self.view.subviews) {
        if ([v isKindOfClass:[WCLineMessageView class]]) {
            [v removeFromSuperview] ;
        }
    }
    self.currentStrategyIndex = 0 ;
    self.lastStratetyIndex    = 0 ;
    //清空保留点路线
    [self.autoRouteArr removeAllObjects] ;
    self.customedRoute = nil ;
//    清空保存点导航点 ,在添加途经点的情况下，不清空。
    if(self.isNeedAddWayPoint == NO){
    [_routeNaviPoints removeAllObjects];
    }
//    customed
    [self.mapView removeOverlays:self.mapView.overlays] ;
}

-(void)getToForeStep{
    
    if (self.routeGenerateType == RouteGenerateType_Customed) {
        if (self.routeNaviPoints.count == 2) {
            [self reset] ;
            return ;
        }
//        更新选中的信控路口
        [self.mapView removeOverlay:self.mapView.overlays.lastObject] ;
//        选中的信控点
        [self.routeNaviPoints removeLastObject] ;
//        路线分段
        [self.customedRoute.routeSegments removeLastObject] ;
//        路线时间
        [self.customedRoute .routeTimeSegments removeLastObject];
//        路线距离
        [self.customedRoute .routeLenthSegments removeLastObject] ;
//        路线途径点
        [self.customedRoute .annotionsOnRouteSegments  removeLastObject] ;
      
//        更新操作
        for (UIView *v in self.view.subviews) {
            if ([v isKindOfClass:[WCLineMessageView class]]) {
                [v  removeFromSuperview] ;
            }
        }
        [self addTagView:self.customedRoute count:1] ;
        
    }else{
        [self reset] ;
    }
}

//返回上一层页面
-(void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//进入下一层页面
-(void)rightButtonClick
{
    if (self.autoRouteArr.count ==0 &&!_customedRoute&&!_choosingRoute) {
        [WCPhoneNotification autoHideWithText:@"请先选择路线！"];
        return;
    }
    WCRoute * r ;
    if (self.routeGenerateType == RouteGenerateType_Automatic&&self.autoRouteArr.count>0) {
        r = self.autoRouteArr[self.currentStrategyIndex] ;
        r.mapAnnotionArr = [WCMAPointAnnotion modelTransformFrom:self.routeNaviPoints];
    }else if(self.routeGenerateType ==RouteGenerateType_Customed&&self.customedRoute){
        self.customedRoute.routeTime = [[self.customedRoute.routeTimeSegments valueForKeyPath:@"@sum.intValue"] integerValue];
        self.customedRoute.routeLength =[[self.customedRoute.routeLenthSegments valueForKeyPath:@"@sum.floatValue"] floatValue];
        r = self.customedRoute ;
        r.mapAnnotionArr = [WCMAPointAnnotion modelTransformFrom:self.routeNaviPoints];
    }else{
        r =  self.choosingRoute ;
    }

    WCThreeBasicViewController *tVC = [[WCThreeBasicViewController alloc]init];
    r.screenShotImage = [self captureAction] ;
    tVC.route = r ;
    [self.navigationController pushViewController:tVC animated:YES];
    
}
#pragma  mark --截屏
-(UIImage *)captureAction{
//    截屏为了能够看见所有经过的点的路线。
    [self.mapView showAnnotations:self.routeNaviPoints animated:NO] ;
    
    CGRect inrect =[self.view convertRect:self.view.bounds toView:self.mapView] ;
    UIImage *screenShotImage = [self.mapView takeSnapshotInRect:inrect] ;
    return screenShotImage;
}
@end
