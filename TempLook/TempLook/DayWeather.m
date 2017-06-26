//
//  DayWeather.m
//  TempLook
//
//  Created by Vitalka on 17.06.17.
//  Copyright © 2017 Vitalka. All rights reserved.
//

#import "DayWeather.h"

@implementation DayWeather

-(id)initWithDailyDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        _temperatureMax = [self temperatureFormatter:dictionary[keyFCApparentTemperatureMax]];
        _temperatureMin = [self temperatureFormatter:dictionary[keyFCApparentTemperatureMin]];
        _icon = [[ForecastModel sharedManager] imageNameForWeatherIconType:dictionary[keyFCIcon]];
        _pressure = dictionary[keyFCPressure];
        _dewPoint = dictionary[keyFCDewPoint];
        _visibility = dictionary[keyFCVisibility];
        _windBearing = dictionary[keyFCWindBearing];
        _humidity = dictionary[keyFCHumidity];
        _summary = dictionary[keyFCSummary];
        _time = dictionary[keyFCTime];
        _temperatureCelsiusMax = [self fahrenheitToCelsius:dictionary[keyFCApparentTemperatureMax]];
        _temperatureCelsiusMin = [self fahrenheitToCelsius:dictionary[keyFCApparentTemperatureMin]];
        _sunrise = dictionary[keyFCSunriseTime];
        _sunset = dictionary[keyFCSunsetTime];
    }
    return self;
}
-(NSString *)fahrenheitToCelsius:(NSString *)temperature{
    
    return [[NSString alloc] initWithFormat:@"%.02f",(([temperature doubleValue] - 32) * (5 / 9))];
}
-(NSString *)temperatureFormatter:(NSString *)temperature{
    
    return [[NSString alloc] initWithFormat:@"%.0f", [temperature doubleValue]];
}

@end
