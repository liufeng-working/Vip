//
//  WCCarMessageView.h
//  VIP
//
//  Created by NJWC on 16/3/29.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WCCarMessage;
@interface WCCarMessageView : UIView

@property (nonatomic, strong)WCCarMessage *carMessage;

@property(nonatomic,strong)NSArray * nameArray;

+(instancetype)carMessageViewWithFrame:(CGRect)frame;

@end
