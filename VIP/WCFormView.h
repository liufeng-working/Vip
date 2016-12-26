//
//  WCFormView.h
//  VIP
//
//  Created by NJWC on 16/3/28.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCFormView : UIView

/**
 *  所有的数据
 */
@property (nonatomic, strong)NSArray *dataArr;

+(instancetype)formViewWithFrame:(CGRect)frame;

@end
