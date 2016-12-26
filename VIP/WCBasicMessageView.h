//
//  WCBasicMessageView.h
//  VIP
//
//  Created by NJWC on 16/3/23.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCBasicMessageView : UIView

/**
 * 车牌号
 */
@property (weak, nonatomic) IBOutlet UITextField *plate;

/**
 *  车辆数目
 */
@property (weak, nonatomic) IBOutlet UITextField *vehicleNum;

/**
 *  优先等级
 */
@property (weak, nonatomic) IBOutlet UITextField *priority;

/**
 *  备注
 */
@property (weak, nonatomic) IBOutlet UITextField *descriptions;


+(instancetype)basicMessageViewWithFrame:(CGRect)frame;

@end
