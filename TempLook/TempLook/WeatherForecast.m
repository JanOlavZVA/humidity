//
//  WeatherForecast.m
//  TempLook
//
//  Created by Vitalka on 17.06.17.
//  Copyright © 2017 Vitalka. All rights reserved.
//

#import "WeatherForecast.h"

#import "DayWeather.h"
#import "HourWeather.h"

@implementation WeatherForecast

-(id)initWithWeatherDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        _currentWeather = [[CurrentWeather alloc]initWithCurrentlyDictionary:dictionary[keyFCCurrentlyForecast]];
        _dailyForecasts = [[NSMutableArray alloc] init];
        for (NSDictionary *dailyDictionary in dictionary[keyFCDailyForecast][@"data"]) {
            DayWeather *dayWeather = [[DayWeather alloc] initWithDailyDictionary:dailyDictionary];
            [self.dailyForecasts addObject:dayWeather];
        }
        _hourlyForecasts = [[NSMutableArray alloc] init];
        for (NSDictionary *hourlyDictionary in dictionary[keyFCHourlyForecast][@"data"]) {
            HourWeather* hourWeather = [[HourWeather alloc] initWithHourDictionary:hourlyDictionary];
            [self.hourlyForecasts addObject:hourWeather];
        }
        
    }
    return self;
}
-(void)getTheWeatherforLocation:(CLLocation *)location{
    NSArray *exclusions = @[keyFCAlerts, keyFCFlags, keyFCMinutelyForecast, keyFCOzone];
    [[ForecastModel sharedManager]getForecastForLatitude:location.coordinate.latitude longitude:location.coordinate.longitude time:nil exclusions:exclusions success:^(id JSON) {
        WeatherForecast *weather = [[WeatherForecast alloc] initWithWeatherDictionary:JSON];
        NSLog(@"Current temp: %@", weather.currentWeather.temperature);
        [self.delegate currentWeatherForLocation:weather];
    } failure:^(NSError *error, id response) {
        NSLog(@"Error while retrieving weather data: %@",[[ForecastModel sharedManager] messageForError:error withResponse:response]);
    }];
}

@end
