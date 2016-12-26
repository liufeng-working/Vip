//
//  PresentCollectRouteView.h
//  VIP
//
//  Created by 万存 on 16/3/28.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^SureBlock)();
typedef void (^CancelBlock)();

@interface PresentCollectRouteView : UIView


@property (nonatomic, copy) SureBlock      sureBlock;
@property (nonatomic, copy) CancelBlock    cancelBlock;

+(void)showAlertWithDataSource:(NSString *)dataSource cancel :(CancelBlock) cancel sure :(SureBlock)sure ;

@end
