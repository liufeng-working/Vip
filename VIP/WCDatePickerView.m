//
//  WCDatePickerView.m
//  VIP
//
//  Created by NJWC on 16/4/11.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WCDatePickerView.h"

@interface WCDatePickerView ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)cancelAndSureClick:(UIButton *)sender;

@end

@implementation WCDatePickerView

+(instancetype)datePickerViewWithFrame:(CGRect)frame
{
    WCDatePickerView * datePickerView = [[[NSBundle mainBundle] loadNibNamed:@"WCDatePickerView" owner:nil options:nil] lastObject];
    datePickerView.frame = frame;
    return datePickerView;
}

-(void)awakeFromNib
{
    [super awakeFromNib];

//    //设置本地化
    self.datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh"];
    
    //最大时间是当前时间
    self.datePicker.maximumDate = [NSDate date];
    
}

-(void)setDateString:(NSString *)dateString
{
    _dateString = dateString;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    self.datePicker.date = [formatter dateFromString:dateString];
}

- (IBAction)cancelAndSureClick:(UIButton *)sender {
    
    if (sender.tag == 0) {
        //啥啥都不用做
        
    }else if(sender.tag == 1){
        
        //回调
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString = [formatter stringFromDate:self.datePicker.date];
        if ([_delegate respondsToSelector:@selector(selectDateWithPickView:date:)]) {
            [_delegate selectDateWithPickView:self date:dateString];
        }
    }
    
    [self removeFromSuperview];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}

//-(void)dealloc
//{
//    NSLog(@"%s",__func__);
//}

@end
