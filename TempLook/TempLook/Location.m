//
//  Location.m
//  TempLook
//
//  Created by Vitalka on 17.06.17.
//  Copyright © 2017 Vitalka. All rights reserved.
//

#import "Location.h"


@implementation Location

-(id)initWithLocation:(CLLocation *)location andLocationName:(NSString *)locationName{
    self = [super init];
    if (self) {
        self.location = location;
        self.locationName = locationName;
    }
    return self;
}

-(void)setLocation:(CLLocation *)location{
    _location = location;
    [self.weatherForecast getTheWeatherforLocation:location];
}


@end
