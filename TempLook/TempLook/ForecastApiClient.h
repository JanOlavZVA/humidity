//
//  ForecastApiClient.h
//  TempLook
//
//  Created by Vitalka on 17.06.17.
//  Copyright © 2017 Vitalka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
#import "AFNetworking.h"


@interface ForecastApiClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

@end
