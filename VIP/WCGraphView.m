//
//  WCGraphView.m
//  VIP
//
//  Created by NJWC on 16/3/28.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WCGraphView.h"
#import "WCGraphLineView.h"
#import "WCTaskStat.h"

@interface WCGraphView ()
{
    UIButton *_lastBtn;
}

@property (nonatomic, strong)UIScrollView *graphScr;
/**
 *  统计的时间
 */
@property (nonatomic, strong)NSMutableArray *statDateArr;

/**
 *  任务数
 */
@property (nonatomic, strong)NSMutableArray *taskNumArr;

/**
 *  优先路口数
 */
@property (nonatomic, strong)NSMutableArray *prioIntNumArr;

/**
 *  执行的总时间
 */
@property (nonatomic, strong)NSMutableArray *travelTimeArr;

/**
 *  节约时间
 */
@property (nonatomic, strong)NSMutableArray *saveTimeArr;


- (IBAction)graphButtonClick:(UIButton *)sender;

@end

@implementation WCGraphView

+(instancetype)graphViewWithFrame:(CGRect)frame
{
    WCGraphView * graphView = [[[NSBundle mainBundle] loadNibNamed:@"WCGraphView" owner:nil options:nil] lastObject];
    graphView.frame = frame;

    return graphView;
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
-(NSMutableArray *)taskNumArr
{
    if (!_taskNumArr) {
        _taskNumArr = [NSMutableArray array];
    }
    return _taskNumArr;
}
-(NSMutableArray *)prioIntNumArr
{
    if (!_prioIntNumArr) {
        _prioIntNumArr = [NSMutableArray array];
    }
    return _prioIntNumArr;
}
-(NSMutableArray *)travelTimeArr
{
    if (!_travelTimeArr) {
        _travelTimeArr = [NSMutableArray array];
    }
    return _travelTimeArr;
}
-(NSMutableArray *)saveTimeArr
{
    if (!_saveTimeArr) {
        _saveTimeArr = [NSMutableArray array];
    }
    return _saveTimeArr;
}


-(void)setDataArr:(NSArray *)dataArr
{
    _dataArr = dataArr;
    
    //先清除原来的残留数据
    [self.statDateArr removeAllObjects];
    [self.taskNumArr removeAllObjects];
    [self.prioIntNumArr removeAllObjects];
    [self.travelTimeArr removeAllObjects];
    [self.saveTimeArr removeAllObjects];
    
    for (WCTaskStat *taskStat in dataArr) {
        //统计时间段
        [self.statDateArr addObject:taskStat.statDate];
        
        //任务数
        [self.taskNumArr addObject:@(taskStat.taskNum)];
        
        //优先路口数
        [self.prioIntNumArr addObject:@(taskStat.prioIntNum)];
        
        //执行时间
        [self.travelTimeArr addObject:@(taskStat.travelTime + taskStat.saveTime)];
        
        //节约时间
        [self.saveTimeArr addObject:@(taskStat.saveTime)];
    }
    
    //有数据了再去添加子视图
    //添加一个图表子控件
   [self addChartView];
}

- (void)addChartView
{
    //先移除原来的，重新画图
    for (id obj in self.graphScr.subviews) {
        [obj removeFromSuperview];
    }
    
    
    for (NSInteger i = 0; i < 3; i ++)
    {
        //
        CGFloat lineW;
        if (i == 0) {
            lineW = kWidth * self.statDateArr.count;
        }else{
            lineW = kWidth * (self.statDateArr.count + 1);
        }
        
        //底部的scrollView
        UIScrollView *bgScr = [[UIScrollView alloc]initWithFrame:CGRectMake(self.graphScr.width * i, 0, self.graphScr.width, self.graphScr.height)];
        bgScr.showsHorizontalScrollIndicator = NO;
        bgScr.showsVerticalScrollIndicator = NO;
        bgScr.contentSize = CGSizeMake(lineW, self.graphScr.height);
        [self.graphScr addSubview:bgScr];
        //图形部分
        WCGraphLineView *lineGraph = [[WCGraphLineView alloc]initWithFrame:CGRectMake(0, 0, lineW, bgScr.height)];
        lineGraph.graphType = i + 1;
        //x轴显示内容
        lineGraph.xAxisValues = self.statDateArr;
        //y轴数值
        if (lineGraph.graphType == WCGraphTypeTimeBar) {

            lineGraph.allTimeValues = self.travelTimeArr;
            lineGraph.lessTimeValues = self.saveTimeArr;
        }else if(lineGraph.graphType == WCGraphTypeLine){

            lineGraph.lineDataValues = self.taskNumArr;
        }else if(lineGraph.graphType == WCGraphTypeBar){

            lineGraph.lineDataValues = self.prioIntNumArr;
        }
        
        //这句开始画
        [lineGraph drawGraph];
        [bgScr addSubview:lineGraph];
    }
}

-(UIScrollView *)graphScr
{
    if (!_graphScr) {
        _graphScr = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 45, self.width, self.height - 45)];
        _graphScr.bounces = NO;
        _graphScr.scrollEnabled = NO;
        _graphScr.showsHorizontalScrollIndicator = NO;
        _graphScr.showsVerticalScrollIndicator = NO;
        _graphScr.contentSize = CGSizeMake(self.width * 3, self.height - 45);
        [self addSubview:_graphScr];
    }
    return _graphScr;
}

-(void)awakeFromNib
{
    _lastBtn = [self viewWithTag:1];
    _lastBtn.selected = YES;
}

- (IBAction)graphButtonClick:(UIButton *)sender {
    
    if (sender == _lastBtn) {
        return;
    }
    
    sender.selected = YES;
    _lastBtn.selected = NO;
    _lastBtn = sender;
    
    for (id obj in self.subviews) {
        if ([obj isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scr = (UIScrollView *)obj;
            scr.contentOffset = CGPointMake(self.width * (sender.tag - 1), 0);
        }
    }
}

@end
