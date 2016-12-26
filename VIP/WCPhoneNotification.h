//
//  WCPhoneNotification.h
//  VIP
//
//  Created by NJWC on 16/3/21.
//  Copyright © 2016年 wancun. All rights reserved.
//

//对MBProgressHUD进行二次封装
#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface WCPhoneNotification : NSObject

//自动隐藏
+ (void)autoHideWithIndicator;
+ (void)autoHideWithText:(NSString*)text;
+ (void)autoHideWithText:(NSString*)text indicator:(BOOL)show;
+ (void)autoHideJokeWithText:(NSString *)text;

//手动隐藏
+ (void)manuallyHideWithIndicator;
+ (void)manuallyHideWithText:(NSString*)text;
+ (void)manuallyHideWithText:(NSString*)text indicator:(BOOL)show;

//隐藏
+ (void)hideNotification;

+ (void)setHUDUserInteractionEnabled:(BOOL)enabled;

@end
