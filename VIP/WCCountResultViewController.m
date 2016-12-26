//
//  WCCountResultViewController.m
//  VIP
//
//  Created by NJWC on 16/3/18.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WCCountResultViewController.h"
#import "WCNavigationView.h"
#import "WCHTTPRequest.h"
#import "WCStatisticsTopView.h"
#import "WCGraphView.h"
#import "WCFormView.h"

#define topViewAndTopDis (20 + kNavigationHeight) //顶部view距离上边的距离
#define topViewAndLeftDis 20 //顶部view距离左边的距离
#define topViewHeight 35 //顶部view的高度

@interface WCCountResultViewController ()<WCNavigationViewDelegate,WCStatisticsTopViewDelegate>
{
    WCStatisticsTopView *_topView;
    WCGraphView *_gView;
    WCFormView *_fView;
}

@property (nonatomic, strong)UIScrollView *formScrollView;

/**
 *  统计周期
 */
@property (nonatomic, assign)NSInteger statPeriod;


@end

@implementation WCCountResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置navigationView的类型
    self.navigationView.titleArray = @[@"日",@"周",@"月",@"年"];
    self.navigationView.navigationViewType = WCNavigationViewTypeCount;
    self.navigationView.delegate = self;
    
    _topView = [WCStatisticsTopView statisticsTopViewWithFrame:CGRectMake(topViewAndLeftDis, topViewAndTopDis, kMainViewWidth - topViewAndLeftDis * 2, topViewHeight)];
    _topView.delegate = self;
    [self.view addSubview:_topView];
    
    
    self.formScrollView.frame = CGRectMake(topViewAndLeftDis, 20 + _topView.bottom, kMainViewWidth - topViewAndLeftDis * 2, kMainViewHeight - 20 * 3 - _topView.height);
    self.formScrollView.contentSize = CGSizeMake(self.formScrollView.width * 2, self.formScrollView.height);
    
    _gView = [WCGraphView graphViewWithFrame:self.formScrollView.bounds];
    [self.formScrollView addSubview:_gView];
    
    
    _fView = [WCFormView formViewWithFrame:CGRectMake(self.formScrollView.width, 0, self.formScrollView.width, self.formScrollView.height)];
    [self.formScrollView addSubview:_fView];
    
    [self getData];
    
}

-(UIScrollView *)formScrollView
{
    if (!_formScrollView) {
        _formScrollView = [[UIScrollView alloc]init];
        
        _formScrollView.backgroundColor = [UIColor clearColor];
        _formScrollView.pagingEnabled = YES;
        _formScrollView.bounces = NO;
        _formScrollView.scrollEnabled = NO;
        _formScrollView.showsHorizontalScrollIndicator = NO;
        _formScrollView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_formScrollView];
    }
    return _formScrollView;
}

//顶部导航条点击事件
-(void)dateButtonClickWithNagivationView:(WCNavigationView *)navigationView fromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
    self.statPeriod = toIndex;
    
    //从新请求数据
    [self getData];
}

//时间选中后
-(void)selectDateWithIndex:(NSInteger)index
{
    if ([self handleDateWithDateString:_topView.startDate.text] >=
        [self handleDateWithDateString:_topView.endDate.text]){
        [WCPhoneNotification autoHideWithText:@"请选择正确的范围"];
        return;
    }
    
    //请求数据
    [self getData];
}

//切换图形和表格
-(void)changeFormStyleWithIndex:(NSInteger)index
{
    [UIView animateWithDuration:0.5 animations:^{
        _formScrollView.contentOffset = CGPointMake(index * _formScrollView.width, 0);
    }];
}

//请求获取数据
-(void)getData
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"account"] = [kDefaults objectForKey:kAccount];
    dic[@"beginDate"] = @([self handleDateWithDateString:_topView.startDate.text]);
    dic[@"endDate"] =  @([self handleDateWithDateString:_topView.endDate.text]);
    dic[@"period"] = @(self.statPeriod);
    //    dic[@"pageIndex"] = @1;
    //    dic[@"pageReocords"] = @5;
    
    [WCHTTPRequest getTaskStatWithParameters:dic success:^(NSArray *success) {
        if (success.count == 0) {
            [WCPhoneNotification autoHideWithText:@"没有新数据"];
//            return ;
        }
        
        //给图形赋值
        _gView.dataArr = success;
        //给表格赋值
        _fView.dataArr = success;
        
    } failure:^(NSString *error) {
        
    }];
}

//处理日期
- (NSInteger)handleDateWithDateString:(NSString *)date
{
   NSString *dateStr = [date stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return [dateStr integerValue];
}

@end
