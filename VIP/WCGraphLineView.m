//
//  WCGraphLineView.m
//  VIP
//
//  Created by NJWC on 16/3/30.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WCGraphLineView.h"

@interface WCGraphLineView ()
{
    float _leftMarginToLeave;
    NSMutableArray *_pointArr;
    NSMutableArray *_timePointArr;
}

/**
 *  y轴 显示的最大数据
 */
@property (nonatomic, strong) NSNumber *yAxisRange;

@end

#define BOTTOM_MARGIN_TO_LEAVE 30.0 //下面留白
#define TOP_MARGIN_TO_LEAVE 30.0 //顶部留白
#define INTERVAL_COUNT 9 //y轴展示几等分
#define kRightMargin 20 //右边留白(对柱状图 才起作用)

#define PLOT_WIDTH (self.width - _leftMarginToLeave * 2)

@implementation WCGraphLineView

- (instancetype)init {
    if((self = [super init])) {
        [self loadDefaultTheme];
    }
    return self;
}

- (void)awakeFromNib
{
    [self loadDefaultTheme];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadDefaultTheme];
    }
    return self;
}

//默认显示的内容
- (void)loadDefaultTheme {
    
    //类型
    self.graphType = WCGraphTypeLine;
    
    //x、y轴字体颜色大小  分割线颜色
    self.themeAttributes = @{
                         kXAxisLabelColorKey : [UIColor colorWithHexString:@"#8899AA"],
                         kXAxisLabelFontKey : [UIFont systemFontOfSize:13],
                         kYAxisLabelColorKey : [UIColor colorWithHexString:@"#8899AA"],
                         kYAxisLabelFontKey : [UIFont systemFontOfSize:15],
                         kYAxisLabelSideMarginsKey : @20,
                         kLineDataBackgroundLineColorKey : [UIColor colorWithHexString:@"#EDF1F5"]
                         };
    
    //填充颜色，折线的颜色
    //@"#3597DB" == 53 151 219
    self.lineDataThemeAttributes = @{
                                 kLineDataFillColorKey : [UIColor colorWithRed:53/255.0 green:151/255.0 blue:219/255.0 alpha:0.3],
                                 kLineDataStrokeWidthKey : @2.5,
                                 kLineDataStrokeColorKey : [UIColor colorWithHexString:@"#3597DB"],
                                 kLineDataPointFillColorKey : [UIColor colorWithHexString:@"#3597DB"],
                                 kLineDataPointValueFontKey : [UIFont systemFontOfSize:18]
                                 };

}

-(void)setXAxisValues:(NSArray *)xAxisValues
{
    NSMutableArray *arr =[NSMutableArray array];
    for (NSInteger i = 0; i < xAxisValues.count; i ++)
    {
        NSDictionary *dic = [NSDictionary dictionaryWithObject:xAxisValues[i] forKey:@(i)];
        [arr addObject:dic];
    }
    
    _xAxisValues = arr;
}

-(void)setLineDataValues:(NSArray *)lineDataValues
{
    NSInteger maxNum = 0;
    NSMutableArray *arr =[NSMutableArray array];
    for (NSInteger i = 0; i < lineDataValues.count; i ++)
    {
        NSNumber * num = lineDataValues[i];
        NSDictionary *dic = [NSDictionary dictionaryWithObject:num forKey:@(i)];
        [arr addObject:dic];
        
        //得到一组数据的最大值
        if ([num integerValue] >= maxNum) {
            maxNum = [num integerValue];
        }
    }
    
    //y轴显示的最大值
    _yAxisRange = @((maxNum/INTERVAL_COUNT + 1) * INTERVAL_COUNT);
    
    _lineDataValues = arr;
}

-(void)setAllTimeValues:(NSArray *)allTimeValues
{
    _allTimeValues = allTimeValues;
    NSInteger maxNum = 0;
    for (NSInteger i = 0; i < allTimeValues.count; i ++)
    {
        NSNumber * num = allTimeValues[i];
        
        //得到一组数据的最大值
        if ([num integerValue] >= maxNum) {
            maxNum = [num integerValue];
        }
    }
    
    //y轴显示的最大值
    _yAxisRange = @((maxNum/INTERVAL_COUNT + 1) * INTERVAL_COUNT);
}


#pragma mark - Actual Plot Drawing Methods

- (void)drawGraph {
    
    if (self.xAxisValues.count <= 0) {
        return;
    }
    //画y轴
    [self drawYLabels];
    
    //画x轴
    [self drawXLabels];
    
    //画横线
    [self drawLineX];
    
    //画竖线
    [self drawLineY];
    
    //画内容
    if (self.graphType == WCGraphTypeBar) {
        [self drawBar];
    }else if (self.graphType == WCGraphTypeLine){
        [self drawLine];
    }else if (self.graphType == WCGraphTypeTimeBar){
        [self drawTimeBar];
    }
}


- (int)getIndexForValue:(NSNumber *)value {
    
    for(int i=0; i< _xAxisValues.count; i++) {
        NSDictionary *d = [_xAxisValues objectAtIndex:i];
        __block BOOL foundValue = NO;
        [d enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSNumber *k = (NSNumber *)key;
            if([k doubleValue] == [value doubleValue]) {
                foundValue = YES;
                *stop = foundValue;
            }
        }];
        if(foundValue){
            return i;
        }
    }
    return -1;
}

/**
 *  画内容
 */
- (void)drawLine{
    
    //填充颜色，折线的颜色
    NSDictionary *theme = _lineDataThemeAttributes;
    
    //填充颜色的图层
    CAShapeLayer *backgroundLayer = [CAShapeLayer layer];
    backgroundLayer.frame = self.bounds;
    backgroundLayer.fillColor = ((UIColor *)theme[kLineDataFillColorKey]).CGColor;
    backgroundLayer.backgroundColor = [UIColor clearColor].CGColor;
    [backgroundLayer setStrokeColor:[UIColor clearColor].CGColor];
    [backgroundLayer setLineWidth:((NSNumber *)theme[kLineDataStrokeWidthKey]).intValue];
    //新建一个路径
    CGMutablePathRef backgroundPath = CGPathCreateMutable();
    
    
    //圆圈的图层
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.frame = self.bounds;
    circleLayer.fillColor = [UIColor whiteColor].CGColor;
    circleLayer.backgroundColor = [UIColor clearColor].CGColor;
    [circleLayer setStrokeColor:((UIColor *)theme[kLineDataPointFillColorKey]).CGColor];
    [circleLayer setLineWidth:((NSNumber *)theme[kLineDataStrokeWidthKey]).intValue];
    //又新建一个路径
    CGMutablePathRef circlePath = CGPathCreateMutable();
    
    
    //折线的图层
    CAShapeLayer *graphLayer = [CAShapeLayer layer];
    graphLayer.frame = self.bounds;
    graphLayer.fillColor = [UIColor clearColor].CGColor;
    graphLayer.backgroundColor = [UIColor clearColor].CGColor;
    [graphLayer setStrokeColor:((UIColor *)theme[kLineDataStrokeColorKey]).CGColor];
    [graphLayer setLineWidth:((NSNumber *)theme[kLineDataStrokeWidthKey]).intValue];
    //又又新建一个路径
    CGMutablePathRef graphPath = CGPathCreateMutable();
    
    
    [self getPointWithDataArray:_lineDataValues];
    
    //起始点
    CGPathMoveToPoint(graphPath, NULL, _leftMarginToLeave, _xPoints[0].y);
    CGPathMoveToPoint(backgroundPath, NULL, _leftMarginToLeave, _xPoints[0].y);
    
    //移动到下一个点
    NSInteger count = _xAxisValues.count;
    for(int i=0; i< count; i++){
        CGPoint point = _xPoints[i];
        CGPathAddLineToPoint(graphPath, NULL, point.x, point.y);
        CGPathAddLineToPoint(backgroundPath, NULL, point.x, point.y);
        CGPathAddEllipseInRect(circlePath, NULL, CGRectMake(point.x - 5, point.y - 5, 10, 10));
    }
    
    //把背景封闭
    CGPathAddLineToPoint(backgroundPath, NULL, _xPoints[count - 1].x, self.height - BOTTOM_MARGIN_TO_LEAVE);
    CGPathAddLineToPoint(backgroundPath, NULL, _leftMarginToLeave, self.height - BOTTOM_MARGIN_TO_LEAVE);
    CGPathCloseSubpath(backgroundPath);
    
    //给图层的路径赋值
    backgroundLayer.path = backgroundPath;
    graphLayer.path = graphPath;
    circleLayer.path = circlePath;
    
    //释放
    CGPathRelease(backgroundPath);
    CGPathRelease(circlePath);
    CGPathRelease(graphPath);

    //给折线加一个动画（需要的时候，加钱 打开注释）
    /*  CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
     animation.duration = 1;
     animation.fromValue = @(0.0);
     animation.toValue = @(1.0);
     [graphLayer addAnimation:animation forKey:@"strokeEnd"];
     */
    //layer的显示先后顺序
    backgroundLayer.zPosition = 0;
    graphLayer.zPosition = 1;
    circleLayer.zPosition = 2;
    
    //添加子图层
    [self.layer addSublayer:graphLayer];
    [self.layer addSublayer:circleLayer];
    [self.layer addSublayer:backgroundLayer];
    
}

//画柱状图
-(void)drawBar
{
    [self getPointWithDataArray:_lineDataValues];
    
    CAShapeLayer *barLayer = [CAShapeLayer layer];
    barLayer.frame = self.bounds;
    barLayer.lineWidth = 35;
    barLayer.fillColor = [UIColor clearColor].CGColor;
    barLayer.backgroundColor = [UIColor clearColor].CGColor;
    barLayer.strokeColor = [UIColor colorWithHexString:@"#86C1E9"].CGColor;
    
    UIBezierPath *barPath = [UIBezierPath bezierPath];
    for (NSInteger i = 0; i < _xAxisValues.count; i ++)
    {
        [barPath moveToPoint:[_pointArr[i] CGPointValue]];
        [barPath addLineToPoint:_xPoints[i]];
    }
    barLayer.path = barPath.CGPath;
    [self.layer addSublayer:barLayer];
    
}

//画时间的柱状图
-(void)drawTimeBar
{
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = 0; i < _allTimeValues.count; i ++)
    {
        NSInteger all = [_allTimeValues[i] integerValue];
        NSInteger less = [_lessTimeValues[i] integerValue];
        NSNumber *num = [NSNumber numberWithInteger:(all -less)];
        [arr addObject:num];
    }
    
    NSMutableArray *arr1 =[NSMutableArray array];
    for (NSInteger i = 0; i < arr.count; i ++)
    {
        NSNumber * num1 = arr[i];
        NSDictionary *dic1 = [NSDictionary dictionaryWithObject:num1 forKey:@(i)];
        [arr1 addObject:dic1];
    }
    
    [self getPointWithDataArray:arr1];
    
    //实际用时
    CAShapeLayer *barLayer = [CAShapeLayer layer];
    barLayer.frame = self.bounds;
    barLayer.lineWidth = 35;
//    [self getBarWidth];
    barLayer.fillColor = [UIColor clearColor].CGColor;
    barLayer.backgroundColor = [UIColor clearColor].CGColor;
    barLayer.strokeColor = [UIColor colorWithHexString:@"#86C1E9"].CGColor;
    UIBezierPath *barPath = [UIBezierPath bezierPath];
    
    
    for (NSInteger i = 0; i < _xAxisValues.count; i ++)
    {
        [barPath moveToPoint:[_pointArr[i] CGPointValue]];
        [barPath addLineToPoint:_xPoints[i]];
    }
    barLayer.path = barPath.CGPath;
    [self.layer addSublayer:barLayer];
    
    //节约时间
    CAShapeLayer *barLayer1 = [CAShapeLayer layer];
    barLayer1.frame = self.bounds;
    barLayer1.lineWidth = 35;
    [self getBarWidth];
    barLayer1.fillColor = [UIColor clearColor].CGColor;
    barLayer1.backgroundColor = [UIColor clearColor].CGColor;
    barLayer1.strokeColor = [UIColor colorWithHexString:@"#BCDDF3"].CGColor;
    UIBezierPath *barPath1 = [UIBezierPath bezierPath];
    
    
    //计算出每段占的份量
    double intervalInPx = (self.bounds.size.height - BOTTOM_MARGIN_TO_LEAVE ) / (INTERVAL_COUNT + 1);
    double yRange = [_yAxisRange doubleValue];
    double yIntervalValue = yRange / INTERVAL_COUNT;
    
    for (NSInteger i = 0; i < _xAxisValues.count; i ++)
    {
        double values = [_lessTimeValues[i] doubleValue];
        double y = values / yIntervalValue  * intervalInPx;
        [barPath1 moveToPoint:_xPoints[i]];
        [barPath1 addLineToPoint:CGPointMake(_xPoints[i].x, _xPoints[i].y - y)];
    }
    barLayer1.path = barPath1.CGPath;
    [self.layer addSublayer:barLayer1];
}

-(void)getPointWithDataArray:(NSArray *)values
{
    //计算出每段占的份量
    double yRange = [_yAxisRange doubleValue];
    double yIntervalValue = yRange / INTERVAL_COUNT;
    
    //获取点
    [values enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *dic = (NSDictionary *)obj;
        
        __block NSNumber *_key = nil;
        __block NSNumber *_value = nil;
        
        [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            _key = (NSNumber *)key;
            _value = (NSNumber *)obj;
        }];
        
        //判断是哪一个数据
        int xIndex = [self getIndexForValue:_key];
        
        //y轴高度
        double height = self.height - BOTTOM_MARGIN_TO_LEAVE;
        double y = height - ((height / ([_yAxisRange doubleValue] + yIntervalValue)) * [_value doubleValue]);
        
        //取整数部分
        (_xPoints[xIndex]).x = ceil((_xPoints[xIndex]).x);
        (_xPoints[xIndex]).y = ceil(y);
    }];
}

-(CGFloat)getBarWidth
{
    if (self.xAxisValues.count <= 15) {
        return 35;
    }else{
        return (PLOT_WIDTH - kRightMargin) / self.xAxisValues.count - 5;
    }
}

- (void)drawXLabels {
    
    //x轴个数
    NSInteger xIntervalCount = _xAxisValues.count;
    
    //每一部分占用的宽度
//    double xIntervalInPx = 0.0;
//    if (self.graphType == WCGraphTypeLine) {
//        if (xIntervalCount == 1) {
//            xIntervalInPx = PLOT_WIDTH/ xIntervalCount;
//        }else{
//            xIntervalInPx = PLOT_WIDTH/ (xIntervalCount - 1);
//        }
//    }else if (self.graphType == WCGraphTypeBar || self.graphType == WCGraphTypeTimeBar) {
//        xIntervalInPx = (PLOT_WIDTH - kRightMargin)/ xIntervalCount;
//    }
    
    double xIntervalInPx = kWidth;
    //构造一个数组
    _xPoints = calloc(sizeof(CGPoint), xIntervalCount);
    
    _pointArr = [NSMutableArray array];
    for(int i=0; i < xIntervalCount; i++){
        //每一点的起始坐标
        
        CGPoint currentLabelPoint;
        if (self.graphType == WCGraphTypeLine) {
            currentLabelPoint = CGPointMake((xIntervalInPx * i) + _leftMarginToLeave - xIntervalInPx / 2.0, self.bounds.size.height - BOTTOM_MARGIN_TO_LEAVE);
        }else if (self.graphType == WCGraphTypeBar || self.graphType == WCGraphTypeTimeBar) {
            currentLabelPoint = CGPointMake((xIntervalInPx * i) + _leftMarginToLeave, self.bounds.size.height - BOTTOM_MARGIN_TO_LEAVE);
        }
        
        
        //每一点具体的位置
        CGRect xLabelFrame = CGRectMake(currentLabelPoint.x , currentLabelPoint.y, xIntervalInPx, BOTTOM_MARGIN_TO_LEAVE);
        
        //记录下每个label的上边中点
        _xPoints[i] = CGPointMake((int) xLabelFrame.origin.x + xLabelFrame.size.width /2 , (int) 0);
        
        //显示内容的lebel
        UILabel *xAxisLabel = [[UILabel alloc] initWithFrame:xLabelFrame];
        
        xAxisLabel.backgroundColor = [UIColor clearColor];
        
        xAxisLabel.font = (UIFont *)_themeAttributes[kXAxisLabelFontKey];
        
        xAxisLabel.textColor = (UIColor *)_themeAttributes[kXAxisLabelColorKey];
        xAxisLabel.textAlignment = NSTextAlignmentCenter;
        
        NSDictionary *dic = [_xAxisValues objectAtIndex:i];
        __block NSString *xLabel = nil;
        [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            xLabel = (NSString *)obj;
        }];
        
        xAxisLabel.text = [NSString stringWithFormat:@"%@", xLabel];
        [self addSubview:xAxisLabel];
        
        CGPoint topCenter = CGPointMake(xAxisLabel.centerX, self.height - BOTTOM_MARGIN_TO_LEAVE);
        [_pointArr addObject:[NSValue valueWithCGPoint:topCenter]];
    }
}

- (void)drawYLabels {
    
    //显示的最大值
    double yRange = [_yAxisRange doubleValue];
    
    //每份的数值是多少
    double yIntervalValue = yRange / INTERVAL_COUNT;
    
    //每段占据高度是多少
    double intervalInPx = (self.bounds.size.height - BOTTOM_MARGIN_TO_LEAVE ) / (INTERVAL_COUNT +1);
    
    NSMutableArray *labelArray = [NSMutableArray array];
    float maxWidth = 0;
    
    for(int i= INTERVAL_COUNT + 1; i >= 0; i--){
        CGPoint currentLinePoint = CGPointMake(_leftMarginToLeave, i * intervalInPx);
        
        //y轴每个标题的位置
        CGRect lableFrame = CGRectMake(0, currentLinePoint.y - (intervalInPx / 2), 100, intervalInPx);
        
        if(i != 0) {
            UILabel *yAxisLabel = [[UILabel alloc] initWithFrame:lableFrame];
            yAxisLabel.backgroundColor = [UIColor clearColor];
            yAxisLabel.font = (UIFont *)_themeAttributes[kYAxisLabelFontKey];
            yAxisLabel.textColor = (UIColor *)_themeAttributes[kYAxisLabelColorKey];
            yAxisLabel.textAlignment = NSTextAlignmentCenter;
            float val = (yIntervalValue * (10 - i));
            //显示
            if(val > 0){
                if (_yAxisSuffix) {
                    yAxisLabel.text = [NSString stringWithFormat:@"%.f%@", val, _yAxisSuffix];
                }else{
                    yAxisLabel.text = [NSString stringWithFormat:@"%.f", val];
                }
                
            } else {
                yAxisLabel.text = [NSString stringWithFormat:@"%.f", val];
            }
            //适应大小，重新设置位置
            [yAxisLabel sizeToFit];
            CGRect newLabelFrame = CGRectMake(0, currentLinePoint.y - (yAxisLabel.layer.frame.size.height / 2), yAxisLabel.frame.size.width, yAxisLabel.layer.frame.size.height);
            yAxisLabel.frame = newLabelFrame;
            
            if(newLabelFrame.size.width > maxWidth) {
                maxWidth = newLabelFrame.size.width;
            }
            
            //把所有的label装进数组
            [labelArray addObject:yAxisLabel];
            [self addSubview:yAxisLabel];
        }
    }
    
    
    //为了美观增加一部分宽度，再次重新设定坐标
    _leftMarginToLeave = maxWidth + [_themeAttributes[kYAxisLabelSideMarginsKey] doubleValue];
    
    for( UILabel *l in labelArray) {
        CGSize newSize = CGSizeMake(_leftMarginToLeave, l.frame.size.height);
        CGRect newFrame = l.frame;
        newFrame.size = newSize;
        l.frame = newFrame;
    }
}

/**
 *  画横线
 */
- (void)drawLineX {
    
    //准备一个形状layer
    CAShapeLayer *linesLayer = [CAShapeLayer layer];
    linesLayer.frame = self.bounds;
    linesLayer.fillColor = [UIColor clearColor].CGColor;
    linesLayer.backgroundColor = [UIColor clearColor].CGColor;
    linesLayer.strokeColor = ((UIColor *)_themeAttributes[kLineDataBackgroundLineColorKey]).CGColor;
    linesLayer.lineWidth = 1;
    
    
    CGMutablePathRef linesPath = CGPathCreateMutable();
    
    double intervalInPx = (self.bounds.size.height - BOTTOM_MARGIN_TO_LEAVE) / (INTERVAL_COUNT + 1);
    for(int i= INTERVAL_COUNT + 1; i > 0; i--){
        
        CGPoint currentLinePoint = CGPointMake(_leftMarginToLeave, (i * intervalInPx));
        
        CGPathMoveToPoint(linesPath, NULL, currentLinePoint.x, currentLinePoint.y);
        CGPathAddLineToPoint(linesPath, NULL, self.width - kRightMargin, currentLinePoint.y);
    }
    
    linesLayer.path = linesPath;
    [self.layer addSublayer:linesLayer];
    CGPathRelease(linesPath);
}

/**
 *  画竖线
 */
- (void)drawLineY {
    
    UIBezierPath * path = [UIBezierPath bezierPath];
    
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = ((UIColor *)_themeAttributes[kLineDataBackgroundLineColorKey]).CGColor;
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    shapeLayer.lineWidth = 1.f;
//    double intervalInPy = PLOT_WIDTH / (_xAxisValues.count - 1);
    double intervalInPy = kWidth;
    NSInteger count;
    if (self.graphType == WCGraphTypeLine) {
        count = _xAxisValues.count;
    }else if(self.graphType == WCGraphTypeBar || self.graphType == WCGraphTypeTimeBar){
        count = 1;//只需要画一个y轴就行了
    }
    for (NSInteger i = 0; i < count; i++) {
        
        [path moveToPoint:CGPointMake(_leftMarginToLeave +  intervalInPy * i,BOTTOM_MARGIN_TO_LEAVE)];
        [path addLineToPoint:CGPointMake(_leftMarginToLeave +  intervalInPy * i,self.height - BOTTOM_MARGIN_TO_LEAVE)];
    }
    
    shapeLayer.path = path.CGPath;
    [self.layer addSublayer:shapeLayer];
    
}

@end
