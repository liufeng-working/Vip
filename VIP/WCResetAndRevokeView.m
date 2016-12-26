//
//  WCResetAndRevokeView.m
//  VIP
//
//  Created by NJWC on 16/3/23.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WCResetAndRevokeView.h"

@interface WCResetAndRevokeView ()

- (IBAction)restAndRevokeBtnClick:(UIButton *)sender;

@end

@implementation WCResetAndRevokeView

+(instancetype)resetAndRevokeViewWithFrame:(CGRect)frame
{
    WCResetAndRevokeView * resetAndRevokeView = [[[NSBundle mainBundle] loadNibNamed:@"WCResetAndRevokeView" owner:nil options:nil] lastObject];
    resetAndRevokeView.frame = frame;
    return resetAndRevokeView;
}


- (IBAction)restAndRevokeBtnClick:(UIButton *)sender {
    
    if ([_delegate respondsToSelector:@selector(resetAndRevokeWithIndex:)]) {
        [_delegate resetAndRevokeWithIndex:sender.tag];
    }
}
@end
