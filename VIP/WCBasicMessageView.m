//
//  WCBasicMessageView.m
//  VIP
//
//  Created by NJWC on 16/3/23.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WCBasicMessageView.h"
#import "WCPopupView.h"

@interface WCBasicMessageView ()<WCPopupViewDelegate,UITextFieldDelegate>

- (IBAction)selectClick:(UIButton *)sender;

@end

@implementation WCBasicMessageView

+(instancetype)basicMessageViewWithFrame:(CGRect)frame
{
    WCBasicMessageView * basicMessageView = [[[NSBundle mainBundle] loadNibNamed:@"WCBasicMessageView" owner:nil options:nil] lastObject];
    basicMessageView.frame = frame;
    return basicMessageView;
}

#pragma mark - ****UITextFieldDelegate****
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];

    //需求变更，车牌号为可选
//    if (!self.plate.text.length) {
//        [WCPhoneNotification autoHideWithText:@"车牌号码不能为空"];
//        return;
//    }
//    if(![self.plate.text isValidateCarNo]){
//        [WCPhoneNotification autoHideWithText:@"车牌号码格式不正确，请重新输入"];
//    }
}

- (IBAction)selectClick:(UIButton *)sender {
    
    //点击这些按钮的时候，就应该让键盘下去了
    [self endEditing:YES];
    
    NSArray *nameArr;
    NSInteger index;
    switch (sender.tag) {
        case 0:
            nameArr = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"];
            index = [nameArr indexOfObject:self.vehicleNum.text];
            break;
        case 1:
            nameArr = @[@"紧急",@"优先",@"一般"];
            index = [nameArr indexOfObject:self.priority.text];
            break;
            
        default:
            break;
    }
    
    [self presentPopupViewWithTag:sender.tag withNameArray:nameArr withIndex:index];
}

-(void)presentPopupViewWithTag:(NSInteger)tag withNameArray:(NSArray *)nameArray withIndex:(NSInteger)index
{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    WCPopupView *popupView = [WCPopupView popupViewWithFrame:window.bounds];
    popupView.tag = tag;
    popupView.delegate = self;
    popupView.lastSelectedIndex = index;
    popupView.nameArray = nameArray;
    [window addSubview:popupView];
}

-(void)selectWithPopupView:(WCPopupView *)popupView withName:(NSString *)name
{
    if (popupView.tag == 0) {
        self.vehicleNum.text = name;
    }else if (popupView.tag == 1){
        self.priority.text = name;
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}


@end
