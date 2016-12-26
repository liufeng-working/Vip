//
//  WCNagivationView.m
//  VIP
//
//  Created by NJWC on 16/3/22.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WCNagivationView.h"

@interface WCNagivationView ()
{
    NSMutableArray * _titleLabelArr;
    NSMutableArray * _proImageArr;
}

@property(nonatomic,strong)NSArray * titleArray;

@end

@implementation WCNagivationView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
     
    }
    return self;
}

//给type赋值时，重新布局上面的数据展示
-(void)setNagivationViewType:(WCNagivationViewType)nagivationViewType
{
    _nagivationViewType = nagivationViewType;
    switch (_nagivationViewType) {
        case WCNagivationViewTypeBasic:
            [self basicView];
            break;
        case WCNagivationViewTypeTask:
            [self taskView];
            break;
        case WCNagivationViewTypeCount:
            [self countView];
            break;
            
        default:
            break;
    }
}

#pragma mark - ****基本信息****
-(UIButton *)leftButton
{
    if (!_leftButton) {
        UIImage * leftImage = [UIImage imageNamed:@"button_arrow_left"];
        _leftButton = [[WCNagivationButton alloc]initWithFrame:CGRectMake(0, 0, leftImage.size.width, leftImage.size.height)];
        [_leftButton setImage:leftImage forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

-(UIButton *)rightButton
{
    if (!_rightButton) {
        UIImage * rightImage = [UIImage imageNamed:@"button_arrow_right"];
        _rightButton = [[WCNagivationButton alloc]initWithFrame:CGRectMake(self.right - rightImage.size.width, 0, rightImage.size.width, rightImage.size.height)];
        [_rightButton setImage:rightImage forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

-(NSArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = [NSArray arrayWithObjects:@"基础信息",@"路线设置",@"相位设置",@"控制执行", nil];
    }
    return _titleArray;
}

//基本信息
-(void)basicView
{
    //添加右边按钮(刚进来时，左边按钮肯定是不显示的)
    [self addSubview:self.rightButton];
    
    for (NSInteger i = 0; i < self.titleArray.count; i++)
    {
        UIImage * progressBarImg = [UIImage imageNamed:@"progress-bar_spot"];
        UIImageView * pImgView = [[UIImageView alloc]initWithFrame:CGRectMake(bProgressAndLeftDis + (progressBarImg.size.width + bProgressDistance) * i, bProgressAndTopDis, progressBarImg.size.width, progressBarImg.size.height)];
        pImgView.image = progressBarImg;
        [self addSubview:pImgView];
        
        NSString * titleStr = self.titleArray[i];
        UIFont * font = kSetFont(bNavTitleSize);
        CGSize titleSize = [titleStr sizeWithFont:font];
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, titleSize.width, titleSize.height)];
        titleLabel.center = CGPointMake(pImgView.centerX, pImgView.bottom + titleSize.height/2.0 + bProgressAndTitleDis);
        titleLabel.font = font;
        titleLabel.text = titleStr;
        titleLabel.textColor = [UIColor colorWithHexString:bNavTitleNormalColor];
        [self addSubview:titleLabel];
    }
}

-(void)leftButtonClick
{
    [self.rightButton removeFromSuperview];
}

-(void)rightButtonClick
{
    [self addSubview:self.leftButton];
}

#pragma mark - ****任务监控****
//任务监控
-(void)taskView
{
    NSLog(@"%s",__func__);
}

#pragma mark - ****数据统计****
//数据统计
-(void)countView
{
    NSLog(@"%s",__func__);
}

@end

@implementation WCNagivationButton


-(void)setHighlighted:(BOOL)highlighted
{}

@end
