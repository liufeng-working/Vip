//
//  WCBigAndSmallView.m
//  VIP
//
//  Created by NJWC on 16/3/24.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WCBigAndSmallView.h"

@interface WCBigAndSmallView ()

- (IBAction)bigAndSmallBtnClick:(UIButton *)sender;


@end

@implementation WCBigAndSmallView

+(instancetype)bigAndSmallViewWithFrame:(CGRect)frame
{
    WCBigAndSmallView * bigAndSmallView = [[[NSBundle mainBundle] loadNibNamed:@"WCBigAndSmallView" owner:nil options:nil] lastObject];
    bigAndSmallView.frame = frame;
    return bigAndSmallView;
}

- (IBAction)bigAndSmallBtnClick:(UIButton *)sender {
    
    if ([_delegate respondsToSelector:@selector(bigAndSmallViewClickWithIndex:)]) {
        [_delegate bigAndSmallViewClickWithIndex:sender.tag];
    }
}
@end
