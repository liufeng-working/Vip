//
//  WCGraphView.h
//  VIP
//
//  Created by NJWC on 16/3/28.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCGraphView : UIView

@property (nonatomic, strong)NSArray *dataArr;

+(instancetype)graphViewWithFrame:(CGRect)frame;

@end
