//
//  WCMainViewController.m
//  VIP
//
//  Created by NJWC on 16/3/18.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WCMainViewController.h"
#import "TaskExcuteView.h"
#import "WCNavigationView.h"
#import "WeatherView.h"
#import "ChartView.h"
#import "AnimatedAnnotation.h"
#import "AnimatedAnnotationView.h"
#import "CustomedAlertView.h"
#import "PresentOverUsedAlertView.h"
#import "PresentCollectRouteView.h"
#import "OffsetNameView.h"
#import "MJExtension.h"
#import "WCIntersections.h"
#import "WCHTTPRequest.h"
#import "WCTaskNum.h"
#import "WCIntStat.h"

#import "WCHTTPRequest.h"
#import "WCTaskStat.h"
#import "WCDataBaseTool.h"

@interface WCMainViewController ()<MAMapViewDelegate,AMapSearchDelegate>
{
    ChartView * _chartView;
    UIButton * _sortButton;
}

//@property (nonatomic ,strong) MAMapView * mapView;


//@property (nonatomic, strong) AnimatedAnnotation *animatedCarAnnotation;

@property (nonatomic, copy) NSString * currentCity ;


@property (nonatomic ,strong) WeatherView * weatherView ;

@property (nonatomic ,strong) AMapLocalWeatherLive * liveWeather;
@property (nonatomic ,strong) AMapLocalDayWeatherForecast *dayForcast ;

@property (nonatomic ,strong) NSMutableArray * allInterActionArr ;

@property (nonatomic, assign)BOOL isSel;
@end

@implementation WCMainViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 信号点
    [self showInterSections];
    
    //请求执行任务的数据（优先路口，节约时间）
    [self getChartDataWithChartView:_chartView];
    
    //待执行、执行中、已执行
    [self loadTaskViewWithWeatherView:_weatherView];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}

- (void)viewDidLoad {
     [super viewDidLoad];
    
    self.view.frame = CGRectMake(kTabBarWidth, kStatusBarHeight, kContentWidth, kContentHeight);
    self.view.backgroundColor = [UIColor colorWithHexString:kBaseControllerBackGroundColor];
    
//TODO:天气
    [self searchLiveWeather] ;
    
    [self searchForecastWeather] ;

// 信号点
    [self showInterSections] ;
    
    //添加一个chart
    _chartView = [[ChartView alloc]initWithPosition:CGPointMake(20, 391.5 + 20)];
    [self.view addSubview:_chartView];
    //请求执行任务的数据（优先路口，节约时间）
    [self getChartDataWithChartView:_chartView];
}

-(void)showInterSections{
    __weak typeof (self) weakSelf = self ;
    [WCHTTPRequest getIntStatWithSuccess:^(NSArray *success) {
        if (success.count == 0) {
            [WCPhoneNotification autoHideWithText:@"没有数据"];
            return ;
        }
//        WCIntStat
        //先移除所有的标注
        [self.mapView removeAnnotations:self.mapView.annotations];
        
        //重新添加标注
        NSDictionary * inters = [WCIntersections getAllInteractions] ;
        for ( WCIntStat * s in success) {
            NSDictionary *dic = inters[s.intersectionId];
            WCIntersections * its = [WCIntersections mj_objectWithKeyValues:dic];
            [weakSelf addAnnotationWithCoordinate:CLLocationCoordinate2DMake(its.lat, its.lon) hotLevel:s.count] ;
        }
    } failure:^(NSString *error) {
        [WCPhoneNotification autoHideWithText:error];
//        NSLog(@"获取地图动画点失败");
    }];
}

-(void)loadWeatherViewWithWeatherInfo:(AMapLocalWeatherLive *)liveInfo forcast:(AMapLocalDayWeatherForecast *)forcast{
    _weatherView = [[WeatherView alloc]initWithPosition:CGPointMake(20, 20) weatherInfo:liveInfo forcast:forcast];
    [self.view addSubview:_weatherView];
    
    [self loadTaskViewWithWeatherView:_weatherView];
    //TODO:地图
    [self loadMapView:_weatherView] ;
}
-(void)loadTaskViewWithWeatherView:(WeatherView *)view{
    __weak typeof(self) weakSelf = self; 
    [WCHTTPRequest getTaskNumWithSuccess:^(WCTaskNum *success) {
        
        for (id obj in weakSelf.view.subviews) {
            if ([obj isKindOfClass:[TaskExcuteView class]]) {
                [(TaskExcuteView *)obj removeFromSuperview];
            }
        }
        
        for (int i = 0; i<3; i++) {
            //TODO:任务
            NSString * times ;
            if (i==0) {
                times = [NSString stringWithFormat:@"%lu/次",(long)success.watingNum] ;
            }else if (i == 1){
                times =[NSString stringWithFormat:@"%lu/次",(long)success.executingNum] ;
            }else{
               times =[NSString stringWithFormat:@"%lu/次",(long)success.executedNum] ;
            }
            TaskExcuteView * taskView = [[TaskExcuteView alloc]initWithTaskType:i+1  position:CGPointMake(i*(20+120.5)+20, 189+20) times:times];
            [weakSelf.view addSubview:taskView];

        }

        [weakSelf.view bringSubviewToFront:self.mapView] ;
        [weakSelf addSortButton] ;
        
    } failure:^(NSString *error) {
        NSLog(@"获取任务执行信息失败");
    }];
   
}

-(void)addSortButton{
    
    if (_sortButton != nil) {
        [_sortButton removeFromSuperview];
    }

    _sortButton = [[UIButton alloc] init];
    [_sortButton setBackgroundImage:[UIImage imageNamed:@"icon_map_Full screen"] forState:UIControlStateNormal];
    [_sortButton setBackgroundImage:[UIImage imageNamed:@"icon_map_Narrow screen"] forState:UIControlStateSelected];
    _sortButton.frame = CGRectMake(kContentWidth-70 , 20, 50, 50);
    [_sortButton addTarget:self action:@selector(sortAndOpen:) forControlEvents:UIControlEventTouchUpInside] ;
    _sortButton.selected = self.isSel;
    [self.view addSubview:_sortButton];
}
-(void)loadMapView:(WeatherView *)view{

     [self.mapView setFrame:CGRectMake(402 + 20 + 20,
                                      0,
                                      kContentWidth - 402 - 20 - 20,
                                      kContentHeight)];            
    [self.mapView setDelegate:self];
    self.mapView.showsCompass = NO ;
    
//    120.980737,31.385598 昆山
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(31.385598, 120.980737)];
    [self.view addSubview:self.mapView];

}

-(void)sortAndOpen:(UIButton *)btn{
    btn.enabled = NO ;
    if (btn.selected == YES) {
        [UIView animateWithDuration:.5 animations:^{
            [self.mapView setFrame:CGRectMake( 402 + 20 + 20,
                                              0,
                                              kContentWidth - 402 - 20 - 20,
                                              kContentHeight)];
        } completion:^(BOOL finished) {
            btn.enabled = YES ;
        }];
        

    }else{

        [UIView animateWithDuration:.5 animations:^{
            
            [self.mapView setFrame:CGRectMake(0,
                                              0,
                                              kContentWidth ,
                                              kContentHeight)];
            
        } completion:^(BOOL finished) {
            
            btn.enabled = YES ;

        }];
    }
   
   
    btn.selected = !btn.selected ;
    self.isSel = btn.selected;
}
#pragma mark -- 天气
- (void)searchLiveWeather
{
    
    AMapWeatherSearchRequest *request = [[AMapWeatherSearchRequest alloc] init];
    request.city                      = @"昆山";
    request.type                      = AMapWeatherTypeLive;
    
    [self.search AMapWeatherSearch:request];
}

- (void)searchForecastWeather
{
    AMapWeatherSearchRequest *request = [[AMapWeatherSearchRequest alloc] init];
    request.city                      = @"昆山";
    request.type                      = AMapWeatherTypeForecast;
    
    [self.search AMapWeatherSearch:request];
}
#pragma  mark -- MAMapdelegate
//
//-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
//    
//    NSLog(@"userLocation___MAIN_ViewCotroller");
////    static dispatch_once_t onceToken;
////    dispatch_once(&onceToken, ^{
////        NSLog(@"1111111") ;
////        AMapReGeocodeSearchRequest *regeo = [AMapReGeocodeSearchRequest new] ;
////        regeo.location = [AMapGeoPoint locationWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude] ;
////        regeo.requireExtension =YES;
////        [self.search AMapReGoecodeSearch:regeo] ;
////    });
//}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[AnimatedAnnotation class]])
    {
        static NSString *animatedAnnotationIdentifier = @"AnimatedAnnotationIdentifier";
        
        AnimatedAnnotationView *annotationView = (AnimatedAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:animatedAnnotationIdentifier];
        
        if (annotationView == nil)
        {
            annotationView = [[AnimatedAnnotationView alloc] initWithAnnotation:annotation
                                                                reuseIdentifier:animatedAnnotationIdentifier];
            
            annotationView.canShowCallout   = NO;
            annotationView.draggable        = YES;
        }
        
        return annotationView;
        
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
-(void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views{
    
    NSLog(@"__views====%@",views) ;
    
}


-(void)addAnnotationWithCoordinate:(CLLocationCoordinate2D)coordinate hotLevel:(NSInteger)level
{
    NSMutableArray *carImages = [[NSMutableArray alloc] init];
    if (level >= 10) {
        [carImages addObject:[UIImage imageNamed:@"map_traffic_red_1"]];
        [carImages addObject:[UIImage imageNamed:@"map_traffic_red_2"]];
        [carImages addObject:[UIImage imageNamed:@"map_traffic_red_3"]];
        [carImages addObject:[UIImage imageNamed:@"map_traffic_red_4"]];
    }else if (level<10&&level>=5){
        [carImages addObject:[UIImage imageNamed:@"map_traffic_yellow_1"]];
        [carImages addObject:[UIImage imageNamed:@"map_traffic_yellow_2"]];
        [carImages addObject:[UIImage imageNamed:@"map_traffic_yellow_3"]];
        [carImages addObject:[UIImage imageNamed:@"map_traffic_yellow_4"]];
    }else{
        [carImages addObject:[UIImage imageNamed:@"map_traffic_green_1"]];
        [carImages addObject:[UIImage imageNamed:@"map_traffic_green_2"]];
        [carImages addObject:[UIImage imageNamed:@"map_traffic_green_3"]];
        [carImages addObject:[UIImage imageNamed:@"map_traffic_green_4"]];
    }
   
    
    AnimatedAnnotation* animatedAnnotation= [[AnimatedAnnotation alloc] initWithCoordinate:coordinate];
    animatedAnnotation.animatedImages   = carImages;
//    animatedAnnotation.title            = @"AutoNavi";
//    animatedAnnotation.subtitle         = [NSString stringWithFormat:@"Car: %lu images",(unsigned long)[animatedAnnotation.animatedImages count]];
    
    [self.mapView addAnnotation:animatedAnnotation];
}
#pragma mark-- AmapSearchDelegate
-(void)onWeatherSearchDone:(AMapWeatherSearchRequest *)request response:(AMapWeatherSearchResponse *)response{

    if (request.type == AMapWeatherTypeLive) {
        _liveWeather = [response.lives firstObject] ;
// 
//        NSLog(@"city:_____%@ ,weather:_____%@ ,tempture:___%@,wind:____%@,humidity:___%@,windDirection:__%@",
//              _liveWeather.city,
//              _liveWeather.weather,
//              _liveWeather.temperature,
//              _liveWeather.windPower,
//              _liveWeather.humidity,
//              _liveWeather.windDirection);
        
    }else{
        AMapLocalWeatherForecast * forecast = [response.forecasts firstObject] ;
        _dayForcast = forecast.casts [1] ;
    }
    
    if (_liveWeather&&_dayForcast) {
        [self loadWeatherViewWithWeatherInfo:_liveWeather forcast:_dayForcast];
    }

}
//目前不需要定位到当前位置
//#pragma mark -- AMapSearchDelegate
//-(void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response{
//    if (response.regeocode!=nil) {
//        NSLog(@"=============%@",response.regeocode.addressComponent.city) ;
//        self.currentCity = response.regeocode.addressComponent.city ;
//
//
//    }
//}

-(void)getChartDataWithChartView:(ChartView *)chartView
{
    
    //默认显示的时间
    //当前时间，向前7天
    NSDate *currentDate = [NSDate date];
    NSDate *lastSevenDay = [NSDate dateWithTimeInterval:-24*60*60*6 sinceDate:currentDate];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyyMMdd";
    NSString *endStr = [formatter stringFromDate:currentDate];
    NSString *startStr = [formatter stringFromDate:lastSevenDay];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"account"] = [kDefaults objectForKey:kAccount];
    dic[@"beginDate"] = @([startStr integerValue]);
    dic[@"endDate"] =  @([endStr integerValue]);
    dic[@"period"] = @(0);
    
    [WCHTTPRequest getTaskStatWithParameters:dic success:^(NSArray *success) {
        if (success.count == 0) {
            [WCPhoneNotification autoHideWithText:@"没有数据"];
//            return ;
        }
        chartView.dataSource = success;
        
    } failure:^(NSString *error) {
        
    }];
}

@end
