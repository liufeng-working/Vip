//
//  WCNavigationView.m
//  VIP
//
//  Created by NJWC on 16/3/22.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WCNavigationView.h"
#import "WCProgressView.h"
#import "WCNoHighlightedButton.h"

@interface WCNavigationView ()
{
    //基础信息页面 用
    NSMutableArray * _titleLabelArr;
    NSMutableArray * _proImageArr;
    NSMutableArray * _progressViewArr;
    
    //任务监控页面 用
    NSInteger _tIndex;
    WCNoHighlightedButton * _lastTaskBtn;
    
    //数据统计页面 用
    NSInteger _cIndex;
    WCNoHighlightedButton * _lastDateBtn;
    
    //任务监控页面 或者 数据统计页面 用
    
}
//基础信息页面 用
/**
 *  上一步按钮
 */
@property(nonatomic,strong)UIButton * leftButton;
/**
 *  下一步按钮
 */
@property(nonatomic,strong)UIButton * rightButton;

//任务监控页面 用
/**
 *  任务状态
 */
@property(nonatomic,strong)NSArray * taskStatusArray;

//数据统计页面 用
/**
 *  日期
 */
@property(nonatomic,strong)NSArray * dateArray;

@end

@implementation WCNavigationView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
     
        //背景图
        UIImageView * bgImage = [[UIImageView alloc]initWithFrame:self.bounds];
        bgImage.image = [UIImage imageNamed:@"top-bar_background"];
        [self addSubview:bgImage];
    }
    return self;
}

//给type赋值时，重新布局上面的数据展示
-(void)setNavigationViewType:(WCNavigationViewType)navigationViewType
{
    _navigationViewType = navigationViewType;
    switch (_navigationViewType) {
        case WCNavigationViewTypeBasic:
            _titleLabelArr = [NSMutableArray array];
            _proImageArr = [NSMutableArray array];
            _progressViewArr = [NSMutableArray array];
            [self basicView];
            break;
        case WCNavigationViewTypeTask:
            [self taskView];
            break;
        case WCNavigationViewTypeCount:
            [self countView];
            break;
        case WCNavigationViewTypePerformTask:
            [self performTaskView];
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
        UIImage *leftImageHighLight = [UIImage imageNamed:@"button_arrow_left_focusing"];
        _leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, leftImage.size.width, leftImage.size.height)];
        _leftButton.hidden = YES;
        [_leftButton setImage:leftImage forState:UIControlStateNormal];
        [_leftButton setImage:leftImageHighLight forState:UIControlStateHighlighted];
        [_leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_leftButton];
    }
    return _leftButton;
}

-(UIButton *)rightButton
{
    if (!_rightButton) {
        UIImage * rightImage = [UIImage imageNamed:@"button_arrow_right"];
        UIImage * rightImageHighLight = [UIImage imageNamed:@"button_arrow_right_focusing"];
        _rightButton = [[UIButton alloc]initWithFrame:CGRectMake(self.width - rightImage.size.width, 0, rightImage.size.width, rightImage.size.height)];
        _rightButton.hidden = YES;
        [_rightButton setImage:rightImage forState:UIControlStateNormal];
        [_rightButton setImage:rightImageHighLight forState:UIControlStateHighlighted];
        [_rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rightButton];
    }
    return _rightButton;
}

//基本信息
-(void)basicView
{
    //显示右边按钮(刚进来时，左边按钮肯定是不显示的)
    self.leftButton.hidden = NO;
    self.rightButton.hidden = NO;
    
    for (NSInteger i = 0; i < self.titleArray.count; i++)
    {
        UIImage * progressBarImg = [UIImage imageNamed:@"progress-bar_spot"];
        UIImageView * pImgView = [[UIImageView alloc]initWithFrame:CGRectMake(bProgressAndLeftDis + (progressBarImg.size.width + bProgressDistance) * i, bProgressAndTopDis, progressBarImg.size.width, progressBarImg.size.height)];
        pImgView.image = progressBarImg;
        [self addSubview:pImgView];
        [_proImageArr addObject:pImgView];
        
        NSString * titleStr = self.titleArray[i];
        UIFont * font = kSetFont(bNavTitleSize);
        CGSize titleSize = [titleStr sizeWithFont:font];
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, titleSize.width, titleSize.height)];
        titleLabel.center = CGPointMake(pImgView.centerX, pImgView.bottom + titleSize.height/2.0 + bProgressAndTitleDis);
        titleLabel.font = font;
        titleLabel.text = titleStr;
        titleLabel.textColor = [UIColor colorWithHexString:bNavTitleNormalColor];
        [self addSubview:titleLabel];
        [_titleLabelArr addObject:titleLabel];
        
        if (i < (self.titleArray.count - 1)) {
            WCProgressView * progressView = [[WCProgressView alloc]initWithFrame:CGRectMake(pImgView.right, pImgView.top + (pImgView.height - bProgressHeight) / 2.0, bProgressDistance / 2.0, bProgressHeight)];
            progressView.isCorner = NO;
            [self addSubview:progressView];
            [_progressViewArr addObject:progressView];
            
            WCProgressView * progressView1 = [[WCProgressView alloc]initWithFrame:CGRectMake(progressView.right, pImgView.top + (pImgView.width - bProgressHeight) / 2.0, bProgressDistance / 2.0, bProgressHeight)];
            progressView1.isCorner = NO;
            [self insertSubview:progressView1 belowSubview:progressView];
            [_progressViewArr addObject:progressView1];
        }
    }
}

-(void)leftButtonClick
{
    if ([_delegate respondsToSelector:@selector(leftButtonClick)]) {
        [_delegate leftButtonClick];
    }
}

-(void)rightButtonClick
{
    if ([_delegate respondsToSelector:@selector(rightButtonClick)]) {
        [_delegate rightButtonClick];
    }
}

-(void)setIndex:(NSInteger)index
{
    _index = index;
    [self settingTitleStatusWithIndex:index];
}

-(void)settingTitleStatusWithIndex:(NSInteger)index
{
    if (index == 1) {
        self.leftButton.hidden = YES;
    }else if (index == 4){
        self.rightButton.hidden = YES;
    }
    
    for (NSInteger i = 0; i < _titleArray.count; i++)
    {
        if (i < index) {
            UIImageView * pImgView = _proImageArr[i];
            pImgView.image = [UIImage imageNamed:@"progress-bar_spot_focusing"];
            
            UILabel * titleLabel = _titleLabelArr[i];
            titleLabel.textColor = [UIColor colorWithHexString:bNavTitleSelectColor];
            
        }else{
            
            UIImageView * pImgView = _proImageArr[i];
            pImgView.image = [UIImage imageNamed:@"progress-bar_spot"];
            
            UILabel * titleLabel = _titleLabelArr[i];
            titleLabel.textColor = [UIColor colorWithHexString:bNavTitleNormalColor];
            
        }
    }
    
    NSInteger progressNum = 2 * index - 1;
    
    for (NSInteger i = 0; i < _progressViewArr.count; i ++)
    {
        if (i < progressNum) {
            UIView * progressView = _progressViewArr[i];
            progressView.backgroundColor = [UIColor colorWithHexString:kProgressTintColor];
        }else{
            UIView * progressView = _progressViewArr[i];
            progressView.backgroundColor = [UIColor colorWithHexString:kProgressBackColor];
        }
    }
}

#pragma mark - ****任务监控****
//任务监控
-(void)taskView
{
    for (NSInteger i = 0; i < self.titleArray.count; i ++)
    {
        UIImage * bgimg = [UIImage imageNamed:@"tabs_top_focusing"];
        CGFloat btnW = bgimg.size.width;
        CGFloat btnH = bgimg.size.height;
        WCNoHighlightedButton * taskBtn = [[WCNoHighlightedButton alloc]initWithFrame:CGRectMake(tTitleAndLeftDis + (tTitleDistance + btnW) * i, tTitleAndTopDis, btnW, btnH)];
        taskBtn.tag = i;
        [taskBtn setTitle:_titleArray[i] forState:UIControlStateNormal];
        [taskBtn setBackgroundImage:bgimg forState:UIControlStateSelected];
        [taskBtn setBackgroundImage:nil forState:UIControlStateNormal];
        [taskBtn setTitleColor:[UIColor colorWithHexString:tTitleNormalColor] forState:UIControlStateNormal];
        [taskBtn setTitleColor:[UIColor colorWithHexString:tTitleSelectColor] forState:UIControlStateSelected];
        taskBtn.titleLabel.font = kSetFont(tTitleSize);
        [self addSubview:taskBtn];
        [taskBtn addTarget:self action:@selector(taskBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (taskBtn.tag == 0) {
            _lastTaskBtn = taskBtn;
            taskBtn.selected = YES;
        }
    }
}

-(void)taskBtnClick:(WCNoHighlightedButton *)sender
{
    if (_lastTaskBtn == sender) {
        return;
    }
    
    _lastTaskBtn.selected = NO;
    sender.selected = YES;
    
    if ([_delegate respondsToSelector:@selector(taskButtonClickWithNagivationView:fromIndex:toIndex:)]) {
        [_delegate taskButtonClickWithNagivationView:self fromIndex:_lastTaskBtn.tag toIndex:sender.tag];
    }
    
    _lastTaskBtn = sender;
}

#pragma mark - ****数据统计****
//数据统计
-(void)countView
{
    for (NSInteger i = 0; i < self.titleArray.count; i ++)
    {
        UIImage * bgimg = [UIImage imageNamed:@"tabs_top_focusing"];
        CGFloat btnW = bgimg.size.width;
        CGFloat btnH = bgimg.size.height;
        WCNoHighlightedButton * dateBtn = [[WCNoHighlightedButton alloc]initWithFrame:CGRectMake(cTitleAndLeftDis + (cTitleDistance + btnW) * i, cTitleAndTopDis, btnW, btnH)];
        dateBtn.tag = i;
        [dateBtn setTitle:_titleArray[i] forState:UIControlStateNormal];
        [dateBtn setBackgroundImage:bgimg forState:UIControlStateSelected];
        [dateBtn setBackgroundImage:nil forState:UIControlStateNormal];
        [dateBtn setTitleColor:[UIColor colorWithHexString:cTitleNormalColor] forState:UIControlStateNormal];
        [dateBtn setTitleColor:[UIColor colorWithHexString:cTitleSelectColor] forState:UIControlStateSelected];
        dateBtn.titleLabel.font = kSetFont(cTitleSize);
        [self addSubview:dateBtn];
        [dateBtn addTarget:self action:@selector(dateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (dateBtn.tag == 0) {
            _lastDateBtn = dateBtn;
            dateBtn.selected = YES;
        }
    }
}

-(void)dateBtnClick:(WCNoHighlightedButton *)sender
{
    if (_lastDateBtn == sender) {
        return;
    }
    
    _lastDateBtn.selected = NO;
    sender.selected = YES;
    if ([_delegate respondsToSelector:@selector(dateButtonClickWithNagivationView:fromIndex:toIndex:)]) {
        [_delegate dateButtonClickWithNagivationView:self fromIndex:_lastDateBtn.tag toIndex:sender.tag];
    }
    
    _lastDateBtn = sender;
}

#pragma mark - ****任务执行页面****
-(void)performTaskView
{
    for(NSInteger i = 0; i < 2; i ++)
    {
        UIImage * img = [UIImage imageNamed:kStringWithFormat(@"button_map_backOrStop%ld",(long)(i + 1))];
        CGFloat imgWidth = img.size.width;
        CGFloat dis = self.width - 2 * imgWidth;
        WCNoHighlightedButton * btn = [[WCNoHighlightedButton alloc]initWithFrame:CGRectMake((imgWidth + dis) * i, 0, imgWidth, img.size.height)];
        btn.tag = i;
        [btn setBackgroundImage:img forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:i == 0 ? @"返回" : @"终止"forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#3597DB"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(30, 0, 0, 0)];
        [self addSubview:btn];
    }
    
    NSString * titleStr = [self.titleArray firstObject];
    UIFont * titleFont = kSetFont(tTaskingSize);
    CGSize titleSize = [titleStr sizeWithFont:titleFont];
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, titleSize.width, titleSize.height)];
    titleLabel.center = self.center;
    titleLabel.font = titleFont;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = titleStr;
    [self addSubview:titleLabel];
}

-(void)buttonClick:(WCNoHighlightedButton *)sender
{
    switch (sender.tag) {
        case 0:
            if ([_delegate respondsToSelector:@selector(backButtonClickWithNagivationView:)]) {
                [_delegate backButtonClickWithNagivationView:self];
            }
            break;
        case 1:
            if ([_delegate respondsToSelector:@selector(stopButtonClickWithNagivationView:)]) {
                [_delegate stopButtonClickWithNagivationView:self];
            }
            break;
        default:
            break;
    }
}


@end
