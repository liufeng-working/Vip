//
//  ChartView.h
//  VIP
//
//  Created by 万存 on 16/3/22.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChartView : UIView

//-(instancetype)initWithPoint:(CGPoint)point;

@property (nonatomic,assign) CGRect rect ;

@property (nonatomic ,strong)NSArray * dataSource ;

-(instancetype)initWithPosition:(CGPoint)point ;

@end
