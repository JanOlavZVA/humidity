//
//  WeatherForecast.h
//  TempLook
//
//  Created by Vitalka on 17.06.17.
//  Copyright © 2017 Vitalka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CurrentWeather.h"
#import <CoreLocation/CoreLocation.h>

@protocol WeatherForecastDelegate <NSObject>

-(void)currentWeatherForLocation:(id)weather;

@end

@interface WeatherForecast : NSObject

@property(strong, nonatomic) NSMutableArray *dailyForecasts;
@property(strong, nonatomic) NSMutableArray *hourlyForecasts;

@property(strong, nonatomic) CurrentWeather *currentWeather;
@property(weak, nonatomic) id <WeatherForecastDelegate> delegate;

-(id)initWithWeatherDictionary:(NSDictionary *)dictionary;

-(void)getTheWeatherforLocation:(CLLocation *)location;



@end
