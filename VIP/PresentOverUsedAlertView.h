//
//  PresentOverUsedAlertView.h
//  VIP
//
//  Created by 万存 on 16/3/28.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCRoute.h"
typedef void (^SelectedRoute)(WCRoute * route) ;
@interface PresentOverUsedAlertView : UIView

@property (nonatomic,copy)SelectedRoute route ;

+(void) showOverUsedViewWhenRouteSelected:(SelectedRoute)route;
@end
