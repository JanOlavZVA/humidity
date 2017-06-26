//
//  CurrentWeather.h
//  TempLook
//
//  Created by Vitalka on 17.06.17.
//  Copyright © 2017 Vitalka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ForecastModel.h"

@interface CurrentWeather : NSObject

@property(strong, nonatomic) NSString *feelsLikeTemp;
@property(strong, nonatomic) NSString *icon;
@property(strong, nonatomic) NSString *pressure;
@property(strong, nonatomic) NSString *precipIntensity;
@property(strong, nonatomic) NSString *precipProbability;
@property(strong, nonatomic) NSString *temperature;
@property(strong, nonatomic) NSString *time;
@property(strong, nonatomic) NSString *summary;
@property(strong, nonatomic) NSString *temperatureCelsius;
@property(strong, nonatomic) NSNumber *windBearing;
@property(strong, nonatomic) NSString *windSpeed;
@property(strong, nonatomic) NSString *localTime;
@property(strong, nonatomic) NSString *visibility;
@property(strong, nonatomic) NSString *dewPoint;

-(id)initWithCurrentlyDictionary:(NSDictionary *)dictionary;

-(NSNumber *)windBearingForCompassSectors:(id)windBearing;

-(NSString *)fahrenheitToCelsius:(NSString *)temperature;

-(NSString *)temperatureFormatter:(NSString *)temperature;



@end
