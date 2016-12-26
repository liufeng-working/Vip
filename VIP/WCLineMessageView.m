//
//  WCLineMessageView.m
//  VIP
//
//  Created by NJWC on 16/3/23.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WCLineMessageView.h"
#import "WCCommonRouteView.h"

@interface WCLineMessageView ()

@property (weak, nonatomic) IBOutlet UIImageView *selectBackgroundImageview;
@property (weak, nonatomic) IBOutlet UIImageView *firstIcon;
@property (weak, nonatomic) IBOutlet UIImageView *secondIcon;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *roadCountLabel;

@property (weak, nonatomic) IBOutlet UIButton *userLineBtn;



- (IBAction)settingUseLineBtnClick:(UIButton *)sender;

@end

@implementation WCLineMessageView

+(instancetype)lineMessageViewWithFrame:(CGRect)frame
{
    WCLineMessageView * lineMessageView = [[[NSBundle mainBundle] loadNibNamed:@"WCLineMessageView" owner:nil options:nil] lastObject];
    lineMessageView.frame = frame;
    return lineMessageView;
}

-(void)setMessage:(WCLineMessage *)message
{
    _message = message;
    self.distanceLabel.text = kStringWithFormat(@"%.2f公里",message.distance);
    self.timeLabel.text = kStringWithFormat(@"%.f分钟",message.time);
    self.roadCountLabel.text = kStringWithFormat(@"途径%ld个信控路口",(long)message.roadCount);
}

- (IBAction)settingUseLineBtnClick:(UIButton *)sender {
    
//    WCCommonRouteView * commonRouteView = [WCCommonRouteView commonRouteViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
//    [[[[UIApplication sharedApplication] delegate] window] addSubview:commonRouteView];
    
    if ([_delegate respondsToSelector:@selector(setUserLineBtnClick:)]) {
        [_delegate setUserLineBtnClick:self];
    }
    
}

/**
 *  改变状态（已经设为常用路线，还是未设为常用路线）
 */
- (void)setStatus
{
    //改变所有控件的状态
    self.userLineBtn.selected = YES;
    self.userLineBtn.userInteractionEnabled = NO;
    self.firstIcon.image = [UIImage imageNamed:@"icon_map_distance"];
    self.secondIcon.image = [UIImage imageNamed:@"icon_map_time"];
    self.selectBackgroundImageview.image = [UIImage imageNamed:@"map_popup"];
    
//    self.firstIcon.image = [UIImage imageNamed:@"icon_map_distance_focusing"];
//    self.secondIcon.image = [UIImage imageNamed:@"icon_map_time_focusing"];
//    self.selectBackgroundImageview.image = [UIImage imageNamed:@"map_popup_focusing"];
    
}


-(void)setBackGround:(BOOL)backGround
{
    _backGround = backGround;
    
    if (backGround) {
        
        self.selectBackgroundImageview.image = [UIImage imageNamed:@"map_popup"];
    }else{
        
        self.selectBackgroundImageview.image = [UIImage imageNamed:@"map_popup_focusing"];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if([_delegate respondsToSelector:@selector(otherAreaClick:)]){
        
        [_delegate otherAreaClick:self];
    }
}

@end



/**
 *  路线的信息
 */
@implementation WCLineMessage

@end
