//
//  WCLineGraphView.h
//  VIP
//
//  Created by NJWC on 16/3/30.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import <UIKit/UIKit.h>


//数据处理
@interface WCLineData : NSObject

/**
 *  内容数据
 */
@property (nonatomic, strong) NSArray *lineDataValues;

/**
 *  点击时出现的内容
 */
@property (nonatomic, strong) NSArray *lineDataPointsLabels;

/**
 *  所有点（要画折线的）
 */
@property (nonatomic) CGPoint *xPoints;

/**
 *  装 填充颜色，折线的颜色 等属性
 */
@property (nonatomic, strong) NSDictionary *lineDataThemeAttributes;


/**
 *  背景填充颜色
 */
UIKIT_EXTERN NSString *const kLineDataFillColorKey;

/**
 *  折线的宽度
 */
UIKIT_EXTERN NSString *const kLineDataStrokeWidthKey;

/**
 *  折线的颜色
 */
UIKIT_EXTERN NSString *const kLineDataStrokeColorKey;

/**
 *  圆圈的填充颜色
 */
UIKIT_EXTERN NSString *const kLineDataPointFillColorKey;

/**
 *  字体大小
 */
UIKIT_EXTERN NSString *const kLineDataPointValueFontKey;


@end

//画图
@interface WCLineGraphView : UIView

/**
 *  x轴数据
 */
@property (nonatomic, strong) NSArray *xAxisValues;

/**
 *  y轴 显示的最大数据
 */
@property (nonatomic, strong) NSNumber *yAxisRange;

/**
 *  y轴数据的 单位
 */
@property (nonatomic, strong) NSString *yAxisSuffix;

/**
 *  数据的内容
 */
@property (nonatomic, readonly, strong) NSMutableArray *lineData;

/**
 *  x、y轴字体颜色 大小 分割线颜色
 */
@property (nonatomic, strong) NSDictionary *themeAttributes;

/**
 *  添加数据
 */
- (void)addLineData:(WCLineData *)newLineData;

/**
 *  开始画图
 */
- (void)setupTheView;

//x轴字体颜色
UIKIT_EXTERN NSString *const kXAxisLabelColorKey1;

//x轴字体大小
UIKIT_EXTERN NSString *const kXAxisLabelFontKey1;

//y轴字体颜色
UIKIT_EXTERN NSString *const kYAxisLabelColorKey1;

//y轴字体大小
UIKIT_EXTERN NSString *const kYAxisLabelFontKey1;

//x轴左边加上最少距离
UIKIT_EXTERN NSString *const kYAxisLabelSideMarginsKey1;

//分割线的颜色
UIKIT_EXTERN NSString *const kLineDataBackgroundLineColorKye1;


@end
