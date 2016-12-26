//
//  WeatherView.m
//  VIP
//
//  Created by 万存 on 16/3/22.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WeatherView.h"
@interface WeatherView()

@property (nonatomic ,strong) UIImageView * currentWeatherImageView ;
@end

@implementation WeatherView


-(instancetype)initWithPosition:(CGPoint)point
                    weatherInfo:(AMapLocalWeatherLive *)liveInfo
                        forcast:(AMapLocalDayWeatherForecast*)forcast{
    if (self= [super init]) {
        [self initWeatherView:point weatherInfo:liveInfo forcast:forcast];
    }
    return self;
}

-(void)initWeatherView:(CGPoint)point weatherInfo:(AMapLocalWeatherLive *)liveInfo forcast:(AMapLocalDayWeatherForecast*)forcast{
    UIImage * weatherBackImage = [UIImage imageNamed:@"weather_background"];
    //CGFloat scaleH = (kContentWidth/2-point.x- 10)*weatherBackImage.size.height/weatherBackImage.size.width;
    self.frame = CGRectMake(point.x, point.y, weatherBackImage.size.width, weatherBackImage.size.height);
    
    UIImageView * weatherBackImageView = [[UIImageView alloc]initWithFrame:self.bounds];
    weatherBackImageView.image = weatherBackImage;
    [self addSubview:weatherBackImageView];
    

    UILabel * currentWeatherLabel = [[UILabel alloc]initWithFrame:CGRectMake(17, 20, [@"实时天气"  widthWithFontSize:20], 21)];
    currentWeatherLabel.text = @"实时天气";
    currentWeatherLabel.textColor = [UIColor colorWithHexString:@"FFFFFF"];
    currentWeatherLabel.font = [UIFont systemFontOfSize:20];
    [weatherBackImageView addSubview:currentWeatherLabel];
    
    UIImage * currentWeatherImage=[UIImage imageNamed:[self getImageName:liveInfo.weather]];
    
       _currentWeatherImageView =[[UIImageView alloc]initWithFrame:CGRectMake(15, 55, currentWeatherImage.size .width, currentWeatherImage.size.height)];
    _currentWeatherImageView.image = currentWeatherImage;
    [weatherBackImageView addSubview:_currentWeatherImageView];
    
    NSString * temStr = [NSString stringWithFormat:@"%@°",liveInfo.temperature] ;
    CGSize currTemSize  = [temStr  sizeWithFont:40 size:CGSizeMake(MAXFLOAT, 50)];
    UILabel * temperNowLabel = [[UILabel alloc]initWithFrame:CGRectMake(_currentWeatherImageView.right+10, _currentWeatherImageView.top+20, currTemSize.width, 40)];
    temperNowLabel.text =temStr;
    temperNowLabel.font = [UIFont systemFontOfSize:40];
    temperNowLabel.textColor = [UIColor colorWithHexString:@"FFFFFF"];
    [weatherBackImageView addSubview:temperNowLabel];
    

//    UILabel * temRangeLabel = [[UILabel alloc]initWithFrame:CGRectMake(temperNowLabel.right+10, temperNowLabel.top+20, [@"12°/-3°"   widthWithFontSize:19], 21)];
//    temRangeLabel.text =@"12°/-3°";
//    temRangeLabel.font = [UIFont systemFontOfSize:19];
//    temRangeLabel.textColor = [UIColor colorWithHexString:@"FFFFFF"];
//    [weatherBackImageView addSubview:temRangeLabel];
    NSString * detailStr = [NSString stringWithFormat:@"%@ %@风 %@级",liveInfo.weather,liveInfo.windDirection,liveInfo.windPower] ;
    UILabel * deailMesLabel = [[UILabel alloc]initWithFrame:CGRectMake(_currentWeatherImageView.right+10, temperNowLabel.bottom+9, [detailStr widthWithFontSize:20], 21)];
    deailMesLabel.text =detailStr;
    deailMesLabel.font = [UIFont systemFontOfSize:20];
    deailMesLabel.textColor =[UIColor colorWithHexString:@"FFFFFF"];
    [weatherBackImageView addSubview:deailMesLabel];
    
//    右边
    UIImageView * seperator = [[UIImageView alloc]initWithFrame:CGRectMake(deailMesLabel.right, 15, 1, weatherBackImage.size.height - 30)];
    seperator.image = [UIImage imageNamed:@"weather_line"];
    [weatherBackImageView addSubview:seperator];
    
    UILabel * tomorrowWeatherLabel = [[UILabel alloc]initWithFrame:CGRectMake(seperator.right+17, 20, [@"明天"  widthWithFontSize:20], 21)];
    tomorrowWeatherLabel.text = @"明天";
    tomorrowWeatherLabel.textColor = [UIColor colorWithHexString:@"FFFFFF"];
    tomorrowWeatherLabel.font = [UIFont systemFontOfSize:20];
    [weatherBackImageView addSubview:tomorrowWeatherLabel];
    
    
    UIImage * tomorrowWeatherImage = [UIImage imageNamed:[self getSmallImage:forcast.dayWeather]];
    UIImageView * tomorrowWeatherImageView =[[UIImageView alloc]initWithFrame:CGRectMake(seperator.right+17, 90, tomorrowWeatherImage.size.width, tomorrowWeatherImage.size.height)];
    tomorrowWeatherImageView.image = tomorrowWeatherImage;
    [weatherBackImageView addSubview:tomorrowWeatherImageView];
    
    NSString * tomoTemStr =[NSString stringWithFormat:@"%@°",forcast.dayTemp] ;
    UILabel * tomorrowRangeLabel = [[UILabel alloc]initWithFrame:CGRectMake(tomorrowWeatherImageView.right+10, tomorrowWeatherImageView.top, [tomoTemStr   widthWithFontSize:19], 21)];
    tomorrowRangeLabel.text =tomoTemStr;
    tomorrowRangeLabel.font = [UIFont systemFontOfSize:19];
    tomorrowRangeLabel.textColor = [UIColor colorWithHexString:@"FFFFFF"];
    [weatherBackImageView addSubview:tomorrowRangeLabel];
    
    
    NSString * tomoWeatherStr = forcast.dayWeather ;
    UILabel * tomoDeailMesLabel = [[UILabel alloc]initWithFrame:CGRectMake(tomorrowWeatherImageView.right+10, tomorrowRangeLabel.bottom+9, [tomoWeatherStr  widthWithFontSize:20], 21)];
    tomoDeailMesLabel.text =tomoWeatherStr;
    tomoDeailMesLabel.font = [UIFont systemFontOfSize:20];
    tomoDeailMesLabel.textColor =[UIColor colorWithHexString:@"FFFFFF"];
    [weatherBackImageView addSubview:tomoDeailMesLabel];
}
-(NSString *)getImageName:(NSString *)weatherStr{
    NSLog(@"weatherString ===%@",weatherStr) ;
    if ([weatherStr isEqualToString:@"晴"]) {
        return @"icon_weather_sunny_" ;
    }else if ([weatherStr isEqualToString:@"多云"]){
        return @"icon_weather_cloudy" ;
    }else if ([weatherStr isEqualToString:@"阴"]){
         return @"icon_weather_yin" ;
    }else if ([weatherStr isEqualToString:@"雷阵雨"]){
         return @"icon_weather_thunder_shower_" ;
    }else if ([weatherStr isEqualToString:@"雨夹雪"]){
         return @"icon_weather_sleet" ;
    }else if ([weatherStr isEqualToString:@"小雨"]){
         return @"icon_weather_light_rain_" ;
    }else if ([weatherStr isEqualToString:@"中雨"]){
         return @"icon_weather_moderate_rain" ;
    }else if ([weatherStr isEqualToString:@"大雨"]){
         return @"icon_weather_heavy_rain" ;
    }else if ([weatherStr isEqualToString:@"暴雨"]){
         return @"icon_weather_rainstorm" ;
    }else if ([weatherStr isEqualToString:@"小雪"]){
         return @"icon_weather_light_snow" ;
    }else if ([weatherStr isEqualToString:@"中雪"]){
         return @"icon_weather_moderate_snow" ;
    }else if ([weatherStr isEqualToString:@"大雪"]){
         return @"icon_weather_heavy" ;
    }else if ([weatherStr isEqualToString:@"雾"]){
         return @"icon_weather_ficon_weather_og" ;
    }else if ([weatherStr isEqualToString:@"雷阵雨并伴有冰雹"]){
        return @"icon_weather_hail" ;
    }else if ([weatherStr containsString:@"雨"]){
         return @"icon_weather_moderate_rain" ;
    }else if ([weatherStr containsString:@"雪"]){
         return @"icon_weather_moderate_rain" ;
    }else if ([weatherStr containsString:@"霾"]||[weatherStr containsString:@"沙"]){
        return @"icon_weather_yin" ;
    }else{
        return @"icon_weather_sunny_" ;
    }
    
}

-(NSString * )getSmallImage:(NSString *)weatherStr {
    NSLog(@"tomorrow weatherString ++++%@",weatherStr) ;
    if ([weatherStr isEqualToString:@"晴"]) {
        return @"Icon_weather_Sunny_Small" ;
    }else if ([weatherStr isEqualToString:@"多云"]){
        return @"Icon_weather_cloudy_Small" ;
    }else if ([weatherStr isEqualToString:@"阴"]){
        return @"Icon_weather_yin_Small" ;
    }else if ([weatherStr isEqualToString:@"雷阵雨"]){
        return @"Icon_weather_thunder_shower_Small" ;
    }else if ([weatherStr isEqualToString:@"雨夹雪"]){
        return @"Icon_weather_sleet_Small" ;
    }else if ([weatherStr isEqualToString:@"小雨"]){
        return @"Icon_weather_light_rain_Small" ;
    }else if ([weatherStr isEqualToString:@"中雨"]){
        return @"Icon_weather_moderate_rain_Small" ;
    }else if ([weatherStr isEqualToString:@"大雨"]){
        return @"Icon_weather_heavy_rain_Small" ;
    }else if ([weatherStr isEqualToString:@"暴雨"]){
        return @"Icon_weather_rainstorm_Small" ;
    }else if ([weatherStr isEqualToString:@"小雪"]){
        return @"Icon_weather_light_snow_Small" ;
    }else if ([weatherStr isEqualToString:@"中雪"]){
        return @"Icon_weather_moderate_snow_Small" ;
    }else if ([weatherStr isEqualToString:@"大雪"]){
        return @"icon_weather_heavy_Small" ;
    }else if ([weatherStr isEqualToString:@"雾"]){
        return @"Icon_weather_ficon_weather_og_Small" ;
    }else if ([weatherStr isEqualToString:@"雷阵雨并伴有冰雹"]){
        return @"Icon_weather_hail_Small" ;
    }else if ([weatherStr containsString:@"雨"]){
        return @"Icon_weather_moderate_rain_Small" ;
    }else if ([weatherStr containsString:@"雪"]){
        return @"Icon_weather_moderate_rain_Small" ;
    }else if ([weatherStr containsString:@"霾"]||[weatherStr containsString:@"沙"]){
        return @"Icon_weather_yin_Small" ;
    }else{
        return @"Icon_weather_sunny_Small" ;
    }
}


@end
