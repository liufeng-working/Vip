//
//  WCStatisticsView.m
//  VIP
//
//  Created by NJWC on 16/3/24.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WCStatisticsView.h"
#import "WCStatisticsTopView.h"
#import "WCGraphView.h"
#import "WCFormView.h"

#define topViewAndTopDis 20 //顶部view距离上边的距离
#define topViewAndLeftDis 20 //顶部view距离左边的距离
#define topViewHeight 35 //顶部view的高度


@interface WCStatisticsView ()<WCStatisticsTopViewDelegate>

@property (nonatomic, strong)UIScrollView *formScrollView;

@end

@implementation WCStatisticsView

-(instancetype)initWithFrame:(CGRect)frame withType:(WCStatisticsViewType)statisticsViewType
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.statisticsViewType = statisticsViewType;
    }
    return self;
}

-(void)settingViewStyle
{
    switch (self.statisticsViewType) {
        
        case WCStatisticsViewTypeDay:
            [self dayView];
            break;
        case WCStatisticsViewTypeWeek:
            [self weekView];
            break;
        case WCStatisticsViewTypeMonth:
            [self monthView];
            break;
        case WCStatisticsViewTypeYear:
            [self yearView];
            break;
        default:
            break;
    }
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
        [self addSubview:_formScrollView];
    }
    return _formScrollView;
}

-(void)dayView
{
    WCStatisticsTopView *topView = [WCStatisticsTopView statisticsTopViewWithFrame:CGRectMake(topViewAndLeftDis, topViewAndLeftDis, kMainViewWidth - topViewAndLeftDis * 2, topViewHeight)];
    topView.delegate = self;
    [self addSubview:topView];
    
    self.formScrollView.frame = CGRectMake(topViewAndLeftDis, topViewAndTopDis + topView.bottom, kMainViewWidth - topViewAndLeftDis * 2, kMainViewHeight - topViewAndTopDis * 2 - topView.bottom);
    self.formScrollView.contentSize = CGSizeMake(self.formScrollView.width * 2, self.formScrollView.height);

    WCGraphView *gView = [WCGraphView graphViewWithFrame:self.formScrollView.bounds];
    [self.formScrollView addSubview:gView];
    

    WCFormView *fView = [WCFormView formViewWithFrame:CGRectMake(self.formScrollView.width, 0, self.formScrollView.width, self.formScrollView.height)];
    [self.formScrollView addSubview:fView];
    
}
-(void)weekView
{
    
}
-(void)monthView
{
    
}
-(void)yearView
{
    
}

#pragma mark - ****WCStatisticsTopViewDelegate****
-(void)datePickWithIndex:(NSInteger)index
{
    
}

-(void)changeFormStyleWithIndex:(NSInteger)index
{
    _formScrollView.contentOffset = CGPointMake(_formScrollView.width * index, 0);
}

@end
