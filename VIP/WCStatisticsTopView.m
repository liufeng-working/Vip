//
//  WCStatisticsTopView.m
//  VIP
//
//  Created by NJWC on 16/3/28.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WCStatisticsTopView.h"
#import "WCDatePickerView.h"

@interface WCStatisticsTopView ()<WCDatePickerViewDelegate>
{
    UIButton *_lastBtn;
}

- (IBAction)datePickClick:(UIButton *)sender;

- (IBAction)changeFormStyleClick:(UIButton *)sender;

@end

@implementation WCStatisticsTopView

+(instancetype)statisticsTopViewWithFrame:(CGRect)frame
{
    WCStatisticsTopView * statisticsTopView = [[[NSBundle mainBundle] loadNibNamed:@"WCStatisticsTopView" owner:nil options:nil] lastObject];
    statisticsTopView.frame = frame;
    return statisticsTopView;
}

-(void)awakeFromNib
{
    //默认显示的时间
    //当前时间，向前7天
    NSDate *currentDate = [NSDate date];
    NSDate *lastSevenDay = [NSDate dateWithTimeInterval:-24*60*60*7 sinceDate:currentDate];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    self.endDate.text = [formatter stringFromDate:currentDate];
    self.startDate.text = [formatter stringFromDate:lastSevenDay];
    
    //默认显示的是图表
    _lastBtn = [self viewWithTag:2];
    _lastBtn.selected = YES;
}

- (IBAction)datePickClick:(UIButton *)sender {

    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    WCDatePickerView *pickerView = [WCDatePickerView datePickerViewWithFrame:window.bounds];
    pickerView.delegate = self;
    pickerView.dateString = sender.tag == 0 ? self.startDate.text : self.endDate.text;
    pickerView.tag = sender.tag;
    [window addSubview:pickerView];
}

- (IBAction)changeFormStyleClick:(UIButton *)sender {
    
    if (sender == _lastBtn) {
        return;
    }
    
    sender.selected = YES;
    _lastBtn.selected = NO;
    _lastBtn = sender;
    
    if([_delegate respondsToSelector:@selector(changeFormStyleWithIndex:)]){
        [_delegate changeFormStyleWithIndex:(sender.tag - 2)];
    }
}

-(void)selectDateWithPickView:(WCDatePickerView *)pickerView date:(NSString *)date
{
    if (pickerView.tag == 0) {
        self.startDate.text = date;
    }else if (pickerView.tag == 1){
        self.endDate.text = date;
    }
    
    if([_delegate respondsToSelector:@selector(selectDateWithIndex:)]){
        
        [_delegate selectDateWithIndex:pickerView.tag];
    }
}
@end
