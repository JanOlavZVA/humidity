//
//  CurrentWeather.m
//  TempLook
//
//  Created by Vitalka on 17.06.17.
//  Copyright © 2017 Vitalka. All rights reserved.
//

#import "CurrentWeather.h"

@implementation CurrentWeather

-(id)initWithCurrentlyDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        _feelsLikeTemp = [self temperatureFormatter: dictionary[keyFCApparentTemperature]];
        _icon = [[ForecastModel sharedManager] imageNameForWeatherIconType:dictionary[keyFCIcon]];
        _pressure = dictionary[keyFCPressure];
        _precipIntensity = dictionary[keyFCPrecipIntensity];
        _precipProbability = dictionary[keyFCPrecipProbability];
        _temperature = [self temperatureFormatter:dictionary[keyFCTemperature]];
        _time = dictionary[keyFCTime];
        _summary = dictionary[keyFCSummary];
        _temperatureCelsius = [self fahrenheitToCelsius: dictionary[keyFCTemperature]];
        _windSpeed = dictionary[keyFCWindSpeed];
        _windBearing = [self windBearingForCompassSectors:dictionary[keyFCWindBearing]];
        _visibility = dictionary[keyFCVisibility];
        _dewPoint = dictionary[keyFCDewPoint];
    }
    return self;
}

-(NSNumber *)windBearingForCompassSectors:(id)windBearing{
    if (!windBearing) {
        NSException *exception = [NSException exceptionWithName:@"InvalidInputException" reason:@"Argument was nil." userInfo:nil];
        @throw exception;
    }
    NSInteger windBearingValue = [(NSNumber *)windBearing doubleValue];
    NSInteger index = (windBearingValue + 11.25)/22.5;
    return [[NSNumber alloc] initWithInt:index % 16];
}

-(NSString *)fahrenheitToCelsius:(NSString *)temperature{
    if (!temperature) {
        NSException *exception = [NSException exceptionWithName:@"InvalidInputException" reason:@"Argument was nil." userInfo:nil];
        @throw exception;
    }
    
    return [[NSString alloc] initWithFormat:@"%.02f",(([temperature doubleValue] - 32) * (5 / 9))];
}
-(NSString *)temperatureFormatter:(NSString *)temperature{
    if (!temperature) {
        NSException *exception = [NSException exceptionWithName:@"InvalidInputException" reason:@"Argument was nil" userInfo:nil];
        @throw exception;
    }
    return [[NSString alloc] initWithFormat:@"%.0f", [temperature doubleValue]];
}


@end
