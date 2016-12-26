//
//  CustomedAlertView.m
//  VIP
//
//  Created by 万存 on 16/3/24.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "CustomedAlertView.h"
@interface CustomedAlertView ()

@property (nonatomic,strong) UIWindow * instanceWindow ;
@property (nonatomic,strong) UIWindow * realWindow ;

/**
 *  标题
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end


@implementation CustomedAlertView

+(CustomedAlertView *)loadCustomedAlertView{
    
    CustomedAlertView * v  = [[NSBundle mainBundle] loadNibNamed:@"CustomedAlertView" owner:self options:nil ][0];
    v.frame = CGRectMake(0, 0, 369, 112);
    return v ;

    
}

+(void)showAlertWithTitle:(NSString *)title
                   cancel:(CancelBlock)cancel
                     sure:(SureBlock)sure
{
    [[self loadCustomedAlertView] title:(NSString *)title show:cancel sure:sure];
}

-(void)title:(NSString *)title show:(CancelBlock) cancel sure:(SureBlock)sure{
    _instanceWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    UIViewController *v =[UIViewController new];
    _instanceWindow.rootViewController = v ;
    
    _instanceWindow.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5] ;
    _realWindow = [[UIApplication sharedApplication].delegate window];
    self.cancelBlock =cancel;
    self.sureBlock = sure;
    self.titleLabel.text = kStringWithFormat(@"是否%@？",title);
    self.frame = CGRectMake(0, 0, 369, 112);
    
    self.center = _instanceWindow.center ;
    [_instanceWindow.rootViewController.view  addSubview:self];
    
    [self show] ;
    
}
-(void)show{
    [_realWindow resignKeyWindow];
    [_instanceWindow makeKeyAndVisible];
}
-(void)dismiss{
    [_instanceWindow resignKeyWindow];
    [_realWindow makeKeyAndVisible] ;
}
- (IBAction)cancel:(UIButton *)sender {
    [self dismiss] ;
    if (self.cancelBlock &&sender.tag == 1) {
        self.cancelBlock();
    }else if (self.sureBlock&&sender.tag == 2){
        self.sureBlock() ;
    }

}



@end
