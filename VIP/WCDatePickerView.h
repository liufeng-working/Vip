//
//  WCDatePickerView.h
//  VIP
//
//  Created by NJWC on 16/4/11.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WCDatePickerView;
@protocol WCDatePickerViewDelegate <NSObject>

- (void)selectDateWithPickView:(WCDatePickerView *)pickerView date:(NSString *)date;

@end

@interface WCDatePickerView : UIView

@property (nonatomic, copy)NSString *dateString;

@property (nonatomic, weak)id<WCDatePickerViewDelegate> delegate;
+(instancetype)datePickerViewWithFrame:(CGRect)frame;

@end
