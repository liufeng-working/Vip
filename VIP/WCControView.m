//
//  WCControView.m
//  VIP
//
//  Created by NJWC on 16/3/31.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WCControView.h"
#import "CustomedAlertView.h"

@interface WCControView ()

- (IBAction)controClick:(UIButton *)sender;

@end

@implementation WCControView

+(instancetype)controViewWithFrame:(CGRect)frame
{
    WCControView * controView = [[[NSBundle mainBundle] loadNibNamed:@"WCControView" owner:nil options:nil] lastObject];
    controView.frame = frame;
    
    
    return controView;
}

- (IBAction)controClick:(UIButton *)sender {
    
    [CustomedAlertView showAlertWithTitle:sender.currentTitle cancel:^{
        
        //点击了取消，什么都不用做
    } sure:^{
        
        if ([_delegate respondsToSelector:@selector(controClickWithIndex:)]) {
            [_delegate controClickWithIndex:sender.tag];
        }
        
    }];
}
@end
