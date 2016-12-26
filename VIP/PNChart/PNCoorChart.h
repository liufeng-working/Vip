//
//  PNCoorChart.h
//  Chart
//
//  Created by 万存 on 16/3/23.
//  Copyright © 2016年 WanCun. All rights reserved.
//

#import "PNGenericChart.h"

#import <UIKit/UIKit.h>
#import "PNChartDelegate.h"
#import "PNBar.h"

#define kXLabelMargin 15
#define kYLabelMargin 15
#define kYLabelHeight 11
#define kXLabelHeight 20

typedef NSString *(^PNYLabelFormatter)(CGFloat yLabelValue);
@interface PNCoorChart : PNGenericChart
/**
 * Draws the chart in an animated fashion.
 */
- (void)strokeChart;

/*
 *折线部分
 */
//折线数据信息
@property (nonatomic) NSArray *lineChartData;

@property (nonatomic) NSMutableArray *pathPoints;

@property (nonatomic) CGFloat chartCavanHeight;

@property (nonatomic) CGFloat chartCavanWidth;

@property (nonatomic) CGFloat yLabelHeight;

@property (nonatomic) float lineYMAX;

@property (nonatomic) float lineYMIN;



@property (nonatomic) CGFloat lineYFixedValueMax;
@property (nonatomic) CGFloat lineYFixedValueMin;


/**
 * String formatter for float values in y-axis labels. If not set, defaults to @"%1.f"
 */
@property (nonatomic, strong) NSString *lineYLabelFormat;

/*
 *圆柱部分
 */
@property (nonatomic) NSArray *xLabels;
@property (nonatomic) NSArray *yLeftLabels;
@property (nonatomic) NSArray *yRightLabels;
@property (nonatomic) float  YRightValueMax;


//圆柱的值
@property (nonatomic) NSArray *yLeftValues;


@property (nonatomic) NSMutableArray * bars;

@property (nonatomic) CGFloat xLabelWidth;
@property (nonatomic) float yLeftValueMax;
@property (nonatomic) UIColor *strokeColor;
@property (nonatomic) NSArray *strokeColors;


/** Update Values. */
- (void)updateChartData:(NSArray *)data;

/** Changes chart margin. */
@property (nonatomic) CGFloat yChartLabelWidth;

/** Formats the ylabel text. */
@property (copy) PNYLabelFormatter yLabelFormatter;

/** Prefix to y label values, none if unset. */
@property (nonatomic) NSString *yLabelPrefix;

/** Suffix to y label values, none if unset. */
@property (nonatomic) NSString *yLabelSuffix;

@property (nonatomic) CGFloat chartMarginLeft;
@property (nonatomic) CGFloat chartMarginRight;
@property (nonatomic) CGFloat chartMarginTop;
@property (nonatomic) CGFloat chartMarginBottom;

/** Controls whether labels should be displayed. */
@property (nonatomic) BOOL showLabel;

/** Controls whether the chart border line should be displayed. */
@property (nonatomic) BOOL showChartBorder;

@property (nonatomic) UIColor *chartBorderColor;

/** Controls whether the chart Horizontal separator should be displayed. */
@property (nonatomic, assign) BOOL showLevelLine;

/** Chart bottom border, co-linear with the x-axis. */
@property (nonatomic) CAShapeLayer * chartBottomLine;

/** Chart bottom border, level separator-linear with the x-axis. */
@property (nonatomic) CAShapeLayer * chartLevelLine;

/** Chart left border, co-linear with the y-axis. */
@property (nonatomic) CAShapeLayer * chartLeftLine;

@property (nonatomic) CAShapeLayer * chartRightLine ;

/** Corner radius for all bars in the chart. */
@property (nonatomic) CGFloat barRadius;

/** Width of all bars in the chart. */
@property (nonatomic) CGFloat barWidth;

@property (nonatomic) CGFloat labelMarginTop;

/** Background color of all bars in the chart. */
@property (nonatomic) UIColor * barBackgroundColor;

/** Text color for all bars in the chart. */
@property (nonatomic) UIColor * labelTextColor;

/** Font for all bars in the chart. */
@property (nonatomic) UIFont * labelFont;

/** How many labels on the x-axis to skip in between displaying labels. */
@property (nonatomic) NSInteger xLabelSkip;

/** How many labels on the y-axis to skip in between displaying labels. */
@property (nonatomic) NSInteger yLabelSum;

/** The maximum for the range of values to display on the y-axis. */
@property (nonatomic) CGFloat yMaxValue;

/** The minimum for the range of values to display on the y-axis. */
@property (nonatomic) CGFloat yMinValue;

/** Controls whether each bar should have a gradient fill. */
@property (nonatomic) UIColor *barColorGradientStart;

/** Controls whether text for x-axis be straight or rotate 45 degree. */
@property (nonatomic) BOOL rotateForXAxisText;

@property (nonatomic, weak) id<PNChartDelegate> delegate;

/**whether show gradient bar*/
@property (nonatomic, assign) BOOL isGradientShow;

/** whether show numbers*/
@property (nonatomic, assign) BOOL isShowNumbers;
@end
