//
//  ForecastModel+CLLocation.h
//  TempLook
//
//  Created by Vitalka on 17.06.17.
//  Copyright © 2017 Vitalka. All rights reserved.
//

#import "ForecastModel.h"
#import <CoreLocation/CoreLocation.h>

@interface ForecastModel (CLLocation)

- (void)getForecastForLocation:(CLLocation *)location
                          time:(NSNumber *)time
                    exclusions:(NSArray *)exclusions
                        extend:(NSString *)extendCommand
                      language:(NSString *)language
                       success:(void (^)(id JSON))success
                       failure:(void (^)(NSError *error, id response))failure;

- (void)getForecastForLocation:(CLLocation *)location
                          time:(NSNumber *)time
                    exclusions:(NSArray *)exclusions
                        extend:(NSString *)extendCommand
                       success:(void (^)(id JSON))success
                       failure:(void (^)(NSError *error, id response))failure;

- (void)getForecastForLocation:(CLLocation *)location
                          time:(NSNumber *)time
                    exclusions:(NSArray *)exclusions
                       success:(void (^)(id JSON))success
                       failure:(void (^)(NSError *error, id response))failure;

- (void)removeCachedForecastForLocation:(CLLocation *)location time:(NSNumber *)time exclusions:(NSArray *)exclusions extend:(NSString *)extendCommand language:(NSString *)languageCode;

- (void)removeCachedForecastForLocation:(CLLocation *)location time:(NSNumber *)time exclusions:(NSArray *)exclusions extend:(NSString *)extendCommand;

@end
