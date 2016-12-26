//
//  WCMainGraphView.h
//  VIP
//
//  Created by NJWC on 16/4/13.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCMainGraphView : UIView

/**
 *  x轴显示数据
 */
@property (nonatomic, strong)NSArray *xValues;

/**
 *  途径路口数（优先路口数）
 */
@property (nonatomic, strong)NSArray *prioIntNumArr;

/**
 *  节约时间
 */
@property (nonatomic, strong)NSArray *saveTimeArr;

/**
 *  *****************开始画图******************
 */
-(void)drawGraph;
/**
 *  ******************************************
 */

@end
