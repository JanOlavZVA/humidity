//
//  ForecastModel.h
//  TempLook
//
//  Created by Vitalka on 17.06.17.
//  Copyright © 2017 Vitalka. All rights reserved.
//

#import <Foundation/Foundation.h>
// Cache keys
extern NSString *const keyFCCacheKey;
extern NSString *const keyFCCacheArchiveKey;
extern NSString *const keyFCCacheExpiresKey;
extern NSString *const keyFCCacheForecastKey;

// Unit types
extern NSString *const keyFCUSUnits;
extern NSString *const keyFCSIUnits;
extern NSString *const keyFCUKUnits;
extern NSString *const keyFCCAUnits;
extern NSString *const keyFCAutoUnits;

// Languages
extern NSString *const keyFCLanguageUkrainian;
extern NSString *const keyFCLanguageBosnian;
extern NSString *const keyFCLanguageGerman;
extern NSString *const keyFCLanguageEnglish;
extern NSString *const keyFCLanguageSpanish;
extern NSString *const keyFCLanguageFrench;
extern NSString *const keyFCLanguageItalian;
extern NSString *const keyFCLanguageDutch;
extern NSString *const keyFCLanguagePolish;
extern NSString *const keyFCLanguagePortuguese;
extern NSString *const keyFCLanguageTetum;
extern NSString *const keyFCLanguagePigLatin;

// Extend types
extern NSString *const keyFCExtendHourly;

// Forecast names used for the data block hash keys
extern NSString *const keyFCCurrentlyForecast;
extern NSString *const keyFCMinutelyForecast;
extern NSString *const keyFCHourlyForecast;
extern NSString *const keyFCDailyForecast;

// Additional names used for the data block hash keys
extern NSString *const keyFCAlerts;
extern NSString *const keyFCFlags;
extern NSString *const keyFCLatitude;
extern NSString *const keyFCLongitude;
extern NSString *const keyFCOffset;
extern NSString *const keyFCTimezone;

// Names used for the data point hash keys
extern NSString *const keyFCCloudCover;
extern NSString *const keyFCCloudCoverError;
extern NSString *const keyFCDewPoint;
extern NSString *const keyFCHumidity;
extern NSString *const keyFCHumidityError;
extern NSString *const keyFCIcon;
extern NSString *const keyFCMoonPhase;
extern NSString *const keyFCOzone;
extern NSString *const keyFCPrecipAccumulation;
extern NSString *const keyFCPrecipIntensity;
extern NSString *const keyFCPrecipIntensityMax;
extern NSString *const keyFCPrecipIntensityMaxTime;
extern NSString *const keyFCPrecipProbability;
extern NSString *const keyFCPrecipType;
extern NSString *const keyFCPressure;
extern NSString *const keyFCPressureError;
extern NSString *const keyFCSummary;
extern NSString *const keyFCSunriseTime;
extern NSString *const keyFCSunsetTime;
extern NSString *const keyFCTemperature;
extern NSString *const keyFCTemperatureMax;
extern NSString *const keyFCTemperatureMaxError;
extern NSString *const keyFCTemperatureMaxTime;
extern NSString *const keyFCTemperatureMin;
extern NSString *const keyFCTemperatureMinError;
extern NSString *const keyFCTemperatureMinTime;
extern NSString *const keyFCApparentTemperature;
extern NSString *const keyFCApparentTemperatureMax;
extern NSString *const keyFCApparentTemperatureMin;
extern NSString *const keyFCTime;
extern NSString *const keyFCVisibility;
extern NSString *const keyFCVisibilityError;
extern NSString *const keyFCWindBearing;
extern NSString *const keyFCWindSpeed;
extern NSString *const keyFCWindSpeedError;

// Names used for weather icons
extern NSString *const keyFCIconClearDay;
extern NSString *const keyFCIconClearNight;
extern NSString *const keyFCIconRain;
extern NSString *const keyFCIconSnow;
extern NSString *const keyFCIconSleet;
extern NSString *const keyFCIconWind;
extern NSString *const keyFCIconFog;
extern NSString *const keyFCIconCloudy;
extern NSString *const keyFCIconPartlyCloudyDay;
extern NSString *const keyFCIconPartlyCloudyNight;
extern NSString *const keyFCIconHail;
extern NSString *const keyFCIconThunderstorm;
extern NSString *const keyFCIconTornado;
extern NSString *const keyFCIconHurricane;

// A numerical value representing the distance to the nearest storm
extern NSString *const keyFCNearestStormDistance;
extern NSString *const keyFCNearestStormBearing;

@interface ForecastModel : NSObject

@property (nonatomic, strong) NSString *apiKey;
@property (nonatomic, strong) NSString *units;
@property (nonatomic, strong) NSString *callback;

@property (nonatomic, assign) BOOL cacheEnabled;
@property (nonatomic, assign) int cacheExpirationInMinutes;

+ (id)sharedManager;

- (void)getForecastForLatitude:(double)lat
                     longitude:(double)lon
                          time:(NSNumber *)time
                    exclusions:(NSArray *)exclusions
                       success:(void (^)(id JSON))success
                       failure:(void (^)(NSError *error, id response))failure;

- (void)getForecastForLatitude:(double)lat
                     longitude:(double)lon
                          time:(NSNumber *)time
                    exclusions:(NSArray *)exclusions
                        extend:(NSString*)extendCommand
                       success:(void (^)(id JSON))success
                       failure:(void (^)(NSError *error, id response))failure;

- (void)getForecastForLatitude:(double)lat
                     longitude:(double)lon
                          time:(NSNumber *)time
                    exclusions:(NSArray *)exclusions
                        extend:(NSString *)extendCommand
                      language:(NSString *)languageCode
                       success:(void (^)(id JSON))success
                       failure:(void (^)(NSError *error, id response))failure;

- (void)cancelAllForecastRequests;

- (NSString *)descriptionForPrecipIntensity:(float)precipIntensity;

- (NSString *)imageNameForWeatherIconType:(NSString *)iconDescription;

- (NSString *)messageForError:(NSError *)error withResponse:(id)response;

- (void)checkForecastCacheForURLString:(NSString *)urlString
                               success:(void (^)(id cachedForecast))success
                               failure:(void (^)(NSError *error))failure;

- (void)cacheForecast:(id)forecast withURLString:(NSString *)urlString;

- (void)removeCachedForecastForLatitude:(double)lat
                              longitude:(double)lon
                                   time:(NSNumber *)time
                             exclusions:(NSArray *)exclusions
                                 extend:(NSString *)extendCommand;

- (void)removeCachedForecastForLatitude:(double)lat
                              longitude:(double)lon
                                   time:(NSNumber *)time
                             exclusions:(NSArray *)exclusions
                                 extend:(NSString *)extendCommand
                               language:(NSString *)languageCode;

- (void)flushCache;



@end
