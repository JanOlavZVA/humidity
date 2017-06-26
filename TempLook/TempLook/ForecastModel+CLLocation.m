//
//  ForecastModel+CLLocation.m
//  TempLook
//
//  Created by Vitalka on 17.06.17.
//  Copyright © 2017 Vitalka. All rights reserved.
//


#import "ForecastModel+CLLocation.h"
#import <UIKit/UIKit.h>

@implementation ForecastModel (CLLocation)

- (void)getForecastForLocation:(CLLocation *)location
                          time:(NSNumber *)time
                    exclusions:(NSArray *)exclusions
                        extend:(NSString*)extendCommand
                      language:(NSString *)languageCode
                       success:(void (^)(id JSON))success
                       failure:(void (^)(NSError *error, id response))failure
{
    float  latitude = location.coordinate.latitude;
    float  longitude = location.coordinate.longitude;
    
    [self getForecastForLatitude:latitude longitude:longitude time:time exclusions:exclusions extend:extendCommand language:languageCode success:^(id JSON) {
        success(JSON);
    } failure:^(NSError *error, id response) {
        failure(error, response);
    }];
}

- (void)getForecastForLocation:(CLLocation *)location
                          time:(NSNumber *)time
                    exclusions:(NSArray *)exclusions
                        extend:(NSString*)extendCommand
                       success:(void (^)(id JSON))success
                       failure:(void (^)(NSError *error, id response))failure
{
    [self getForecastForLocation:location time:time exclusions:exclusions extend:extendCommand language:nil success:success failure:failure];
}

- (void)getForecastForLocation:(CLLocation *)location
                          time:(NSNumber *)time
                    exclusions:(NSArray *)exclusions
                       success:(void (^)(id JSON))success
                       failure:(void (^)(NSError *error, id response))failure
{
    [self getForecastForLocation:location time:time exclusions:exclusions extend:nil success:success failure:failure];
}

// Removes a cached forecast in case you want to refresh it prematurely
- (void)removeCachedForecastForLocation:(CLLocation *)location
                                   time:(NSNumber *)time
                             exclusions:(NSArray *)exclusions
                                 extend:(NSString*)extendCommand
                               language:(NSString *)languageCode
{
    float latitude = location.coordinate.latitude;
    float longitude = location.coordinate.longitude;
    
    [self removeCachedForecastForLatitude:latitude longitude:longitude time:time exclusions:exclusions extend:extendCommand language:languageCode];
}

// Deprecated method
- (void)removeCachedForecastForLocation:(CLLocation *)location
                                   time:(NSNumber *)time
                             exclusions:(NSArray *)exclusions
                                 extend:(NSString*)extendCommand
{
    [self removeCachedForecastForLocation:location time:time exclusions:exclusions extend:extendCommand language:nil];
}

@end
