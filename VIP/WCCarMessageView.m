//
//  WCCarMessageView.m
//  VIP
//
//  Created by NJWC on 16/3/29.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WCCarMessageView.h"
#import "WCCarMessage.h"
#import "WCRoadLineView.h"

@interface WCCarMessageView ()

/**
 *  车牌号
 */
@property (weak, nonatomic) IBOutlet UILabel *plate;

/**
 *  车辆数目
 */
@property (weak, nonatomic) IBOutlet UILabel *vehicleNum;

/**
 *  优先级
 */
@property (weak, nonatomic) IBOutlet UILabel *priority;

/**
 *  路线信息
 */
@property (weak, nonatomic) IBOutlet WCRoadLineView *roadlineView;


@end

@implementation WCCarMessageView

+(instancetype)carMessageViewWithFrame:(CGRect)frame
{
    WCCarMessageView * carMessageView = [[[NSBundle mainBundle] loadNibNamed:@"WCCarMessageView" owner:nil options:nil] lastObject];
    carMessageView.frame = frame;
    return carMessageView;
}
-(void)setCarMessage:(WCCarMessage *)carMessage
{
    _carMessage = carMessage;
    self.plate.text = carMessage.plate;
    self.vehicleNum.text = carMessage.vehicleNum;
    self.priority.text = carMessage.priority;
}

-(void)setNameArray:(NSArray *)nameArray
{
    _nameArray = nameArray;
    
    self.roadlineView.width = self.width;
    self.roadlineView.nameArr = nameArray;
    self.roadlineView.roadLineViewType = WCRoadLineViewTypeAllName;
    self.roadlineView.count = 9;
    [self.roadlineView settingRoadLine];
}

@end
