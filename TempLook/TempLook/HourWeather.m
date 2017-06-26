//
//  HourWeather.m
//  TempLook
//
//  Created by Vitalka on 17.06.17.
//  Copyright © 2017 Vitalka. All rights reserved.
//

#import "HourWeather.h"
#import "ForecastModel.h"

@implementation HourWeather

-(id)initWithHourDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        _feelsLike = [dictionary[keyFCApparentTemperature] stringValue];
        _humidity = [dictionary[keyFCHumidity] stringValue];
        _temperature = [self temperatureFormatter:[dictionary[keyFCTemperature] stringValue]];
        _precipProbability = [dictionary[keyFCPrecipProbability] stringValue];
        _windBearing = [dictionary[keyFCWindBearing] stringValue];
        _time = [dictionary[keyFCTime] stringValue];
        _icon = [[ForecastModel sharedManager] imageNameForWeatherIconType:dictionary[keyFCIcon]];
        _celsius = [self fahrenheitToCelsius:[dictionary[keyFCTemperature] stringValue]];
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
