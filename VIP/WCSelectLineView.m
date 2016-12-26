//
//  WCSelectLineView.m
//  VIP
//
//  Created by NJWC on 16/3/23.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WCSelectLineView.h"

@interface WCSelectLineView ()
{
    UIButton * _lastBtn;
}

- (IBAction)lineBtnClick:(UIButton *)sender;

@end

@implementation WCSelectLineView

+(instancetype)selectLineViewWithFrame:(CGRect)frame
{
    WCSelectLineView * selectView = [[[NSBundle mainBundle] loadNibNamed:@"WCSelectLineView" owner:nil options:nil] lastObject];
    selectView.frame = frame;
    return selectView;
}

-(void)awakeFromNib
{
    _lastBtn = self.subviews[0];
    _lastBtn.selected = YES;
}


- (IBAction)lineBtnClick:(UIButton *)sender {
    
    if (_lastBtn == sender) {
        return;
    }
    sender.selected = YES;
    _lastBtn.selected = NO;
    _lastBtn = sender;
    
    if ([_delegate respondsToSelector:@selector(selectLineWithIndex:)]) {
        [_delegate selectLineWithIndex:sender.tag];
    }
}
@end
