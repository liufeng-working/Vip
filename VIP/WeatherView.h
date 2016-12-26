//
//  WeatherView.h
//  VIP
//
//  Created by 万存 on 16/3/22.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

//typedef NS_ENUM(NSInteger , WeatherType) {
//    WeatherTypeSunning =0 ,// 晴 icon_weather_sunny_
//    WeatherTypeCloudy,     //多云 icon_weather_cloudy
//    WeatherTypeYin          ,//阴 icon_weather_yin
//    
//    WeatherTypeThunder     , //雷阵雨 icon_weather_thunder_shower_
//       WeatherTypeHail ,      //雷阵雨并伴有冰雹 icon_weather_hail --
//    WeatherTypeSleet        ,//雨夹雪 icon_weather_sleet
//        WeatherTypeLightRain , // 小雨 icon_weather_light_rain_
//    WeatherTypeModerateRain ,//中雨 icon_weather_moderate_rain
//        WeatherTypeHeavyRain,//大雨 icon_weather_heavy_rain
//        WeatherTypeRainStorm    ,//暴雨 icon_weather_rainstorm
////    雾 icon_weather_ficon_weather_og
//    WeatherTypeLightSnow , //小雪 icon_weather_light_snow
//    WeatherTypeModerateSnow ,//中雪 icon_weather_moderate_snow
//
//      WeatherTypeHeavySnow,  //大雪 icon_weather_heavy
//
//};
@interface WeatherView : UIView


-(instancetype)initWithPosition:(CGPoint)point
                    weatherInfo:(AMapLocalWeatherLive *)liveInfo
                        forcast:(AMapLocalDayWeatherForecast*)forcast;
@end
