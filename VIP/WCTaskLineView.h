//
//  WCTaskLineView.h
//  VIP
//
//  Created by NJWC on 16/3/25.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WCRoadLineView;
@interface WCTaskLineView : UIView

/**
 *  路线名称
 */
@property(nonatomic,strong)NSArray<NSString *> * nameArr;

@property (weak, nonatomic) IBOutlet WCRoadLineView *roadLineView;


+(instancetype)taskLineViewWithFrame:(CGRect)frame;

@end
