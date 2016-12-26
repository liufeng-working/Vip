//
//  WCPerformTaskViewController.m
//  VIP
//
//  Created by NJWC on 16/3/23.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WCPerformTaskViewController.h"
#import "WCNavigationView.h"
#import "WCHTTPRequest.h"
#import "WCTaskInfo.h"
#import "WCPerformView.h"
#import <AMapNaviKit/MAPointAnnotation.h>
#import "WCMAPointAnnotion.h"
#import "CustomAnnotationView.h"
#import "WCDataBaseTool.h"
#import "WCRoute.h"
#import "WCIntersectionInfo.h"
#import "WCTaskStatus.h"
#import "WCDeviceDirectionTool.h"
#import "WCDataSolver.h"
#import "MyMAPointAnnotation.h"
#import "WCStageSetting.h"
#import "WCStageList.h"
@interface WCPerformTaskViewController ()<WCNavigationViewDelegate,MAMapViewDelegate,AMapNaviViewControllerDelegate,AMapNaviManagerDelegate,UIAlertViewDelegate>
{
    WCPerformView *_performView;
    NSTimer       *timer ;
}


//但航管理
//@property (nonatomic, strong) AMapNaviManager *naviManager;

@property (nonatomic ,assign)NSInteger lastIndex; //记录上一次经过的第几个点

@property (nonatomic ,assign) BOOL route_SaveMoneyAvailabale;
@property (nonatomic ,assign) BOOL route_ShortDistanceAvailable;
@property (nonatomic ,assign) BOOL route_FastestTimeAvailable ;

@property (nonatomic ,strong) WCRoute *route;
@property (nonatomic ,strong) MAUserLocation * userLocation ;

@property (nonatomic, strong) MAAnnotationView *userLocationAnnotationView;

@end

@implementation WCPerformTaskViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated] ;

    
}
-(void)dealloc{
    NSLog(@"dealloc") ;
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (timer) {
        [timer invalidate];
        timer = nil ;
    }
    
    //用来控制 执行中 页面的进度
    [WCDeviceDirectionTool shareDeviceDirection].index = self.lastIndex ;
    //发通知，通知去改变进度
    [[NSNotificationCenter defaultCenter] postNotificationName:@"progress" object:nil];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated] ;
    
    //    timer
    [self timer] ;
    
    [self addPoints] ;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
//    重新设置view的frame，不能继承自父类baseViewController的view
    self.view.frame = CGRectMake(0, 0, kContentWidth, kContentHeight);
 
    //设置自定义导航条的view
    self.navigationView.titleArray = @[@"任务执行中"];
    self.navigationView.navigationViewType = WCNavigationViewTypePerformTask;
    self.navigationView.delegate = self;
    
    self.route = [WCDataBaseTool getRouteMessageWithTaskId:self.taskInfo.taskId];;
//WCTaskInfo
    
    //左侧的view
    _performView = [[WCPerformView alloc]initWithFrame:CGRectMake(0, kNavigationHeight, 240, kMainViewHeight)];
    
    NSMutableArray * nameArr = [NSMutableArray array] ;
    NSMutableArray *pointArr = [WCDataSolver myMApointAnnotionsFromString:self.taskInfo.intersections] ;

    for (MyMAPointAnnotation *p in pointArr) {
        [nameArr addObject:p.title] ;
    }
    _performView.nameArr = [NSArray arrayWithArray:nameArr] ;
    
    __weak typeof (self) wSelf = self ;
    [WCHTTPRequest getStageInfoWithIntersections:self.taskInfo.intersections success:^(NSArray *setting) {
        NSArray * sets = setting ;
        
        NSMutableArray * stageArr = [NSMutableArray array] ;
        NSArray *intArr = [wSelf.taskInfo.intersections componentsSeparatedByString:@","];
        NSArray *stageAr = [_taskInfo.stages componentsSeparatedByString:@","];
        for (NSInteger i = 0;i < intArr.count;i++) {
            NSString *intStr = intArr[i];
            NSString *stageId = stageAr[i];
            WCStageSetting * settin = sets[i];
            
            for (WCStageList * stage in settin.stageList) {
                if ([stage.intersectionId isEqualToString:intStr] &&
                    [stage.stageId isEqualToString:stageId]) {
                    [stageArr addObject:stage.stageName];
                    break;
                }
            }
        }
        _performView.detailNameArr = stageArr;
        [_performView startDrawLine];
        
        /**一定要先画出来，才能设定当前选择的路口是第几个
         想要改变进度，就给index赋值就行了
         */
        _performView.index = [WCDeviceDirectionTool shareDeviceDirection].index;
        
    } failure:^(NSString *error) {
        [WCPhoneNotification autoHideWithText:@"获取相位信息失败"];
    }] ;
    
//    NSArray * detailArr = [WCDataSolver turningsFromArray:[self.taskInfo.stageList mutableCopy]] ;
//    _performView.detailNameArr = [NSMutableArray arrayWithArray:detailArr] ;
    
    
    
    
    [self.view addSubview:_performView];
//    mapView
    [self loadMapView] ;
//   划线
    [self drawLine] ;
    

    

}
-(void)timer{
    if (!timer) {
        timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(sendUserLocation) userInfo:nil repeats:YES] ;
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];

    }
}

-(void)sendUserLocation{
    if (!self.userLocation) {
        return;
    }
    NSMutableDictionary * dic = [NSMutableDictionary dictionary] ;
    dic[@"account"] =  self.taskInfo.account ;
    dic[@"taskId"]  =  @(self.taskInfo.taskId) ;
    dic[@"plate"]   =  self.taskInfo.plate ;
    dic[@"lat"]     =  @(self.userLocation.coordinate.latitude) ;
    dic[@"lon"]     =  @(self.userLocation.coordinate.longitude) ;
    
    
    __weak typeof (self) wSelf = self ;

    [WCHTTPRequest getTaskStatusWithParameters:dic success:^(NSArray *success) {
        
        for (NSInteger i = 0; i < success.count; i ++)
        {
            WCTaskStatus *status = success[i];
            if (status.status == 1) {
                NSInteger index = i + 1;
                
                
                if (wSelf.lastIndex <= index) {
                    //如果与上次相同就什么都不用做，直接返回
                    //加上 "<" 是防止交叉路线的情况
                }else{
                    
                    //如果不相同改变进度
                    _performView.index = index;
                    
                    //记录下这次的值
                    wSelf.lastIndex = index;
                    
                    
                    //任务执行完成
                    if (index == success.count) {
                        //任务执行完成，退出当前页面
                        [wSelf finishTask];
                        
                        //任务执行完成，要在发一个通知，告诉执行中 与 待执行 刷新页面
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh" object:nil];
                    }
                 
                    //找到符合情况的，可以结束这次的for循环
                    break ;
                }
            }
        }
    } failure:^(NSString *error) {
    }];
}

-(void)finishTask
{
    //关闭定时器
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    
    //提示框
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"当前任务已经执行完成" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //任务执行 完成恢复进度为0
    [WCDeviceDirectionTool shareDeviceDirection].index = 0;
    
    //从父视图移除
    [self popFromParentViewController];
}


-(void)addPoints{
//    NSMutableArray * pointArr = [WCMAPointAnnotion modelTransformTo:self.route.annotionsOnRoutes] ;
    
    NSMutableArray *pointArr = [WCDataSolver myMApointAnnotionsFromString:self.taskInfo.intersections] ;
    [self.mapView addAnnotations:pointArr] ;
////    使地图可以看见所有的标注点
//    [self.mapView showAnnotations:[WCMAPointAnnotion modelTransformTo:self.route.annotionsOnRoutes] animated:YES] ;

}

-(void)drawLine{
    NSMutableArray * routeNaviPoints =[WCDataSolver routeSegmentsFromString:self.taskInfo.points] ;
    if (!routeNaviPoints) {
        [WCPhoneNotification autoHideWithText:@"路线信息为空"];
        return ;
    }
    MAPolyline * polyline = [self getPolylineWithCoordinates:routeNaviPoints] ;
    [self.mapView addOverlay:polyline] ;
//    [self.mapView setVisibleMapRect:[polyline boundingMapRect] animated:NO] ;
//    for (int i =0; i<self.route.routeSegments.count; i++) {
//        NSArray * arr = self.route.routeSegments[i] ;
//        MAPolyline * polyline = [self getPolylineWithCoordinates:arr] ;
////        居中
//        if (i == arr.count/2) {
//            [self.mapView setVisibleMapRect:[polyline boundingMapRect] animated:NO] ;
//        }
//        [self.mapView addOverlay:polyline] ;
//    }

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
-(void)loadMapView{
    
    [self.mapView setDelegate:self];
    [self.mapView setFrame:CGRectMake( 240,
                                      kNavigationHeight,
                                      self.view.width - 240,
                                      self.view.height- kNavigationHeight )];
    self.mapView.showsUserLocation =YES;
    self.mapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
    [self.view addSubview:self.mapView];
}

#pragma mark -- MAMapView Delegate
-(MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay{

        if ([overlay isKindOfClass:[MAPolyline class]])
        {
            MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:(MAPolyline*)overlay];

            polylineRenderer.lineWidth   = 10.f;
            polylineRenderer.strokeColor = [UIColor colorWithHexString:@"3597DB"];
            
            return polylineRenderer;
        }
        
        return nil;
    
}

-(MAAnnotationView *) mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
   if ([annotation isKindOfClass:[MAUserLocation class]]){
        static NSString *userLocationStyleReuseIndetifier = @"userLocationStyleReuseIndetifier";
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:userLocationStyleReuseIndetifier];
       
       
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:userLocationStyleReuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"icon_map_coordinate"];
       self.userLocationAnnotationView = annotationView ;
        return annotationView;
   }else if ([annotation isKindOfClass:[MyMAPointAnnotation class]])
   {
       
       MyMAPointAnnotation* myMAPointAnnotation = (MyMAPointAnnotation *)annotation ;
       static NSString *customReuseIndetifier = @"customReuseIndetifier";
       
       CustomAnnotationView *annotationView = (CustomAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
       
       if (annotationView == nil)
       {
           annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
           // must set to NO, so we can show the custom callout view.
           annotationView.canShowCallout = YES;
           annotationView.draggable = YES;
           annotationView.calloutOffset = CGPointMake(0, -5);
       }
       UIImage * image ;
       if (myMAPointAnnotation.status == 1) {
           image = [UIImage imageNamed:@"icon_map_signal-lamp_focusing"] ;
       }else{
           image = [UIImage imageNamed:@"icon_map_signal-lamp_desalination"] ;
       }

       annotationView.portrait =image;
       
       return annotationView;
   }

    return  nil ;
}
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    
    self.userLocation = userLocation;
    [mapView setCenterCoordinate:userLocation.location.coordinate animated:YES] ;
    
    if (!updatingLocation && self.userLocationAnnotationView != nil)
    {
        [UIView animateWithDuration:0.1 animations:^{

            double degree = userLocation.heading.trueHeading;
            self.userLocationAnnotationView.transform = CGAffineTransformMakeRotation(degree * M_PI / 180.f );

        }];
    }
}

- (void)showRouteWithNaviRoute:(AMapNaviRoute *)naviRoute
{
    if (naviRoute == nil)
    {
        return;
    }
    // 清除旧的overlays
//    [self.mapView removeOverlays:self.mapView.overlays];
    
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
//    [self.mapView setVisibleMapRect:[polyline boundingMapRect] animated:YES];
    
}

//返回按钮
#pragma mark - ****WCNavigationViewDelegate****
-(void)backButtonClickWithNagivationView:(WCNavigationView *)navigationView
{
    //从父视图上移除自己
    [self popFromParentViewController];
    
    
}

/**
 *  终止任务
 *
 *  @param navigationView **
 */
-(void)stopButtonClickWithNagivationView:(WCNavigationView *)navigationView
{
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"account"] = self.taskInfo.account;
    dic[@"taskId"] = @(self.taskInfo.taskId);
    
    [WCHTTPRequest finishTaskWithParameters:dic success:^(NSString *success) {
        
        //终止任务，要发一个通知，告诉执行中 与 待执行 刷新页面
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh" object:nil];
        
        //恢复进度
        [WCDeviceDirectionTool shareDeviceDirection].index = 0;
        
        //从父视图上移除自己
        [self popFromParentViewController];
        [WCPhoneNotification autoHideWithText:@"终止任务成功!"];
    } failure:^(NSString *error) {
        [WCPhoneNotification autoHideWithText:@"终止任务失败,请重试"];

    }];
}

//从父视图移除自己
-(void)popFromParentViewController
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}


@end
