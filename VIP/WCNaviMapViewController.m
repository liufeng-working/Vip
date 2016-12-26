//
//  WCNaviMapViewController.m
//  VIP
//
//  Created by 万存 on 16/4/5.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WCNaviMapViewController.h"
#import "WCIntersections.h"
@interface WCNaviMapViewController ()

@end

@implementation WCNaviMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}


-(MAMapView *)mapView
{
    if (!_mapView) {
        _mapView = [[MAMapView alloc] init];
        _mapView.delegate =self ;
        [_mapView setZoomLevel:18] ;
    }
    return _mapView;
}

- (void)initNaviManager
{
    if (self.naviManager == nil)
    {
        _naviManager = [[AMapNaviManager alloc] init];
    }
    
    self.naviManager.delegate = self;
}

-(AMapNaviManager *)naviManager
{
    if (!_naviManager) {
        _naviManager = [[AMapNaviManager alloc] init];
        _naviManager.delegate = self;
    }
    return _naviManager;
}

-(void)initSearch{
    self.search = [[AMapSearchAPI alloc] init];
    self.search .delegate = self; 
}

-(AMapSearchAPI *)search
{
    if (!_search) {
        _search = [[AMapSearchAPI alloc] init];
        _search .delegate = self;
    }
    return _search;
}

-(void)naviManager:(AMapNaviManager *)naviManager onCalculateRouteFailure:(NSError *)error{
    NSLog(@"error=====%@",error.localizedDescription) ;
}

//-(NSMutableArray *)allIntersections{
//    if (!_allIntersections) {
//        _allIntersections = [NSMutableArray array] ;
//        NSDictionary * dic = [WCIntersections getAllInteractions] ;
//        NSArray * allValues =[WCIntersections mj_objectArrayWithKeyValuesArray:dic.allValues];
//        for (int i =0; i<allValues.count; i++) {
//            WCIntersections * inter = allValues [i] ;
//            MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
//            annotation.coordinate = CLLocationCoordinate2DMake( inter.lat, inter.lon);
//            annotation.title    = inter.intersectionName;
//            annotation.subtitle = inter.intersectionId ;
//            [_allIntersections addObject:annotation] ;
//        }
//    }
//    return _allIntersections ;
//}
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    NSLog(@"base -- ") ;
}

@end
