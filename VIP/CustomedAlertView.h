//
//  CustomedAlertView.h
//  VIP
//
//  Created by 万存 on 16/3/24.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SureBlock)();
typedef void(^CancelBlock)();
@interface CustomedAlertView : UIView

@property (nonatomic, strong) SureBlock      sureBlock;
@property (nonatomic, strong) CancelBlock    cancelBlock;

+(void)showAlertWithTitle:(NSString *)title
                   cancel:(CancelBlock)cancel
                     sure:(SureBlock)sure;
@end
