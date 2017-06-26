//
//  ForecastApiClient.m
//  TempLook
//
//  Created by Vitalka on 17.06.17.
//  Copyright © 2017 Vitalka. All rights reserved.
//

#import "ForecastApiClient.h"

static NSString * const ForecastApiBaseURLString = @"https://api.darksky.net/forecast/";

@implementation ForecastApiClient

+ (instancetype)sharedClient {
    static ForecastApiClient*_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[ForecastApiClient alloc] initWithBaseURL:[NSURL URLWithString:ForecastApiBaseURLString]];
    });
    
    return _sharedClient;
}


@end
