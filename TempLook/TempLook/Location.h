//
//  Location.h
//  TempLook
//
//  Created by Vitalka on 17.06.17.
//  Copyright © 2017 Vitalka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherForecast.h"

@import CoreLocation;

@interface Location : NSObject

@property(strong, nonatomic)CLLocation *location;

@property(strong, nonatomic)NSString *locationName;

@property(strong, nonatomic)WeatherForecast *weatherForecast;

@property(strong, nonatomic)NSTimeZone *locationTimeZone;

-(id)initWithLocation:(CLLocation *)location andLocationName:(NSString *)locationName;



@end
