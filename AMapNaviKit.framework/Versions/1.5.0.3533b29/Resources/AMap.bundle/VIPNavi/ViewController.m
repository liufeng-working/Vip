//
//  ViewController.m
//  VIPNavi
//
//  Created by 万存 on 16/3/18.
//  Copyright © 2016年 WanCun. All rights reserved.
//

#import "ViewController.h"
#import "NavPointAnnotation.h"

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

@interface ViewController (){
    
    UITapGestureRecognizer *_mapViewTapGesture;

}



@property  (nonatomic,assign) TravelTypes travelType;

@property (nonatomic) NavigationTypes naviType;




@property (nonatomic) BOOL calRouteSuccess; // 指示是否算路成功

@property (nonatomic,strong)  NSMutableArray *annotionArr;

@property (nonatomic, strong) AMapNaviPoint* startPoint;
@property (nonatomic, strong) AMapNaviPoint* endPoint;
@property (nonatomic ,strong) AMapNaviPoint *wayPoint1 ;
@property (nonatomic,strong)  AMapNaviPoint *wayPoint2 ;

@property (nonatomic,strong)   NavPointAnnotation *tapAnnotation;


@end

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.travelType = TravelTypeCar;
    self.mapView.showsUserLocation =YES;
    self.mapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
    [self.mapView setZoomLevel:16.1 animated:YES];
    [self.view addSubview:self.mapView];
//    添加手势
    [self.mapView addGestureRecognizer:_mapViewTapGesture];
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.mapView removeGestureRecognizer:_mapViewTapGesture];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self initGestureRecognizer];
}
- (void)initGestureRecognizer
{
    _mapViewTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                 action:@selector(handleSingleTap:)];
}
#pragma mark - Gesture Action

- (void)handleSingleTap:(UITapGestureRecognizer *)theSingleTap
{

    
    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:[theSingleTap locationInView:self.mapView]
                                              toCoordinateFromView:self.mapView];
    
    _tapAnnotation = [[NavPointAnnotation alloc]init];
    
    _tapAnnotation.coordinate = coordinate;
    
    _tapAnnotation .title = @"点你妹";
    
    _tapAnnotation.navPointType = NavPointAnnotationStart;
    [self.mapView addAnnotation:_tapAnnotation];
    
    
    CLLocationCoordinate2D coordinate1 = [self.mapView convertPoint:[theSingleTap locationInView:self.mapView]
                                              toCoordinateFromView:self.mapView];
    
   NavPointAnnotation* tapAnnotation1 = [[NavPointAnnotation alloc]init];
    
    tapAnnotation1.coordinate = coordinate1;
    
    tapAnnotation1 .title = @"点你妹1";
    
    tapAnnotation1.navPointType = NavPointAnnotationEnd;
    [self.mapView addAnnotation:tapAnnotation1];
    
    
//    if (_selectPointState == MapSelectPointStateStartPoint)
//    {
//        if (_beginAnnotation)
//        {
//            _beginAnnotation.coordinate = coordinate;
//        }
//        else
//        {
//            _beginAnnotation = [[NavPointAnnotation alloc] init];
//            [_beginAnnotation setCoordinate:coordinate];
//            _beginAnnotation.title        = @"起始点";
//            _beginAnnotation.navPointType = NavPointAnnotationStart;
//            [self.mapView addAnnotation:_beginAnnotation];
//        }
//    }
//    else if (_selectPointState == MapSelectPointStateWayPoint)
//    {
//        if (_wayAnnotation)
//        {
//            _wayAnnotation.coordinate = coordinate;
//        }
//        else
//        {
//            _wayAnnotation = [[NavPointAnnotation alloc] init];
//            [_wayAnnotation setCoordinate:coordinate];
//            _wayAnnotation.title        = @"途径点";
//            _wayAnnotation.navPointType = NavPointAnnotationWay;
//            [self.mapView addAnnotation:_wayAnnotation];
//        }
//    }
//    else if (_selectPointState == MapSelectPointStateEndPoint)
//    {
//        if (_endAnnotation)
//        {
//            _endAnnotation.coordinate = coordinate;
//        }
//        else
//        {
//            _endAnnotation = [[NavPointAnnotation alloc] init];
//            [_endAnnotation setCoordinate:coordinate];
//            _endAnnotation.title        = @"终 点";
//            _endAnnotation.navPointType = NavPointAnnotationEnd;
//            [self.mapView addAnnotation:_endAnnotation];
//        }
//    }
}

#pragma mark - 初始化当航点

- (void)initNaviPoints
{
//118.762769,31.9806650
//    118.769955,31.980889
//    118.790239,31.982512
    _startPoint = [AMapNaviPoint locationWithLatitude:31.980665 longitude:118.769933];
    _endPoint   = [AMapNaviPoint locationWithLatitude:31.982512 longitude:118.769933];
    
    _wayPoint1    = [AMapNaviPoint locationWithLatitude:31.980889  longitude:118.790239];

//    _wayPoint2    =  [AMapNaviPoint locationWithLatitude:31.977174  longitude:118.762831];

}
- (void)initAnnotations
{
    NavPointAnnotation *beginAnnotation = [[NavPointAnnotation alloc] init];
    [beginAnnotation setCoordinate:CLLocationCoordinate2DMake(_startPoint.latitude, _startPoint.longitude)];
    beginAnnotation.title        = @"起始点";
    beginAnnotation.navPointType = NavPointAnnotationStart;
    [self.annotionArr addObject:beginAnnotation];
    [self.mapView addAnnotation:beginAnnotation];
    
    
//    NavPointAnnotation *byAnnotation = [[NavPointAnnotation alloc] init];
//    [byAnnotation setCoordinate:CLLocationCoordinate2DMake(_wayPoint1.latitude, _wayPoint1.longitude)];
//    byAnnotation.title        = @"途径点";
//    byAnnotation.navPointType = NavPointAnnotationWay;
//    [self.annotionArr addObject:byAnnotation];
//
//    [self.mapView addAnnotation:byAnnotation];
//    
//    NavPointAnnotation *endAnnotation = [[NavPointAnnotation alloc] init];
//    [endAnnotation setCoordinate:CLLocationCoordinate2DMake(_endPoint.latitude, _endPoint.longitude)];
//    endAnnotation.title        = @"终点";
//    endAnnotation.navPointType = NavPointAnnotationEnd;
//    
//    
//    [self.annotionArr addObject:endAnnotation];
//
//    [self.mapView addAnnotation:endAnnotation];
    
    
}

#pragma mark -- buttonAction
- (IBAction)doneClick:(id)sender {
    NSArray *startPoints = @[_startPoint];
    NSArray *endPoints   = @[_tapAnnotation];
//    NSArray *wayPoints  = @[_wayPoint1];
    
    if (self.travelType == TravelTypeCar) {
        [self.naviManager calculateDriveRouteWithStartPoints:startPoints endPoints:endPoints wayPoints:nil drivingStrategy:0];

    }else{
        [self.naviManager calculateWalkRouteWithStartPoints:startPoints endPoints:endPoints];
    }
    
    
}
- (void)calRoute
{
    NSArray *startPoints;
    NSArray *wayPoints;
    NSArray *endPoints;
    
    if (_wayAnnotation)
    {
        wayPoints = @[[AMapNaviPoint locationWithLatitude:_wayAnnotation.coordinate.latitude
                                                longitude:_wayAnnotation.coordinate.longitude]];
    }
    
    if (_endAnnotation)
    {
        endPoints = @[[AMapNaviPoint locationWithLatitude:_endAnnotation.coordinate.latitude
                                                longitude:_endAnnotation.coordinate.longitude]];
    }
    
    if (_beginAnnotation)
    {
        startPoints = @[[AMapNaviPoint locationWithLatitude:_beginAnnotation.coordinate.latitude
                                                  longitude:_beginAnnotation.coordinate.longitude]];
    }
    
    if (_startCurrLoc)
    {
        if (endPoints.count > 0)
        {
            if (_travelType == TravelTypeCar)
            {
                [self.naviManager calculateDriveRouteWithEndPoints:endPoints
                                                         wayPoints:wayPoints
                                                   drivingStrategy:[_strategyMap[_strategyCombox.inputTextField.text] integerValue]];
            }
            else if (_travelType == TravelTypeWalk)
            {
                [self.naviManager calculateWalkRouteWithEndPoints:endPoints];
            }
            return;
        }
    }
    else
    {
        if (startPoints.count > 0 && endPoints.count > 0)
        {
            if (_travelType == TravelTypeCar)
            {
                [self.naviManager calculateDriveRouteWithStartPoints:startPoints
                                                           endPoints:endPoints
                                                           wayPoints:wayPoints
                                                     drivingStrategy:[_strategyMap[_strategyCombox.inputTextField.text] integerValue]];
            }
            else if (_travelType == TravelTypeWalk)
            {
                [self.naviManager calculateWalkRouteWithStartPoints:startPoints endPoints:endPoints];
            }
            
            return;
        }
    }
    [self.view makeToast:@"请先在地图上选点"
                duration:2.0
                position:[NSValue valueWithCGPoint:CGPointMake(160, 240)]];
    
}

#pragma mark -- MAMapView Delegate

-(MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
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
    }
    
    return nil;

}
- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineView *polylineView = [[MAPolylineView alloc] initWithPolyline:overlay];
        
        polylineView.lineWidth   = 5.0f;
        polylineView.strokeColor = [UIColor redColor];
        
        return polylineView;
    }
    return nil;
}
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    
    _startPoint = [AMapNaviPoint locationWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
//    [self.mapView removeAnnotations:self.annotionArr];
    
}
-(void)mapViewDidFinishLoadingMap:(MAMapView *)mapView{
    
    NSLog(@"0k----------");

}

#pragma mark -- AMapNaviManager Delegate
-(void)naviManagerOnCalculateRouteSuccess:(AMapNaviManager *)naviManager{
    [super naviManagerOnCalculateRouteSuccess:naviManager];
    
    [self showRouteWithNaviRoute:[[naviManager naviRoute] copy]];
    
    _calRouteSuccess = YES;
}
- (void)naviManager:(AMapNaviManager *)naviManager didPresentNaviViewController:(UIViewController *)naviViewController
{
    [super naviManager:naviManager didPresentNaviViewController:naviViewController];
    
    if (self.naviType == NavigationTypeGPS)
    {
        [self.naviManager startGPSNavi];
    }
    else if (self.naviType == NavigationTypeSimulator)
    {
        [self.naviManager startEmulatorNavi];
    }
}
- (void)naviManager:(AMapNaviManager *)naviManager didDismissNaviViewController:(UIViewController *)naviViewController
{   
    [super naviManager:naviManager didDismissNaviViewController:naviViewController];
}

//----------
- (void)showRouteWithNaviRoute:(AMapNaviRoute *)naviRoute
{
    if (naviRoute == nil)
    {
        return;
    }
    
    // 清除旧的overlays
    [self.mapView removeOverlays:self.mapView.overlays];
    
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
-(NSMutableArray *)annotionArr{
    if (!_annotionArr) {
        _annotionArr =[NSMutableArray array];
    }
    return _annotionArr;
}
@end
