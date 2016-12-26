//
//  WCLineGraphView.m
//  VIP
//
//  Created by NJWC on 16/3/30.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WCLineGraphView.h"

//处理数据
@implementation WCLineData

- (instancetype)init {
    if((self = [super init])) {
        [self loadDefaultTheme];
    }
    return self;
}


- (void)loadDefaultTheme {
    
    //填充颜色，折线的颜色
    //@"#3597DB" == 53 151 219
    _lineDataThemeAttributes = @{
                                 kLineDataFillColorKey : [UIColor colorWithRed:53/255.0 green:151/255.0 blue:219/255.0 alpha:0.3],
                                 kLineDataStrokeWidthKey : @2.5,
                                 kLineDataStrokeColorKey : [UIColor colorWithHexString:@"#3597DB"],
                                 kLineDataPointFillColorKey : [UIColor colorWithHexString:@"#3597DB"],
                                 kLineDataPointValueFontKey : [UIFont systemFontOfSize:18]
                                 };
}

-(void)setLineDataValues:(NSArray *)lineDataValues
{
    NSMutableArray *arr =[NSMutableArray array];
    for (NSInteger i = 0; i < lineDataValues.count; i ++)
    {
        NSDictionary *dic = [NSDictionary dictionaryWithObject:lineDataValues[i] forKey:@(i)];
        [arr addObject:dic];
    }
    
    _lineDataValues = arr;
}

#pragma mark - Theme Key Extern Keys

NSString *const kLineDataFillColorKey      = @"kLineDataFillColorKey";
NSString *const kLineDataStrokeWidthKey    = @"kLineDataStrokeWidthKey";
NSString *const kLineDataStrokeColorKey    = @"kLineDataStrokeColorKey";
NSString *const kLineDataPointFillColorKey = @"kLineDataPointFillColorKey";
NSString *const kLineDataPointValueFontKey = @"kLineDataPointValueFontKey";

@end


#define BOTTOM_MARGIN_TO_LEAVE 30.0
#define TOP_MARGIN_TO_LEAVE 30.0
#define INTERVAL_COUNT 9
#define PLOT_WIDTH (self.bounds.size.width - _leftMarginToLeave * 2)

//画图部分
@implementation WCLineGraphView
{
    float _leftMarginToLeave;
}
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
    
    //x、y轴字体颜色大小  分割线颜色
    _themeAttributes = @{
                         kXAxisLabelColorKey1 : [UIColor colorWithHexString:@"#8899AA"],
                         kXAxisLabelFontKey1 : [UIFont systemFontOfSize:13],
                         kYAxisLabelColorKey1 : [UIColor colorWithHexString:@"#8899AA"],
                         kYAxisLabelFontKey1 : [UIFont systemFontOfSize:15],
                         kYAxisLabelSideMarginsKey1 : @20,
                         kLineDataBackgroundLineColorKye1 : [UIColor colorWithHexString:@"#EDF1F5"]
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


- (void)addLineData:(WCLineData *)newLineData;
{
    if(nil == newLineData) {
        return;
    }
    
    if(_lineData == nil){
        _lineData = [NSMutableArray array];
    }
    [_lineData addObject:newLineData];
}

- (void)setupTheView
{
    for(WCLineData *lineData in _lineData) {
        [self drawLineWithLineData:lineData];
    }
}

#pragma mark - Actual Plot Drawing Methods

- (void)drawLineWithLineData:(WCLineData *)lineData {
    
    //画y轴
    [self drawYLabels:lineData];
    
    //画x轴
    [self drawXLabels:lineData];
    
    //画横线
    [self drawLineX:lineData];
    
    //画竖线
    [self drawLineY:lineData];
    
    //画内容
    [self drawLine:lineData];
}

- (int)getIndexForValue:(NSNumber *)value forPlot:(WCLineData *)lineData {
    
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
- (void)drawLine:(WCLineData *)lineData {
    
    //填充颜色，折线的颜色
    NSDictionary *theme = lineData.lineDataThemeAttributes;
    
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
    
    //计算出每段占的份量
    double yRange = [_yAxisRange doubleValue];
    double yIntervalValue = yRange / INTERVAL_COUNT;
    
    //
    [lineData.lineDataValues enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *dic = (NSDictionary *)obj;
        
        __block NSNumber *_key = nil;
        __block NSNumber *_value = nil;
        
        [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            _key = (NSNumber *)key;
            _value = (NSNumber *)obj;
        }];
        
        //判断是哪一个数据
        int xIndex = [self getIndexForValue:_key forPlot:lineData];
        
        //y轴高度
        double height = self.height - BOTTOM_MARGIN_TO_LEAVE;
        double y = height - ((height / ([_yAxisRange doubleValue] + yIntervalValue)) * [_value doubleValue]);
        
        //取整数部分
        (lineData.xPoints[xIndex]).x = ceil((lineData.xPoints[xIndex]).x);
        (lineData.xPoints[xIndex]).y = ceil(y);
    }];
    
    //起始点
    CGPathMoveToPoint(graphPath, NULL, _leftMarginToLeave, lineData.xPoints[0].y);
    CGPathMoveToPoint(backgroundPath, NULL, _leftMarginToLeave, lineData.xPoints[0].y);
    
    //移动到下一个点
    NSInteger count = _xAxisValues.count;
    for(int i=0; i< count; i++){
        CGPoint point = lineData.xPoints[i];
        CGPathAddLineToPoint(graphPath, NULL, point.x, point.y);
        CGPathAddLineToPoint(backgroundPath, NULL, point.x, point.y);
        CGPathAddEllipseInRect(circlePath, NULL, CGRectMake(point.x - 5, point.y - 5, 10, 10));
    }
    
    //最后一个点（不在数组内）
    CGPathAddLineToPoint(graphPath, NULL, _leftMarginToLeave + PLOT_WIDTH, lineData.xPoints[count -1].y);
    CGPathAddLineToPoint(backgroundPath, NULL, _leftMarginToLeave + PLOT_WIDTH, lineData.xPoints[count - 1].y);
    
    //把背景封闭
    CGPathAddLineToPoint(backgroundPath, NULL, _leftMarginToLeave + PLOT_WIDTH, self.bounds.size.height - BOTTOM_MARGIN_TO_LEAVE);
    CGPathAddLineToPoint(backgroundPath, NULL, _leftMarginToLeave, self.bounds.size.height - BOTTOM_MARGIN_TO_LEAVE);
    CGPathCloseSubpath(backgroundPath);
    
    //给图层的路径赋值
    backgroundLayer.path = backgroundPath;
    graphLayer.path = graphPath;
    circleLayer.path = circlePath;
    
    //释放
    CGPathRelease(backgroundPath);
    CGPathRelease(graphPath);
    CGPathRelease(circlePath);
    
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

- (void)drawXLabels:(WCLineData *)lineData {
    
    //x轴个数
    NSInteger xIntervalCount = _xAxisValues.count;
    
    //每一部分占用的宽度
    double xIntervalInPx = PLOT_WIDTH / (xIntervalCount - 1);
    
    //构造一个数组
    lineData.xPoints = calloc(sizeof(CGPoint), xIntervalCount);
    
    for(int i=0; i < xIntervalCount; i++){
        //每一点的起始坐标
        CGPoint currentLabelPoint = CGPointMake((xIntervalInPx * i) + _leftMarginToLeave - xIntervalInPx / 2.0, self.bounds.size.height - BOTTOM_MARGIN_TO_LEAVE);
        
        //没一点具体的位置
        CGRect xLabelFrame = CGRectMake(currentLabelPoint.x , currentLabelPoint.y, xIntervalInPx, BOTTOM_MARGIN_TO_LEAVE);
        
        //记录下每个label的上边中点
        lineData.xPoints[i] = CGPointMake((int) xLabelFrame.origin.x + (xLabelFrame.size.width /2) , (int) 0);
        
        //显示内容的lebel
        UILabel *xAxisLabel = [[UILabel alloc] initWithFrame:xLabelFrame];
        
        xAxisLabel.backgroundColor = [UIColor clearColor];
        
        xAxisLabel.font = (UIFont *)_themeAttributes[kXAxisLabelFontKey1];
        
        xAxisLabel.textColor = (UIColor *)_themeAttributes[kXAxisLabelColorKey1];
        xAxisLabel.textAlignment = NSTextAlignmentCenter;
        
        NSDictionary *dic = [_xAxisValues objectAtIndex:i];
        __block NSString *xLabel = nil;
        [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            xLabel = (NSString *)obj;
        }];
        
        xAxisLabel.text = [NSString stringWithFormat:@"%@", xLabel];
        [self addSubview:xAxisLabel];
    }
}

- (void)drawYLabels:(WCLineData *)lineData {
    
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
            yAxisLabel.font = (UIFont *)_themeAttributes[kYAxisLabelFontKey1];
            yAxisLabel.textColor = (UIColor *)_themeAttributes[kYAxisLabelColorKey1];
            yAxisLabel.textAlignment = NSTextAlignmentCenter;
            float val = (yIntervalValue * (10 - i));
            //显示
            if(val > 0){
                if (_yAxisSuffix) {
                    yAxisLabel.text = [NSString stringWithFormat:@"%.1f%@", val, _yAxisSuffix];
                }else{
                    yAxisLabel.text = [NSString stringWithFormat:@"%.1f", val];
                }
                
            } else {
                yAxisLabel.text = [NSString stringWithFormat:@"%.1f", val];
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
    _leftMarginToLeave = maxWidth + [_themeAttributes[kYAxisLabelSideMarginsKey1] doubleValue];
    
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
- (void)drawLineX:(WCLineData *)lineData {
    
    //准备一个形状layer
    CAShapeLayer *linesLayer = [CAShapeLayer layer];
    linesLayer.frame = self.bounds;
    linesLayer.fillColor = [UIColor clearColor].CGColor;
    linesLayer.backgroundColor = [UIColor clearColor].CGColor;
    linesLayer.strokeColor = ((UIColor *)_themeAttributes[kLineDataBackgroundLineColorKye1]).CGColor;
    linesLayer.lineWidth = 1;
    
    
    CGMutablePathRef linesPath = CGPathCreateMutable();
    
    double intervalInPx = (self.bounds.size.height - BOTTOM_MARGIN_TO_LEAVE) / (INTERVAL_COUNT + 1);
    for(int i= INTERVAL_COUNT + 1; i > 0; i--){
        
        CGPoint currentLinePoint = CGPointMake(_leftMarginToLeave, (i * intervalInPx));
        
        CGPathMoveToPoint(linesPath, NULL, currentLinePoint.x, currentLinePoint.y);
        CGPathAddLineToPoint(linesPath, NULL, currentLinePoint.x + PLOT_WIDTH, currentLinePoint.y);
    }
    
    linesLayer.path = linesPath;
    [self.layer addSublayer:linesLayer];
    CGPathRelease(linesPath);
}

/**
 *  画竖线
 */
- (void)drawLineY:(WCLineData *)lineData {
    
    UIBezierPath * path = [UIBezierPath bezierPath];
    
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = ((UIColor *)_themeAttributes[kLineDataBackgroundLineColorKye1]).CGColor;
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    shapeLayer.lineWidth = 1.f;
    double intervalInPy = PLOT_WIDTH / (_xAxisValues.count - 1);
    for (NSInteger i = 0; i < _xAxisValues.count; i++) {
        
        [path moveToPoint:CGPointMake(_leftMarginToLeave +  intervalInPy * i,BOTTOM_MARGIN_TO_LEAVE)];
        [path addLineToPoint:CGPointMake(_leftMarginToLeave +  intervalInPy * i,self.height - BOTTOM_MARGIN_TO_LEAVE)];
    }
    
    shapeLayer.path = path.CGPath;
    [self.layer addSublayer:shapeLayer];
    
}

#pragma mark - Theme Key Extern Keys

NSString *const kXAxisLabelColorKey1         = @"kXAxisLabelColorKey";
NSString *const kXAxisLabelFontKey1          = @"kXAxisLabelFontKey";
NSString *const kYAxisLabelColorKey1         = @"kYAxisLabelColorKey";
NSString *const kYAxisLabelFontKey1          = @"kYAxisLabelFontKey";
NSString *const kYAxisLabelSideMarginsKey1   = @"kYAxisLabelSideMarginsKey";
NSString *const kLineDataBackgroundLineColorKye1 = @"kLineDataBackgroundLineColorKye";

@end
