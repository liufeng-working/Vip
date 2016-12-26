//
//  WCGraphLineView.h
//  VIP
//
//  Created by NJWC on 16/3/30.
//  Copyright © 2016年 wancun. All rights reserved.
//



typedef NS_ENUM(NSInteger,WCGraphType) {
    
    WCGraphTypeLine = 1,  //带阴影的折线图
    WCGraphTypeBar,       //柱状图
    WCGraphTypeTimeBar,   //节约时间的柱状图
};


#import <UIKit/UIKit.h>

@interface WCGraphLineView : UIView

/**
 *  类型
 */
@property(nonatomic,assign)WCGraphType graphType;

/**
 *  x轴数据
 */
@property (nonatomic, strong) NSArray *xAxisValues;

/**
 *  y轴数据的 单位
 */
@property (nonatomic, copy) NSString *yAxisSuffix;

/**
 *  内容数据(折线图，柱状图)
 */
@property (nonatomic, strong) NSArray *lineDataValues;

/**
 *  总时间
 */
@property(nonatomic,strong)NSArray * allTimeValues;
/**
 *  节约的时间
 */
@property(nonatomic,strong)NSArray * lessTimeValues;

/**
 *  所有点
 */
@property (nonatomic,assign) CGPoint *xPoints;

/**
 *  装 填充颜色，折线的颜色 等属性
 */
@property (nonatomic, strong) NSDictionary *lineDataThemeAttributes;


/**
 *  x、y轴字体颜色 大小 分割线颜色
 */
@property (nonatomic, strong) NSDictionary *themeAttributes;

/**
 *  *****************开始画图******************
 */
-(void)drawGraph;
/**
 *  ******************************************
 */

@end

//x轴字体颜色
#define kXAxisLabelColorKey     @"kXAxisLabelColorKey"
//x轴字体大小
#define kXAxisLabelFontKey @"kXAxisLabelFontKey"
//y轴字体颜色
#define kYAxisLabelColorKey @"kYAxisLabelColorKey"
//y轴字体大小
#define kYAxisLabelFontKey  @"kYAxisLabelFontKey"
//x轴左边加上最少距离
#define kYAxisLabelSideMarginsKey  @"kYAxisLabelSideMarginsKey"
//分割线的颜色
#define kLineDataBackgroundLineColorKey  @"kLineDataBackgroundLineColorKye"
//背景填充颜色
#define kLineDataFillColorKey  @"kLineDataFillColorKey"
//折线的宽度
#define kLineDataStrokeWidthKey  @"kLineDataStrokeWidthKey"
//折线的颜色
#define kLineDataStrokeColorKey  @"kLineDataStrokeColorKey"
//圆圈的填充颜色
#define kLineDataPointFillColorKey  @"kLineDataPointFillColorKey"
//字体大小
#define kLineDataPointValueFontKey  @"kLineDataPointValueFontKey"
//每部分宽度
#define kWidth 80

