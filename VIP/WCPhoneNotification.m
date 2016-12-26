//
//  WCPhoneNotification.m
//  SurfNewsHD
//
//  Created by NJWC on 16/3/21.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WCPhoneNotification.h"
#import "AppDelegate.h"
#import "NSString+Extensions.h"

#define HideTime   2.0f
#define Margin     10.0f
#define YOffset    -50.0f
#define LabelFont  kAlertSize

@implementation WCPhoneNotification

MBProgressHUD *HUD = nil;

//自动隐藏
+ (void)autoHideWithIndicator
{
    if (HUD){
        [HUD hide:NO];
        HUD = nil;
    }
    
    HUD = [MBProgressHUD showHUDAddedTo:kTheApp.window animated:YES];
	
	HUD.removeFromSuperViewOnHide = YES;
    HUD.margin = Margin;
    HUD.yOffset = YOffset;
    HUD.userInteractionEnabled = NO;
	
	[HUD hide:YES afterDelay:HideTime];
}

+ (void)autoHideWithText:(NSString*)text
{
    if (text == nil || [text isEmptyOrBlank]) {
        return;
    }
    
    if (HUD){
        [HUD hide:NO];
        HUD = nil;
    }
    
    HUD = [MBProgressHUD showHUDAddedTo:kTheApp.window animated:YES];
	
	HUD.mode = MBProgressHUDModeText;
	HUD.labelText = text;
	HUD.margin = Margin;
	HUD.yOffset = YOffset;
    HUD.color = [UIColor blackColor];
    HUD.labelFont = [UIFont systemFontOfSize:LabelFont];
	HUD.removeFromSuperViewOnHide = YES;
	HUD.userInteractionEnabled = NO;
    
	[HUD hide:YES afterDelay:HideTime];
    
    
}

+ (void)autoHideWithText:(NSString*)text indicator:(BOOL)show
{
    if (text == nil || [text isEmptyOrBlank]) {
        return [WCPhoneNotification autoHideWithIndicator];
    }
    
    if (!show) {
        return [WCPhoneNotification autoHideWithText:text];
    }
    
    if (HUD){
        [HUD hide:NO];
        HUD = nil;
    }
    
    HUD = [MBProgressHUD showHUDAddedTo:kTheApp.window animated:YES];
	
	HUD.labelText = text;
    HUD.margin = Margin;
	HUD.yOffset = YOffset;
    HUD.color = [UIColor blackColor];
    HUD.labelFont = [UIFont systemFontOfSize:LabelFont];
	HUD.removeFromSuperViewOnHide = YES;
    HUD.userInteractionEnabled = NO;
	
	[HUD hide:YES afterDelay:HideTime];
}

+ (void)autoHideJokeWithText:(NSString *)text {
    if (text == nil || [text isEmptyOrBlank]) {
        return;
    }
    
    if (HUD){
        [HUD hide:NO];
        HUD = nil;
    }
    
    HUD = [MBProgressHUD showHUDAddedTo:kTheApp.window animated:YES];
    
    HUD.mode = MBProgressHUDModeText;
    HUD.labelText = text;
    HUD.margin = Margin;
    HUD.yOffset = [UIScreen mainScreen].bounds.size.height * 0.5 - 100;
    HUD.color = [UIColor blackColor];
    HUD.labelFont = [UIFont systemFontOfSize:LabelFont];
    HUD.removeFromSuperViewOnHide = YES;
    HUD.userInteractionEnabled = NO;
    
    [HUD hide:YES afterDelay:HideTime];
}

//手动隐藏
+ (void)manuallyHideWithIndicator
{
    if (HUD){
        [HUD hide:NO];
        HUD = nil;
    }
    
    HUD = [MBProgressHUD showHUDAddedTo:kTheApp.window animated:YES];
	
    HUD.margin = Margin;
	HUD.yOffset = YOffset;
	HUD.removeFromSuperViewOnHide = YES;
    HUD.userInteractionEnabled = YES;
    HUD.dimBackground = YES;
}

+ (void)manuallyHideWithText:(NSString*)text
{
    if (text == nil || [text isEmptyOrBlank]) {
        return;
    }
    
    if (HUD){
        [HUD hide:NO];
        HUD = nil;
    }
    
    HUD = [MBProgressHUD showHUDAddedTo:kTheApp.window animated:YES];
	
	HUD.mode = MBProgressHUDModeText;
	HUD.labelText = text;
	HUD.margin = Margin;
	HUD.yOffset = YOffset;
    HUD.color = [UIColor blackColor];
    HUD.labelFont = [UIFont systemFontOfSize:LabelFont];
	HUD.removeFromSuperViewOnHide = YES;
}

+ (void)manuallyHideWithText:(NSString*)text indicator:(BOOL)show
{
    if (text == nil || [text isEmptyOrBlank]) {
        return [WCPhoneNotification manuallyHideWithIndicator];
    }
    
    if (HUD){
        [HUD hide:NO];
        HUD = nil;
    }
    
    if (!show) {
        return [WCPhoneNotification manuallyHideWithText:text];
    }
    
    HUD = [MBProgressHUD showHUDAddedTo:kTheApp.window animated:YES];
	
	HUD.labelText = text;
    HUD.margin = Margin;
	HUD.yOffset = YOffset;
    HUD.color = [UIColor blackColor];
    HUD.labelFont = [UIFont systemFontOfSize:LabelFont];
	HUD.removeFromSuperViewOnHide = YES;
}

//隐藏
+ (void)hideNotification
{
    if (HUD) {
        [HUD hide:YES];
    }
}

+ (void)setHUDUserInteractionEnabled:(BOOL)enabled
{
    if (HUD) {
        HUD.userInteractionEnabled = enabled;
    }
}

@end
