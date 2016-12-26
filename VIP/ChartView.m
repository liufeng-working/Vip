//
//  ChartView.m
//  VIP
//
//  Created by 万存 on 16/3/22.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "ChartView.h"

#import "WCTaskStat.h"
#import "WCMainGraphView.h"

@interface ChartView()

/**
 *  统计的时间
 */
@property (nonatomic, strong)NSMutableArray *statDateArr;

/**
 *  优先路口数
 */
@property (nonatomic, strong)NSMutableArray *prioIntNumArr;

/**
 *  节约时间
 */
@property (nonatomic, strong)NSMutableArray *saveTimeArr;

@end
@implementation ChartView


-(instancetype)initWithPosition:(CGPoint)point{
    if (self = [super init]) {
        [self initChartViewWithPoint:point];
    }
    return self  ;
}
-(void)initChartViewWithPoint:(CGPoint)point{
    UIImage * chartBackImage =[UIImage imageNamed:@"statistics_background"];
    self.frame =CGRectMake(point.x, point.y, chartBackImage.size.width, chartBackImage.size.height);
    
    UIImageView * chartBackImageView = [[UIImageView alloc]initWithFrame:self.bounds];
    chartBackImageView.image = chartBackImage;
    [self addSubview:chartBackImageView];
    
    UIImage * staticImage = [UIImage imageNamed:@"icon_statistics2"];
    UIImageView * staticImageView =[[UIImageView alloc]initWithFrame:CGRectMake(17, 10 , staticImage.size.width, staticImage.size.height)];
    staticImageView.image = staticImage;
    [chartBackImageView addSubview:staticImageView];
    
    
    UILabel * staticLabel = [[UILabel alloc]initWithFrame:CGRectMake(staticImageView.right+10, 10, [@"执行效益"  widthWithFontSize:20], 21)];
    staticLabel.text = @"执行效益";
    staticLabel.textColor = [UIColor colorWithHexString:@"8899AA"];
    staticLabel.font = [UIFont systemFontOfSize:20];
    [chartBackImageView addSubview:staticLabel];
    
    _rect =CGRectMake(0, staticLabel.bottom+20, self.frame.size.width, self.frame.size.height-staticLabel.bottom - 20 );
}

/**
 *  一大波懒加载
 */
-(NSMutableArray *)statDateArr
{
    if (!_statDateArr) {
        _statDateArr = [NSMutableArray array];
    }
    return _statDateArr;
}

-(NSMutableArray *)prioIntNumArr
{
    if (!_prioIntNumArr) {
        _prioIntNumArr = [NSMutableArray array];
    }
    return _prioIntNumArr;
}

-(NSMutableArray *)saveTimeArr
{
    if (!_saveTimeArr) {
        _saveTimeArr = [NSMutableArray array];
    }
    return _saveTimeArr;
}

-(void)setDataSource:(NSArray *)dataSource{
    
    _dataSource = dataSource;
    if (!dataSource||dataSource.count == 0) {
        return;
    }
    
    //先清除原来的残留数据
    [self.statDateArr removeAllObjects];
    [self.prioIntNumArr removeAllObjects];
    [self.saveTimeArr removeAllObjects];
    
    for (WCTaskStat *taskStat in dataSource) {
        //统计时间段
        [self.statDateArr addObject:taskStat.statDate];
        
        
        //优先路口数
        [self.prioIntNumArr addObject:@(taskStat.prioIntNum)];
        
        
        //节约时间
        [self.saveTimeArr addObject:@(taskStat.saveTime)];
    }
    
    
    [self addGraph];
}

-(void)addGraph
{
    for (id obj in self.subviews) {
        if ([obj isKindOfClass:[WCMainGraphView class]]) {
            [obj removeFromSuperview];
        }
    }
    
    
    WCMainGraphView *graphView = [[WCMainGraphView alloc]initWithFrame:CGRectMake(0, 20, self.width, self.height - 20)];
    graphView.xValues = self.statDateArr;
    graphView.prioIntNumArr = self.prioIntNumArr;
    graphView.saveTimeArr = self.saveTimeArr;
    [graphView drawGraph];
    [self addSubview:graphView];
}
@end
