//
//  PresentCollectRouteView.m
//  VIP
//
//  Created by 万存 on 16/3/28.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "PresentCollectRouteView.h"
#import "WCRoadLineView.h"
@interface PresentCollectRouteView ()<UITextFieldDelegate>

@property (nonatomic,strong) UIWindow *instanceWindow ;
@property (nonatomic,strong) UIWindow *realWindow;

@property (nonatomic,assign) CGFloat keyBoardHeight ;

@property (strong, nonatomic) IBOutlet WCRoadLineView *roadLineView;
@property (strong, nonatomic) IBOutlet UITextField *nameTF;

@end

@implementation PresentCollectRouteView

-(void)awakeFromNib{
    self.roadLineView.width = 630;
    //默认
    self.roadLineView.roadLineViewType = WCRoadLineViewTypeSenvenName;
    //默认
    self.roadLineView.count = 7;
    
    self.roadLineView.layer.borderWidth = 0.3;
    self.roadLineView.layer.borderColor = [UIColor colorWithRed:214/255.0 green:224/255.0 blue:229/255.0 alpha:0.8].CGColor;
    
    self.nameTF.layer.borderWidth = 0.3;
    self.nameTF.layer.borderColor = [UIColor colorWithRed:214/255.0 green:224/255.0 blue:229/255.0 alpha:0.8].CGColor;
    self.nameTF.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 0)];
    //设置显示模式为永远显示(默认不显示)
    self.nameTF.leftViewMode = UITextFieldViewModeAlways;
}
+(PresentCollectRouteView*)loadPrensentView{
    PresentCollectRouteView * v = [[[NSBundle mainBundle] loadNibNamed:@"PresentCollectRouteView" owner:self options:nil] lastObject];
    
    v.frame = CGRectMake(0, 0, 670, 385);
    return v;
}
+(void)showAlertWithDataSource:(NSString *)dataSource cancel :(CancelBlock) cancel sure :(SureBlock)sure{
    [[self loadPrensentView] showPresentView:cancel sure:sure dataSource:dataSource];
}
-(void)showPresentView:(CancelBlock)cancel sure :(SureBlock)sure dataSource:(NSString *)source{
    _instanceWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    UIViewController *v =[UIViewController new];
    _instanceWindow.rootViewController = v ;
    
    _instanceWindow.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5] ;
    _realWindow = [[UIApplication sharedApplication].delegate window];
    self.cancelBlock =cancel;
    self.sureBlock = sure;
//    self.frame = CGRectMake(0, 0, 670, 327);
    
    self.center = _instanceWindow.center ;
    
//    data
    self.roadLineView.nameArr= [source componentsSeparatedByString:@","];
    [self.roadLineView settingRoadLine];

    
    [_instanceWindow.rootViewController.view  addSubview:self];
    
    [self show] ;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

-(void)show{
    [_realWindow resignKeyWindow];
    [_instanceWindow makeKeyAndVisible];
}
-(void)dismiss{
    [self removeFromSuperview] ;
    [_instanceWindow resignKeyWindow];
    [_realWindow makeKeyAndVisible];
}
- (IBAction)buttonClick:(UIButton *)sender {
    [self dismiss] ;
    if (self.cancelBlock&&sender.tag == 1) {
        self.cancelBlock();
    }else if (self.sureBlock&&sender.tag == 2){
        self.sureBlock (_nameTF) ;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.25 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, 0);
    }];
}
-(void)keyboardWillShow:(NSNotification *)noti{
    
    NSDictionary *userInfo = [noti userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    _keyBoardHeight = keyboardRect.size.height;
    CGFloat transformHeight = _keyBoardHeight -kScreenHeight+self.bottom;
    [UIView animateWithDuration:0.25 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, -transformHeight);
    }];
}

@end
