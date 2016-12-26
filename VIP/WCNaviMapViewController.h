//
//  WCNaviMapViewController.h
//  VIP
//
//  Created by 万存 on 16/4/5.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WCBaseViewController.h"
#import <AMapNaviKit/MAMapKit.h>
#import <AMapNaviKit/AMapNaviKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
@interface WCNaviMapViewController : WCBaseViewController <MAMapViewDelegate,AMapNaviManagerDelegate,AMapSearchDelegate>

@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) AMapNaviManager *naviManager;

@property (nonatomic ,strong) AMapSearchAPI * search ;

@property (nonatomic ,strong) NSMutableArray *allIntersections ;

@end
