//
//  PresentOverUsedAlertView.m
//  VIP
//
//  Created by 万存 on 16/3/28.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "PresentOverUsedAlertView.h"
#import "PresentOverUsedCell.h"
#import "WCHTTPRequest.h"
#import "WCIntersections.h"
#import <AMapNaviKit/MAPointAnnotation.h>
#import "WCMAPointAnnotion.h"
#import "WCDataSolver.h"
#import "WCIntersectionInfo.h"
@interface PresentOverUsedAlertView()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UIWindow *instanceWindow ;
@property (nonatomic,strong) UIWindow *realWindow;


@property (nonatomic ,strong) NSMutableArray * dataSource;
@property (nonatomic ,strong) UITableView * tableView ;



@property (nonatomic ,strong) WCRoute * routeLine ;

@end


@implementation PresentOverUsedAlertView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"EDF1F5"] ;
        [self createHeader] ;
    }
    return self;
}
-(void)getOverUsedLine{
    
   [WCHTTPRequest getLineInfoWithsuccess:^(NSArray *success) {
       self.dataSource = [success mutableCopy] ;
       [_tableView reloadData] ;
       
   } failure:^(NSString *error) {
       NSLog(@"获取常用路线失败");
   }];
}
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array] ;
    }
    return _dataSource;
}
+(PresentOverUsedAlertView *)loadOverUsedView{
    PresentOverUsedAlertView * v = [[PresentOverUsedAlertView alloc] initWithFrame:CGRectMake(0, 0, 725, 500)];
    return v;
}
+(void) showOverUsedViewWhenRouteSelected:(SelectedRoute)route{
    
    [[self loadOverUsedView] showView:route];
}

-(void)showView:(SelectedRoute)route{
    
    _instanceWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    UIViewController *v =[UIViewController new];
    _instanceWindow.rootViewController = v ;
    
    _instanceWindow.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5] ;
    _realWindow = [[UIApplication sharedApplication].delegate window];

    
    self.center = _instanceWindow.center ;
    [_instanceWindow.rootViewController.view  addSubview:self];
    
    self.route =route ;
    
    [self show] ;
}
-(void)show{

    [_realWindow resignKeyWindow];
    [_instanceWindow makeKeyAndVisible];
}
-(void)dismiss{
    [self removeFromSuperview];
    [_instanceWindow resignKeyWindow];
    [_realWindow makeKeyAndVisible] ;
}


-(void)createHeader{
    UILabel * titleLabel  = [UILabel new];
    titleLabel.bounds = CGRectMake(0, 0, 100, 21);
    titleLabel.center = CGPointMake(self.centerX, 30);
    titleLabel.textColor = [UIColor colorWithHexString:@"334455"];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"常用路线";
    [self addSubview:titleLabel] ;
    
    
    UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeCustom] ;
    cancelButton.frame =CGRectMake(self.width - 20 - 35, 12.5, 35 , 35);
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"icon_popup_cancel"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelButton] ;
    
    
    UILabel * seperater = [UILabel new];
    seperater.frame = CGRectMake(0, titleLabel.bottom+20, self.width, 1);
    seperater.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5] ;
    [self addSubview:seperater];
    
    
    [self createTableWithBottomLine:seperater];
    
    [self getOverUsedLine] ;

}
-(void)createTableWithBottomLine:(UILabel *)line{
    _tableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, line.bottom, self.width, self.height-line.bottom)];
    _tableView.dataSource= self;
    _tableView.delegate =self;
    _tableView.rowHeight = 140 ;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone ;
    [self addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:@"PresentOverUsedCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count ;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PresentOverUsedCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
  
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;

    cell.info = self.dataSource[indexPath.row] ;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WCLineInfo * info = self.dataSource[indexPath.row] ;
    
//    转化模型
    WCRoute * r = [WCRoute new];
    NSDictionary * dic =[WCIntersections getAllInteractions] ;
    NSArray * inters = [info.intersections componentsSeparatedByString:@","] ;
    NSMutableArray * mapAnnotationArr = [NSMutableArray array] ;
    NSMutableArray * annotionsSegments = [NSMutableArray array] ;

    for (int  i = 0; i<inters.count; i++) {
        NSString * key = inters[i] ;
        NSDictionary * valueDic = dic[key] ;
//        "111106": {
//            "intersectionId": "111106",
//            "intersectionName": "黑龙江路/同丰路",
//            "lat": 31.386477,
//            "lon": 120.98241,
//            "status": 1,
//            "taskId": -1
//        },
        WCIntersectionInfo * info = [WCIntersectionInfo new] ;
        info.intersectionId = [valueDic[@"intersectionId"] integerValue];
        info.intersectionName = valueDic[@"intersectionName"];
        [annotionsSegments addObject:info] ;
        if (i==0||i==inters.count-1) {
            WCMAPointAnnotion *ann = [WCMAPointAnnotion new] ;
            ann.lat = [valueDic[@"lat"] doubleValue] ;
            ann.lon = [valueDic[@"lon"] doubleValue] ;
            ann.title    = valueDic[@"intersectionName"];
            ann.subtitle = valueDic[@"intersectionId"] ;
            [mapAnnotationArr addObject:ann];
        }

    }
    [r.annotionsOnRouteSegments addObject:annotionsSegments];
    r.mapAnnotionArr    = [mapAnnotationArr copy] ;
    r.routeTime         = info. preTime ;
    r.routeLength       = [info.length integerValue];
    [r.routeSegments addObject:[WCDataSolver routeSegmentsFromString:info.points]];
    
    if (self.route) {
        self.route(r) ;
    }
    [self dismiss] ;
    
}
-(void)buttonClick:(UIButton *)btn{
    [self dismiss];
}
@end
