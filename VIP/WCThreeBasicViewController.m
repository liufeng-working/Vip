//
//  WCThreeBasicViewController.m
//  VIP
//
//  Created by NJWC on 16/4/1.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WCThreeBasicViewController.h"
#import "WCFourBasicViewController.h"
#import "OffsetTableView.h"
#import "WCNavigationView.h"
#import "WCMAPointAnnotion.h"
#import "WCStageList.h"
#import "WCHTTPRequest.h"
#import "WCStageSetting.h"
#import "WCDataSolver.h"
#import "WCIntersectionInfo.h"
@interface WCThreeBasicViewController ()<WCNavigationViewDelegate>


@property (nonatomic,strong) NSMutableArray * offsetArr ;


@property (nonatomic ,strong)  OffsetTableView * tabView ;

@property (nonatomic ,strong)  NSMutableArray * selectedIDArr ;
@end

@implementation WCThreeBasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationView.index = 3;
    self.navigationView.delegate = self;
    
    [self getOffsetData] ;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivePoster:) name:@"POSTSTAGEID" object:nil];
  
}
-(void)receivePoster:(NSNotification *)notice{
    self.selectedIDArr = notice.userInfo[@"IDArray"];
    
}
-(NSMutableArray *)selectedIDArr{
    if (!_selectedIDArr) {
        _selectedIDArr = [NSMutableArray array] ;
    }
    return _selectedIDArr  ;
}
#pragma mark -- 获取相位数据
-(void)getOffsetData{
    NSMutableArray * IDArr = [NSMutableArray array] ;
    for (WCIntersectionInfo *info in self.route.annotionsOnRoutes) {
        [IDArr addObject:@(info.intersectionId)] ;
    }
    NSString * IDString = [IDArr componentsJoinedByString:@","] ;
    
    __weak typeof (self) weakSelf = self ;
   [WCHTTPRequest getStageInfoWithIntersections:IDString success:^(NSArray *setting) {
       _tabView = [[OffsetTableView alloc]initWithFrame:CGRectMake(20, kNavigationHeight + 20, kMainViewWidth - 40, kMainViewHeight -40 + 1)];
       _tabView.lineArray = self.route.annotionsOnRoutes ;
       _tabView.offsetNameArr = [NSMutableArray arrayWithArray:setting] ;
       [self.view addSubview:_tabView] ;
     
    
       weakSelf.offsetArr = [setting mutableCopy];
       
   } failure:^(NSString *error) {
       
       [WCPhoneNotification autoHideWithText:error];
       
   }];
}

-(void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightButtonClick
{
//    dic[@"intersections"] = @"101104";//路口编号
//    dic[@"length"] = @"3.5";//路线长度
//    dic[@"preTime"] = @35;//行程时间
//    dic[@"stages"] = @"1";//相位编号
    NSMutableDictionary * dic = [NSMutableDictionary dictionary] ;

    NSString * IDString = [WCDataSolver intersectionsStringFromArray:_route.annotionsOnRoutes];
    
    NSString *stateNumString =[WCDataSolver turningIDFromArray:_selectedIDArr] ;
    
    NSString *pragrmIDstring =[WCDataSolver programeIDFromArray:_offsetArr] ;
    
    dic[@"intersections"] = IDString;
    dic[@"stages"] = stateNumString ;
    dic[@"programs"] = pragrmIDstring ;
    dic[@"preTime"] = @(self.route.routeTime) ;
    dic[@"length"]  = @(self.route.routeLength) ;
    WCFourBasicViewController *fVC = [[WCFourBasicViewController alloc]init];
    fVC.senderDic = dic ;
    self.route.routeTurnings =[WCDataSolver turningsFromArray:_selectedIDArr];
    fVC.route = self.route ;
    [self.navigationController pushViewController:fVC animated:YES];
}

@end
