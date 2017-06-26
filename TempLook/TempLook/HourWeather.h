//
//  HourWeather.h
//  TempLook
//
//  Created by Vitalka on 17.06.17.
//  Copyright © 2017 Vitalka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HourWeather : NSObject

@property(strong, nonatomic) NSString *feelsLike;
@property(strong, nonatomic) NSString *humidity;
@property(strong, nonatomic) NSString *precipProbability;
@property(strong, nonatomic) NSString *icon;
@property(strong, nonatomic) NSString *windBearing;
@property(strong, nonatomic) NSString *temperature;
@property(strong, nonatomic) NSString *time;
@property(strong, nonatomic) NSString *celsius;

-(id)initWithHourDictionary:(NSDictionary *)dictionary;

@end
